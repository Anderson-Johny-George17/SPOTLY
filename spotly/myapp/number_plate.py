import os
import cv2
import time
import json
import django
import numpy as np
from PIL import Image
from ultralytics import YOLO
import easyocr
from sklearn.cluster import KMeans
from sklearn.metrics.pairwise import cosine_similarity
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input
from tensorflow.keras.preprocessing import image as keras_image
import requests
from geopy.geocoders import Nominatim

# ================= DJANGO INIT =================
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "spotly.settings")
django.setup()

from myapp.models import Stolen_vehicle, Alert

# ================= CONFIG =================
GEMINI_API_KEY = "API-KEY"
CAPTURE_SECONDS = 5
VEHICLE_CLASSES = [2, 3, 5, 7]  # car, motorcycle, bus, truck
MEDIA_ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "media")
ALERT_IMAGE_DIR = os.path.join(MEDIA_ROOT, "detected_vehicles")
os.makedirs(ALERT_IMAGE_DIR, exist_ok=True)

print(f"MEDIA_ROOT: {MEDIA_ROOT}")
print(f"ALERT_IMAGE_DIR: {ALERT_IMAGE_DIR}")

# ================= MODELS =================
yolo = YOLO("yolov8n.pt")
# Initialize OCR with better settings
ocr = easyocr.Reader(
    ['en'],
    gpu=False,
    model_storage_directory='model',
    user_network_directory='user_network',
    download_enabled=True,
    detector=True,
    recognizer=True
)
resnet_model = ResNet50(weights="imagenet", include_top=False, pooling="avg")

# ================= GEMINI =================
# Try to use the new google-genai package first
try:
    import google.genai as genai

    genai.configure(api_key=GEMINI_API_KEY)
    gemini = genai.GenerativeModel("gemini-2.5-flash")
    print("✅ Using google.genai (new API)")
except ImportError:
    # Fallback to old API
    try:
        import google.generativeai as genai

        genai.configure(api_key=GEMINI_API_KEY)
        gemini = genai.GenerativeModel("models/gemini-2.5-flash")
        print("✅ Using google.generativeai (old API)")
    except ImportError:
        print("❌ Both google-genai and google-generativeai packages not found!")
        print("Install: pip install google-genai")
        exit(1)

# Initialize geolocator for reverse geocoding
geolocator = Nominatim(user_agent="vehicle_detection_system")


# ================= UTILITY FUNCTIONS =================

def resolve_image_path(db_path):
    """
    Convert DB image paths to correct absolute paths
    """
    if not db_path:
        return None

    # Remove any leading / or media/
    db_path = db_path.strip().replace("\\", "/")
    db_path = db_path.lstrip("/")

    # If it starts with media/, remove it
    if db_path.startswith("media/"):
        db_path = db_path[len("media/"):]

    # Try multiple possible locations
    possible_paths = [
        os.path.join(MEDIA_ROOT, db_path),
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "media", db_path),
        os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "media", db_path),
    ]

    for abs_path in possible_paths:
        if os.path.exists(abs_path):
            return abs_path

    print(f"⚠️ Image missing at all paths: {db_path}")
    return None


def detect_vehicle(img):
    """Detect vehicle in image and return cropped vehicle"""
    results = yolo(img, classes=VEHICLE_CLASSES, conf=0.4)
    for r in results:
        if r.boxes:
            x1, y1, x2, y2 = map(int, r.boxes[0].xyxy[0])
            return img[y1:y2, x1:x2], int(r.boxes[0].cls[0]), (x1, y1, x2, y2)
    return None, None, None


def extract_snapshot(source):
    if source.lower() == "webcam":
        cap = cv2.VideoCapture(0)
        start = time.time()
        while time.time() - start < CAPTURE_SECONDS:
            ret, frame = cap.read()
            if not ret:
                continue
            v, cls, bbox = detect_vehicle(frame)
            if v is not None:
                cap.release()
                return v, cls, bbox, frame  # Return full frame too
        cap.release()
        raise Exception("No vehicle detected from webcam")

    if not os.path.exists(source):
        raise Exception(f"File not found: {source}")

    img = cv2.imread(source)
    v, cls, bbox = detect_vehicle(img)
    if v is None:
        raise Exception("No vehicle detected in image")
    return v, cls, bbox, img  # Return full image too


