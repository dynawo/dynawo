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

partial model SwitchOffLogicSide1 "Manage switch-off logic for side 1 of a quadripole"

  parameter Integer NbSwitchOffSignalsSide1(min = 1, max = 3) "Number of switch-off signals to take into account in inputs";

  Dynawo.Connectors.BPin switchOffSignal1Side1(value(start = SwitchOffSignal1Side10)) "Switch-off signal 1 for side 1 of the quadripole";
  Dynawo.Connectors.BPin switchOffSignal2Side1(value(start = SwitchOffSignal2Side10)) if NbSwitchOffSignalsSide1 >= 2 "Switch-off signal 2 for side 1 of the quadripole";
  Dynawo.Connectors.BPin switchOffSignal3Side1(value(start = SwitchOffSignal3Side10)) if NbSwitchOffSignalsSide1 >= 3 "Switch-off signal 3 for side 1 of the quadripole";

  Dynawo.Connectors.BPin runningSide1(value(start = RunningSide10)) "Indicates if the component is running on side 1 or not";

  parameter Boolean SwitchOffSignal1Side10 = false "Initial switch-off signal 1 for side 1 of the quadripole";
  parameter Boolean SwitchOffSignal2Side10 = false "Initial switch-off signal 2 for side 1 of the quadripole";
  parameter Boolean SwitchOffSignal3Side10 = false "Initial switch-off signal 3 for side 1 of the quadripole";

  final parameter Boolean RunningSide10 = if NbSwitchOffSignalsSide1 >= 3 then not(SwitchOffSignal1Side10 or SwitchOffSignal2Side10 or SwitchOffSignal3Side10) elseif NbSwitchOffSignalsSide1 >= 2 then not(SwitchOffSignal1Side10 or SwitchOffSignal2Side10) else not SwitchOffSignal1Side10 "Indicates if the component is initially running on side 1 or not";

equation
  if (NbSwitchOffSignalsSide1 >= 3) then
    when switchOffSignal1Side1.value or switchOffSignal2Side1.value or switchOffSignal3Side1.value and pre(runningSide1.value) then
      runningSide1.value = false;
    elsewhen not switchOffSignal1Side1.value and not switchOffSignal2Side1.value and not switchOffSignal3Side1.value and not pre(runningSide1.value) then
      runningSide1.value = true;
    end when;
  elseif (NbSwitchOffSignalsSide1 >= 2) then
    when switchOffSignal1Side1.value or switchOffSignal2Side1.value and pre(runningSide1.value) then
      runningSide1.value = false;
    elsewhen not switchOffSignal1Side1.value and not switchOffSignal2Side1.value and not pre(runningSide1.value) then
      runningSide1.value = true;
    end when;
  else
    when switchOffSignal1Side1.value and pre(runningSide1.value) then
      runningSide1.value = false;
    elsewhen not switchOffSignal1Side1.value and not pre(runningSide1.value) then
      runningSide1.value = true;
    end when;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><body>
Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true.</body></html>"));
end SwitchOffLogicSide1;
