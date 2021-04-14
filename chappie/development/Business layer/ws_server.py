import asyncio
import websockets
from websockets import WebSocketServerProtocol


class Server:
    clients = set()

    async def register(self, ws):
        self.clients.add(ws)
    
    async def unregister(self, ws):
        self.clients.remove(ws)

    async def send_to_clients(self, message):
        if self.clients:
            await asyncio.wait([client.send(message) for client in self.clients])

    async def ws_handler(self, ws: WebSocketServerProtocol, uri: str):
        await self.register(ws)
        try:
            await self.distribute(ws)
        finally:
            await self.unregister(ws)

    async def distribute(self, ws):
        for c in self.clients:
            print(c)
        async for message in ws:
            await self.send_to_clients(message)

host = "0.0.0.0"
port = 4000
server = Server()
start_server = websockets.serve(server.ws_handler, host, port)
print(f"Listening for messages on {host}:{port}..\n")
loop = asyncio.get_event_loop()
loop.run_until_complete(start_server)
loop.run_forever()

