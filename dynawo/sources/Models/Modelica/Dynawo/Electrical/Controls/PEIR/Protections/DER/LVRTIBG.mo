within Dynawo.Electrical.Controls.PEIR.Protections.DER;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model LVRTIBG "Low voltage ride through for IBG"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.Time tLVRTInt "Time delay of trip for intermediate voltage dips in s";
  parameter Types.Time tLVRTMax "Time delay of trip for small voltage dips in s";
  parameter Types.Time tLVRTMin "Time delay of trip for severe voltage dips in s";
  parameter Types.VoltageModulePu ULVRTArmingPu "Voltage threshold under which the automaton is activated after tLVRTMax in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTIntPu "Voltage threshold under which the automaton is activated after tLVRTMin in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTMinPu "Voltage threshold under which the automaton is activated instantaneously in pu (base UNom)";

  Dynawo.Connectors.BPin switchOffSignal(value(start = false)) "Switch off message for the generator";

  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Monitored voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

protected
  Types.Time tThresholdReached(start = Modelica.Constants.inf) "Time when the threshold was reached in s";

equation
  // Arming
  when UMonitoredPu <= ULVRTArmingPu and not(pre(switchOffSignal.value)) then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.LVRTArming);
  elsewhen UMonitoredPu > ULVRTArmingPu and pre(tThresholdReached) <> Modelica.Constants.inf and not(pre(switchOffSignal.value)) then
    tThresholdReached = Modelica.Constants.inf;
    Timeline.logEvent1(TimelineKeys.LVRTDisarming);
  end when;

  // Tripping
  when UMonitoredPu < ULVRTMinPu and not pre(switchOffSignal.value) then  // No delay
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  elsewhen time - tThresholdReached >= tLVRTMin and UMonitoredPu < ULVRTIntPu and not pre(switchOffSignal.value) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  elsewhen UMonitoredPu >= ULVRTIntPu and  time - tThresholdReached >= tLVRTInt + (tLVRTMax - tLVRTInt) * (UMonitoredPu - ULVRTIntPu) / (ULVRTArmingPu - ULVRTIntPu) and not pre(switchOffSignal.value) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.LVRTTripped);
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The IBG unit can disconnect if the voltage is found below the LVRT capability curve. (See figure 2.8 in G. Chaspierre thesis 'Reduced-order modelling of active distribution networks for large-disturbance simulations')</body></html>"));
end LVRTIBG;
