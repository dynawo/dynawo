within Dynawo.Electrical.Events.Event;
model EventBoolean "Specific model for Boolean events"
  //extends EventEquations(redeclare type typeParameter = Boolean, redeclare connector typeConnector = Modelica.Blocks.Interfaces.BooleanOutput);

  parameter typeParameter stateEvent1 "Post event state";
  parameter typeParameter stateEvent2 if (nbEventVariables >= 2);
  parameter typeParameter stateEvent3 if (nbEventVariables >= 3);
  parameter typeParameter stateEvent4 if (nbEventVariables >= 4);
  parameter typeParameter stateEvent5 if (nbEventVariables >= 5);

  typeConnector state1 "Current state";
  typeConnector state2 if (nbEventVariables >= 2);
  typeConnector state3 if (nbEventVariables >= 3);
  typeConnector state4 if (nbEventVariables >= 4);
  typeConnector state5 if (nbEventVariables >= 5);

  parameter Types.Time tEvent "Event time";
  parameter Integer nbEventVariables(min = 1, max = 5) "Number of variables to update during the event";

protected
  // Replaceable items in order to allow using this model for various types (integer, boolean, real...)
  replaceable connector typeConnector = Modelica.Blocks.Interfaces.BooleanOutput;
  replaceable type typeParameter = Boolean;

equation
  when (time >= tEvent) then
    state1 = stateEvent1;
  end when;

  if (nbEventVariables >= 2) then
    when (time >= tEvent) then
      state2 = stateEvent2;
    end when;
  end if;

  if (nbEventVariables >= 3) then
    when (time >= tEvent) then
      state3 = stateEvent3;
    end when;
  end if;

  if (nbEventVariables >= 4) then
    when (time >= tEvent) then
      state4 = stateEvent4;
    end when;
  end if;

  if (nbEventVariables >= 5) then
    when (time >= tEvent) then
      state5 = stateEvent5;
    end when;
  end if;

  annotation(preferredView = "text");
end EventBoolean;
