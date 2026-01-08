import json

def handler(event, context):
    print("🔔 Event received from EventBridge:")
    print(json.dumps(event, indent=2))

    # Extract S3 details from EventBridge event
    try:
        bucket_name = event["detail"]["bucket"]["name"]
        object_key = event["detail"]["object"]["key"]
        object_size = event["detail"]["object"].get("size", "Unknown")

        print(f"📦 Bucket Name : {bucket_name}")
        print(f"📄 Object Key  : {object_key}")
        print(f"📏 Object Size : {object_size} bytes")

    except KeyError as e:
        print(f"❌ Error parsing event: Missing key {e}")
        return {
            "statusCode": 400,
            "body": "Invalid EventBridge S3 event"
        }

    return {
        "statusCode": 200,
        "body": f"File {object_key} successfully processed"
    }