def read_plate_enhanced(full_img, vehicle_bbox):
    """Enhanced OCR that looks for plates in both the cropped vehicle AND the full image"""
    plates = []

    print("🔍 Starting OCR for license plates...")

    # Preprocess image for better OCR
    gray = cv2.cvtColor(full_img, cv2.COLOR_BGR2GRAY)
    # Apply adaptive thresholding
    thresh = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                                   cv2.THRESH_BINARY, 11, 2)

    # Try OCR on the full image first
    try:
        print("  Scanning full image for plates...")
        results = ocr.readtext(thresh, paragraph=False, detail=1)
        for bbox, text, conf in results:
            clean = text.replace(" ", "").upper()
            # More flexible plate detection
            if len(clean) >= 3 and conf > 0.25:  # Lower confidence threshold
                # Check if this text is near the vehicle bounding box
                x1, y1, x2, y2 = vehicle_bbox
                # Expand search area around vehicle
                search_x1 = max(0, x1 - 150)
                search_y1 = max(0, y1 - 100)
                search_x2 = min(full_img.shape[1], x2 + 150)
                search_y2 = min(full_img.shape[0], y2 + 100)

                # Get OCR bounding box center
                ocr_x_center = (bbox[0][0] + bbox[2][0]) / 2
                ocr_y_center = (bbox[0][1] + bbox[2][1]) / 2

                # Check if OCR result is near the vehicle
                if (search_x1 <= ocr_x_center <= search_x2 and
                                search_y1 <= ocr_y_center <= search_y2):
                    plates.append(clean)
                    print(f"  ✅ Found plate in full image: '{clean}' (confidence: {conf:.2f})")
    except Exception as e:
        print(f"  ⚠️ OCR error on full image: {e}")

    # Also try OCR on just the vehicle crop
    x1, y1, x2, y2 = vehicle_bbox
    vehicle_crop = full_img[y1:y2, x1:x2]

    if vehicle_crop.size > 0:
        # Look at bottom 40% of vehicle for plate (more area)
        height = vehicle_crop.shape[0]
        plate_region = vehicle_crop[int(height * 0.6):, :]

        if plate_region.size > 0:
            # Preprocess plate region
            plate_gray = cv2.cvtColor(plate_region, cv2.COLOR_BGR2GRAY)
            plate_thresh = cv2.adaptiveThreshold(plate_gray, 255,
                                                 cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                                                 cv2.THRESH_BINARY, 11, 2)

            try:
                print("  Scanning vehicle crop for plates...")
                results = ocr.readtext(plate_thresh, paragraph=False, detail=1)
                for _, text, conf in results:
                    clean = text.replace(" ", "").upper()
                    if len(clean) >= 3 and conf > 0.25:
                        plates.append(clean)
                        print(f"  ✅ Found plate in vehicle crop: '{clean}' (confidence: {conf:.2f})")
            except Exception as e:
                print(f"  ⚠️ OCR error on vehicle crop: {e}")

    # Remove duplicates while preserving order
    unique_plates = []
    for plate in plates:
        if plate not in unique_plates:
            unique_plates.append(plate)

    print(f"  📋 Total unique plates found: {len(unique_plates)}")
    return unique_plates


