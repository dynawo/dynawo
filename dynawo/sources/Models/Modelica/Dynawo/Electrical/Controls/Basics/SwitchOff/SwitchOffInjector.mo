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

partial model SwitchOffInjector "Switch-off model for an injector"
  /* The three possible/expected switch-off signals for a generator are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton/control block
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 3);

  Constants.state state(start = State0) "Injector connection state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not(running.value) then
    Timeline.logEvent1(TimelineKeys.ComponentDisconnected);
    state = Constants.state.Open;
  elsewhen running.value and not(pre(running.value)) then
    Timeline.logEvent1(TimelineKeys.ComponentConnected);
    state = Constants.state.Closed;
  end when;

  annotation(preferredView = "text");
end SwitchOffInjector;
