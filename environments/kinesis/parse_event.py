import base64
import json

def parse_event(event, context):
    # print("Received event: " + json.dumps(event, indent=2))
    records = event.get("Records")
    # print(records)
    if records:
        for record in records:
            # print(record)
            payload = record.get("kinesis").get("data")
            # print(payload)
            if payload:
                decoded_payload = base64.b64decode(payload).decode("utf-8")
                print(f"decoded payload: {decoded_payload}")
                return decoded_payload