def get_detailed_color_info(img):
    """Get detailed color information including color name"""
    try:
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        pixels = img_rgb.reshape(-1, 3)

        # Use k-means to find dominant colors
        kmeans = KMeans(n_clusters=3, n_init=10, random_state=42)
        kmeans.fit(pixels)

        # Get cluster centers and sizes
        colors = kmeans.cluster_centers_
        labels = kmeans.labels_
        label_counts = np.bincount(labels)

        # Sort by frequency
        sorted_indices = np.argsort(-label_counts)

        # Get dominant color (most frequent)
        dominant_color_rgb = colors[sorted_indices[0]]

        # Convert RGB to color name
        color_name = rgb_to_color_name(dominant_color_rgb)

        return {
            'dominant_rgb': dominant_color_rgb.tolist(),
            'color_name': color_name,
            'secondary_colors': colors[sorted_indices[1:]].tolist(),
            'color_distribution': (label_counts / len(labels)).tolist()
        }
    except Exception as e:
        print(f"⚠️ Color detection error: {e}")
        return {
            'dominant_rgb': [0, 0, 0],
            'color_name': 'Unknown',
            'secondary_colors': [],
            'color_distribution': []
        }


def rgb_to_color_name(rgb):
    """Convert RGB to approximate color name"""
    r, g, b = rgb

    # Common color mappings
    color_names = [
        (255, 0, 0, 'Red'),
        (0, 255, 0, 'Green'),
        (0, 0, 255, 'Blue'),
        (255, 255, 0, 'Yellow'),
        (255, 165, 0, 'Orange'),
        (128, 0, 128, 'Purple'),
        (255, 192, 203, 'Pink'),
        (165, 42, 42, 'Brown'),
        (0, 0, 0, 'Black'),
        (255, 255, 255, 'White'),
        (128, 128, 128, 'Gray'),
        (192, 192, 192, 'Silver'),
        (139, 69, 19, 'Brown'),
        (255, 215, 0, 'Gold'),
        (0, 128, 128, 'Teal'),
        (0, 255, 255, 'Cyan'),
        (255, 0, 255, 'Magenta'),
        (128, 128, 0, 'Olive'),
        (0, 128, 0, 'Dark Green'),
        (0, 0, 128, 'Navy'),
    ]

    # Find closest color
    min_distance = float('inf')
    closest_color = 'Unknown'

    for cr, cg, cb, name in color_names:
        distance = np.sqrt((r - cr) ** 2 + (g - cg) ** 2 + (b - cb) ** 2)
        if distance < min_distance:
            min_distance = distance
            closest_color = name

    return closest_color


def get_current_location():
    """Get current location using IP address"""
    try:
        print("📍 Getting current location...")

        # Method 1: Try using IP address
        try:
            response = requests.get('https://ipinfo.io/json', timeout=5)
            if response.status_code == 200:
                data = response.json()
                loc = data.get('loc', '').split(',')
                if len(loc) == 2:
                    lat, lon = float(loc[0]), float(loc[1])
                    city = data.get('city', 'Unknown')
                    region = data.get('region', 'Unknown')
                    country = data.get('country', 'Unknown')

                    print(f"  ✅ Location from IP: {lat}, {lon}")
                    print(f"  📍 Address: {city}, {region}, {country}")

                    return {
                        'latitude': lat,
                        'longitude': lon,
                        'address': f"{city}, {region}, {country}",
                        'method': 'ip_api'
                    }
        except Exception as e:
            print(f"  ⚠️ IP location failed: {e}")

        # Method 2: Use default/fallback location
        print("  ⚠️ Using fallback location")
        return {
            'latitude': 9.9764209,  # Example coordinates (Kochi, Kerala)
            'longitude': 76.2861703,
            'address': "Kochi, Kerala, India",
            'method': 'fallback'
        }

    except Exception as e:
        print(f"❌ Location error: {e}")
        return {
            'latitude': 9.9764209,
            'longitude': 76.2861703,
            'address': "Unknown Location",
            'method': 'error'
        }


def feature_embedding(img):
    try:
        img = cv2.resize(img, (224, 224))
        arr = keras_image.img_to_array(img)
        arr = np.expand_dims(arr, axis=0)
        arr = preprocess_input(arr)
        return resnet_model.predict(arr, verbose=0)[0]
    except Exception as e:
        print(f"⚠️ Feature embedding error: {e}")
        return np.zeros((2048,))


def bbox_ratio(b):
    x1, y1, x2, y2 = b
    return (x2 - x1) / (y2 - y1) if (y2 - y1) else 0


