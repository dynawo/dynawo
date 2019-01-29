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

// used for phase-shifterI (applied on current), phase-shifterP (applied on power) and tap-changer (applied on voltage)
partial model BaseTapChangerPhaseShifter "Base model for tap-changers and phase-shifters"
  import Modelica.Constants;

  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  public
    type State = enumeration (moveDownN "1: tap-changer/phase-shifter has decreased the next tap",
                              moveDown1 "2: tap-changer/phase-shifter has decreased the first tap",
                              waitingToMoveDown "3: tap-changer/phase-shifter is waiting to decrease the first tap",
                              standard "4:tap-changer/phase-shifter is in standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                              waitingToMoveUp "5: tap-changer/phase-shifter is waiting to increase the first tap",
                              moveUp1 "6: tap-changer/phase-shifter has increased the first tap",
                              moveUpN "7: tap-changer/phase-shifter has increased the next tap",
                              locked "8: tap-changer/phase-shifter locked");
    State state(start = state0);

    parameter Real valueMax "Threshold above which the tap-changer/phase-shifter will take action";

    parameter SIunits.Time t1st (min = 0) "Time lag before changing the first tap";
    parameter SIunits.Time tNext (min = 0) "Time lag before changing subsequent taps";
    parameter Integer tapMin "Minimum tap";
    parameter Integer tapMax "Maximum tap";
    parameter Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";
    parameter Boolean increaseTapToDecreaseValue = not decreaseTapToDecreaseValue "Whether increasing the tap will decrease the monitored value";
    parameter Boolean decreaseTapToIncreaseValue = not increaseTapToIncreaseValue "Whether decreasing the tap will increase the monitored value";
    parameter Boolean decreaseTapToDecreaseValue = increaseTapToIncreaseValue "Whether decreasing the tap will decrease the monitored value";
    parameter SIunits.Time tTransition = 0 "Time lag before transition to standard state"; //to avoid problems with discrete events iterations

    Connectors.ImPin valueToMonitor (value (start = valueToMonitor0)) "Monitored value";
    Connectors.ZPin tap (value (start = tap0)) "Current tap";
    Connectors.BPin AutomatonExists (value (start = true)) "Pin to indicate to deactivate internal automaton";

  protected
    type TapChangerType = enumeration ( undefined "1: undefined", tapChanger "2: tap-changer", phaseShifter "3: phase-shifter");
    parameter TapChangerType tapChangerType( start = TapChangerType.undefined );
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
    SIunits.Time tValueAboveMaxWhileRunning(start = Constants.inf) "Time when the monitored signal went above the maximum limit and the tap-changer/phase-shifter is running";
    SIunits.Time tTapUp(start = Constants.inf) "Time when the tap has been increased";
    SIunits.Time tTapDown(start = Constants.inf) "Time when the tap has been decreased";

