within Dynawo.Electrical.Events.Event;
model EventQuadripoleStatus "Event for quadripole opening or closing (for example, for tripping)"
  extends SingleIntegerEvent (stateEvent1 = if
                                              (openOrigin and openExtremity) then Integer(Constants.state.Open)
                                         elseif (openOrigin and not openExtremity) then Integer(Constants.state.Closed2)
                                         elseif (not openOrigin and openExtremity) then Integer(Constants.state.Closed1)
                                         else Integer(Constants.state.Closed));

  parameter Boolean openOrigin "Open the quadripole origin ?";
  parameter Boolean openExtremity "Open the quadripole extremity ?";

  annotation(preferredView = "text");
end EventQuadripoleStatus;
