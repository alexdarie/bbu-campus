from google.cloud import pubsub_v1
import os
import asyncio
import websockets

credential_path = "asavage2251-c9acf02886b8.json"
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path

subscriber = pubsub_v1.SubscriberClient()
subscription_path = subscriber.subscription_path(
    'asavage2251', 'chappie-weather-measurements'
)


async def produce(message, host, port):
    async with websockets.connect(f"ws://{host}:{port}") as ws:
        try:
            await ws.send(message)
        except websockets.exceptions.ConnectionClosed as exc:
            print('da')


def callback(message):
    print(message)
    try:
        data = message.data.decode('utf-8')
        asyncio.run(produce(message=data, host='0.0.0.0', port=4000))
        message.ack()
    except Exception as exc:
        print("err", exc)


future = subscriber.subscribe(subscription_path, callback=callback)
print("Listening for messages on {}..\n".format(subscription_path))
try:
    future.result()
except:
    future.cancel()
