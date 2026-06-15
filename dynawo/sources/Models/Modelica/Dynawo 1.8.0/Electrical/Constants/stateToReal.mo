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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

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
    assert(false, "Bad handling of component connection state " + String (stateAsEnumeration) + " when trying to convert it to real");
  end if;

  annotation(preferredView = "text");
end stateToReal;
