within Dynawo.Electrical.Controls.Voltage;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
* for power systems.
*/

package BaseClasses
  extends Icons.BasesPackage;

partial model BaseTapChangerBlocking "Base model for Tap Changer Blocking (TCB)"
/* Lock tap changers when the voltage level goes below a predefined threshold
     in order to avoid a voltage collapse */
  import Modelica.Constants;
  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;


  type State = enumeration (Standard "1: TCB is in normal state",
                            Armed "2: TCB is armed",
                            Locked "3: TCB is blocked");

  parameter Types.Time tLagBeforeBlocked "Time to wait before activating block event";
  parameter Types.Time tLagTransBlockedT "Time to wait before sending block event to high voltage transformers";
  parameter Types.Time tLagTransBlockedD "Time to wait before sending block event to low voltage transformers";

  Connectors.BPin blockOrder(value(start = blocked0)) "TCB manual block order";
  Connectors.BPin unblockOrder(value(start = blocked0)) "TCB manual unblock order";
  Boolean blockedT(start = blocked0) "High voltage transformers blocked ?";
  Boolean blockedD(start = blocked0) "Low voltage transformers blocked ?";

  parameter Boolean blocked0 = false "Is the TCB initially blocked ?";
  parameter State state0 = State.Standard "Initial state";

protected
  Boolean UUnderMin(start = false) "U < Umin ?";
  Types.Time tUnderUmin(start = Constants.inf) "Time when U < Umin";
  Types.Time tLocked(start = Constants.inf) "Time when the TCB was blocked";
  State state(start = state0) "State of the automata throughout the simulation";

equation
  // Automata state transitions
  // Note that the deactivation from the Locked state is only manual and can happen only if the arming condition is false
  when UUnderMin and pre(state) == State.Standard then
    state = State.Armed;
    tLocked = Constants.inf;
    Timeline.logEvent1(TimelineKeys.TapChangersArming);
  elsewhen not(UUnderMin) and pre(state) == State.Armed then
    state = State.Standard;
    tLocked = Constants.inf;
    Timeline.logEvent1(TimelineKeys.TapChangersUnarming);
  elsewhen (((time - tUnderUmin >= tLagBeforeBlocked) or (blockOrder.value and not(pre(blockOrder.value)))) and pre(state) == State.Armed) or (blockOrder.value and not(pre(blockOrder.value)) and pre(state) == State.Standard) then
    state = State.Locked;
    tLocked = time;
    Timeline.logEvent1(TimelineKeys.TapChangersBlocked);
  elsewhen unblockOrder.value and not(pre(unblockOrder.value)) and not(UUnderMin) and pre(state) == State.Locked then
    state = State.Standard;
    tLocked = Constants.inf;
    Timeline.logEvent1(TimelineKeys.TapChangersUnblocked);
  end when;

  // Lock order transmission to low voltage and high voltage tap-changers
  when time - tLocked >= tLagTransBlockedT and pre(state) == State.Locked then
    blockedT = true;
    Timeline.logEvent1(TimelineKeys.TapChangersBlockedT);
  elsewhen state == State.Standard and pre(state) == State.Locked then
    blockedT = false;
  end when;

  when time - tLocked >= tLagTransBlockedD and pre(state) == State.Locked then
    blockedD = true;
    Timeline.logEvent1(TimelineKeys.TapChangersBlockedD);
  elsewhen state == State.Standard and pre(state) == State.Locked then
    blockedD = false;
  end when;

  annotation(preferredView = "text");
end BaseTapChangerBlocking;

annotation(preferredView = "text");
end BaseClasses;
