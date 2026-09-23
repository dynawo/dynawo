within Dynawo.Electrical.Constants;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

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
