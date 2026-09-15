import cv2
from ultralytics import YOLO
import easyocr
import google.generativeai as genai
import time
Options:
1) Webcam
2) Image file

Choose (1 or 2): 2
Enter image path: C:\Users\Anderson\PycharmProjects\spotly\car 11.jpg

🔍 Processing source: C:\Users\Anderson\PycharmProjects\spotly\car 11.jpg

0: 640x480 1 truck, 99.1ms
Speed: 39.4ms preprocess, 99.1ms inference, 2.4ms postprocess per image at shape (1, 3, 640, 480)
✅ Detected vehicle class: 7
✅ Extracted features: color=[     69.479      73.022      71.116], plates=[]
✅ Saved detected image: detected_vehicles/detected_1770114609834.jpg
🔍 Comparing against 2 stolen vehicles...

--- Comparing with Stolen Vehicle ID: 1 ---
✅ Found stolen image at: C:\Users\Anderson\PycharmProjects\spotly\myapp\..\media\20260203-113104.jpg

0: 640x480 1 truck, 76.7ms
Speed: 4.6ms preprocess, 76.7ms inference, 1.2ms postprocess per image at shape (1, 3, 640, 480)
✅ Stolen vehicle class: 7
📊 Similarity scores: feature=0.931, color_dist=15.5, plate_match=False
🤖 Gemini AI comparison in progress...
🤖 Gemini result: YES, these are the same vehicle because every observable detail is identical, including the make, model, color, body style, roof type, headlight design, auxiliary lights, wheel design, tire pattern, windshield decals, and most definitively, the license plate number (KL 60 M 8448). The background also appears to be the same, suggesting the photos were taken at the same location.
✅ ALERT 32 created | FINAL MATCH = YES
📝 Details: {
  "final_match": "YES",
  "is_same_vehicle": "YES",
  "feature_similarity": 0.931,
  "color_distance": 15.47,
  "vehicle_class_match": true,
  "number_plate_stolen": [],
  "number_plate_detected": [],
  "number_plate_match": false,
  "bbox_ratio": {
    "stolen": 0.83,
    "detected": 0.99
  },
  "gemini_result": "YES, these are the same vehicle because every observable detail is identical, including the make, model, color, body style, roof type, headlight design, auxiliary lights, wheel design, tire pattern, windshield decals, and most definitively, the license plate number (KL 60 M 8448). The background also appears to be the same, suggesting the photos were taken at the same location.",
  "detection_timestamp": "2026-02-03 16:00:16"
}

--- Comparing with Stolen Vehicle ID: 2 ---
✅ Found stolen image at: C:\Users\Anderson\PycharmProjects\spotly\myapp\..\media\20260203-114738.jpg

0: 384x640 1 car, 110.7ms
Speed: 4.7ms preprocess, 110.7ms inference, 2.1ms postprocess per image at shape (1, 3, 384, 640)
✅ Stolen vehicle class: 2
C:\Python312\Lib\site-packages\torch\utils\data\dataloader.py:668: UserWarning: 'pin_memory' argument is set as true but no accelerator is found, then device pinned memory won't be used.
  warnings.warn(warn_msg)
📊 Similarity scores: feature=0.596, color_dist=77.5, plate_match=False
🤖 Gemini AI comparison in progress...
🤖 Gemini result: NO, these are different vehicles because they are completely different makes, models, colors, body styles, and vehicle types (a Porsche sports car versus a Mahindra Thar off-road SUV).
✅ ALERT 33 created | FINAL MATCH = NO
📝 Details: {
  "final_match": "NO",
  "is_same_vehicle": "NO",
  "feature_similarity": 0.596,
  "color_distance": 77.46,
  "vehicle_class_match": false,
  "number_plate_stolen": [
    "5460112D"
  ],
  "number_plate_detected": [],
  "number_plate_match": false,
  "bbox_ratio": {
    "stolen": 1.87,
    "detected": 0.99
  },
  "gemini_result": "NO, these are different vehicles because they are completely different makes, models, colors, body styles, and vehicle types (a Porsche sports car versus a Mahindra Thar off-road SUV).",
  "detection_timestamp": "2026-02-03 16:00:22"
}

==================================================
✅ Comparison completed!
==================================================

Press Enter to exit...
import os
from PIL import Image
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input
from tensorflow.keras.preprocessing import image as keras_image

# ---------- CONFIG ----------
GEMINI_API_KEY = "AIzaSyCJ8X-ygrPPhDdol_OghQcKTLDEtHsxJfo"  # replace with your key
VEHICLE_CLASSES = [2, 3, 5, 7]  # car, motorcycle, bus, truck
CAPTURE_SECONDS = 5
# ---------------------------

# Setup Gemini
genai.configure(api_key=GEMINI_API_KEY)
gemini = genai.GenerativeModel("models/gemini-2.5-flash")

# YOLO model
yolo = YOLO("yolov8n.pt")
ocr = easyocr.Reader(['en'])

# Feature embedding model (ResNet50)
resnet_model = ResNet50(weights='imagenet', include_top=False, pooling='avg')

# ---------- CORE FUNCTIONS ----------

