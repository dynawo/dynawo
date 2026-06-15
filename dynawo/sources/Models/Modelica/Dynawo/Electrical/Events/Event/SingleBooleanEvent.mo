within Dynawo.Electrical.Events.Event;
model SingleBooleanEvent "Specific model for Boolean one-variable event"
  extends EventBoolean(nbEventVariables = 1);

  annotation(preferredView = "text");
end SingleBooleanEvent;
