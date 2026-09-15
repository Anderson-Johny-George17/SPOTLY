    # import cv2
    # import numpy as np
    # import easyocr
    # import mysql.connector
    # import os
    # import datetime
    # from ultralytics import YOLO
    # from PIL import Image
    # from .models import Stolen_vehicle
    # # ================== DATABASE CONFIG ==================
    # DB_CONFIG = {
    #     "host": "localhost",
    #     "user": "root",
    #     "password": "Aj1708",
    #     "database": "spotly"
    # }
    #
    # # ================== LOAD MODELS ==================
    # print("Loading YOLOv8...")
    # model = YOLO("yolov8n.pt")
    # dummy = np.zeros((640, 640, 3), dtype=np.uint8)
    # model(dummy, verbose=False)
    # print("✓ YOLO ready")
    #
    # print("Loading EasyOCR...")
    # ocr = easyocr.Reader(['en'], gpu=False)
    # print("✓ OCR ready")
    #
    # # ================== HELPERS ==================
    # def db_connect():
    #     return mysql.connector.connect(**DB_CONFIG)
    #
    # def normalize_plate(text):
    #     return ''.join(c for c in text if c.isalnum()).upper()
    #
    # def read_image_safe(path):
    #     img = cv2.imread(path)
    #     if img is None:
    #         img = np.array(Image.open(path).convert("RGB"))
    #         img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    #     return img
    #
    # def extract_plate(image):
    #     gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    #     results = ocr.readtext(gray)
    #     for r in results:
    #         plate = normalize_plate(r[1])
    #         if 6 <= len(plate) <= 10:
    #             return plate
    #     return ""
    #
    # # ================== LOAD STOLEN PLATES FROM DB ==================
    # def load_stolen_plates():
    #     conn = db_connect()
    #     cur = conn.cursor(dictionary=True)
    #     cur.execute("SELECT * FROM stolen_vehicles")
    #     rows = cur.fetchall()
    #     conn.close()
    #
    #     stolen = []
    #     for r in rows:
    #         img_path = r['vehicle_image']
    #         if not os.path.exists(img_path):
    #             continue
    #         img = read_image_safe(img_path)
    #         plate = extract_plate(img)
    #         if plate:
    #             r['plate'] = plate
    #             stolen.append(r)
    #             print(f"✓ Loaded stolen plate {plate} (ID {r['id']})")
    #     return stolen
    #
    # STOLEN_DATA = load_stolen_plates()
    #
    # # ================== PROCESS FRAME ==================
    # def process_frame(frame, source=""):
    #     results = model(frame, conf=0.4, verbose=False)[0]
    #
    #     for box in results.boxes:
    #         cls = int(box.cls[0])
    #         if cls not in [2, 3, 5, 7]:
    #             continue
    #
    #         x1, y1, x2, y2 = map(int, box.xyxy[0])
    #         roi = frame[y1:y2, x1:x2]
    #         if roi.size == 0:
    #             continue
    #
    #         plate = extract_plate(roi)
    #         if not plate:
    #             continue
    #
    #         for stolen in STOLEN_DATA:
    #             if plate == stolen['plate']:
    #                 cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 255), 3)
    #                 label = f"STOLEN {plate}"
    #                 cv2.putText(frame, label, (x1, y1 - 10),
    #                             cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255), 2)
    #
    #                 print("\n🚨 STOLEN VEHICLE DETECTED 🚨")
    #                 print({
    #                     "stolen_id": stolen['id'],
    #                     "plate": plate,
    #                     "vehicle_type": stolen['vehicle_type'],
    #                     "vehicle_color": stolen['vehicle_color'],
    #                     "latitude": stolen['latitude'],
    #                     "longitude": stolen['longitude'],
    #                     "source": source,
    #                     "time": datetime.datetime.now().isoformat()
    #                 })
    #
    #     return frame
    #
    # # ================== IMAGE ==================
    # def detect_image(path):
    #     img = read_image_safe(path)
    #     out = process_frame(img, path)
    #     os.makedirs("results", exist_ok=True)
    #     name = f"results/image_{int(datetime.datetime.now().timestamp())}.jpg"
    #     cv2.imwrite(name, out)
    #     print(f"✓ Image saved to {name}")
    #
    # # ================== VIDEO ==================
    # def detect_video(path):
    #     cap = cv2.VideoCapture(path)
    #     os.makedirs("results", exist_ok=True)
    #     out_path = f"results/video_{int(datetime.datetime.now().timestamp())}.mp4"
    #
    #     fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    #     w = int(cap.get(3))
    #     h = int(cap.get(4))
    #     fps = cap.get(cv2.CAP_PROP_FPS)
    #     out = cv2.VideoWriter(out_path, fourcc, fps, (w, h))
    #
    #     while cap.isOpened():
    #         ret, frame = cap.read()
    #         if not ret:
    #             break
    #         frame = process_frame(frame, path)
    #         out.write(frame)
    #
    #     cap.release()
    #     out.release()
    #     print(f"✓ Video saved to {out_path}")
    #
    # # ================== CAMERA ==================
    # def detect_camera():
    #     cap = cv2.VideoCapture(0)
    #     os.makedirs("results", exist_ok=True)
    #     out_path = f"results/camera_{int(datetime.datetime.now().timestamp())}.mp4"
    #
    #     fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    #     w = int(cap.get(3))
    #     h = int(cap.get(4))
    #     out = cv2.VideoWriter(out_path, fourcc, 20, (w, h))
    #
    #     print("Press CTRL+C to stop camera")
    #
    #     try:
    #         while True:
    #             ret, frame = cap.read()
    #             if not ret:
    #                 break
    #             frame = process_frame(frame, "CAMERA")
    #             out.write(frame)
    #     except KeyboardInterrupt:
    #         pass
    #
    #     cap.release()
    #     out.release()
    #     print(f"✓ Camera video saved to {out_path}")
    #
    # # ================== MAIN MENU ==================
    # def main():
    #     while True:
    #         print("\n========== STOLEN VEHICLE SYSTEM ==========")
    #         print("1. Detect from IMAGE")
    #         print("2. Detect from VIDEO")
    #         print("3. Detect from CAMERA")
    #         print("4. Exit")
    #         ch = input("Choose option: ").strip()
    #
    #         if ch == "1":
    #             p = input("Image path: ").strip()
    #             detect_image(p)
    #         elif ch == "2":
    #             p = input("Video path: ").strip()
    #             detect_video(p)
    #         elif ch == "3":
    #             detect_camera()
    #         elif ch == "4":
    #             break
    #         else:
    #             print("Invalid choice")
    #
    # if __name__ == "__main__":
    #     main()
