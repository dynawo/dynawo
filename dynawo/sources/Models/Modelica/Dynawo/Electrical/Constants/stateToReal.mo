within Dynawo.Electrical.Constants;
function stateToReal "Converts a component connection state from enumeration to real"
  extends Icons.Function;

  input state stateAsEnumeration;

  output Real stateAsReal;

algorithm
  if (stateAsEnumeration == state.Open) then
    stateAsReal := Open;
  elseif (stateAsEnumeration == state.Closed) then
    stateAsReal := Closed;
  elseif (stateAsEnumeration == state.Closed1) then
    stateAsReal := Closed1;
  elseif (stateAsEnumeration == state.Closed2) then
    stateAsReal := Closed2;
  elseif (stateAsEnumeration == state.Closed3) then
    stateAsReal := Closed3;
  elseif (stateAsEnumeration == state.Undefined) then
    stateAsReal := Undefined;
  else
    assert(false, "Bad handling of component connection state " + String( stateAsEnumeration) + " when trying to convert it to real");
  end if;

  annotation(preferredView = "text");
end stateToReal;