equation
  // to force the value of AutomatonExists : writing only value = true in the ZPin declaration would lead the other side of the conneion to be set to false, leading to a bug
  // when initial() then
  when (time > 0) then
    AutomatonExists.value = true;
  end when;

  assert (tap.value <= tapMax, "tap value supposed to be below maximum tap");
  assert (tap.value >= tapMin, "tap value supposed to be above minimum tap");

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

  when (valueToMonitor.value > valueMax)  then
    valueAboveMax = true;
    valueUnderStop = false;
    Timeline.logEvent1(TimelineKeys.PhaseShifterAboveMax);
  elsewhen (valueToMonitor.value <= valueStop) then
    valueAboveMax = false;
    valueUnderStop = true;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBelowStop);
  end when;

  lookingToDecreaseTap = running.value and valueAboveMax and decreaseTapToDecreaseValue;
  lookingToIncreaseTap = running.value and valueAboveMax and increaseTapToDecreaseValue;

  //The "not(locked)" condition is important to prevent unwanted transitions when the phase-shifter leaves the "locked" state
  when running.value and valueAboveMax and not(locked) then
    tValueAboveMaxWhileRunning= time;
  elsewhen running.value and valueUnderStop and not(locked) then
    tValueAboveMaxWhileRunning= Constants.inf;
  elsewhen running.value and locked then
    tValueAboveMaxWhileRunning= Constants.inf;
  end when;

  //Transition to "locked"
  when (not running.value) or locked then
    state = State.locked;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "locked" to "standard"
  elsewhen running.value and not(locked) and not(valueAboveMax) and pre(state) == State.locked then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "locked" to "waitingToMoveDown"
  elsewhen running.value and not(locked) and lookingToDecreaseTap and pre(state) == State.locked then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "locked" to "waitingToMoveUp"
  elsewhen running.value and not(locked) and lookingToIncreaseTap and pre(state) == State.locked then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "standard" to "waitingToMoveUp"
  elsewhen running.value and lookingToIncreaseTap and pre(state) == State.standard then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
  //Transition from "waitingToMoveUp" to "standard"
  elsewhen running.value and valueUnderStop and pre(state) == State.waitingToMoveUp then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "standard" to "waitingToMoveDown"
  elsewhen running.value and lookingToDecreaseTap and pre(state) == State.standard then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
  //Transition from "waitingToMoveDown" to "standard"
  elsewhen running.value and valueUnderStop and pre(state) == State.waitingToMoveDown then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "waitingToMoveUp" to "moveUp1"
  elsewhen running.value and pre(state) == State.waitingToMoveUp and time - tValueAboveMaxWhileRunning>= t1st and pre(tap.value) < tapMax then
    state = State.moveUp1;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition from "moveUp1" to "standard"
  elsewhen running.value and valueUnderStop and pre(state) == State.moveUp1 then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveUp1" to "moveUpN"
  elsewhen running.value and pre(state) == State.moveUp1 and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.moveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition from "moveUpN" to "standard"
  elsewhen running.value and valueUnderStop and pre(state) == State.moveUpN then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveUpN" to "moveUpN"
  elsewhen running.value and pre(state) == State.moveUpN and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.moveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition from "waitingToMoveDown" to "moveDown1"
  elsewhen running.value and pre(state) == State.waitingToMoveDown and time - tValueAboveMaxWhileRunning>= t1st and pre(tap.value) > tapMin then
    state = State.moveDown1;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition from "moveDown1" to "standard"
  elsewhen running.value and valueUnderStop and pre(state) == State.moveDown1 then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveDown1" to "moveDownN"
  elsewhen running.value and pre(state) == State.moveDown1 and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.moveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition from "moveDownN" to "standard"
  elsewhen running.value and valueUnderStop and pre(state) == State.moveDownN then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveDownN" to "moveDownN"
  elsewhen running.value and pre(state) == State.moveDownN and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.moveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  end when;

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
    Boolean valueUnderMax "True if the monitored signal is under the maximum limit";
    Boolean valueAboveMin "True if the monitored signal is above the minimum limit";
    SIunits.Time tValueUnderMaxWhileRunning(start = 0) "Time when the monitored signal went under the maximum limit and the tap-changer/phase-shifter is running";
    SIunits.Time tValueUnderMinWhileRunning(start = Constants.inf) "Time when the monitored signal went under the minimum limit and the tap-changer/phase-shifter is running";
    SIunits.Time tValueAboveMinWhileRunning(start = 0) "Time when the monitored signal went above the minimum limit and the tap-changer/phase-shifter is running";

