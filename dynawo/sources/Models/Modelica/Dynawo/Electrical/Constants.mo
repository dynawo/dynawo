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

  public
  
  final constant Real OPEN = 1 " Component disconnected";
  final constant Real CLOSED = 2 "Component connected";
  final constant Real CLOSED_1 = 3 "Component connected on side 1";
  final constant Real CLOSED_2 = 4 "Component connected on side 2";
  final constant Real CLOSED_3 = 5 "Component connected on side 3";
  final constant Real UNDEFINED = 6 "Component status undefined";

  type state = enumeration(OPEN "Component disconnected", CLOSED "Component connected", CLOSED_1 "Component connected on side 1", CLOSED_2 "Component connected on side 2", CLOSED_3 "Component connected on side 3", UNDEFINED "Component status undefined");

  function stateToReal "Converts a component connection state from enumeration to real"
    input state stateAsEnumeration;
    output Real stateAsReal;
  algorithm
    if (stateAsEnumeration == state.OPEN) then
      stateAsReal := OPEN;
    elseif (stateAsEnumeration == state.CLOSED) then
      stateAsReal := CLOSED;
    elseif (stateAsEnumeration == state.CLOSED_1) then
      stateAsReal := CLOSED_1;
    elseif (stateAsEnumeration == state.CLOSED_2) then
      stateAsReal := CLOSED_2;
    elseif (stateAsEnumeration == state.CLOSED_3) then
      stateAsReal := CLOSED_3;
    elseif (stateAsEnumeration == state.UNDEFINED) then
      stateAsReal := UNDEFINED;
    else
      assert(false, "Bad handling of component connection state " + String (stateAsEnumeration) + " when trying to convert it to real");
    end if;
  end stateToReal;

  function realToState "Converts a component connection state from real to enumeration"
    input Real stateAsReal;
    output state stateAsEnumeration;
  algorithm
    if (stateAsReal == OPEN) then
      stateAsEnumeration := state.OPEN;
    elseif (stateAsReal == CLOSED) then
      stateAsEnumeration := state.CLOSED;
    elseif (stateAsReal == CLOSED_1) then
      stateAsEnumeration := state.CLOSED_1;
    elseif (stateAsReal == CLOSED_2) then
      stateAsEnumeration := state.CLOSED_2;
    elseif (stateAsReal == CLOSED_3) then
      stateAsEnumeration := state.CLOSED_3;
    elseif (stateAsReal == UNDEFINED) then
      stateAsEnumeration := state.UNDEFINED;
    else
      assert(false, "Invalid real value when trying to convert to enumeration " + String(stateAsReal));
    end if;
  end realToState;

end Constants;
