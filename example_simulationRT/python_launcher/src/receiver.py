
import time

import zmq

def main():
    address="tcp://localhost:5556"
    context = zmq.Context()
    socket = context.socket(zmq.REP)
    socket.connect(address)

    print("Starting receiver loop")
    while True:
        message = socket.recv_string()
        print(f"Received: {message}")

        reply_text = "OK"
        socket.send_string(reply_text)
        time.sleep(0.1)

if __name__ == "__main__":
    main()
