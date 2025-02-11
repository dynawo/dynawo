import zmq


class ActionSender:
    def __init__(self):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REQ)
        self.socket.connect("tcp://localhost:5555")

    def send_action(self, message):
        print(f"Sending action: {message}")
        self.socket.send_string(message)

        # Wait for acknowledgment
        message = self.socket.recv_string()
        if message == "OK":
            print("Action acknowledged by Simulator")
        else:
            print(f"Action failed: {message}")


if __name__ == '__main__':
    cmd = ""
