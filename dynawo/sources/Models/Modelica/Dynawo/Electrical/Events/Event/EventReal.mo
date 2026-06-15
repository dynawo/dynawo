within Dynawo.Electrical.Events.Event;
model EventReal "Specific model for Real events"
  extends EventEquations(redeclare type typeParameter = Real, redeclare connector typeConnector = Dynawo.Connectors.ZPin);

  annotation(preferredView = "text");
end EventReal;
