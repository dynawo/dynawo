import argparse
import zmq
import struct

def parse_args():
    parser = argparse.ArgumentParser(description="zmq topic to subscribe")
    parser.add_argument('--topic', '-t', type=str, default='', help='')
    return parser.parse_args()

def main(topic=None):
    address="tcp://localhost:5556"
    context = zmq.Context()
    socket = context.socket(zmq.SUB)
    socket.connect(address)
    if topic is None:
        socket.setsockopt(zmq.SUBSCRIBE, b"")
    else:
        socket.setsockopt(zmq.SUBSCRIBE, topic.encode("utf-8"))
    poller = zmq.Poller()
    poller.register(socket, zmq.POLLIN)
    print("Starting receiver loop")
    while True:
        events = dict(poller.poll(5000))
        if socket in events:
            recv_topic = socket.recv_string()
            data = socket.recv()
            if recv_topic == "curves_values":
                num_doubles = len(data) // 8
                values = struct.unpack(f'{num_doubles}d', data)
                print(f"Received (topic: {recv_topic}):\n{values}")
            else:
                print(f"Received (topic: {recv_topic}):\n{data.decode()}")


if __name__ == "__main__":
    args = parse_args()
    main(args.topic)
