#!/usr/bin/python3

import os
import signal
import sys
import time
import ctypes
import math
import zmq

# some global definitions
last_simStat = 'SIMSTAT_UNDEF'
action = True
simControlGlobalIO = None
startS = 0.0
# DynawoZmqAddress = "tcp://simt-dynawo22:5555"
DynawoZmqAddress = "tcp://localhost:5555"

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
        # constants:
        self.dyVScalFactor = 100.0
        # setup some functions
        self.cIOlib.init_shm.argtypes = None
        self.cIOlib.init_shm.restype = ctypes.c_int
        self.cIOlib.cleanup_shm.argtypes = None
        self.cIOlib.cleanup_shm.restype = ctypes.c_int
        self.cIOlib.write_prclientDyPy_pid.argtypes = [ ctypes.c_int ]
        self.cIOlib.write_prclientDyPy_pid.restype = None

        # attach shared memory
        self.simControlGlobalId = self.cIOlib.init_shm()
        print("client-dynawo-py: shared memory id %d created"
              %  self.simControlGlobalId)
        # set pid in shared memory
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
        return self.cIOlib.read_dynIn_g06_injection_PRefPu() \
            / self.dyVScalFactor
    def read_dynIn_g06_injection_QRefPu(self):
        return self.cIOlib.read_dynIn_g06_injection_QRefPu() \
            / self.dyVScalFactor


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
    #end simControlGlobalIOcl

class DynawoConnectCl:
    def __init__(self, address="tcp://localhost:5555"):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REQ)
        self.socket.connect(address)
        #end __init__

    def trigger(self):

        back = 0
        self.socket.send_string("")
        # Wait for acknowledgment
        message = self.socket.recv_string()
        # insert if needed:
        # analyse message and set back
        return back

    def sendData(self):
        back = 0
        self.socket.send_string("dynIn_g06_injection_PRefPu" + " ,input_value,double, %e)" % read_dynIn_g06_injection_PRefPu())
        # Wait for acknowledgment
        message = self.socket.recv_string()
        self.socket.send_string("dynIn_g06_injection_QRefPu" + " ,input_value,double, %e)" % read_dynIn_g06_injection_QRefPu())
        # Wait for acknowledgment
        message = self.socket.recv_string()

        self.socket.send_string(data)
        # Wait for acknowledgment
        message = self.socket.recv_string()
        return back

    def shutdown(self):

        back = 0
        self.socket.send_string("stop")
        # Wait for acknowledgment
        message = self.socket.recv_string()
        # insert if needed
        # analyse message and set back
        return back

    #end DynawoConnectCl

def initPrClient(myPid):

    global startS
    global DynawoZmqAddress

    # time in s
    startS = time.time()
    print("client-dynawo-py pid: %d" % myPid)
    # shared memory
    simControlGlobalIO = simControlGlobalIOcl(myPid)

    # dynawo
    DynawoConnect = DynawoConnectCl(DynawoZmqAddress)
    return (simControlGlobalIO, DynawoConnect)
    #end initPrClient

def cyclic_task():
    global simControlGlobalIO
    global DynawoConnect
    global last_simStat
    global startS

    back = 0

    # get status
    simStat = simControlGlobalIO.show_simControlStatus()
    if (last_simStat != simStat):
        print("client-dynawo-py: status: " + simStat)
        last_simStat = simStat

    # state machine
    if (simStat == 'SIMSTAT_RUN'):
        print("trigger at %f" % (time.time() - startS) )
        if (DynawoConnect.trigger() != 0):
            back = -1
    elif (simStat == 'SIMSTAT_EXIT'):
        back = -1

    simControlGlobalIO.set_statusPrClientPyDy('PROCSTAT_READY')
    return back
    #end cyclic_task

def cleanupPrClient():
    global simControlGlobalIO
    global DynawoConnect

    DynawoConnect.shutdown()

    if (simControlGlobalIO.cleanup_shm() == 0):
        print("client-dynawo-py: shared memory cleaned up")
    #end cleanupPrClient


def handle_signal(signum, frame):
    global action

    # print(f"Received signal {signum}")
    signal.getsignal(signum)
    if (signum == signal.SIGUSR1):
        # print("SIGUSR1")
        if (cyclic_task() == -1):
            action = False
    elif (signum == signal.SIGINT):
        print("client-dynawo-py: SIGINT")
        print("client-dynawo-py: exit ")
        action = False
    elif (signum == signal.SIGTERM):
        print("client-dynawo-py: SIGTERM")
        print("client-dynawo-py: exit ")
        action = False
    else:
        print("client-dynawo-py: no action")
        #end else

    #end handle_signal

# main
def main():
    global simControlGlobalIO
    global DynawoConnect
    global action

    #setup global and dynawo
    (simControlGlobalIO, DynawoConnect) = initPrClient(os.getpid())

    # Assign signal handlers
    signal.signal(signal.SIGUSR1, handle_signal)
    signal.signal(signal.SIGINT, handle_signal)
    signal.signal(signal.SIGTERM, handle_signal)

    periodNs = simControlGlobalIO.read_prclientDyPy_periodNs()
    myPeriod = float(periodNs) * 1.0e-9
    print("client-dynawo-py: period %f s" % (myPeriod))
    while action:
        # sleep is interrupted by signal
        time.sleep(myPeriod)  # sleep

    cleanupPrClient()
    #end main

if __name__ == "__main__":
    # run main script if not started by shell
    main()
