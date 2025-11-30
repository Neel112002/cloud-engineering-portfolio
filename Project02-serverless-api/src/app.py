import json
import os
import uuid
import boto3
from datetime import datetime

table_name = os.environ["TABLE_NAME"]
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(table_name)


def lambda_handler(event, context):
    # event is HTTP API payload (v2.0)
    try:
        body = json.loads(event.get("body") or "{}")
    except json.JSONDecodeError:
        return _response(400, {"message": "Invalid JSON body"})

    name = body.get("name")
    email = body.get("email")
    message = body.get("message")

    if not (name and email and message):
        return _response(400, {"message": "name, email, and message are required"})

    item = {
        "id": str(uuid.uuid4()),
        "name": name,
        "email": email,
        "message": message,
        "created_at": datetime.utcnow().isoformat() + "Z",
    }

    table.put_item(Item=item)

    return _response(201, {"message": "Feedback saved", "id": item["id"]})


def _response(status_code, body_dict):
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body_dict),
    }
