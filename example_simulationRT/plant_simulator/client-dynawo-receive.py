#!/usr/bin/python3

import os
import sys
import time
import ctypes
import math
import argparse
import zmq
import struct

def parse_args():
    parser = argparse.ArgumentParser(description="zmq topic to subscribe")
    parser.add_argument('--topic', '-t', type=str, default='', help='')
    return parser.parse_args()

# some global definitions
last_simStat = 'SIMSTAT_UNDEF'
action = True
simControlGlobalIO = None
# DynawoZmqPubAddress = "tcp://simt-dynawo22:5556"
DynawoZmqPubAddress = "tcp://localhost:5556"

class simControlGlobalIOcl:
    # read an write into control global in shared memory

    # some definitions
    cIOlibFileName = "./libpython-shm-io.so"
    cIOlib = None
    simControlGlobalId = -1
    simControlStatusList = (
        'SIMSTAT_UNDEF',
        'SIMSTAT_INIT',
        'SIMSTAT_FREEZE',
        'SIMSTAT_STEP',
        'SIMSTAT_RUN',
        'SIMSTAT_HOLD',
        'SIMSTAT_TERM',
        'SIMSTAT_FAIL',
        'SIMSTAT_IPCR',
        'SIMSTAT_RESUME',
        'SIMSTAT_EXIT' )
    statusPrClientList = (
        'PROCSTAT_READY',
        'PROCSTAT_STEPPING' )


    def __init__(self, myPid):

        self.cIOlib = ctypes.CDLL(self.cIOlibFileName)
        # setup some functions
        self.cIOlib.init_shm.argtypes = None
        self.cIOlib.init_shm.restype = ctypes.c_int
        self.cIOlib.cleanup_shm.argtypes = None
        self.cIOlib.cleanup_shm.restype = ctypes.c_int
        self.cIOlib.write_prclientDyPy_pid.argtypes = [ ctypes.c_int ]
        self.cIOlib.write_prclientDyPy_pid.restype = None
        self.curveValuesWritten = 0

        # attach shared memory
        self.simControlGlobalId = self.cIOlib.init_shm()
        print("client-dynawo-py: shared memory id %d created"
              %  self.simControlGlobalId)
        # set pid in shared memory
        if (myPid != 0):
            self.cIOlib.write_prclientDyPy_pid(myPid)
        # setup read functions
        self.initReadFunctions()
        # setup write functions
        self.initWriteFunctions()
        #end __ini__

    def show_simControlStatus(self):
        return self.simControlStatusList[self.read_simControlStatus()]

    def set_statusPrClientPyDy(self,Status):

        back = 0
        if self.statusPrClientList.__contains__(Status):
            IntStat = self.statusPrClientList.index(Status)
            self.write_statusPrClientDyPy(IntStat)
        else:
            back = -1
        return back
        #end statusPrClientPy

    def initReadFunctions(self):
        self.cIOlib.read_simControlStatus.argtypes = None
        self.cIOlib.read_statusPrClientDyPy.argtypes = None
        self.cIOlib.read_prclientDyPy_periodNs.argtypes = None
        self.cIOlib.read_prclientDyPy_LoopLimit.argtypes = None

        self.cIOlib.read_simControlStatus.restype = ctypes.c_int
        self.cIOlib.read_prclientDyPy_periodNs.restype = ctypes.c_long
        self.cIOlib.read_prclientDyPy_LoopLimit.restype = ctypes.c_int
        self.cIOlib.read_dynIn_g06_injection_PRefPu.restype = ctypes.c_double
        self.cIOlib.read_dynIn_g06_injection_QRefPu.restype = ctypes.c_double
        #end initReadFunctions

    def initWriteFunctions(self):
        self.cIOlib.write_simControlStatus.argtypes = [ ctypes.c_int ]
        self.cIOlib.write_statusPrClientDyPy.argtypes = [ ctypes.c_int ]
        self.cIOlib.write_prclientDyPy_periodNs.argtypes = [ ctypes.c_long]
        self.cIOlib.write_prclientDyPy_LoopLimit.argtypes = [ ctypes.c_int]
        self.cIOlib.write_resultPrClientDyPy.argtypes = [ ctypes.c_double]

        self.cIOlib.write_simControlStatus.restype = None
        self.cIOlib.write_prclientDyPy_periodNs.restype = None
        self.cIOlib.write_prclientDyPy_LoopLimit.restype = None
        self.cIOlib.write_resultPrClientDyPy.restype = None
        #end initWriteFunctions

    def cleanup_shm(self):
        return self.cIOlib.cleanup_shm()

    # all read functions
    def read_simControlStatus(self):
        return self.cIOlib.read_simControlStatus()
    def read_statusPrClientDyPy(self):
        return self.cIOlib.read_statusPrClientDyPy()
    def read_prclientDyPy_periodNs(self):
        return self.cIOlib.read_prclientDyPy_periodNs()
    def read_prclientDyPy_pid(self):
        return self.cIOlib.read_prclientDyPy_pid()
    def read_prclientDyPy_LoopLimit(self):
        return self.cIOlib.read_prclientDyPy_LoopLimit()
    def read_dynIn_g06_injection_PRefPu(self):
        return self.cIOlib.read_dynIn_g06_injection_PRefPu()
    def read_dynIn_g06_injection_QRefPu(self):
        return self.cIOlib.read_dynIn_g06_injection_QRefPu()


    # all write functions
    def write_simControlStatus(self,simControlStatus):
        self.cIOlib.write_simControlStatus(simControlStatus)
    def write_statusPrClientDyPy(self, statusPrClientDyPy):
        self.cIOlib.write_statusPrClientDyPy(statusPrClientDyPy)
    def write_prclientDyPy_periodNs(self,prclientDyPy_periodNs):
        self.cIOlib.write_prclientDyPy_periodNs(prclientDyPy_periodNs)
    def write_prclientDyPy_pid(self,prclientDyPy_pid):
        self.cIOlib.write_prclientDyPy_pid(prclientDyPy_pid)
    def write_prclientDyPy_LoopLimit(self,prclientDyPy_LoopLimit):
        self.cIOlib.write_prclientDyPy_LoopLimit(prclientDyPy_LoopLimit)
    def write_resultPrClientDyPy(self, result):
        self.cIOlib.write_resultPrClientDyPy(result)
    def write_dynOut_bus_BG06_U(self,dynOut_bus_BG06_U):
        self.cIOlib.write_dynOut_bus_BG06_U(dynOut_bus_BG06_U)
    def write_dynOut_bus_BG06_UPhase(self,dynOut_bus_BG06_UPhase):
        self.cIOlib.write_dynOut_bus_BG06_UPhase(dynOut_bus_BG06_UPhase)
    def write_dynOut_bus_1042_U(self,dynOut_bus_1042_U):
        self.cIOlib.write_dynOut_bus_1042_U(dynOut_bus_1042_U)
    def write_dynOut_bus_1042_UPhase(self,dynOut_bus_1042_UPhase):
        self.cIOlib.write_dynOut_bus_1042_UPhase(dynOut_bus_1042_UPhase)
    def write_dynOut_line_1042_1044a_P1Pu(self,dynOut_line_1042_1044a_P1Pu):
        self.cIOlib.write_dynOut_line_1042_1044a_P1Pu(dynOut_line_1042_1044a_P1Pu)
    def write_dynOut_line_1042_1044a_Q1Pu(self,dynOut_line_1042_1044a_Q1Pu):
        self.cIOlib.write_dynOut_line_1042_1044a_Q1Pu(dynOut_line_1042_1044a_Q1Pu)
    def write_dynOut_line_1042_1044b_P1Pu(self,dynOut_line_1042_1044b_P1Pu):
        self.cIOlib.write_dynOut_line_1042_1044b_P1Pu(dynOut_line_1042_1044b_P1Pu)
    def write_dynOut_line_1042_1044b_Q1Pu(self,dynOut_line_1042_1044b_Q1Pu):
        self.cIOlib.write_dynOut_line_1042_1044b_Q1Pu(dynOut_line_1042_1044b_Q1Pu)
    def write_dynOut_line_1042_1045_P1Pu(self,dynOut_line_1042_1045_P1Pu):
        self.cIOlib.write_dynOut_line_1042_1045_P1Pu(dynOut_line_1042_1045_P1Pu)
    def write_dynOut_line_1042_1045_Q1Pu(self,dynOut_line_1042_1045_Q1Pu):
        self.cIOlib.write_dynOut_line_1042_1045_Q1Pu(dynOut_line_1042_1045_Q1Pu)

    def writeCurveValues(self, value):
        back = 0
        expect = 10
        if (value.__len__() == expect):
            self.write_dynOut_bus_BG06_U(value[0])
            self.write_dynOut_bus_BG06_UPhase(value[1])
            self.write_dynOut_bus_1042_U(value[2])
            self.write_dynOut_bus_1042_UPhase(value[3])
            self.write_dynOut_line_1042_1044a_P1Pu(value[4])
            self.write_dynOut_line_1042_1044a_Q1Pu(value[5])
            self.write_dynOut_line_1042_1044b_P1Pu(value[6])
            self.write_dynOut_line_1042_1044b_Q1Pu(value[7])
            self.write_dynOut_line_1042_1045_P1Pu(value[8])
            self.write_dynOut_line_1042_1045_Q1Pu(value[9])
            self.curveValuesWritten += expect
            #end value__len = expect
        else:
            print("writeCurveValues error: %d values reveived, %d expected"\
                      % ((value.__len__()), expect))
            ValNo = 0
            for Val in value:
                print("value %d: %s" % (ValNo, Val))
                ValNo += 1
            back = 1
        return back
        #end writeCurveValues
    #end simControlGlobalIOcl

