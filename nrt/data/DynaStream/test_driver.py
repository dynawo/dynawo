# Copyright (c) 2026, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: MPL-2.0
import json
import os
import subprocess
import sys
import threading
import time
import unittest
from unittest import mock

import zmq

import driver

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "util", "nrt_diff"))
import nrtUtils


class ProtocolServer:
    def __init__(self, change=True, bad_reply=False):
        self.change = change
        self.bad_reply = bad_reply
        self.ready = threading.Event()
        self.stop = threading.Event()
        self.requests = []
        self.thread = threading.Thread(target=self.serve)

    def serve(self):
        ctx = zmq.Context()
        rep = ctx.socket(zmq.REP)
        pub = ctx.socket(zmq.PUB)
        rep.linger = pub.linger = 0
        self.control = "tcp://127.0.0.1:%s" % rep.bind_to_random_port("tcp://127.0.0.1")
        self.output = "tcp://127.0.0.1:%s" % pub.bind_to_random_port("tcp://127.0.0.1")
        self.ready.set()
        t = 1
        action = False
        while not self.stop.is_set():
            if not rep.poll(50):
                continue
            request = rep.recv_multipart()
            self.requests.append(request)
            if request[0] == b"action":
                action = True
                rep.send_string("action received")
            else:
                rep.send_string("wrong" if self.bad_reply else "step trigger received")
                time.sleep(0.1)
                t += 1
                value = driver.VALUE if action and self.change else 0
                pub.send_multipart([b"curves", json.dumps({"curves": {"time": t, "values": {driver.CURVE: value}}}).encode()])
        rep.close()
        pub.close()
        ctx.term()

    def __enter__(self):
        self.thread.start()
        self.ready.wait(2)
        return self

    def __exit__(self, *args):
        self.stop.set()
        self.thread.join(2)


class DriverTests(unittest.TestCase):
    def test_action_changes_curve(self):
        with ProtocolServer() as server:
            driver.run(server.control, server.output, timeout=5)
            self.assertIn([b"action", b"12_1_deltaPc,input_value,0.1"], server.requests)

    def test_acknowledgement_without_effect_fails(self):
        with ProtocolServer(change=False) as server:
            with self.assertRaisesRegex(RuntimeError, "no expected effect"):
                driver.run(server.control, server.output, timeout=5)

    def test_bad_reply_fails(self):
        with ProtocolServer(bad_reply=True) as server:
            with self.assertRaisesRegex(RuntimeError, "unexpected control reply"):
                driver.run(server.control, server.output, timeout=5)

    def test_no_server_times_out(self):
        with self.assertRaises(TimeoutError):
            driver.run("tcp://127.0.0.1:1", "tcp://127.0.0.1:2", timeout=0.2)

    def test_runner_reaps_simulator_on_driver_failure(self):
        case = nrtUtils.TestCase("x", "x", "", "/nonexistent", 1, "ALLOWED", [0])
        popen = subprocess.Popen
        children = []

        def start(*args, **kwargs):
            child = popen(*args, **kwargs)
            children.append(child)
            return child

        with mock.patch.object(nrtUtils.subprocess, "Popen", side_effect=start), \
             mock.patch.object(nrtUtils.subprocess, "run", return_value=subprocess.CompletedProcess([], 1)):
            code, _, _ = case.launch_dynastream([sys.executable, "-c", "import time; time.sleep(30)"], ROOT, 1)
        self.assertEqual(code, 1)
        self.assertIsNotNone(children[0].poll())

    def test_runner_reaps_simulator_on_driver_timeout(self):
        case = nrtUtils.TestCase("x", "x", "", "/nonexistent", 1, "ALLOWED", [0])
        popen = subprocess.Popen
        children = []

        def start(*args, **kwargs):
            child = popen(*args, **kwargs)
            children.append(child)
            return child

        with mock.patch.object(nrtUtils.subprocess, "Popen", side_effect=start), \
             mock.patch.object(nrtUtils.subprocess, "run", side_effect=subprocess.TimeoutExpired("driver", 1)):
            code, _, _ = case.launch_dynastream([sys.executable, "-c", "import time; time.sleep(30)"], ROOT, 1)
        self.assertEqual(code, -150)
        self.assertIsNotNone(children[0].poll())


if __name__ == "__main__":
    unittest.main()
