within Dynawo.Electrical.Controls.Transformers.BaseClasses;

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

partial model BaseTapChangerPhaseShifter "Base model for tap-changers and phase-shifters"
  import Modelica.Constants;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends SwitchOff.SwitchOffTapChangerPhaseShifter;
  extends TapChangerPhaseShifterParams;

  parameter Real valueMax "Threshold above which the tap-changer/phase-shifter will take action (unit depending on the monitored variable unit)";

  Connectors.ImPin valueToMonitor(value(start = valueToMonitor0)) "Monitored value (unit depending on the monitored variable unit)";
  Connectors.ZPin tap(value(start = tap0)) "Current tap";
  Connectors.BPin AutomatonExists(value = true) "Pin to indicate to deactivate internal automaton";

  Boolean locked(start = locked0) "Whether the tap-changer/phase-shifter is locked";
  State state(start = state0) "State of the tap-changer/phase-shifter";

protected
  Boolean valueAboveMax(start = false) "True if the monitored signal is above the maximum limit";
  Boolean lookingToIncreaseTap "True if the tap-changer/phase-shifter wants to increase tap";
  Boolean lookingToDecreaseTap "True if the tap-changer/phase-shifter wants to decrease tap";
  Types.Time tValueAboveMaxWhileRunning(start = Constants.inf) "Time when the monitored signal went above the maximum limit and the tap-changer/phase-shifter is running, in s";
  Types.Time tTapUp(start = Constants.inf) "Time when the tap has been increased in s";
  Types.Time tTapDown(start = Constants.inf) "Time when the tap has been decreased in s";

equation
  assert (tap.value <= tapMax, "Tap value supposed to be below maximum tap");
  assert (tap.value >= tapMin, "Tap value supposed to be above minimum tap");

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter;
