import asyncio
import websockets
import json

from google.cloud import pubsub_v1
import os

credential_path = "asavage2251-c9acf02886b8.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(
    "asavage2251", "chappie-display-settings"
)

publisher2 = pubsub_v1.PublisherClient()
topic_path2 = publisher2.topic_path(
    "asavage2251", "chappie-pairing"
)

async def consumer_handler(websocket):
    async for message in websocket:
        print("initial message:", message)
        if "displayCode" in message:
            print("is displayCode:", message)
            message = json.loads(message)
            data = "{\"displayCode\": " + str(message["displayCode"]) + "}"
            data = data.encode('utf-8')
            future = publisher.publish(topic_path, data=data)
            print(future.result())
        elif "emit" in message:
            print("is emit: ", message)
            message = json.loads(message)
            # data = "{\"emit\": \"" + str(message["emit"]) + "\"}"
            data = json.dumps(message)
            data = data.encode('utf-8')
            future = publisher.publish(topic_path2, data=data)
            print(future.result())


async def consume(hostname, port):
    websocket_resource_url = f"ws://{hostname}:{port}"
    async with websockets.connect(websocket_resource_url) as websocket:
        await consumer_handler(websocket)

loop = asyncio.get_event_loop()
loop.run_until_complete(consume(hostname="0.0.0.0", port="4000"))
loop.run_forever()
