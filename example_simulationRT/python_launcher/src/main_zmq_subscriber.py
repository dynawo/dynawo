
import zmq
from logging_config import setup_logging

def main():
    address="tcp://localhost:5556"
    context = zmq.Context()
    socket = context.socket(zmq.SUB)
    socket.connect(address)
    socket.subscribe(b'')
    poller = zmq.Poller()
    poller.register(socket, zmq.POLLIN)
    print("Starting receiver loop")
    while True:
        events = dict(poller.poll(5000))
        if socket in events:
            message = socket.recv()
            print(f"Received:\n{message.decode()}")

if __name__ == "__main__":
    setup_logging()
    main()
