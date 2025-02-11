import zmq


class ActionSender:
    def __init__(self, address="tcp://localhost:5555"):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REQ)
        self.socket.connect(address)

    def send_action(self, message):
        print(f"Sending action: {message}")
        self.socket.send_string(message)

        # Wait for acknowledgment
        message = self.socket.recv_string()
        print(f"return received: {message}")
