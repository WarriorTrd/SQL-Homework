import requests
import json

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

order_id = "7b56edd2-9197-4786-8c0c-df3661430cf6"
url = f"https://wapi.congresshall.avtotickets.uz/api/order-data?order_id={order_id}"

res = requests.get(url, headers=headers)
if res.status_code == 200:
    print("✅ INFO FOUND:")
    print(json.dumps(res.json(), indent=2, ensure_ascii=False))
    with open("test_seat_result.json", "w", encoding="utf-8") as f:
        json.dump(res.json(), f, indent=2, ensure_ascii=False)
else:
    print("❌ Failed. Status code:", res.status_code)
