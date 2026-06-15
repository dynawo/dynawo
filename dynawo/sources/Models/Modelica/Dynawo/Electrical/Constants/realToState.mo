within Dynawo.Electrical.Constants;
function realToState "Converts a component connection state from real to enumeration"
  extends Icons.Function;

  input Real stateAsReal;

  output state stateAsEnumeration;

algorithm
  if (stateAsReal == Open) then
    stateAsEnumeration := state.Open;
  elseif (stateAsReal == Closed) then
    stateAsEnumeration := state.Closed;
  elseif (stateAsReal == Closed1) then
    stateAsEnumeration := state.Closed1;
  elseif (stateAsReal == Closed2) then
    stateAsEnumeration := state.Closed2;
  elseif (stateAsReal == Closed3) then
    stateAsEnumeration := state.Closed3;
  elseif (stateAsReal == Undefined) then
    stateAsEnumeration := state.Undefined;
  else
    assert(false, "Invalid real value when trying to convert to enumeration " + String(stateAsReal));
  end if;

  annotation(preferredView = "text");
end realToState;