def gemini_compare(img1, img2):
    try:
        # Convert to PIL Image
        img1_pil = Image.fromarray(cv2.cvtColor(img1, cv2.COLOR_BGR2RGB))
        img2_pil = Image.fromarray(cv2.cvtColor(img2, cv2.COLOR_BGR2RGB))

        # Enhanced prompt with specific details
        prompt = """
        You are a vehicle identification expert. Analyze these two vehicle images and determine if they are the SAME vehicle.

        Provide a DETAILED analysis with the following information:

        1. VEHICLE MAKE & MODEL:
           - What is the make (brand) of each vehicle?
           - What is the specific model of each vehicle?
           - Are they the same make and model?

        2. COLOR ANALYSIS:
           - Primary color of each vehicle
           - Any secondary colors, stripes, or patterns
           - Paint finish (matte, glossy, metallic)
           - Are the colors identical or similar?

        3. BODY FEATURES:
           - Body style (sedan, SUV, truck, hatchback, etc.)
           - Number of doors
           - Window shapes and tinting
           - Roof type (sunroof, convertible, hardtop)
           - Any body modifications or customizations

        4. FRONT END DETAILS:
           - Headlight design and shape
           - Grille pattern and design
           - Bumper style and any damage
           - Fog lights or auxiliary lights

        5. REAR END DETAILS:
           - Taillight design
           - Rear bumper and exhaust pipes
           - Any stickers, badges, or decals

        6. WHEELS & TIRES:
           - Wheel design and size
           - Rim type and color
           - Tire brand and tread pattern
           - Any wheel covers or hubcaps

        7. LICENSE PLATES (CRITICAL):
           - Can you read any license plate numbers?
           - If visible, what are the plate numbers?
           - Plate color and design
           - Are the plates from the same region?

        8. UNIQUE IDENTIFIERS:
           - Any visible damage (dents, scratches)
           - Stickers, decals, or custom markings
           - Window stickers or toll tags
           - Antenna type or roof racks

        9. INTERIOR VISIBLE FEATURES (if visible):
           - Steering wheel type
           - Dashboard features
           - Seat color/material

        FINAL VERDICT:
        Based on ALL the above analysis, are these images of the SAME vehicle?

        Answer format:
        START_ANALYSIS

        MAKE & MODEL: [Details here]

        COLOR: [Details here]

        BODY FEATURES: [Details here]

        FRONT END: [Details here]

        REAR END: [Details here]

        WHEELS: [Details here]

        LICENSE PLATES: [Details here]

        UNIQUE IDENTIFIERS: [Details here]

        INTERIOR: [Details here]

        FINAL CONCLUSION: YES/NO - [Detailed explanation]

        END_ANALYSIS
        """

        print("🤖 Sending images to Gemini AI for detailed analysis...")
        response = gemini.generate_content([prompt, img1_pil, img2_pil])
        result = response.text.strip()
        print("✅ Gemini analysis completed")

        return result
    except Exception as e:
        print(f"⚠️ Gemini error: {e}")
        return "ERROR: Could not compare"


def save_detected_image(img):
    """Save detected image with timestamp"""
    timestamp = int(time.time() * 1000)  # Milliseconds for uniqueness
    filename = f"detected_{timestamp}.jpg"
    relative_path = f"detected_vehicles/{filename}"
    full_path = os.path.join(MEDIA_ROOT, relative_path)

    # Ensure directory exists
    os.makedirs(os.path.dirname(full_path), exist_ok=True)

    cv2.imwrite(full_path, img)
    print(f"✅ Saved detected image: {relative_path}")
    return relative_path


