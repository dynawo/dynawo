within Dynawo.Electrical.Controls.Basics.SwitchOff;

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

partial model SwitchOffLogicSide2 "Manage switch-off logic for side 2 of a quadripole"
  /* Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true */

  Dynawo.Connectors.BPin switchOffSignal1Side2(value(start = false)) "Switch-off signal 1 for side 2 of the quadripole";
  Dynawo.Connectors.BPin switchOffSignal2Side2(value(start = false)) if NbSwitchOffSignalsSide2 >= 2 "Switch-off signal 2 for side 2 of the quadripole";
  Dynawo.Connectors.BPin switchOffSignal3Side2(value(start = false)) if NbSwitchOffSignalsSide2 >= 3 "Switch-off signal 3 for side 2 of the quadripole";

  Dynawo.Connectors.BPin runningSide2(value(start = true)) "Indicates if the component is running on side 2 or not";

  parameter Integer NbSwitchOffSignalsSide2(min = 1, max = 3) "Number of switch-off signals to take into account in inputs";

equation
  if (NbSwitchOffSignalsSide2 >= 3) then
    when switchOffSignal1Side2.value or switchOffSignal2Side2.value or switchOffSignal3Side2.value and pre(runningSide2.value) then
      runningSide2.value = false;
    elsewhen not switchOffSignal1Side2.value and not switchOffSignal2Side2.value and not switchOffSignal3Side2.value and not pre(runningSide2.value) then
      runningSide2.value = true;
    end when;
  elseif (NbSwitchOffSignalsSide2 >= 2) then
    when switchOffSignal1Side2.value or switchOffSignal2Side2.value and pre(runningSide2.value) then
      runningSide2.value = false;
    elsewhen not switchOffSignal1Side2.value and not switchOffSignal2Side2.value and not pre(runningSide2.value) then
      runningSide2.value = true;
    end when;
  else
    when switchOffSignal1Side2.value and pre(runningSide2.value) then
      runningSide2.value = false;
    elsewhen not switchOffSignal1Side2.value and not pre(runningSide2.value) then
      runningSide2.value = true;
    end when;
  end if;

  annotation(preferredView = "text");
end SwitchOffLogicSide2;
