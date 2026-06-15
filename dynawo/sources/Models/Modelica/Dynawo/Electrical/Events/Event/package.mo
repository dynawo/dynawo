within Dynawo.Electrical.Events;
package Event
  import Dynawo.Electrical.Constants;

  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body><div>A simulation event is described as follows :</div><div><br></div><div>when tEvent is reached, one or more variables (connected using state1 - state5 ZPins) are updated. Their new value is stateEvent1 - stateEvent5. Depending on the type of model variable they are connected to, the event model is different.</div></body></html>"));
end Event;