def extract_plate_from_gemini_response(gemini_result):
    """Extract license plate numbers from Gemini response"""
    plates = []

    # Look for license plate patterns
    import re

    # Common plate patterns
    patterns = [
        r'[A-Z]{1,3}\s*\d{1,4}\s*[A-Z]{0,3}\s*\d{0,4}',  # Standard plates
        r'\b[A-Z]{2}\s*\d{2}\s*[A-Z]{1,2}\s*\d{4}\b',  # Indian format
        r'[A-Z]{3}-\d{4}',  # US format
        r'[A-Z]{2}\d{2}[A-Z]{2}\d{4}',  # No space format
        r'[A-Z]{2}\d{2}[A-Z]{1,3}\d{4}',  # Variant
    ]

    for pattern in patterns:
        matches = re.findall(pattern, gemini_result.upper())
        plates.extend(matches)

    # Also look for "Plate:" or "License:" indicators
    lines = gemini_result.split('\n')
    for line in lines:
        line_upper = line.upper()
        if any(keyword in line_upper for keyword in ['PLATE', 'LICENSE', 'REGISTRATION']):
            # Extract alphanumeric sequences
            words = line.split()
            for word in words:
                if len(word) >= 4 and any(c.isdigit() for c in word) and any(c.isalpha() for c in word):
                    clean_word = ''.join(c for c in word if c.isalnum()).upper()
                    if clean_word not in plates:
                        plates.append(clean_word)

    return list(set(plates))  # Remove duplicates


# ================= MAIN PIPELINE =================

