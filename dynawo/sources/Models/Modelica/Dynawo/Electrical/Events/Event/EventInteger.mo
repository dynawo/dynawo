within Dynawo.Electrical.Events.Event;
model EventInteger "Specific model for Integer events"
  extends EventEquations(redeclare type typeParameter = Integer, redeclare connector typeConnector = Dynawo.Connectors.IntPin);

  annotation(preferredView = "text");
end EventInteger;
