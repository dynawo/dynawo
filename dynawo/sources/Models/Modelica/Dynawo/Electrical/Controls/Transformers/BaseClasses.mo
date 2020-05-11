within Dynawo.Electrical.Controls.Transformers;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package BaseClasses
  extends Icons.BasesPackage;

// used for phase-shifterI (applied on current), phase-shifterP (applied on power) and tap-changer (applied on voltage)
partial model BaseTapChangerPhaseShifter "Base model for tap-changers and phase-shifters"
  import Modelica.Constants;

  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  public
    type State = enumeration (MoveDownN "1: tap-changer/phase-shifter has decreased the next tap",
                              MoveDown1 "2: tap-changer/phase-shifter has decreased the first tap",
                              WaitingToMoveDown "3: tap-changer/phase-shifter is waiting to decrease the first tap",
                              Standard "4:tap-changer/phase-shifter is in standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                              WaitingToMoveUp "5: tap-changer/phase-shifter is waiting to increase the first tap",
                              MoveUp1 "6: tap-changer/phase-shifter has increased the first tap",
                              MoveUpN "7: tap-changer/phase-shifter has increased the next tap",
                              Locked "8: tap-changer/phase-shifter locked");
    State state(start = state0);

    parameter Real valueMax "Threshold above which the tap-changer/phase-shifter will take action";

    parameter Types.Time t1st (min = 0) "Time lag before changing the first tap";
    parameter Types.Time tNext (min = 0) "Time lag before changing subsequent taps";
    parameter Integer tapMin "Minimum tap";
    parameter Integer tapMax "Maximum tap";
    parameter Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";
    parameter Boolean increaseTapToDecreaseValue = not decreaseTapToDecreaseValue "Whether increasing the tap will decrease the monitored value";
    parameter Boolean decreaseTapToIncreaseValue = not increaseTapToIncreaseValue "Whether decreasing the tap will increase the monitored value";
    parameter Boolean decreaseTapToDecreaseValue = increaseTapToIncreaseValue "Whether decreasing the tap will decrease the monitored value";

    Connectors.ImPin valueToMonitor (value (start = valueToMonitor0)) "Monitored value";
    Connectors.ZPin tap (value (start = tap0)) "Current tap";
    Connectors.BPin AutomatonExists (value (start = true)) "Pin to indicate to deactivate internal automaton";

  protected
    parameter Boolean regulating0 "Whether the tap-changer/phase-shifter is initially regulating";
    parameter Boolean locked0 = not regulating0 "Whether the tap-changer/phase-shifter is initially locked";
    parameter Boolean running0 = true "Whether the tap-changer/phase-shifter is initially running";
    parameter Real valueToMonitor0  "Initial monitored value";
    parameter Integer tap0 "Initial tap";
    parameter State state0 "Initial state";

    Boolean locked (start = locked0) "Whether the tap-changer/phase-shifter is locked";

    Boolean valueAboveMax(start = false) "True if the monitored signal is above the maximum limit";
    Boolean lookingToIncreaseTap "True if the tap-changer/phase-shifter wants to increase tap";
    Boolean lookingToDecreaseTap "True if the tap-changer/phase-shifter wants to decrease tap";
    Types.Time tValueAboveMaxWhileRunning(start = Constants.inf) "Time when the monitored signal went above the maximum limit and the tap-changer/phase-shifter is running";
    Types.Time tTapUp(start = Constants.inf) "Time when the tap has been increased";
    Types.Time tTapDown(start = Constants.inf) "Time when the tap has been decreased";

equation

  assert (tap.value <= tapMax, "Tap value supposed to be below maximum tap");
  assert (tap.value >= tapMin, "Tap value supposed to be above minimum tap");

annotation(preferredView = "text");
end BaseTapChangerPhaseShifter;


partial model BaseTapChangerPhaseShifter_MAX "Base model for tap-changers and phase-shifters which takes a maximum and stop value, and tries to bring the value back to the stop value when the maximum value is reached"
  import Modelica.Constants;

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseTapChangerPhaseShifter;

  public
    parameter Real valueStop (max = valueMax) "Value below which the phase-shifter will stop";

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

  //Transition to "locked"
  when (not running.value) or locked then
    state = State.Locked;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "waitingToMoveDown"
  elsewhen lookingToDecreaseTap and pre(state) <> State.WaitingToMoveDown and pre(state) <> State.MoveDown1 and pre(state) <> State.MoveDownN then
    state = State.WaitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "waitingToMoveUp"
  elsewhen lookingToIncreaseTap and pre(state) <> State.WaitingToMoveUp and pre(state) <> State.MoveUp1 and pre(state) <> State.MoveUpN then
    state = State.WaitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "standard"
  elsewhen not(valueAboveMax) and pre(state) <> State.Standard then
    state = State.Standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "moveDown1"
  elsewhen pre(state) == State.WaitingToMoveDown and time - tValueAboveMaxWhileRunning>= t1st and pre(tap.value) > tapMin then
    state = State.MoveDown1;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition to "moveUp1"
  elsewhen pre(state) == State.WaitingToMoveUp and time - tValueAboveMaxWhileRunning>= t1st and pre(tap.value) < tapMax then
    state = State.MoveUp1;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition to "moveDownN"
  elsewhen (pre(state) == State.MoveDown1 or pre(state) == State.MoveDownN) and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.MoveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition to "moveUpN"
  elsewhen (pre(state) == State.MoveUp1 or pre(state) == State.MoveUpN) and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.MoveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  end when;

annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_MAX;


partial model BaseTapChangerPhaseShifter_INTERVAL "Base model for tap-changers and phase-shifters which tries to keep a value within a given interval"
  import Modelica.Constants;

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseTapChangerPhaseShifter;

  public
    parameter Real valueMin (max = valueMax) "Minimum allowed value";

  protected
    Boolean valueUnderMin "True if the monitored signal is under the minimum limit";
    Types.Time tValueUnderMinWhileRunning(start = Constants.inf) "Time when the monitored signal went under the minimum limit and the tap-changer/phase-shifter is running";

equation

  when (valueToMonitor.value < valueMin) and not(locked) then
    valueUnderMin = true;
    tValueUnderMinWhileRunning = time;
    valueAboveMax = false;
    tValueAboveMaxWhileRunning = pre(tValueAboveMaxWhileRunning);
  elsewhen (valueToMonitor.value > valueMax) and not(locked) then
    valueUnderMin = false;
    tValueUnderMinWhileRunning = pre(tValueUnderMinWhileRunning);
    valueAboveMax = false;
    tValueAboveMaxWhileRunning = pre(tValueAboveMaxWhileRunning);
  elsewhen (valueToMonitor.value >= valueMin or valueToMonitor.value <= valueMax) and not(locked) then
    valueUnderMin = false;
    tValueUnderMinWhileRunning = pre(tValueUnderMinWhileRunning);
    valueAboveMax = false;
    tValueAboveMaxWhileRunning = pre(tValueAboveMaxWhileRunning);
  elsewhen running.value and locked then
    valueUnderMin = pre(valueUnderMin);
    tValueUnderMinWhileRunning = Constants.inf;
    valueAboveMax = pre(valueAboveMax);
    tValueAboveMaxWhileRunning = pre(tValueAboveMaxWhileRunning);
  end when;

  lookingToDecreaseTap = (running.value and valueAboveMax and decreaseTapToDecreaseValue) or (running.value and valueUnderMin and decreaseTapToIncreaseValue);
  lookingToIncreaseTap = (running.value and valueUnderMin and increaseTapToIncreaseValue) or (running.value and valueAboveMax and increaseTapToDecreaseValue);

  //Transition to "locked" (possible from any state)
  when not(running.value) or locked then
    state = State.Locked;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "waitingToMoveDown" (possible from any state other than the MoveDown ones)
  elsewhen lookingToDecreaseTap and pre(state) <> State.WaitingToMoveDown and pre(state) <> State.MoveDown1 and  pre(state) <> State.MoveDownN then
    state = State.WaitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "waitingToMoveUp" (possible from any state other than the MoveUp ones)
  elsewhen lookingToIncreaseTap and pre(state) <> State.WaitingToMoveUp and pre(state) <> State.MoveUp1 and pre(state) <> State.MoveUpN then
    state = State.WaitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "standard" (possible from any state)
  elsewhen not(valueUnderMin) and not(valueAboveMax) and pre(state) <> State.Standard then
    state = State.Standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition to "moveDown1" (possible from "waitingToMoveDown")
  elsewhen pre(state) == State.WaitingToMoveDown and time - (if increaseTapToIncreaseValue then tValueAboveMaxWhileRunning else tValueUnderMinWhileRunning) >= t1st and pre(tap.value) > tapMin then
    state = State.MoveDown1;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition to "moveUp1" (possible from "waitingToMoveUp")
  elsewhen pre(state) == State.WaitingToMoveUp and time - (if increaseTapToIncreaseValue then tValueUnderMinWhileRunning else tValueAboveMaxWhileRunning) >= t1st and pre(tap.value) < tapMax then
    state = State.MoveUp1;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition to "moveDownN" (possible from "moveDown1" and "moveDownN")
  elsewhen (pre(state) == State.MoveDown1 or pre(state) == State.MoveDownN)  and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.MoveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition to "moveUpN" (possible from "moveUp1" and "moveUpN")
  elsewhen (pre(state) == State.MoveUp1 or  pre(state) == State.MoveUpN)  and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.MoveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  end when;

end BaseTapChangerPhaseShifter_INTERVAL;


partial model BaseTapChangerPhaseShifter_TARGET "Base model for tap-changers and phase-shifters ensuring that the monitored value remains close to a target value"
  extends BaseTapChangerPhaseShifter_INTERVAL (valueMax = targetValue + deadBand, valueMin = targetValue - deadBand);

  public
    parameter Real targetValue "Target value";
    parameter Real deadBand (min = 0) "Acceptable dead-band next to the target value";

annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_TARGET;

annotation(preferredView = "text");
end BaseClasses;
