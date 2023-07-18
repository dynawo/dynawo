within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.AggregatedIBG;

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

model LVRT "Low voltage ride through"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  import Modelica.Constants;

  parameter Types.Time tFilter = 1e-2 "Filter time constant for computation of UMin1Pu, UMinIntPu, and tMaxRecovery in s";
  parameter Types.Time tLVRTInt "Time delay of trip for intermediate voltage dips in s";
  parameter Types.Time tLVRTMax "Time delay of trip for small voltage dips in s";
  parameter Types.Time tLVRTMin "Time delay of trip for severe voltage dips in s";
  parameter Types.VoltageModulePu ULVRTArmingPu "Voltage threshold under which the automaton is activated after tLVRTMax in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTIntPu "Voltage threshold under which the automaton is activated after t1 in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTMinPu "Voltage threshold under which the automaton is activated instantaneously in pu (base UNom)";

  // Parameters of the partial tripping curves
  parameter Types.PerUnit c;
  parameter Types.PerUnit d;
  parameter Types.PerUnit e;
  parameter Types.PerUnit f;
  parameter Types.PerUnit g;
  parameter Types.PerUnit h;

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Monitored voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Types.PerUnit aux3(start = 1) "Auxiliary variable used to compute f3";
  Types.PerUnit f1(start = 1) "Partial tripping coefficient for trips in period [0, tLVRTInt], equals to 1 if no trip, 0 if fully tripped";
  Types.PerUnit f2(start = 1) "Partial tripping coefficient for trips in period [tLVRTMin, tLVRTInt], equals to 1 if no trip, 0 if fully tripped";
  Types.PerUnit f3(start = 1) "Partial tripping coefficient for trips in period [tLVRTInt, tLVRTMax], equals to 1 if no trip, 0 if fully tripped";
  Types.PerUnit f4(start = 1) "Partial tripping coefficient for trips in period [tLVRTMax, inf], equals to 1 if no trip, 0 if fully tripped";
  Types.PerUnit fLVRT(start = 1) "Global partial tripping coefficient, equals to 1 if no trip, 0 if fully tripped";
  Types.Time tMaxRecovery(start = 0) "Maximum 'single-block' duration for which the protection has been armed in s";
  Types.VoltageModulePu UMin1Pu(start = 1) "Minimum voltage in period [0, tLVRTMin] in pu (base UNom)";
  Types.VoltageModulePu UMinIntPu(start = 1) "Minimum voltage in period [tLVRTMin, tLVRTInt] in pu (base UNom)";
  Types.VoltageModulePu UMinMaxPu(start = 1) "Minimum voltage in period [tLVRTMax, inf] in pu (base UNom)";

protected
  Types.Time tThresholdReached(start = Constants.inf) "Time when the threshold was reached";

equation
  // Arming
  when UMonitoredPu <= ULVRTArmingPu and not(pre(switchOffSignal.value)) then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.LVRTArming);
  elsewhen UMonitoredPu > ULVRTArmingPu and pre(tThresholdReached) <> Constants.inf and not(pre(switchOffSignal.value)) then
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.LVRTDisarming);
  end when;

  // Computation of minimum voltages
  if switchOffSignal.value == true or tThresholdReached == Constants.inf then  // Not armed or tripped
    der(UMin1Pu) = 0;
    der(UMinIntPu) = 0;
    der(UMinMaxPu) = 0;
  elseif time - tThresholdReached < tLVRTMin then
    UMin1Pu + tFilter * der(UMin1Pu) = if UMonitoredPu < UMin1Pu then UMonitoredPu else UMin1Pu;  // Relaxed version of UMin1Pu = min(UMin1Pu, UMonitoredPu)
    der(UMinIntPu) = 0;
    der(UMinMaxPu) = 0;
  elseif time - tThresholdReached < tLVRTInt then
    UMinIntPu + tFilter * der(UMinIntPu) = if UMonitoredPu < UMinIntPu then UMonitoredPu else UMinIntPu;
    der(UMin1Pu) = 0;
    der(UMinMaxPu) = 0;
  elseif time - tThresholdReached > tLVRTMax then
    UMinMaxPu + tFilter * der(UMinMaxPu) = if UMonitoredPu < UMinMaxPu then UMonitoredPu else UMinMaxPu;
    der(UMin1Pu) = 0;
    der(UMinIntPu) = 0;
  else
    der(UMin1Pu) = 0;
    der(UMinIntPu) = 0;
    der(UMinMaxPu) = 0;
  end if;

  // Computation of tMaxRecovery
  if switchOffSignal.value == true or tThresholdReached == Constants.inf then  // Not armed or tripped
    der(tMaxRecovery) = 0;
  else
    tMaxRecovery + tFilter * der(tMaxRecovery) = if (time - tThresholdReached) > tMaxRecovery then (time - tThresholdReached) else tMaxRecovery;
  end if;

  // Partial trips
  if UMin1Pu > ULVRTMinPu then
    f1 = 1;
  elseif UMin1Pu > d*ULVRTMinPu then
    f1 = c * (UMin1Pu - d*ULVRTMinPu) / (ULVRTMinPu - d*ULVRTMinPu);
  else
    f1 = 0;
  end if;

  if UMinIntPu > ULVRTIntPu then
    f2 = 1;
  elseif UMinIntPu > f*ULVRTIntPu then
    f2 = e * (UMinIntPu - f*ULVRTIntPu) / (ULVRTIntPu - f*ULVRTIntPu);
  else
    f2 = 0;
  end if;

  /*
  // Original model
  if tMaxRecovery < tLVRTInt then
    f3 = 1;
  elseif tMaxRecovery < tLVRTInt + tMaxSlowRecovery and time < tLVRTMax then
    f3 = (tLVRTInt + tMaxSlowRecovery - tMaxRecovery) / tMaxSlowRecovery;
  else
    f3 = 0;
  end if;*/
  // Modified model
  if time - tThresholdReached < tLVRTMax and time - tThresholdReached > tLVRTInt and switchOffSignal.value == false and tThresholdReached <> Constants.inf then
    aux3 = g * (UMonitoredPu - (f*ULVRTIntPu + (h*ULVRTArmingPu - f*ULVRTIntPu) * (time - tLVRTMax) / (tLVRTInt - tLVRTMax)));
    f3 + der(f3) * tFilter = if aux3 < f3 then aux3 else f3;
  else
    aux3 = 1;
    der(f3) = 0;
  end if;

  if UMinMaxPu > ULVRTArmingPu then
    f4 = 1;
  elseif UMinMaxPu > h*ULVRTArmingPu then
    f4 = (UMinMaxPu - h*ULVRTArmingPu) / (ULVRTArmingPu - h*ULVRTArmingPu);
  else
    f4 = 0;
  end if;

  fLVRT = f1 * f2 * f3 * f4;

  when fLVRT < 0.001 then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  end when;

  annotation(preferredView = "text");
end LVRT;