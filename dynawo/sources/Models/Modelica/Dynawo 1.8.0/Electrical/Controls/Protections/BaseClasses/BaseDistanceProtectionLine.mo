within Dynawo.Electrical.Controls.Protections.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseDistanceProtectionLine "Base model for line distance protection"
  import Modelica.Constants;
  import Modelica.Math.BooleanVectors.anyTrue;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Integer NbZones(min = 1, max = 4) "Number of zones in the distance protection scheme";
  parameter Integer LineSide(min = 1, max = 2) "Side of the line where the distance protection is located";
  parameter Types.Time[NbZones] tZone "Time delay for trips in zone i in s (for each protected zone)";
  parameter Types.PerUnit[NbZones] RPu "Resistive reach of zone i in pu (base UNom, SnRef) (for each protected zone)";
  parameter Types.PerUnit[NbZones] XPu "Reactive reach of zone i in pu (base UNom, SnRef) (for each protected zone)";
  parameter Boolean[NbZones] TrippingZone "True if zone i can send a tripping signal";
  parameter Types.Time CircuitBreakerTime "Time required to open the circuit breaker in s";
  parameter Boolean WithBlinder "True if a load blinder is used";
  parameter Types.Angle BlinderAnglePu "Load angle of the load blinder in rad";
  parameter Real BlinderReachPu "Reach in the Z plane of the load blinder in pu (base UNom, SnRef)";

  input Types.VoltageModulePu UMonitoredPu "Monitored voltage in pu (base UNom)";
  input Types.ActivePowerPu PMonitoredPu "Monitored active power in pu (base SnRef)";
  input Types.ReactivePowerPu QMonitoredPu "Monitored reactive power in pu (base SnRef)";

  Connectors.IntPin lineState(value(start = 2)) "Switch off message for the protected line";

  Boolean Blinded "True if the apparent impedance is in the load blinder area";
  Boolean[NbZones] tripped(each start = false) "true if the protection tripped (for each protected zone)";
  Types.Time[NbZones] tThresholdReached(each start = Constants.inf) "Time when the apparent impedance enters zone i in s (for each protected zone)";

equation
  Blinded = if UMonitoredPu^2 / sqrt(PMonitoredPu^2 + QMonitoredPu^2) > BlinderReachPu and abs(Modelica.Math.atan2(QMonitoredPu, PMonitoredPu)) < BlinderAnglePu then true else false;

  // Check if apparent impedance is in a protected zone
  for i in 1:NbZones loop
    when (UMonitoredPu^2 / (PMonitoredPu^2 + QMonitoredPu^2) * PMonitoredPu <= RPu[i] and
        UMonitoredPu^2 / (PMonitoredPu^2 + QMonitoredPu^2) * QMonitoredPu <= XPu[i] and
        UMonitoredPu^2 / (PMonitoredPu^2 + QMonitoredPu^2) * PMonitoredPu > -UMonitoredPu^2 / (PMonitoredPu^2 + QMonitoredPu^2) * QMonitoredPu) and
        not Blinded and pre(tThresholdReached[i]) == Constants.inf then
      tThresholdReached[i] = time;
      if i == 1 then
        Timeline.logEvent1(TimelineKeys.Zone1Arming);
      elseif i == 2 then
        Timeline.logEvent1(TimelineKeys.Zone2Arming);
      elseif i == 3 then
        Timeline.logEvent1(TimelineKeys.Zone3Arming);
      else
        Timeline.logEvent1(TimelineKeys.Zone4Arming);
      end if;
    elsewhen not (UMonitoredPu^2/(PMonitoredPu^2 + QMonitoredPu^2)*PMonitoredPu <= RPu[i] and
        UMonitoredPu^2/(PMonitoredPu^2 + QMonitoredPu^2)*QMonitoredPu <= XPu[i] and
        UMonitoredPu^2/(PMonitoredPu^2 + QMonitoredPu^2)*PMonitoredPu > -UMonitoredPu^2/(PMonitoredPu^2 + QMonitoredPu^2)*QMonitoredPu and
        not Blinded) and
        pre(tThresholdReached[i]) <> Constants.inf and time - pre(tThresholdReached[i]) < tZone[i] then
      tThresholdReached[i] = Constants.inf;
      if i == 1 then
        Timeline.logEvent1(TimelineKeys.Zone1Disarming);
      elseif i == 2 then
        Timeline.logEvent1(TimelineKeys.Zone2Disarming);
      elseif i == 3 then
        Timeline.logEvent1(TimelineKeys.Zone3Disarming);
      else
        Timeline.logEvent1(TimelineKeys.Zone4Disarming);
      end if;
    end when;
  end for;

  // Trips
  /*
  Trips are not included in the if lineState.value condition to avoid the following Modelica error
  Following variable is discrete, but does not appear on the LHS of a when-statement: ‘lineState.value‘.
  */
  for i in 1:NbZones loop
    when time - tThresholdReached[i] >= tZone[i] + CircuitBreakerTime then
      if TrippingZone[i] then
        tripped[i] = true;
      else
        tripped[i] = pre(tripped[i]);
      end if;

      if i == 1 then
        Timeline.logEvent1(TimelineKeys.DistanceTrippedZone1);
      elseif i == 2 then
        Timeline.logEvent1(TimelineKeys.DistanceTrippedZone2);
      elseif i == 3 then
        Timeline.logEvent1(TimelineKeys.DistanceTrippedZone3);
      else
        Timeline.logEvent1(TimelineKeys.DistanceTrippedZone4);
      end if;
    end when;
  end for;

  when anyTrue(tripped) then
    if lineState.value == 2 or lineState.value == 5 - LineSide then  // Other end is closed
      lineState.value = 5 - LineSide;
    else  // Other end is open
      lineState.value = 1;
    end if;
  end when;

  annotation(
    preferredView = "text");
end BaseDistanceProtectionLine;
