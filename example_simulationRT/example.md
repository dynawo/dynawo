From this directory, in separate terminals:

1. Run a python server for the interface:

```bash
cd ws-hmi
python3 -m http.server
```
Then open in browser:

http://localhost:8000/

2. Run Dynawo:

```bash
dynawo jobs -i RTNordic_example/Nordic.jobs
```

Dynawo will communicate with javascript using websocket (port )

1. python listener (ZMQ over port 5556)
4.
```bash
python3 -i python_launcher/src/receiver.py
```



4. Modify events and trigger new steps (ZMQ over port 5555)

Run python event handler in interactive mode:

```bash
python3 -i python_launcher/src/main_interactive.py -d RTNordic_example/Events.dyd -p RTNordic_example/Events.par
```

To open a line: use the events list to modify the attributes (t, val) of an event, e.g. to open L4032-4044 then close:

```python
events.DisconnectLine.open(sender)
events.DisconnectLine.reset(sender) # reset the tEvent to a large value to by-pass "when" hysteresis
events.DisconnectLine.close(sender)
```

To trigger the next step, send an empty ZMQ message:
```python
sender.send_action("")
```

### New parameters

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
- publishToWebsocket (bool) enable publishing results to Websocket (8000)
