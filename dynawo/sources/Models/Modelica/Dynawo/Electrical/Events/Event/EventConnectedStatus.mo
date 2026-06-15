within Dynawo.Electrical.Events.Event;
model EventConnectedStatus "Event for changing connection status of a component (connected or disconnected)"
  extends SingleIntegerEvent (stateEvent1 = if
                                              (open) then Integer(Constants.state.Open)
                                         else Integer(Constants.state.Closed));

  parameter Boolean open "Disconnect the component ?";

  annotation(preferredView = "text");
end EventConnectedStatus;
