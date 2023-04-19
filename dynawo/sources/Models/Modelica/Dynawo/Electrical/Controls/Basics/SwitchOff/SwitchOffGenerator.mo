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

partial model SwitchOffGenerator "Switch-off model for a generator"
  /* The three possible/expected switch-off signals for a generator are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton in the generator (under-voltage protection for example)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 3);

  Constants.state state(start = State0) "Generator connection state";
  Real genState(start = Integer(State0)) "Generator continuous connection state";

  Modelica.Blocks.Math.IntegerToReal converter "Converter for generator state";

  parameter Constants.state State0 = Constants.state.Closed "Start value of connection state";

equation
  when not(running.value) then
    Timeline.logEvent1 (TimelineKeys.GeneratorDisconnected);
    state = Constants.state.Open;
  elsewhen running.value and not(pre(running.value)) then
    Timeline.logEvent1 (TimelineKeys.GeneratorConnected);
    state = Constants.state.Closed;
  end when;

  converter.y = genState;
  converter.u = Integer(state);

  annotation(preferredView = "text");
end SwitchOffGenerator;
