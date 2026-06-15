within Dynawo.Electrical.Events.Event;
model TripleBooleanEvent "Specific model for Boolean three-variable event"
  extends EventBoolean(nbEventVariables = 3);

  annotation(preferredView = "text");
end TripleBooleanEvent;
