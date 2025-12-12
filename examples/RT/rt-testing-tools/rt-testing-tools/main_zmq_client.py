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

import zmq

class ControlSender:
    def __init__(self, address="tcp://localhost:5555"):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REQ)
        self.socket.connect(address)

    def _send(self, topic, format="string", *chunks):
        print(f"Sending control '{topic}'")
        if len(chunks) == 0:
            self.socket.send_string(f"{topic}")
        else:
            self.socket.send_string(f"{topic}", zmq.SNDMORE)
            for chunk in chunks[:-1]:
                if format == "string":
                    self.socket.send_string(f"{chunk}", zmq.SNDMORE)
                elif format == "bytes":
                    self.socket.send(memoryview(chunk), zmq.SNDMORE)

            # last part:
            if format == "string":
                self.socket.send_string(f"{chunks[-1]}")
            elif format == "bytes":
                self.socket.send(memoryview(chunks[-1]))

            if topic != "load":
                print(f'{chunks[-1]}')
        # Wait for acknowledgment
        message = self.socket.recv_string()
        print(f"return received: '{message}'")

    def send_action(self, actions):
        self._send("action", "string", *actions)

    def send_step_trigger(self):
        self._send("step")

    def send_stop(self):
        self._send("stop")

    def send_dump_trigger(self):
        self._send("dump")

    def send_load_file(self, filename):
        with open(filename, 'rb') as f:
            data = f.read()
            print(f"file size: {len(data)}")
            self._send("load", "bytes", data)

if __name__ == "__main__":
    sender = ControlSender()
