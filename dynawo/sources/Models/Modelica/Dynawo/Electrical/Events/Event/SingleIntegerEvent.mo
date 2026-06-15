within Dynawo.Electrical.Events.Event;
model SingleIntegerEvent "Specific model for Integer one-variable event"
  extends EventInteger(nbEventVariables = 1);

  annotation(preferredView = "text");
end SingleIntegerEvent;
