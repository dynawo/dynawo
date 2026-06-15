within Dynawo.Electrical.Events.Event;
model EventQuadripoleConnection "Event for quadripole connection"
  extends EventQuadripoleStatus(openOrigin = not
                                                (connectOrigin), openExtremity = not
                                                                                    (connectExtremity));

  parameter Boolean connectOrigin "Connect the quadripole origin ?";
  parameter Boolean connectExtremity "Connect the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleConnection;
