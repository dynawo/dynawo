# Real-Time Dynawo documentation

Real-Time Dynawo is an expermental mode of Dynawo allowing interactive simulation. It is built and tested with DynaWaltz models and solver (long-term stability oriented with fixed time-step), without being restricted to it.

It includes:
- Management of time for real-time synchronization
- Capability to modify model parameters and variables in the runtime
- Interfaces for inputs and outputs (ZMQ, Websocket)

## Time management

Time synchronization can happen internaly (sleep in simulation loop), or externaly (trigger the simulation of a configured ammount time).

### Internal time synchronization

A sleep is added in the loop. Enabled and configured in Jobs file.

| Job Simulation attribute | Value | Description|
|----------|:-------------:|---|
| timeSync | true/(false)| Enable internal time synchronization |
| timeSyncAcceleration | float | Acceleration factor of the simulation |

### External time syncrhonization

Dynawo is orchestrated by an extenal signal which triggers the simulation of a configured amount of time.

This signal is received by Dynawo through ZMQ connector (port 5555).

| Job Simulation attribute | Value | Description|
|----------|:-------------:|---|
| eventSubscriberTrigger | true/(false)| Enable trigger subscription |
| triggerSimulationTimeStepInS | float | Ammount of time to be simulated after trigger signal is received |

## Dynawo inputs

Modelica model parameter or DYNUpdatableX (X = Boolean, Integer, Continuous, Discrete) model value can be modified after an action is received by Dynawo through its ZMQ connector (port 5555)

It should be sent with a series of: "<model>,<parameter1>,<type1(bool,int,double)>,<value1>,<parameter2>,<type2>,<value2>"...


| Job Simulation attribute | Value | Description|
|----------|:-------------:|---|
| eventSubscriberActions | true/(false)| Enable event subscription |


## Dynawo outputs

Dynawo outputs can be sent during the simulation with a publication rate depending on the time management mode:
- Internal time management: results sent after each simulation loop;
- External time management: results sent following the rate defined by triggerSimulationTimeStepInS (send last results before waiting for trigger).

Results can be exported though ZMQ or WebSocket. ZMQ publication use topics for curves, constraints, and timeline (topic is represented by a string at the beggining of the message, separated from the data by a newline char). WebSocket publication only concerns curves where they are sent in JSON format.

Outputs include:
- Dynawo Curves values (as defined in curves "CRV" file) -> ZMQ (topic "curves") or WebSocket
- Dynawo Constraints (equipment ID, side, type) -> ZMQ (topic "constraints")
- Dynawo Timeline (time, model name, message) -> ZMQ (topic "timeline")

| Job Simulation attribute | Value | Description|
|----------|:-------------:|---|
| publishToZmq | true/(false)| Enable publication to ZMQ (port 5556)|
| publishToZmqCurvesFormat | ("JSON")/"CSV"| Output curves format |
| publishToWebsocket | true/(false)| Enable sending results to websocket (port 9001) |

NB: interactive mode disables the recording of curves values for file export at the end of the simulation, hence "jobs-with-curves" launcher won't have any effect.

## Sumary of new Jobs parameters

New attributes areAdded to the **simulation** tag in the jobs file.

Synchronize with dynawo internal sleep:
- timeSync (bool): enable the internal synchronization
- timeSyncAcceleration (float): acceleration factor (sleep until (tNext-tStart)/timeSyncAcceleration)

Synchronize though ZMQ trigger (5555):
- eventSubscriberTrigger (bool) enable external trigger
- triggerSimulationTimeStepInS (float) period after which Dynawo should wait for trigger

Receive actions though ZMQ (5555):
- eventSubscriberActions (bool) enable action receiver

Publish results:
- publishToZmq (bool) enable publishing results ZMQ (5556)
- publishToZmqCurvesFormat (["JSON"]/"CSV") set export format to ZMQ
- publishToWebsocket (bool) enable publishing results to Websocket (8000)


# Play with the example

An example dynawo configuration is defined in RTNordic_example (based on Nordic test system), with configuration:
- external trigger for time synchronization (1s per trigger)
- models defined for runtime update:
  - DisconnectLine: Event model connected to line L4032-4044;
  - LineStatus: Updatame model connected to line L4032-4042;
  - SouthLoadsDelta: SetPoint model connected to South loads deltaPc and deltaQc.

## Run RT Dynawo

To run dynawo enabling real-time mode, modify jobs file to configure interfaces, and run dynawo with -i ("interactive"):

```bash
dynawo jobs -i RTNordic_example/Nordic.jobs
```

## Interact with Dynawo I/O

Several connectors can be instanciated for outputs and intputs and can be enabled with jobs file.

## curves display (websocket output)
Run a python server for the interface:

```bash
cd ws-hmi
python3 -m http.server
```
Then open in browser:

http://localhost:8000/

Dynawo will communicate with javascript using websocket (port 9001)

## subscribe simulation step results (ZMQ output)

An example of ZMQ subscriber in python to get curves values each step (ZMQ over port 5556)

```bash
python3 python_launcher/src/main_zmq_subscriber.py
```

## Python client to modify models and trigger new steps

Run python event handler in interactive mode:

```bash
python3 -i python_launcher/src/main_zmq_client.py
```

### Step trigger
To trigger the simulation of *triggerSimulationTimeStepInS* seconds, send an empty message:
```python
sender.send("")
```

### Change a parameter value

Two options are presented in the test case to open a line:
- using an Event model: the Event is declared in the Events.dyd file, and connected to line L4032-4044 state. To open the line: it is possible to send an action changing the time of the event (or set it to 0 for immediate change) and the state of the line (t, val):
```python
sender.send("DisconnectLine,event_tEvent,double,0,event_disconnectExtremity,bool,1,event_disconnectOrigin,bool,1")
```

- using an Updatable model: since line state is an integer variable, it is connected to a DYNUpdatableInteger model. The updatable does not need to be initialized in the PAR file. It will modify the value of the variable when an input is received:
```python
sender.send("LineStatus,input_value,int,1")
```

To change the value of the SetPoint deltaPc and deltaQc, it is possible to modify SetPoint Value0 parameter in the runtime, which will be propagated to connected variables:
```python
sender.send("SouthLoadsDelta,setPoint_Value0,double,.05")
```

### Terminate the simulation

The message "stop" terminates the simulation remotely:
```python
sender.send("stop")
```
