"""Lambda function"""
import json
import boto3

TABLE_NAME = "Counter"

dynamo = boto3.resource("dynamodb").Table(TABLE_NAME)


def lambda_handler(event, context):
    """Lambda handler to update view count"""
    event_body_object = json.loads(event["body"])

    counter_id = event_body_object["counter_id"]

    result = dynamo.get_item(
        Key={"CounterID": counter_id},
    )

    cur_view_count = int(result["Item"]["PageViewCount"]) | 0

    response = dynamo.update_item(
        Key={"CounterID": counter_id},
        ReturnValues="ALL_NEW",
        UpdateExpression="SET PageViewCount = PageViewCount + :val",
        ExpressionAttributeValues={
            ":val": 1,
        },
    )

    new_view_count = int(response["Attributes"]["PageViewCount"]) | 0

    return {"previous_view_count": cur_view_count, "new_view_count": new_view_count}
