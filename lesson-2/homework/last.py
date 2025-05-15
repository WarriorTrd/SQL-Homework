import requests
import json
from datetime import datetime

# === CONFIGURATION ===
TRIP_ID_RANGE = range(82880, 82920)  # Search around likely trip IDs
SEAT_NUMBER = 18  # Internal test seat
BEARER_TOKEN = "f96d14e8-5a78-419d-b5c9-fc6973499578"  # Valid test token
BASE_URL = "https://wapi.congresshall.avtotickets.uz"  # Real API endpoint

# === SAVE RESPONSE ===
def save_json(data, seat_number, trip_id):
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"passenger_data_trip_{trip_id}_seat_{seat_number}_{timestamp}.json"
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"\n📝 Data saved to {filename}")

# === MAIN FUNCTION ===
def fetch_passenger_info(trip_id, seat_number, bearer_token):
    fallback_urls = [
        f"{BASE_URL}/api/tickets/{trip_id}/passenger?seat={seat_number}",
        f"{BASE_URL}/api/ticket-info?trip_id={trip_id}&seat={seat_number}",
        f"{BASE_URL}/api/trips/{trip_id}/seats/{seat_number}/info",
        f"{BASE_URL}/api/orders/lookup?trip_id={trip_id}&seat={seat_number}",
        f"{BASE_URL}/api/internal/orders/by-trip/{trip_id}"
    ]

    headers = {
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'uz',
        'Authorization': f'Bearer {bearer_token}',
        'Connection': 'keep-alive',
        'Origin': 'https://avtoticket.uz',
        'Referer': 'https://avtoticket.uz/',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'
    }

    for url in fallback_urls:
        print(f"\n[INFO] Trying endpoint: {url}")
        try:
            res = requests.get(url, headers=headers, timeout=15)
            print(f"[STATUS] HTTP {res.status_code}")

            if res.status_code == 200:
                try:
                    data = res.json()

                    if "orders" in data:
                        print("[INFO] Parsing trip manifest...")
                        for order in data["orders"]:
                            for seat in order.get("seats", []):
                                if seat.get("seat_number") == seat_number:
                                    print("\n✅ Test seat found:")
                                    print(json.dumps(seat, indent=2, ensure_ascii=False))

                                    name = seat.get("passenger_name", "N/A")
                                    doc = seat.get("document_number", "N/A")
                                    paid = seat.get("paid", False)

                                    print(f"\n🧾 Name: {name}\n🪪 Document: {doc}\n💳 Paid: {paid}")
                                    save_json(seat, seat_number, trip_id)
                                    return True
                        print("⚠️ Seat not found in trip manifest.")
                        continue

                    if data.get("errors"):
                        print("⚠️ API returned error:", data["errors"])
                        continue

                    print("\n✅ Passenger data found:")
                    print(json.dumps(data, indent=2, ensure_ascii=False))
                    save_json(data, seat_number, trip_id)
                    return True
                except json.JSONDecodeError:
                    print("❌ Invalid JSON.")
                    print(res.text[:300])
            else:
                print("❌ Error:", res.text[:300])
        except Exception as e:
            print(f"❌ Request error: {e}")

    return False

# === EXECUTE FULL SWEEP ===
found = False
for trip_id in TRIP_ID_RANGE:
    print(f"\n🔍 Testing trip ID: {trip_id}...")
    if fetch_passenger_info(trip_id, SEAT_NUMBER, BEARER_TOKEN):
        print(f"\n✅ Match found for trip ID {trip_id}.")
        found = True
        break
if not found:
    print("\n❌ Could not find any matching trip ID for seat.")