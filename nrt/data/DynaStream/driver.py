# Copyright (c) 2026, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: MPL-2.0
"""Drive the Nordic NRT. The simulation is started and owned by the NRT runner."""
import json
import math
import sys
import time

import zmq

CONTROL = "tcp://127.0.0.1:15555"
OUTPUT = "tcp://127.0.0.1:15556"
CURVE = "NETWORK_12_1_DeltaPc"
VALUE = 0.1


def run(control=CONTROL, output=OUTPUT, timeout=60):
    deadline = time.monotonic() + timeout
    context = zmq.Context()
    req = context.socket(zmq.REQ)
    sub = context.socket(zmq.SUB)
    req.setsockopt(zmq.LINGER, 0)
    sub.setsockopt(zmq.LINGER, 0)
    sub.setsockopt_string(zmq.SUBSCRIBE, "curves")
    req.connect(control)
    sub.connect(output)

    def wait(socket):
        remaining = max(0, int((deadline - time.monotonic()) * 1000))
        if not remaining or not socket.poll(remaining, zmq.POLLIN):
            raise TimeoutError("timed out waiting for DynaStream")

    def send(parts, expected):
        print("sending", parts, flush=True)
        req.send_multipart([part.encode() for part in parts])
        wait(req)
        reply = req.recv_string()
        if reply != expected:
            raise RuntimeError("unexpected control reply: " + reply)

    def curve():
        wait(sub)
        topic, payload = sub.recv_multipart()
        if topic != b"curves":
            raise RuntimeError("unexpected output topic")
        data = json.loads(payload)["curves"]
        print("curve time", data["time"], flush=True)
        return data["time"], data["values"][CURVE]

    try:
        # PUB/SUB has no readiness handshake. Retry a bounded number of steps
        # if a publication was missed while the subscription was connecting.
        for attempt in range(3):
            if sub.poll(min(1000, max(0, int((deadline - time.monotonic()) * 1000))), zmq.POLLIN):
                break
            send(["step"], "step trigger received")
        t, baseline = curve()
        if t > 3:
            raise RuntimeError("baseline arrived too late: %s" % t)
        if not math.isfinite(baseline) or math.isclose(baseline, VALUE, abs_tol=1e-5):
            raise RuntimeError("unexpected baseline curve value: %s" % baseline)
        send(["action", "12_1_deltaPc,input_value,0.1"], "action received")
        # Requests are queued in order; the step is processed after the action.
        # Accept the next publication only after the action has had a full step.
        send(["step"], "step trigger received")
        while True:
            next_t, value = curve()
            if next_t > t:
                break
        while next_t < 5 and not math.isclose(value, VALUE, rel_tol=1e-4, abs_tol=1e-5):
            send(["step"], "step trigger received")
            previous = next_t
            while next_t <= previous:
                next_t, value = curve()
        if not math.isclose(value, VALUE, rel_tol=1e-4, abs_tol=1e-5):
            raise RuntimeError("action had no expected effect: %s at %s" % (value, next_t))
        # Advance through the stop time, which itself waits for a trigger.
        for _ in range(5):
            if next_t >= 5:
                break
            send(["step"], "step trigger received")
            previous = next_t
            while next_t <= previous:
                next_t, _ = curve()
        send(["step"], "step trigger received")
    finally:
        req.close()
        sub.close()
        context.term()


if __name__ == "__main__":
    try:
        run()
    except Exception as exc:
        print("DynaStream driver failed: %s" % exc, file=sys.stderr)
        sys.exit(1)