class DynawoConnectCl:
    def __init__(self, address="tcp://localhost:5556", topic=None):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.SUB)
        self.socket.connect(address)
        if topic is None:
            self.socket.setsockopt(zmq.SUBSCRIBE, b"")
        else:
            self.socket.setsockopt(zmq.SUBSCRIBE, topic.encode("utf-8"))
            print("utf-8 encoded subscribed")

        self.poller = zmq.Poller()
        self.poller.register(self.socket, zmq.POLLIN)
        #end __init__

    def getEvents(self):
        recv_topic = ""
        data = None
        events = dict(self.poller.poll(5000))
        if self.socket in events:
            recv_topic = self.socket.recv_string()
            data = self.socket.recv()
        return (recv_topic, data)
        #end getEvents

    def shutdown(self):

        back = 0
        self.socket.send_string("stop")
        # Wait for acknowledgment
        message = self.socket.recv_string()
        # insert if needed
        # analyse message and set back
        return back

    #end DynawoConnectCl


def main(topic=None):
    global DynawoZmqPubAddress

    # global in shared memory
    simControlGlobalIO = simControlGlobalIOcl(0)
    # dynawo
    DynawoConnect = DynawoConnectCl(DynawoZmqPubAddress)
    print("Starting receiver loop")
    startS = time.time()
    Go = True
    while Go:
        # get status
        simStat = simControlGlobalIO.show_simControlStatus()
        if (simStat == 'SIMSTAT_EXIT'):
             Go = False

        (topic, data) = DynawoConnect.getEvents()
        print("at %f received topic: %s" % \
                  ((time.time() - startS), topic))

        if topic == "curves_values":
            num_doubles = len(data) // 8
            values = struct.unpack("%dd" % num_doubles, data)
            simControlGlobalIO.writeCurveValues(values)
        #end while Go

    print("%d curve values written into shm" \
              % simControlGlobalIO.curveValuesWritten)
    if (simControlGlobalIO.cleanup_shm() == 0):
        print("client-dynawo-py: shared memory cleaned up")

    #end main

if __name__ == "__main__":
    args = parse_args()
    main(args.topic)
