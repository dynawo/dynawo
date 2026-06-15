within Dynawo.Electrical.Events.Event;
model DoubleBooleanEvent "Specific model for Boolean two-variable event"
  extends EventBoolean(nbEventVariables = 2);

  annotation(preferredView = "text");
end DoubleBooleanEvent;