import cv2
import numpy as np
import easyocr
import os
import datetime
from ultralytics import YOLO
from PIL import Image
from django.utils import timezone
from myapp.models import Stolen_vehicle, Alert, Customer  # import models directly


# ================== LOAD MODELS ==================
print("Loading YOLOv8...")
model = YOLO("yolov8n.pt")
dummy = np.zeros((640, 640, 3), dtype=np.uint8)
model(dummy, verbose=False)
print("✓ YOLO ready")

print("Loading EasyOCR...")
ocr = easyocr.Reader(['en'], gpu=False)
print("✓ OCR ready")


# ================== HELPERS ==================
def normalize_plate(text):
    return ''.join(c for c in text if c.isalnum()).upper()


def read_image_safe(path):
    img = cv2.imread(path)
    if img is None:
        img = np.array(Image.open(path).convert("RGB"))
        img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    return img


def extract_plate(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    results = ocr.readtext(gray)
    for r in results:
        plate = normalize_plate(r[1])
        if 6 <= len(plate) <= 10:
            return plate
    return ""


# ================== LOAD STOLEN VEHICLES FROM DB ==================
def load_stolen_data():
    stolen_data = []
    for v in Stolen_vehicle.objects.all():
        img_path = v.vehicle_image
        if not os.path.exists(img_path):
            continue
        img = read_image_safe(img_path)
        plate = extract_plate(img)
        if plate:
            stolen_data.append({
                "id": v.id,
                "plate": plate,
                "vehicle_type": v.vehicle_type,
                "vehicle_color": v.vehicle_color,
                "latitude": v.latitude,
                "longitude": v.longitude,
                "customer": v.CUSTOMER
            })
            print(f"✓ Loaded stolen plate {plate} (ID {v.id})")
    return stolen_data


STOLEN_DATA = load_stolen_data()


# ================== PROCESS FRAME ==================
def process_frame(frame, source=""):
    results = model(frame, conf=0.4, verbose=False)[0]

    for box in results.boxes:
        cls = int(box.cls[0])
        if cls not in [2, 3, 5, 7]:  # Car, bus, truck, motorcycle etc.
            continue

        x1, y1, x2, y2 = map(int, box.xyxy[0])
        roi = frame[y1:y2, x1:x2]
        if roi.size == 0:
            continue

        plate = extract_plate(roi)
        if not plate:
            continue

        for stolen in STOLEN_DATA:
            if plate == stolen['plate']:
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 255), 3)
                label = f"STOLEN {plate}"
                cv2.putText(frame, label, (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255), 2)

                print("\n🚨 STOLEN VEHICLE DETECTED 🚨")
                print({
                    "stolen_id": stolen['id'],
                    "plate": plate,
                    "vehicle_type": stolen['vehicle_type'],
                    "vehicle_color": stolen['vehicle_color'],
                    "latitude": stolen['latitude'],
                    "longitude": stolen['longitude'],
                    "source": source,
                    "time": datetime.datetime.now().isoformat()
                })

                # Save alert in DB
                Alert.objects.create(
                    CUSTOMER=stolen['customer'],
                    phn_number="NA",  # Add real phone if needed
                    date=str(datetime.date.today()),
                    time=str(datetime.datetime.now().time()),
                    message=f"Stolen vehicle detected: {plate}",
                    photo=save_frame(roi)
                )

    return frame


