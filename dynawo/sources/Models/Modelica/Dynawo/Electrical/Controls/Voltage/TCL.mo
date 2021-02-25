within Dynawo.Electrical.Controls.Voltage;

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

model TCL "Tap Changer Lock (TCL)"
  /* Lock tap changers when the voltage level goes below a predefined threshold
     in order to avoid a voltage collapse */
  import Modelica.Constants;

  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  public

    type State = enumeration (Standard "1: TCL is in normal state",
                              Armed "2: TCL is armed",
                              Locked "3: TCL is locked");

    parameter Types.VoltageModule UMin "Minimum voltage threshold before tap-changer locking";
    parameter Types.Time tLagBeforeLocked "Time to wait before activating lock event";
    parameter Types.Time tLagTransLockedT "Time to wait before sending lock event to high voltage transformers";
    parameter Types.Time tLagTransLockedD "Time to wait before sending lock event to low voltage transformers";

    Connectors.ImPin UMonitored (value (unit = "kV")) "Monitored voltage";
    Connectors.BPin lockOrder (value (start = locked0)) "TCL manual lock order";
    Connectors.BPin unlockOrder (value (start = locked0)) "TCL manual lock order";
    Boolean lockedT (start = locked0) "High voltage transformers locked ?";
    Boolean lockedD (start = locked0) "Low voltage transformers locked ?";

  protected

    parameter Boolean locked0 = false "Is the TCL initially locked ?";
    parameter State state0 = State.Standard "Initial state";

    Boolean UUnderMin (start = false) "U < Umin ?";
    Types.Time tUnderUmin (start = Constants.inf) "Time when U < Umin";
    Types.Time tLocked (start = Constants.inf) "Time when the TCL was locked";
    State state(start = state0) "State of the automata throughout the simulation";

  equation

    // Check when the monitored voltage goes below UMin
    when UMonitored.value < UMin then
      UUnderMin = true;
      tUnderUmin = time;
    elsewhen UMonitored.value >= UMin and pre(UUnderMin) then
      UUnderMin = false;
      tUnderUmin = Constants.inf;
    end when;

    // Automata state transitions
    // Note that the deactivation from the Locked state is only manual
    when UUnderMin and pre(state) == State. Standard then
      state = State.Armed;
      tLocked = Constants.inf;
      Timeline.logEvent1(TimelineKeys.TapChangersArming);
    elsewhen not(UUnderMin) and pre(state) == State.Armed then
      state = State.Standard;
      tLocked = Constants.inf;
      Timeline.logEvent1(TimelineKeys.TapChangersUnarming);
    elsewhen (((time - tUnderUmin >= tLagBeforeLocked) or (lockOrder.value and not(pre(lockOrder.value)))) and pre(state) == State.Armed) or (lockOrder.value and not(pre(lockOrder.value)) and pre(state) == State.Standard) then
      state = State.Locked;
      tLocked = time;
      Timeline.logEvent1(TimelineKeys.TapChangersLocked);
    elsewhen unlockOrder.value and not(pre(unlockOrder.value)) and pre(state) == State.Locked then
      state = State.Standard;
      tLocked = Constants.inf;
      Timeline.logEvent1(TimelineKeys.TapChangersUnlocked);
    end when;

    // Lock order transmission to low voltage and high voltage tap-changers
    when time - tLocked >= tLagTransLockedT and pre(state) == State.Locked then
      lockedT = true;
      Timeline.logEvent1(TimelineKeys.TapChangersLockedT);
    elsewhen unlockOrder.value and not(pre(unlockOrder.value)) then
      lockedT = false;
    end when;

    when time - tLocked >= tLagTransLockedD and pre(state) == State.Locked then
      lockedD = true;
      Timeline.logEvent1(TimelineKeys.TapChangersLockedD);
    elsewhen unlockOrder.value and not(pre(unlockOrder.value)) then
      lockedD = false;
    end when;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model will send a lock order to transformers with tap-changers in order that the tap is locked to its current step if the voltage becomes lower than a threshold on some nodes. Such a mechanism enables to avoid voltage collapse on situations where the tap actions become negative for the system stability.</body></html>"));
end TCL;
