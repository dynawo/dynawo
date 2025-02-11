import logging
from enum import Enum

class ParameterType(Enum):
    BOOL=0
    INT=1
    DOUBLE=2
    STRING=3


class Parameter:
    def __init__(self, name, ptype, value):
        self.name: str = name
        self.type: ParameterType = ptype
        self.value: bool|float|int|str = value

    def __str__(self):
        if self.type == ParameterType.BOOL:
            return f"{self.name},{self.type.name.lower()},{int(self.value)}"
        else:
            return f"{self.name},{self.type.name.lower()},{self.value}"



class Event:
    def __init__(self, name, par_id):
        self.name = name
        self.par_id = par_id
        self.parameters = {"event_tEvent": Parameter("event_tEvent", ParameterType.DOUBLE, 0)}

    def __str__(self):
        s = self.name
        for p in self.parameters.values():
            s += f",{p}"
        return s

    def update_value(self, name: str, value):
        if name not in self.parameters:
            logging.error(f"Event parameter {name} does not exist for event {self.name} ({self.__class__})")
            return
        self.parameters[name].value = value

class EventQuadripoleDisconnection(Event):
    def __init__(self, name, par_id):
        super().__init__(name, par_id)
        self.parameters["event_disconnectExtremity"] = Parameter("event_disconnectExtremity", ParameterType.BOOL, False)
        self.parameters["event_disconnectOrigin"] = Parameter("event_disconnectOrigin", ParameterType.BOOL, False)

    def open(self, sender, t=0):
        self.parameters["event_tEvent"].value = t
        self.parameters["event_disconnectExtremity"].value = True
        self.parameters["event_disconnectOrigin"].value = True
        sender.send_action(str(self))

    def close(self, sender, t=0):
        self.parameters["event_tEvent"].value = t
        self.parameters["event_disconnectExtremity"].value = False
        self.parameters["event_disconnectOrigin"].value = False
        sender.send_action(str(self))

    def reset(self, sender):
        self.parameters["event_tEvent"].value = 1000000
        sender.send_action(str(self))

class EventConnectedStatus(Event):
    def __init__(self, name, par_id):
        super().__init__(name, par_id)
        self.parameters["event_tOpen"] = Parameter("event_tOpen", ParameterType.BOOL, False)

class EventQuadripoleConnection(Event):
    def __init__(self, name, par_id):
        super().__init__(name, par_id)
        self.parameters["event_connectExtremity"] = Parameter("event_connectExtremity", ParameterType.BOOL, False)
        self.parameters["event_connectOrigin"] = Parameter("event_connectOrigin", ParameterType.BOOL, False)

class EventSetPointBoolean(Event):
    def __init__(self, name, par_id):
        super().__init__(name, par_id)
        self.parameters["event_stateEvent1"] = Parameter("event_stateEvent1", ParameterType.BOOL, False)

class EventSetPointDoubleReal(Event):
    def __init__(self, name, par_id):
        super().__init__(name, par_id)
        self.parameters["event_stateEvent1"] = Parameter("event_stateEvent1", ParameterType.DOUBLE, False)
        self.parameters["event_stateEvent2"] = Parameter("event_stateEvent2", ParameterType.DOUBLE, False)

    def set(self, sender, val1, val2, t=0):
        self.parameters["event_tEvent"].value = t
        self.parameters["event_stateEvent1"].value = val1
        self.parameters["event_stateEvent2"].value = val2
        sender.send_action(str(self))

class EventSetPointReal(Event):
    def __init__(self, name, par_id):
        super().__init__(name, par_id)
        self.parameters["event_stateEvent1"] = Parameter("event_stateEvent1", ParameterType.DOUBLE, False)
        self.event_event_stateEvent1: float = 0.

    def set(self, sender, val1, t=0):
        self.parameters["event_tEvent"].value = t
        self.parameters["event_stateEvent1"].value = val1
        sender.send_action(str(self))

EVENT_CLASS = {
    "EventQuadripoleDisconnection": EventQuadripoleDisconnection,
    "EventConnectedStatus": EventConnectedStatus,
    "EventQuadripoleConnection": EventQuadripoleConnection,
    "EventSetPointBoolean": EventSetPointBoolean,
    "EventSetPointDoubleReal": EventSetPointDoubleReal,
    "EventSetPointReal": EventSetPointReal
}