# ================== SAVE FRAME ==================
def save_frame(frame):
    os.makedirs("results", exist_ok=True)
    name = f"results/alert_{int(datetime.datetime.now().timestamp())}.jpg"
    cv2.imwrite(name, frame)
    return name


# ================== IMAGE ==================
def detect_image(path):
    img = read_image_safe(path)
    out = process_frame(img, path)
    os.makedirs("results", exist_ok=True)
    name = f"results/image_{int(datetime.datetime.now().timestamp())}.jpg"
    cv2.imwrite(name, out)
    print(f"✓ Image saved to {name}")


# ================== VIDEO ==================
def detect_video(path):
    cap = cv2.VideoCapture(path)
    os.makedirs("results", exist_ok=True)
    out_path = f"results/video_{int(datetime.datetime.now().timestamp())}.mp4"

    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    w = int(cap.get(3))
    h = int(cap.get(4))
    fps = cap.get(cv2.CAP_PROP_FPS)
    out = cv2.VideoWriter(out_path, fourcc, fps, (w, h))

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        frame = process_frame(frame, path)
        out.write(frame)

    cap.release()
    out.release()
    print(f"✓ Video saved to {out_path}")


# ================== CAMERA ==================
def detect_camera():
    cap = cv2.VideoCapture(0)
    os.makedirs("results", exist_ok=True)
    out_path = f"results/camera_{int(datetime.datetime.now().timestamp())}.mp4"

    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    w = int(cap.get(3))
    h = int(cap.get(4))
    out = cv2.VideoWriter(out_path, fourcc, 20, (w, h))

    print("Press CTRL+C to stop camera")

    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            frame = process_frame(frame, "CAMERA")
            out.write(frame)
    except KeyboardInterrupt:
        pass

    cap.release()
    out.release()
    print(f"✓ Camera video saved to {out_path}")


# ================== MAIN MENU ==================
def main():
    while True:
        print("\n========== STOLEN VEHICLE SYSTEM ==========")
        print("1. Detect from IMAGE")
        print("2. Detect from VIDEO")
        print("3. Detect from CAMERA")
        print("4. Exit")
        ch = input("Choose option: ").strip()

        if ch == "1":
            p = input("Image path: ").strip()
            detect_image(p)
        elif ch == "2":
            p = input("Video path: ").strip()
            detect_video(p)
        elif ch == "3":
            detect_camera()
        elif ch == "4":
            break
        else:
            print("Invalid choice")


if __name__ == "__main__":
    main()
