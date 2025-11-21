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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model SwitchOffLogicSide2 "Manage switch-off logic for side 2 of a quadripole"

  parameter Integer NbSwitchOffSignalsSide2(min = 1, max = 3) "Number of switch-off signals to take into account in inputs";

  Dynawo.Connectors.BPin switchOffSignal1Side2(value(start = SwitchOffSignal1Side20)) "Switch-off signal 1 for side 2 of the quadripole";
  Dynawo.Connectors.BPin switchOffSignal2Side2(value(start = SwitchOffSignal2Side20)) if NbSwitchOffSignalsSide2 >= 2 "Switch-off signal 2 for side 2 of the quadripole";
  Dynawo.Connectors.BPin switchOffSignal3Side2(value(start = SwitchOffSignal3Side20)) if NbSwitchOffSignalsSide2 >= 3 "Switch-off signal 3 for side 2 of the quadripole";

  Dynawo.Connectors.BPin runningSide2(value(start = RunningSide20)) "Indicates if the component is running on side 2 or not";

  parameter Boolean SwitchOffSignal1Side20 = false "Initial switch-off signal 1 for side 2 of the quadripole";
  parameter Boolean SwitchOffSignal2Side20 = false "Initial switch-off signal 2 for side 2 of the quadripole";
  parameter Boolean SwitchOffSignal3Side20 = false "Initial switch-off signal 3 for side 2 of the quadripole";

  final parameter Boolean RunningSide20 = if NbSwitchOffSignalsSide2 >= 3 then not(SwitchOffSignal1Side20 or SwitchOffSignal2Side20 or SwitchOffSignal3Side20) elseif NbSwitchOffSignalsSide2 >= 2 then not(SwitchOffSignal1Side20 or SwitchOffSignal2Side20) else not SwitchOffSignal1Side20 "Indicates if the component is initially running on side 2 or not";

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

  annotation(preferredView = "text",
    Documentation(info = "<html><body>
Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true.</body></html>"));
end SwitchOffLogicSide2;
