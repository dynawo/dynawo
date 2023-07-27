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

partial model BaseTapChangerPhaseShifterInterval "Base model for tap-changers and phase-shifters which tries to keep a value within a given interval"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseTapChangerPhaseShifter;

  parameter Real valueMin(max = valueMax) "Minimum allowed value (unit depending on the monitored variable unit)";
  parameter Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";
  parameter Boolean increaseTapToDecreaseValue = not decreaseTapToDecreaseValue "Whether increasing the tap will decrease the monitored value";
  parameter Boolean decreaseTapToIncreaseValue = not increaseTapToIncreaseValue "Whether decreasing the tap will increase the monitored value";
  parameter Boolean decreaseTapToDecreaseValue = increaseTapToIncreaseValue "Whether decreasing the tap will decrease the monitored value";

protected
  Boolean valueUnderMin "True if the monitored signal is under the minimum limit";
  Types.Time tValueUnderMinWhileRunning(start = Constants.inf) "Time when the monitored signal went under the minimum limit and the tap-changer/phase-shifter is running, in s";

equation
  when (valueToMonitor.value < valueMin) and not(locked) and running.value then
    valueUnderMin = true;
    tValueUnderMinWhileRunning = time;
    valueAboveMax = false;
    tValueAboveMaxWhileRunning = pre(tValueAboveMaxWhileRunning);
  elsewhen (valueToMonitor.value > valueMax) and not(locked) and running.value then
    valueUnderMin = false;
    tValueUnderMinWhileRunning = pre(tValueUnderMinWhileRunning);
    valueAboveMax = true;
    tValueAboveMaxWhileRunning = time;
  elsewhen (valueToMonitor.value >= valueMin and valueToMonitor.value <= valueMax) and not(locked) and running.value then
    valueUnderMin = false;
    tValueUnderMinWhileRunning = pre(tValueUnderMinWhileRunning);
    valueAboveMax = false;
    tValueAboveMaxWhileRunning = pre(tValueAboveMaxWhileRunning);
  elsewhen (running.value and locked) or not(running.value) then
    valueUnderMin = pre(valueUnderMin);
    tValueUnderMinWhileRunning = Constants.inf;
    valueAboveMax = pre(valueAboveMax);
    tValueAboveMaxWhileRunning = Constants.inf;
  end when;

  lookingToDecreaseTap = (valueAboveMax and decreaseTapToDecreaseValue) or (valueUnderMin and decreaseTapToIncreaseValue);
  lookingToIncreaseTap = (valueUnderMin and increaseTapToIncreaseValue) or (valueAboveMax and increaseTapToDecreaseValue);

  //Transition to "Locked" (possible from any state and prioritary)
  when not(running.value) or locked then
    state = State.Locked;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "WaitingToMoveDown" (possible from any state other than the down ones)
  elsewhen lookingToDecreaseTap and (pre(state) == State.Standard or pre(state) == State.MoveUp1 or pre(state) == State.MoveUpN or pre(state) == State.WaitingToMoveUp or pre(state) == State.Locked) and running.value and not(locked) then
    state = State.WaitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "WaitingToMoveUp" (possible from any state other than the up ones)
  elsewhen lookingToIncreaseTap and (pre(state) == State.Standard or pre(state) == State.MoveDown1 or pre(state) == State.MoveDownN or pre(state) == State.WaitingToMoveDown or pre(state) == State.Locked) and running.value and not(locked) then
    state = State.WaitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "Standard" (possible from any state)
  elsewhen not(valueUnderMin) and not(valueAboveMax) and pre(state) <> State.Standard and running.value and not(locked) then
    state = State.Standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "MoveDown1" (only possible from "WaitingToMoveDown")
  elsewhen pre(state) == State.WaitingToMoveDown and time - (if increaseTapToIncreaseValue then tValueAboveMaxWhileRunning else tValueUnderMinWhileRunning) >= t1st and pre(tap.value) > tapMin then
    state = State.MoveDown1;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition to "MoveUp1" (only possible from "WaitingToMoveUp")
  elsewhen pre(state) == State.WaitingToMoveUp and time - (if increaseTapToIncreaseValue then tValueUnderMinWhileRunning else tValueAboveMaxWhileRunning) >= t1st and pre(tap.value) < tapMax then
    state = State.MoveUp1;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition to "MoveDownN" (only possible from "MoveDown1" or "MoveDownN")
  elsewhen (pre(state) == State.MoveDown1 or pre(state) == State.MoveDownN) and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.MoveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition to "MoveUpN" (only possible from "MoveUp1" or "MoveUpN")
  elsewhen (pre(state) == State.MoveUp1 or pre(state) == State.MoveUpN) and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.MoveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  end when;

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterInterval;
