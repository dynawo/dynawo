within Dynawo.Electrical.Events.Event;
model SingleRealEvent "Specific model for Real one-variable event"
  extends EventReal(nbEventVariables = 1);

  annotation(preferredView = "text");
end SingleRealEvent;
