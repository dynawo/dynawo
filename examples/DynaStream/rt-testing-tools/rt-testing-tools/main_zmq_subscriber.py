# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
import argparse
import zmq
import struct
import signal
from pathlib import Path

def parse_args():
    parser = argparse.ArgumentParser(description="zmq topic to subscribe")
    parser.add_argument('--topic', '-t', type=str, default='', help='')
    parser.add_argument('--dump_dir', '-d', type=str, default=None, help='')
    return parser.parse_args()

def signal_handler(sig, frame):
    global running
    running = False

def main(topic, dump_dir):
    global running
    running = True
    signal.signal(signal.SIGINT, signal_handler)
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
    while running is True:
        events = dict(poller.poll(100))
        if socket in events:
            recv_topic = socket.recv_string()
            data = socket.recv()
            if recv_topic == "curves_values":
                num_doubles = len(data) // 8
                values = struct.unpack(f'{num_doubles}d', data)
                print(f"Received (topic: {recv_topic}):\n{values}")
            elif recv_topic == "dump":
                print(f"dump received ({len(data)} bytes)")
                if dump_dir is not None:
                    dump_dir_path = Path(dump_dir)
                    if dump_dir_path.is_dir():
                        filename = dump_dir_path / "latest_dump.dmp"
                        if filename.exists():
                            os.remove(filename)
                        with open(filename, "wb+") as f:
                            f.write(data)
                    else:
                        raise NotADirectoryError('Dump directory does not exist: {dump_dir}')
                else:
                    print("No dump directory given for writing to disk")
            else:
                print(f"Received (topic: {recv_topic}):\n{data.decode()}")


if __name__ == "__main__":
    args = parse_args()
    main(args.topic, args.dump_dir)
