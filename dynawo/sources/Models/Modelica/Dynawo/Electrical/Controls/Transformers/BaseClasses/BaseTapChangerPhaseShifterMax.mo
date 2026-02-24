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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseTapChangerPhaseShifterMax "Base model for tap-changers and phase-shifters which takes a maximum and stop value, and tries to bring the value back to the stop value when the maximum value is reached"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseTapChangerPhaseShifter;

  parameter Real valueStop(max = valueMax) "Value below which the phase-shifter will stop (unit depending on the monitored variable unit)";
  parameter Integer increasePhase "Whether the phase shifting is increased when the tap is increased";

  Dynawo.Connectors.ImPin P(value(start = P0)) "Active power (unit depending on the monitored active power unit)";

  Integer sign = if P.value < 0 then 1 else -1 "Sign of the active power flowing through the phase-shifter transformer";
  Boolean increaseTapToIncreaseValue = sign * increasePhase < 0 "Whether increasing the tap will increase the monitored value";
  Boolean increaseTapToDecreaseValue = not decreaseTapToDecreaseValue "Whether increasing the tap will decrease the monitored value";
  Boolean decreaseTapToIncreaseValue = not increaseTapToIncreaseValue "Whether decreasing the tap will increase the monitored value";
  Boolean decreaseTapToDecreaseValue = increaseTapToIncreaseValue "Whether decreasing the tap will decrease the monitored value";

  parameter Types.ActivePower P0 "Initial active power (unit depending on the monitored active power unit)";

protected
  Boolean valueUnderStop "Whether the monitored signal is under the stop limit";

equation
  when (valueToMonitor.value > valueMax) and not(locked) then
    valueAboveMax = true;
    tValueAboveMaxWhileRunning = time;
    valueUnderStop = false;
    Timeline.logEvent1(TimelineKeys.PhaseShifterAboveMax);
  elsewhen (valueToMonitor.value <= valueStop) and not(locked) then
    valueAboveMax = false;
    tValueAboveMaxWhileRunning = Constants.inf;
    valueUnderStop = true;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBelowStop);
   elsewhen running.value and locked then
    valueAboveMax = pre(valueAboveMax);
    tValueAboveMaxWhileRunning = Constants.inf;
    valueUnderStop = pre(valueUnderStop);
  end when;

  lookingToDecreaseTap = running.value and valueAboveMax and decreaseTapToDecreaseValue;
  lookingToIncreaseTap = running.value and valueAboveMax and increaseTapToDecreaseValue;

  //Transition to "Locked" (possible from any state and prioritary)
  when (not running.value) or locked then
    state = State.Locked;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "WaitingToMoveDown" (possible from any state except down states)
  elsewhen lookingToDecreaseTap and (pre(state) == State.Standard or pre(state) == State.MoveUp1 or pre(state) == State.MoveUpN or pre(state) == State.WaitingToMoveUp or pre(state) == State.Locked) and running.value and not(locked) then
    state = State.WaitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "WaitingToMoveUp" (possible from any state except up states)
  elsewhen lookingToIncreaseTap and (pre(state) == State.Standard or pre(state) == State.MoveDown1 or pre(state) == State.MoveDownN or pre(state) == State.WaitingToMoveDown or pre(state) == State.Locked) and running.value and not(locked) then
    state = State.WaitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "Standard" (possible from any state)
  elsewhen valueUnderStop and pre(state) <> State.Standard and running.value and not(locked) then
    state = State.Standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "MoveDown1" (only possible from WaitingToMoveDown)
  elsewhen pre(state) == State.WaitingToMoveDown and time - tValueAboveMaxWhileRunning>= t1st and pre(tap.value) > tapMin then
    state = State.MoveDown1;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent3(TimelineKeys.TapDown, String(valueToMonitor.value * factorValueToDisplay), unitValueToDisplay);
  //Transition to "MoveUp1" (only possible from WaitingToMoveUp)
  elsewhen pre(state) == State.WaitingToMoveUp and time - tValueAboveMaxWhileRunning>= t1st and pre(tap.value) < tapMax then
    state = State.MoveUp1;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent3(TimelineKeys.TapUp, String(valueToMonitor.value * factorValueToDisplay), unitValueToDisplay);
  //Transition to "MoveDownN" (only possible from MoveDown1 or MoveDownN)
  elsewhen (pre(state) == State.MoveDown1 or pre(state) == State.MoveDownN) and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.MoveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent3(TimelineKeys.TapDown, String(valueToMonitor.value * factorValueToDisplay), unitValueToDisplay);
  //Transition to "MoveUpN" (only possible from MoveUp1 or MoveUpN)
  elsewhen (pre(state) == State.MoveUp1 or pre(state) == State.MoveUpN) and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.MoveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent3(TimelineKeys.TapUp, String(valueToMonitor.value * factorValueToDisplay), unitValueToDisplay);
  end when;

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterMax;
