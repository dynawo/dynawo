within Dynawo.Electrical.Events.Event;
model EventQuadripoleDisconnection "Event for quadripole disconnection"
  extends EventQuadripoleStatus(openOrigin = disconnectOrigin, openExtremity = disconnectExtremity);

  parameter Boolean disconnectOrigin "Disconnect the quadripole origin ?";
  parameter Boolean disconnectExtremity "Disconnect the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleDisconnection;
