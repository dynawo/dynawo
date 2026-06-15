within Dynawo.Electrical.Events.Event;
model TripleRealEvent "Specific model for Real three-variable event"
  extends EventReal(nbEventVariables = 3);

  annotation(preferredView = "text");
end TripleRealEvent;
