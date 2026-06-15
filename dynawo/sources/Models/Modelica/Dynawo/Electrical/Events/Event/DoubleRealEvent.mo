within Dynawo.Electrical.Events.Event;
model DoubleRealEvent "Specific model for Boolean two-variable event"
  extends EventReal(nbEventVariables = 2);

  annotation(preferredView = "text");
end DoubleRealEvent;
