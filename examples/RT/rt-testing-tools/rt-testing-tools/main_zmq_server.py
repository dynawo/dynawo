
import zmq

class ControlReceiver:
    def __init__(self, address="tcp://*:5555"):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REP)
        self.socket.bind(address)
        print(f"Server listening on {address}")

    def start(self):
        while True:
            # Receive the first part (topic)
            topic = self.socket.recv_string()
            print(f"Received topic: {topic}")

            # Handle multi-part messages
            chunks = []
            while self.socket.getsockopt(zmq.RCVMORE):
                chunk = self.socket.recv()
                chunks.append(chunk)

            # Process the message
            response = self.handle_message(topic, chunks)

            # Send acknowledgment
            self.socket.send_string(response)

    def handle_message(self, topic, chunks):
        if topic == "action":
            print(f"Action received: {chunks}")
            return chunks
        elif topic == "step":
            print("Step trigger received")
            return "Step acknowledged"
        elif topic == "stop":
            print("Stop signal received")
            return "Stopped"
        elif topic == "dump":
            print("Dump trigger received")
            return "Dump acknowledged"
        else:
            print(f"Unknown topic: {topic}")
            return "Unknown command"

if __name__ == "__main__":
    receiver = ControlReceiver()
    receiver.start()
