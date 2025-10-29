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

class ActionSender:
    def __init__(self, address="tcp://localhost:5555"):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REQ)
        self.socket.connect(address)

    def send(self, message):
        print(f"Sending action: {message}")
        self.socket.send_string(message)

        # Wait for acknowledgment
        message = self.socket.recv_string()
        print(f"return received: {message}")


if __name__ == "__main__":
    sender = ActionSender()