def detect_vehicle(img):
    results = yolo(img, classes=VEHICLE_CLASSES, conf=0.4)
    for r in results:
        if r.boxes:
            x1, y1, x2, y2 = map(int, r.boxes[0].xyxy[0])
            bbox = (x1, y1, x2, y2)
            vehicle_crop = img[y1:y2, x1:x2]
            class_id = int(r.boxes[0].cls[0])
            return vehicle_crop, class_id, bbox
    return None, None, None

def extract_snapshot(source):
    source = source.lower()
    if source.endswith((".jpg", ".png", ".jpeg", ".webp")):
        if not os.path.exists(source):
            raise Exception(f"File not found: {source}")
        img = cv2.imread(source)
        v, cls, bbox = detect_vehicle(img)
        if v is None:
            raise Exception("No vehicle detected in image.")
        return v, cls, bbox

    cap = cv2.VideoCapture(0 if source=="webcam" else source)
    start = time.time()
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        v, cls, bbox = detect_vehicle(frame)
        if v is not None:
            cap.release()
            return v, cls, bbox
        if source=="webcam" and time.time()-start>CAPTURE_SECONDS:
            break
    cap.release()
    raise Exception("No vehicle detected in stream.")

def read_plate(img):
    return [t[1] for t in ocr.readtext(img) if len(t[1])>=4]

def gemini_compare(img1, img2):
    if isinstance(img1, np.ndarray):
        img1 = Image.fromarray(cv2.cvtColor(img1, cv2.COLOR_BGR2RGB))
    if isinstance(img2, np.ndarray):
        img2 = Image.fromarray(cv2.cvtColor(img2, cv2.COLOR_BGR2RGB))
    r = gemini.generate_content([
        "Compare these two vehicles. Are they the SAME vehicle? Consider color, model, shape, damage, stickers, and unique features.",
        img1, img2
    ])
    return r.text

def get_dominant_color(img):
    # Convert to RGB and reshape
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    pixels = img_rgb.reshape(-1,3)
    # Use k-means to find dominant color
    from sklearn.cluster import KMeans
    kmeans = KMeans(n_clusters=1, n_init=5)
    kmeans.fit(pixels)
    return kmeans.cluster_centers_[0]

def feature_embedding(img):
    img_resized = cv2.resize(img, (224,224))
    img_array = keras_image.img_to_array(img_resized)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)
    features = resnet_model.predict(img_array)
    return features.flatten()

def compare_features(feat1, feat2):
    sim = cosine_similarity([feat1], [feat2])[0][0]
    return sim

def bounding_box_ratio(bbox):
    x1,y1,x2,y2 = bbox
    width = x2-x1
    height = y2-y1
    return width/height if height>0 else 0

# ---------- MAIN ----------

def main():
    print("=== Enhanced Vehicle Verification System ===")
    print("Options for input/checker: image path, video path, or 'webcam'")

    input_src = input("Enter INPUT vehicle source: ").strip()
    checker_src = input("Enter CHECKER vehicle source: ").strip()

    try:
        print("\n🔍 Extracting input vehicle...")
        input_vehicle, input_cls, input_bbox = extract_snapshot(input_src)
        input_plate = read_plate(input_vehicle)
        input_color = get_dominant_color(input_vehicle)
        input_feat = feature_embedding(input_vehicle)
        input_ratio = bounding_box_ratio(input_bbox)

        print("🔍 Extracting checker vehicle...")
        checker_vehicle, checker_cls, checker_bbox = extract_snapshot(checker_src)
        checker_plate = read_plate(checker_vehicle)
        checker_color = get_dominant_color(checker_vehicle)
        checker_feat = feature_embedding(checker_vehicle)
        checker_ratio = bounding_box_ratio(checker_bbox)

        print("\n🧠 Gemini Semantic Comparison:")
        print(gemini_compare(input_vehicle, checker_vehicle))

        print("\n🔹 Feature Comparison:")
        # Class match
        print("Vehicle Type Match:", "✅" if input_cls==checker_cls else "❌")
        # Color distance
        color_distance = np.linalg.norm(input_color-checker_color)
        print(f"Dominant Color Distance: {color_distance:.2f}")
        # Bounding box ratio
        print(f"Bounding Box Ratio: input={input_ratio:.2f}, checker={checker_ratio:.2f}")
        # Feature embedding similarity
        sim_score = compare_features(input_feat, checker_feat)
        print(f"Feature Embedding Cosine Similarity: {sim_score:.3f}")
        # Number plate
        if input_plate and checker_plate:
            if set(input_plate) & set(checker_plate):
                print("✅ Number Plate MATCHED")
            else:
                print("❌ Number Plate NOT matched")
        else:
            print("⚠️ Number plate not visible in one or both sources")

        # Show images
        cv2.imshow("Input Vehicle", input_vehicle)
        cv2.imshow("Checker Vehicle", checker_vehicle)
        print("\nPress any key on the image windows to exit.")
        cv2.waitKey(0)
        cv2.destroyAllWindows()

    except Exception as e:
        print("❌ Error:", str(e))

if __name__=="__main__":
    main()
