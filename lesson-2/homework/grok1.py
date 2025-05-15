import requests
import json
from datetime import datetime
import logging

# Set up logging for debugging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# API headers (as provided, assumed valid for testing)
headers = {
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'uz',
    'Authorization': 'Bearer f96d14e8-5a78-419d-b5c9-fc6973499578',
    'Connection': 'keep-alive',
    'Origin': 'https://avtoticket.uz',
    'Referer': 'https://avtoticket.uz/',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'cross-site',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
    'sec-ch-ua': '"Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"'
}

def fetch_order_by_id(order_id, base_url="https://wapi.congresshall.avtotickets.uz"):
    """Fetch order details by order ID."""
    url = f"{base_url}/api/order-data?order_id={order_id}"
    try:
        logger.info(f"Querying order ID: {order_id}")
        res = requests.get(url, headers=headers, timeout=10)
        if res.status_code == 200:
            return res.json()
        else:
            logger.error(f"Failed to fetch order {order_id}. Status code: {res.status_code}, Response: {res.text}")
            return None
    except requests.RequestException as e:
        logger.error(f"Error querying order {order_id}: {str(e)}")
        return None

def fetch_orders_by_trip(trip_date, trip_time, from_city, to_city, seat_number, base_url="https://wapi.congresshall.avtotickets.uz"):
    """Fetch orders for a specific trip and seat (mocked endpoint, adjust based on API docs)."""
    # Format date and time for API (assuming ISO format, adjust as per API)
    trip_datetime = f"{trip_date}T{trip_time}:00"
    params = {
        'trip_date': trip_datetime,
        'from_city': from_city,
        'to_city': to_city,
        'seat_number': seat_number
    }
    url = f"{base_url}/api/trip-orders"  # Hypothetical endpoint, replace with actual
    try:
        logger.info(f"Querying trip orders: {params}")
        res = requests.get(url, headers=headers, params=params, timeout=10)
        if res.status_code == 200:
            orders = res.json()
            # Filter for the specific seat
            for order in orders.get('orders', []):
                if order.get('seat_number') == seat_number:
                    return order
            logger.warning(f"No order found for seat {seat_number} on trip {trip_datetime}")
            return None
        else:
            logger.error(f"Failed to fetch trip orders. Status code: {res.status_code}, Response: {res.text}")
            return None
    except requests.RequestException as e:
        logger.error(f"Error querying trip orders: {str(e)}")
        return None

def main():
    # Test seat details
    order_id = "7b56edd2-9197-4786-8c0c-df3661430cf6"  # Provided, may not match test seat
    trip_date = "2025-05-03"  # May 3, 2025
    trip_time = "22:30"  # 22:30
    from_city = "Tashkent"
    to_city = "Bukhara"
    seat_number = 18

    # Step 1: Try fetching by order_id
    logger.info("Attempting to fetch by order ID...")
    order_data = fetch_order_by_id(order_id)
    if order_data and order_data.get('seat_number') == seat_number:
        logger.info("✅ Order found by ID:")
        print(json.dumps(order_data, indent=2, ensure_ascii=False))
        with open("test_seat_result.json", "w", encoding="utf-8") as f:
            json.dump(order_data, f, indent=2, ensure_ascii=False)
        return

    # Step 2: If order_id fails or doesn't match, try fetching by trip details
    logger.info("Order ID failed or mismatched, attempting to fetch by trip details...")
    order_data = fetch_orders_by_trip(trip_date, trip_time, from_city, to_city, seat_number)
    if order_data:
        logger.info("✅ Order found by trip details:")
        print(json.dumps(order_data, indent=2, ensure_ascii=False))
        with open("test_seat_result.json", "w", encoding="utf-8") as f:
            json.dump(order_data, f, indent=2, ensure_ascii=False)
    else:
        logger.error("❌ No order found for the specified seat and trip.")
        print("❌ Failed to retrieve passenger info. Check API endpoint, token, or trip details.")

if __name__ == "__main__":
    main()