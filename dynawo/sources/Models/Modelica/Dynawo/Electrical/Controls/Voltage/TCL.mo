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

    parameter Types.AC.VoltageModule UMin "Minimum voltage threshold before tap-changer locking";
    parameter SIunits.Time tLagBeforeLocked "Time to wait before activating lock event";
    parameter SIunits.Time tLagTransLockedT "Time to wait before sending lock event to high voltage transformers";
    parameter SIunits.Time tLagTransLockedD "Time to wait before sending lock event to low voltage transformers";

    Connectors.ImPin UMonitored (value (unit = "kV")) "Monitored voltage";
    Connectors.BPin lockOrder (value (start = locked0)) "TCL lock order";
    Boolean lockedT (start = locked0) "High voltage transformers locked ?";
    Boolean lockedD (start = locked0) "Low voltage transformers locked ?";

  protected

    parameter Boolean locked0 = false "Is the TCL initially locked ?";

    Boolean UUnderMin (start = false) "U < Umin ?";
    SIunits.Time tUnderUmin (start = Constants.inf) "Time when U < Umin";
    SIunits.Time tLocked (start = Constants.inf) "Time when the TCL was locked";
    Boolean locked (start = locked0) "TCL locked ?";

  equation

    // Check when the monitored voltage goes below UMin
    // If the TCL is manually locked we ignore the voltage related events. Might be reviewed later.
    when UMonitored.value < UMin and UMonitored.value > 0  and not (lockOrder.value) then
      UUnderMin = true;
      tUnderUmin = time;
      Timeline.logEvent1(TimelineKeys.TapChangersArming);
    elsewhen UMonitored.value > UMin and pre(UUnderMin) and not pre(lockOrder.value) then
      UUnderMin = false;
      tUnderUmin = Constants.inf;
      Timeline.logEvent1(TimelineKeys.TapChangersUnarming);
    end when;

    // Lock order activation
    when ( (UUnderMin and time - tUnderUmin >= tLagBeforeLocked) or lockOrder.value ) and (not pre(locked)) then
      locked = true;
      tLocked = time;
      Timeline.logEvent1(TimelineKeys.TapChangersLocked);
    elsewhen not(UUnderMin) and not(lockOrder.value) and (pre(locked)) then
      locked = false;
      tLocked = Constants.inf;
      Timeline.logEvent1(TimelineKeys.TapChangersUnlocked);
    end when;

    // Lock order transmission to low voltage and high voltage tap-changers
    when locked and time - tLocked >= tLagTransLockedT then
      lockedT = true;
      Timeline.logEvent1(TimelineKeys.TapChangersLockedT);
    elsewhen not(locked) then
      lockedT = false;
    end when;

    when locked and time - tLocked >= tLagTransLockedD then
      lockedD = true;
      Timeline.logEvent1(TimelineKeys.TapChangersLockedD);
    elsewhen not(locked) then
      lockedD = false;
    end when;

end TCL;
