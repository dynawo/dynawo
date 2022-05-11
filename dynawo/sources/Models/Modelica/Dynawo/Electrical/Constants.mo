within Dynawo.Electrical;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package Constants "Defining constants for network components"
  /* This package enables to express the connection status for any component in a similar way
     between C++ and Modelica. */
  extends Icons.Package;

  final constant Real Open = 1 " Component disconnected";
  final constant Real Closed = 2 "Component connected";
  final constant Real Closed1 = 3 "Component connected on side 1";
  final constant Real Closed2 = 4 "Component connected on side 2";
  final constant Real Closed3 = 5 "Component connected on side 3";
  final constant Real Undefined = 6 "Component status undefined";

  type state = enumeration(Open "Component disconnected", Closed "Component connected", Closed1 "Component connected on side 1", Closed2 "Component connected on side 2", Closed3 "Component connected on side 3", Undefined "Component status undefined");

function stateToReal "Converts a component connection state from enumeration to real"

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

end stateToReal;

function realToState "Converts a component connection state from real to enumeration"

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

end realToState;

  annotation(preferredView = "text");
end Constants;
