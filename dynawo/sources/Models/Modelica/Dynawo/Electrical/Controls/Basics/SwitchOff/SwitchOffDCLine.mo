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

partial model SwitchOffDCLine "Switch-off signal for a DC line"
  /* The two possible/expected switch-off signals for each terminal of the DC line are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  extends SwitchOffLogicSide1(NbSwitchOffSignalsSide1 = 2);
  extends SwitchOffLogicSide2(NbSwitchOffSignalsSide2 = 2);

  Dynawo.Connectors.BPin running(value(start = true)) "Indicates if the component is running or not";

  Constants.state state(start = State0) "DC Line connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not(runningSide1.value) or not(runningSide2.value) then
    Timeline.logEvent1(TimelineKeys.DCLineOpen);
    state = Constants.state.Open;
  elsewhen runningSide1.value and runningSide2.value and (not(pre(runningSide1.value)) or not(pre(runningSide2.value))) then
    Timeline.logEvent1(TimelineKeys.DCLineClosed);
    state = Constants.state.Closed;
  end when;

  running.value = runningSide1.value and runningSide2.value;

  annotation(preferredView = "text");
end SwitchOffDCLine;
