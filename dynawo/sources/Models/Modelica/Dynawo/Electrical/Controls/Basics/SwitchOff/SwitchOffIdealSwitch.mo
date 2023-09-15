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

partial model SwitchOffIdealSwitch "Switch-off signal for an ideal switch"
  /* The only possible/expected switch-off signal for an ideal switch is:
     - a switch-off signal coming from the outside (event or controller)
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 1);

  Constants.state state(start = State0) "Ideal switch connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not(running.value) then
    Timeline.logEvent1 (TimelineKeys.IdealSwitchSwitchOff);
    state = Constants.state.Open;
  elsewhen running.value and not(pre(running.value)) then
    Timeline.logEvent1 (TimelineKeys.IdealSwitchSwitchOn);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffIdealSwitch;