equation

  valueUnderMax = not valueAboveMax;
  valueAboveMin = not valueUnderMin;

  when (valueToMonitor.value < valueMin and tapChangerType==TapChangerType.tapChanger) then
    valueUnderMin = true;
    Timeline.logEvent1(TimelineKeys.TapChangerBelowMin);
  elsewhen (valueToMonitor.value < valueMin and tapChangerType==TapChangerType.phaseShifter) then
    valueUnderMin = true;
    Timeline.logEvent1(TimelineKeys.PhaseShifterBelowMin);
  elsewhen (valueToMonitor.value >= valueMin)  then
    valueUnderMin = false;
  end when;

  when (valueToMonitor.value > valueMax and tapChangerType==TapChangerType.tapChanger) then
    valueAboveMax = true;
    Timeline.logEvent1(TimelineKeys.TapChangerAboveMax);
  elsewhen (valueToMonitor.value > valueMax and tapChangerType==TapChangerType.phaseShifter) then
    valueAboveMax = true;
    Timeline.logEvent1(TimelineKeys.PhaseShifterAboveMax);
  elsewhen valueToMonitor.value <= valueMax then
    valueAboveMax = false;
  end when;
  
  lookingToDecreaseTap = (running.value and valueAboveMax and decreaseTapToDecreaseValue) or (running.value and valueUnderMin and decreaseTapToIncreaseValue);
  lookingToIncreaseTap = (running.value and valueUnderMin and increaseTapToIncreaseValue) or (running.value and valueAboveMax and increaseTapToDecreaseValue);
  
  //The "not(locked)" condition is important to prevent unwanted transitions when the phase-shifter leaves the "locked" state
  when valueUnderMin and not(locked) then
    tValueUnderMinWhileRunning= time;
    tValueAboveMinWhileRunning= pre(tValueAboveMinWhileRunning);
  elsewhen not(valueUnderMin) and not(locked) then
    tValueUnderMinWhileRunning= pre(tValueUnderMinWhileRunning);
    tValueAboveMinWhileRunning= time;
  elsewhen locked then
    tValueUnderMinWhileRunning = Constants.inf;
    tValueAboveMinWhileRunning = Constants.inf;
  end when;

  //The "not(locked)" condition is important to prevent unwanted transitions when the phase-shifter leaves the "locked" state
  when valueAboveMax and not(locked) then
    tValueAboveMaxWhileRunning= time;
    tValueUnderMaxWhileRunning= pre(tValueUnderMaxWhileRunning);
  elsewhen not(valueAboveMax) and not(locked) then
    tValueAboveMaxWhileRunning= pre(tValueAboveMaxWhileRunning);
    tValueUnderMaxWhileRunning= time;
  elsewhen locked then
    tValueAboveMaxWhileRunning = Constants.inf;
    tValueUnderMaxWhileRunning = Constants.inf;
  end when;

  //Transition to "locked"
  when not(running.value) or locked then
    state = State.locked;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "locked" to "standard"
  elsewhen running.value and not(locked) and valueAboveMin and valueUnderMax and pre(state) == State.locked and time - (if increaseTapToIncreaseValue then tValueAboveMinWhileRunning else tValueUnderMaxWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "locked" to "waitingToMoveDown"
  elsewhen running.value and not(locked) and lookingToDecreaseTap and pre(state) == State.locked then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "locked" to "waitingToMoveUp"
  elsewhen running.value and not(locked) and lookingToIncreaseTap and pre(state) == State.locked then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "standard" to "waitingToMoveUp"
  elsewhen running.value and lookingToIncreaseTap and pre(state) == State.standard then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
  //Transition from "waitingToMoveUp" to "standard"
  elsewhen running.value and valueAboveMin and valueUnderMax and pre(state) == State.waitingToMoveUp and time - (if increaseTapToIncreaseValue then tValueAboveMinWhileRunning else tValueUnderMaxWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "standard" to "waitingToMoveDown" 
  elsewhen running.value and lookingToDecreaseTap and pre(state) == State.standard then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
  //Transition from "waitingToMoveDown" to "standard"
  elsewhen running.value and valueAboveMin and valueUnderMax and pre(state) == State.waitingToMoveDown and time - (if increaseTapToIncreaseValue then tValueUnderMaxWhileRunning else tValueAboveMinWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "waitingToMoveDown" to "waitingToMoveUp" 
  elsewhen running.value and lookingToIncreaseTap and pre(state) == State.waitingToMoveDown then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
  //Transition from "waitingToMoveUp" to "waitingToMoveDown" 
  elsewhen running.value and lookingToDecreaseTap and pre(state) == State.waitingToMoveUp then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = pre(tTapDown);
  //Transition from "waitingToMoveUp" to "moveUp1" 
  elsewhen running.value and pre(state) == State.waitingToMoveUp and time - (if increaseTapToIncreaseValue then tValueUnderMinWhileRunning else tValueAboveMaxWhileRunning) >= t1st and pre(tap.value) < tapMax then
    state = State.moveUp1;  
    tap.value = pre(tap.value) + 1; 
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition from "moveUp1" to "standard" 
  elsewhen running.value and valueAboveMin and valueUnderMax and pre(state) == State.moveUp1 and time - (if increaseTapToIncreaseValue then tValueAboveMinWhileRunning else tValueUnderMaxWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveUp1" to "waitingToMoveDown" 
  elsewhen running.value and lookingToDecreaseTap and pre(state) == State.moveUp1 then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = pre(tTapDown);
  //Transition from "moveUp1" to "moveUpN" 
  elsewhen running.value and pre(state) == State.moveUp1 and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.moveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition from "moveUpN" to "standard" 
  elsewhen running.value and valueAboveMin and valueUnderMax and pre(state) == State.moveUpN and time - (if increaseTapToIncreaseValue then tValueAboveMinWhileRunning else tValueUnderMaxWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveUpN" to "waitingToMoveDown" 
  elsewhen running.value and lookingToDecreaseTap and pre(state) == State.moveUpN then
    state = State.waitingToMoveDown;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = pre(tTapDown);
  //Transition from "moveUpN" to "moveUpN" 
  elsewhen running.value and pre(state) == State.moveUpN and time - pre(tTapUp) >= tNext and pre(tap.value) < tapMax then
    state = State.moveUpN;
    tap.value = pre(tap.value) + 1;
    tTapUp = time;
    tTapDown = pre(tTapDown);
    Timeline.logEvent1(TimelineKeys.TapUp);
  //Transition from "waitingToMoveDown" to "moveDown1" 
  elsewhen running.value and pre(state) == State.waitingToMoveDown and time - (if increaseTapToIncreaseValue then tValueAboveMaxWhileRunning else tValueUnderMinWhileRunning) >= t1st and pre(tap.value) > tapMin then
    state = State.moveDown1;  
    tap.value = pre(tap.value) - 1; 
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition from "moveDown1" to "standard" 
  elsewhen running.value and valueAboveMin and valueUnderMax and pre(state) == State.moveDown1 and time - (if decreaseTapToDecreaseValue then tValueUnderMaxWhileRunning else tValueAboveMinWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveDown1" to "waitingToMoveUp" 
  elsewhen running.value and lookingToIncreaseTap and pre(state) == State.moveDown1 then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = Constants.inf;
  //Transition from "moveDown1" to "moveDownN" 
  elsewhen running.value and pre(state) == State.moveDown1 and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.moveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  //Transition from "moveDownN" to "standard" 
  elsewhen running.value and valueAboveMin and valueUnderMax and pre(state) == State.moveDownN and time - (if decreaseTapToDecreaseValue then tValueUnderMaxWhileRunning else tValueAboveMinWhileRunning) >= tTransition then
    state = State.standard;
    tap.value = pre(tap.value);
    tTapUp = Constants.inf;
    tTapDown = Constants.inf;
  //Transition from "moveDownN" to "waitingToMoveUp" 
  elsewhen running.value and lookingToIncreaseTap and pre(state) == State.moveDownN then
    state = State.waitingToMoveUp;
    tap.value = pre(tap.value);
    tTapUp = pre(tTapUp);
    tTapDown = Constants.inf;
  //Transition from "moveDownN" to "moveDownN" 
  elsewhen running.value and pre(state) == State.moveDownN and time - pre(tTapDown) >= tNext and pre(tap.value) > tapMin then
    state = State.moveDownN;
    tap.value = pre(tap.value) - 1;
    tTapUp = pre(tTapUp);
    tTapDown = time;
    Timeline.logEvent1(TimelineKeys.TapDown);
  end when;

end BaseTapChangerPhaseShifter_INTERVAL;


partial model BaseTapChangerPhaseShifter_TARGET "Base model for tap-changers and phase-shifters ensuring that the monitored value remains close to a target value"
  extends BaseTapChangerPhaseShifter_INTERVAL (valueMax = targetValue + deadBand, valueMin = targetValue - deadBand);

  public
    parameter Real targetValue "Target value";
    parameter Real deadBand (min = 0) "Acceptable dead-band next to the target value";

end BaseTapChangerPhaseShifter_TARGET;


end BaseClasses;
