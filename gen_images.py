import os, base64, json, urllib.request

api_key = os.environ["OPENAI_API_KEY"]
out_dir = r"C:\source\dadaroo\assets\images"
os.makedirs(out_dir, exist_ok=True)

images = [
    ("app_icon.png", "A fun warm cartoon app icon for a mobile app called Dadaroo. Shows a happy cartoon dad in a car holding a takeaway food bag, warm orange and brown colour scheme, simple rounded icon style suitable for mobile app icon, no text, flat design"),
    ("splash.png", "A warm friendly splash screen illustration for a family takeaway delivery app called Dadaroo. A cartoon dad driving home with takeaway bags, happy family waiting at home visible through a window, warm orange and brown tones, fun and inviting, no text"),
    ("badge_speed.png", "A fun cartoon badge icon of a lightning bolt with a takeaway bag, gold and orange colours, achievement badge style, simple flat design, no text"),
    ("badge_chef.png", "A fun cartoon badge icon of a chef hat with a gold star, orange and brown colours, achievement badge style, simple flat design, no text"),
]

for filename, prompt in images:
    print("Generating: " + filename)
    body = json.dumps({
        "model": "gpt-image-1",
        "prompt": prompt,
        "n": 1,
        "size": "1024x1024",
        "quality": "high"
    }).encode()
    req = urllib.request.Request(
        "https://api.openai.com/v1/images/generations",
        data=body,
        headers={"Authorization": "Bearer " + api_key, "Content-Type": "application/json"}
    )
    resp = urllib.request.urlopen(req, timeout=120)
    data = json.loads(resp.read())
    b64 = data["data"][0]["b64_json"]
    with open(os.path.join(out_dir, filename), "wb") as f:
        f.write(base64.b64decode(b64))
    print("  Saved: " + filename)

print("Done!")
