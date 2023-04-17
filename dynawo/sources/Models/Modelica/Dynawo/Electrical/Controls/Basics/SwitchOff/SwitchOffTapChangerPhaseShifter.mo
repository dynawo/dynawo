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

partial model SwitchOffTapChangerPhaseShifter "Switch-off model for a tap-changer or a phase-shifter"
  /* The only possible/expected switch-off signal for a tap-changer is:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.Automaton;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  parameter Automaton Type;

equation
  when not(running.value) then
    if (Type == Automaton.TapChanger) then
      Timeline.logEvent1 (TimelineKeys.TapChangerSwitchOff);
    elseif (Type == Automaton.PhaseShifter) then
      Timeline.logEvent1 (TimelineKeys.PhaseShifterSwitchOff);
    end if;
  elsewhen running.value and not(pre(running.value)) then
    if (Type == Automaton.TapChanger) then
      Timeline.logEvent1 (TimelineKeys.TapChangerSwitchOn);
    elseif (Type == Automaton.PhaseShifter) then
      Timeline.logEvent1 (TimelineKeys.PhaseShifterSwitchOn);
    end if;
  end when;

  annotation(preferredView = "text");
end SwitchOffTapChangerPhaseShifter;