def compare_vehicle_and_create_alert(source):
    """Main function to compare vehicle and create alerts"""
    try:
        print(f"\n🔍 Processing source: {source}")

        # Get current location
        current_location = get_current_location()
        print(f"📍 Current Location: {current_location['address']}")
        print(f"📍 Coordinates: {current_location['latitude']}, {current_location['longitude']}")

        # Extract vehicle from source
        chk_vehicle, chk_cls, chk_bbox, full_img = extract_snapshot(source)
        print(f"✅ Detected vehicle class: {chk_cls}")

        # Extract features from detected vehicle
        chk_feat = feature_embedding(chk_vehicle)
        chk_color_info = get_detailed_color_info(chk_vehicle)

        # Use ENHANCED plate detection
        print("\n📋 Starting license plate detection...")
        chk_plate = read_plate_enhanced(full_img, chk_bbox)

        print(f"\n✅ Extracted features:")
        print(f"  • Color: {chk_color_info['color_name']} (RGB: {chk_color_info['dominant_rgb']})")
        print(f"  • Plates detected: {chk_plate}")

        # Save detected image
        detected_img_path = save_detected_image(chk_vehicle)

        # Get all stolen vehicles
        stolen_vehicles = Stolen_vehicle.objects.all()
        print(f"\n🔍 Comparing against {len(stolen_vehicles)} stolen vehicles...")

        for stolen in stolen_vehicles:
            print(f"\n" + "=" * 70)
            print(f"🔍 COMPARING WITH STOLEN VEHICLE ID: {stolen.id}")
            print(f"📋 STOLEN VEHICLE INFO:")
            print(f"   • Type: {stolen.vehicle_type}")
            print(f"   • Color: {stolen.vehicle_color}")
            print(f"   • Stolen Location: {stolen.latitude}, {stolen.longitude}")
            print("=" * 70)

            # Resolve stolen vehicle image path
            stolen_img_path = resolve_image_path(stolen.vehicle_image)
            if not stolen_img_path:
                print(f"⚠️ Image missing for stolen vehicle {stolen.id}")
                continue

            print(f"✅ Found stolen image at: {stolen_img_path}")

            # Load and detect vehicle in stolen image
            stolen_full_img = cv2.imread(stolen_img_path)
            if stolen_full_img is None:
                print(f"⚠️ Could not load image")
                continue

            ref_vehicle, ref_cls, ref_bbox = detect_vehicle(stolen_full_img)
            if ref_vehicle is None:
                print(f"⚠️ Vehicle not detected in stolen image")
                continue

            print(f"✅ Stolen vehicle class: {ref_cls}")

            # Extract features from stolen vehicle
            ref_feat = feature_embedding(ref_vehicle)
            ref_color_info = get_detailed_color_info(ref_vehicle)

            # Use ENHANCED plate detection for stolen vehicle too
            ref_plate = read_plate_enhanced(stolen_full_img, ref_bbox)

            # Calculate similarities
            try:
                feature_sim = float(cosine_similarity([ref_feat], [chk_feat])[0][0])
            except:
                feature_sim = 0.0

            # Calculate color similarity
            try:
                ref_color = np.array(ref_color_info['dominant_rgb'])
                chk_color = np.array(chk_color_info['dominant_rgb'])
                color_dist = float(np.linalg.norm(ref_color - chk_color))
                color_similar = ref_color_info['color_name'] == chk_color_info['color_name']
            except:
                color_dist = 100.0
                color_similar = False

            # Check plate match
            plate_match = False
            all_plates = chk_plate + ref_plate

            if all_plates:
                print(f"\n📋 PLATE COMPARISON:")
                print(f"  • Detected plates: {chk_plate}")
                print(f"  • Stolen plates: {ref_plate}")

                for cp in chk_plate:
                    for rp in ref_plate:
                        if cp == rp:
                            plate_match = True
                            print(f"  ✅✅ EXACT MATCH: '{cp}' == '{rp}'")
                        elif cp in rp or rp in cp:
                            plate_match = True
                            print(f"  ✅ PARTIAL MATCH: '{cp}' similar to '{rp}'")

            print(f"\n📊 TECHNICAL SIMILARITY SCORES:")
            print(f"  • Feature similarity: {feature_sim:.3f} {'(HIGH)' if feature_sim > 0.75 else '(LOW)'}")
            print(f"  • Color distance: {color_dist:.1f} {'(GOOD)' if color_dist < 50 else '(POOR)'}")
            print(f"  • Color names match: {'YES' if color_similar else 'NO'}")
            print(f"  • Vehicle class match: {'YES' if ref_cls == chk_cls else 'NO'}")
            print(f"  • Plate match: {'YES' if plate_match else 'NO'}")

            # Use Gemini for detailed comparison
            print("\n" + "=" * 70)
            print("🤖 STARTING GEMINI AI DETAILED ANALYSIS")
            print("=" * 70)

            gemini_result = gemini_compare(ref_vehicle, chk_vehicle)

            # Extract plates from Gemini response
            gemini_plates = extract_plate_from_gemini_response(gemini_result)
            if gemini_plates:
                print(f"\n📋 GEMINI DETECTED PLATES: {gemini_plates}")
                # Add Gemini plates to our plate list
                all_plates.extend(gemini_plates)
                all_plates = list(set(all_plates))  # Remove duplicates

            # Parse Gemini conclusion
            is_same_gemini = "FINAL CONCLUSION: YES" in gemini_result.upper()

            # Determine final match
            is_same = False
            match_reasons = []

            # Strong indicators
            if plate_match:
                is_same = True
                match_reasons.append("License plate match")

            if is_same_gemini and feature_sim > 0.70:
                is_same = True
                match_reasons.append("Gemini AI confirmation with good feature match")

            # Good indicators
            if feature_sim > 0.85:
                is_same = True
                match_reasons.append("Very high feature similarity")

            if color_similar and feature_sim > 0.75 and ref_cls == chk_cls:
                is_same = True
                match_reasons.append("Color match + good feature similarity + same class")

            # Moderate indicators
            if feature_sim > 0.80 and color_dist < 60:
                is_same = True
                match_reasons.append("High feature similarity with reasonable color match")

            final_result = "YES" if is_same else "NO"

            # Prepare comprehensive details
            details = {
                "final_match": final_result,
                "is_same_vehicle": final_result,
                "match_reasons": match_reasons if is_same else ["No conclusive match found"],
                "technical_analysis": {
                    "feature_similarity": round(feature_sim, 3),
                    "color_distance": round(color_dist, 2),
                    "color_names_match": color_similar,
                    "detected_color": chk_color_info['color_name'],
                    "stolen_color": ref_color_info['color_name'],
                    "vehicle_class_match": ref_cls == chk_cls,
                    "detected_class": chk_cls,
                    "stolen_class": ref_cls
                },
                "plate_analysis": {
                    "detected_plates": chk_plate,
                    "stolen_plates": ref_plate,
                    "gemini_detected_plates": gemini_plates,
                    "plate_match": plate_match,
                    "all_plates": all_plates
                },
                "location_info": {
                    "detection_location": current_location,
                    "stolen_location": {
                        "latitude": stolen.latitude,
                        "longitude": stolen.longitude,
                        "vehicle_type": stolen.vehicle_type,
                        "vehicle_color": stolen.vehicle_color
                    }
                },
                "gemini_analysis": gemini_result,
                "detection_timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
                "image_paths": {
                    "detected_image": detected_img_path,
                    "stolen_image": stolen.vehicle_image
                }
            }

            # Create alert with current location instead of stolen location
            alert_status = "detected" if is_same else "no_match"

            alert = Alert.objects.create(
                stolen_vehicle=stolen,
                status=alert_status,
                latitude=current_location['latitude'],  # Use current location
                longitude=current_location['longitude'],  # Use current location
                detected_image=detected_img_path,
                details=json.dumps(details, indent=2)
            )

            print(f"\n" + "=" * 70)
            if is_same:
                print(f"🚨🚨🚨 VEHICLE DETECTED - ALERT #{alert.id} 🚨🚨🚨")
                print(f"📍 DETECTION LOCATION: {current_location['address']}")
                print(f"📍 COORDINATES: {current_location['latitude']}, {current_location['longitude']}")
                print(f"\n✅ MATCH CONFIRMED!")
                for reason in match_reasons:
                    print(f"   • {reason}")
            else:
                print(f"✅ Alert #{alert.id} created | No match found")
            print("=" * 70)

            # Visual comparison
            try:
                display_ref = cv2.resize(ref_vehicle, (400, 300))
                display_chk = cv2.resize(chk_vehicle, (400, 300))

                label_ref = f"Stolen: {stolen.vehicle_type}"
                label_chk = "Detected Vehicle"

                color = (0, 255, 0) if is_same else (0, 0, 255)
                cv2.putText(display_ref, label_ref, (10, 30),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)
                cv2.putText(display_chk, label_chk, (10, 30),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)

                combined = np.hstack([display_ref, display_chk])
                window_name = f"Match: {'YES' if is_same else 'NO'} - Stolen ID: {stolen.id}"
                cv2.imshow(window_name, combined)
                cv2.waitKey(3000)  # Show for 3 seconds
                cv2.destroyAllWindows()
            except Exception as e:
                print(f"⚠️ Could not display images: {e}")

        print("\n" + "=" * 70)
        print("✅ COMPARISON COMPLETED SUCCESSFULLY!")
        print("=" * 70)

    except Exception as e:
        print(f"❌ Error in comparison pipeline: {e}")
        import traceback
        traceback.print_exc()


# ================= RUN SCRIPT =================

if __name__ == "__main__":
    print("=" * 70)
    print("🚗 ADVANCED VEHICLE DETECTION & ALERT SYSTEM")
    print("=" * 70)
    print("\nOptions:")
    print("1) Webcam")
    print("2) Image file")

    choice = input("\nChoose (1 or 2): ").strip()

    if choice == "1":
        source = "webcam"
        print("🎥 Using webcam...")
    elif choice == "2":
        image_path = input("Enter image path: ").strip()
        if not os.path.exists(image_path):
            print(f"❌ File not found: {image_path}")
            print("Please check the path and try again.")
            exit(1)
        source = image_path
        print(f"📸 Using image: {image_path}")
    else:
        print("❌ Invalid choice")
        exit(1)

    try:
        compare_vehicle_and_create_alert(source)
    except KeyboardInterrupt:
        print("\n🛑 Process interrupted by user")
    except Exception as e:
        print(f"❌ Fatal error: {e}")
        import traceback

        traceback.print_exc()

    print("\n" + "=" * 70)
    print("Process completed. Press Enter to exit...")
    input()
