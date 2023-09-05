within Dynawo.Examples.DynaFlow.IEEE14.TestCases;

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

model IEEE14CLA "IEEE 14-bus system benchmark formed with 14 buses, 5 generators (2 generators and 3 synchronous condensers), 1 shunt, 3 transformers , 17 lines and 11 loads. At t=50s, the consumption of load 5 increases. Three Current Limit Automatons are supervising current on lines B1-B5, B1-B2 and B2-B5."
  extends Dynawo.Examples.DynaFlow.IEEE14.BaseClasses.IEEE14Base;
  extends Modelica.Icons.Example;

  // Loads references
  parameter Types.ActivePowerPu P0Pu_Load2 = 0.217000;
  parameter Types.ReactivePowerPu Q0Pu_Load2 = 0.127000;
  parameter Types.ActivePowerPu P0Pu_Load3 = 0.942000;
  parameter Types.ReactivePowerPu Q0Pu_Load3 = 0.190000;
  parameter Types.ActivePowerPu P0Pu_Load4 = 0.478000;
  parameter Types.ReactivePowerPu Q0Pu_Load4 = -0.039000;
  parameter Types.ActivePowerPu P0Pu_Load5 = 0.076000;
  parameter Types.ReactivePowerPu Q0Pu_Load5 = 0.016000;
  parameter Types.ActivePowerPu P0Pu_Load6 = 0.112000;
  parameter Types.ReactivePowerPu Q0Pu_Load6 = 0.075000;
  parameter Types.ActivePowerPu P0Pu_Load9 = 0.295000;
  parameter Types.ReactivePowerPu Q0Pu_Load9 = 0.166000;
  parameter Types.ActivePowerPu P0Pu_Load10 = 0.090000;
  parameter Types.ReactivePowerPu Q0Pu_Load10 = 0.058000;
  parameter Types.ActivePowerPu P0Pu_Load11 = 0.035000;
  parameter Types.ReactivePowerPu Q0Pu_Load11 = 0.018000;
  parameter Types.ActivePowerPu P0Pu_Load12 = 0.061000;
  parameter Types.ReactivePowerPu Q0Pu_Load12 = 0.016000;
  parameter Types.ActivePowerPu P0Pu_Load13 = 0.135000;
  parameter Types.ReactivePowerPu Q0Pu_Load13 = 0.058000;
  parameter Types.ActivePowerPu P0Pu_Load14 = 0.149000;
  parameter Types.ReactivePowerPu Q0Pu_Load14 = 0.050000;

  Real IB1B5, IB1B2, IB2B5;

  Dynawo.Electrical.Controls.Current.CurrentLimitAutomaton CLAB1B2(IMax = 1.55, OrderToEmit = 4, Running = true, tLagBeforeActing = 30);
  Dynawo.Electrical.Controls.Current.CurrentLimitAutomaton CLAB2B5(IMax = 0.49, OrderToEmit = 4, Running = true, tLagBeforeActing = 20);
  Dynawo.Electrical.Controls.Current.CurrentLimitAutomaton CLAB1B5(IMax = 2, OrderToEmit = 4, Running = true, tLagBeforeActing = 50);

equation
  IB1B5 = sqrt(LineB1B5.terminal1.i.re * LineB1B5.terminal1.i.re + LineB1B5.terminal1.i.im * LineB1B5.terminal1.i.im);
  IB1B2 = sqrt(LineB1B2.terminal1.i.re * LineB1B2.terminal1.i.re + LineB1B2.terminal1.i.im * LineB1B2.terminal1.i.im);
  IB2B5 = sqrt(LineB2B5.terminal1.i.re * LineB2B5.terminal1.i.re + LineB2B5.terminal1.i.im * LineB2B5.terminal1.i.im);

  CLAB1B2.IMonitored.value = IB1B2;
  when CLAB1B2.order.value > 3 then
    LineB1B2.switchOffSignal2.value = true;
  elsewhen CLAB1B2.order.value <= 3 then
    LineB1B2.switchOffSignal2.value = false;
  end when;

  CLAB2B5.IMonitored.value = IB2B5;
  when CLAB2B5.order.value > 3 then
    LineB2B5.switchOffSignal2.value = true;
  elsewhen CLAB2B5.order.value <= 3 then
    LineB2B5.switchOffSignal2.value = false;
  end when;

  CLAB1B5.IMonitored.value = IB1B5;
  when CLAB1B5.order.value > 3 then
    LineB1B5.switchOffSignal2.value = true;
  elsewhen CLAB1B5.order.value <= 3 then
    LineB1B5.switchOffSignal2.value = false;
  end when;

// Loads references
  Load2.PRefPu = P0Pu_Load2;
  Load2.QRefPu = Q0Pu_Load2;
  Load3.PRefPu = P0Pu_Load3;
  Load3.QRefPu = Q0Pu_Load3;
  Load4.PRefPu = P0Pu_Load4;
  Load4.QRefPu = Q0Pu_Load4;
  Load5.PRefPu = if time < 50 then P0Pu_Load5 else P0Pu_Load5 + 0.3;
  Load5.QRefPu = Q0Pu_Load5;
  Load6.PRefPu = P0Pu_Load6;
  Load6.QRefPu = Q0Pu_Load6;
  Load9.PRefPu = P0Pu_Load9;
  Load9.QRefPu = Q0Pu_Load9;
  Load10.PRefPu = P0Pu_Load10;
  Load10.QRefPu = Q0Pu_Load10;
  Load11.PRefPu = P0Pu_Load11;
  Load11.QRefPu = Q0Pu_Load11;
  Load12.PRefPu = P0Pu_Load12;
  Load12.QRefPu = Q0Pu_Load12;
  Load13.PRefPu = P0Pu_Load13;
  Load13.QRefPu = Q0Pu_Load13;
  Load14.PRefPu = P0Pu_Load14;
  Load14.QRefPu = Q0Pu_Load14;
  Load2.deltaP = 0;
  Load2.deltaQ = 0;
  Load3.deltaP = 0;
  Load3.deltaQ = 0;
  Load4.deltaP = 0;
  Load4.deltaQ = 0;
  Load5.deltaP = 0;
  Load5.deltaQ = 0;
  Load6.deltaP = 0;
  Load6.deltaQ = 0;
  Load9.deltaP = 0;
  Load9.deltaQ = 0;
  Load10.deltaP = 0;
  Load10.deltaQ = 0;
  Load11.deltaP = 0;
  Load11.deltaQ = 0;
  Load12.deltaP = 0;
  Load12.deltaQ = 0;
  Load13.deltaP = 0;
  Load13.deltaQ = 0;
  Load14.deltaP = 0;
  Load14.deltaQ = 0;

// Generators references
  Gen1.URefPu = Gen1.URef0Pu;
  Gen1.PRefPu = Gen1.PRef0Pu;
  Gen2.URefPu = Gen2.URef0Pu;
  Gen2.PRefPu = Gen2.PRef0Pu;
  Gen3.URefPu = Gen3.URef0Pu;
  Gen3.PRefPu = Gen3.PRef0Pu;
  Gen6.URefPu = Gen6.URef0Pu;
  Gen6.PRefPu = Gen6.PRef0Pu;
  Gen8.URefPu = Gen8.URef0Pu;
  Gen8.PRefPu = Gen8.PRef0Pu;

// Switch off signals for generators, loads, lines, transformers and bank
  Gen1.switchOffSignal1.value = false;
  Gen1.switchOffSignal2.value = false;
  Gen1.switchOffSignal3.value = false;
  Gen2.switchOffSignal1.value = false;
  Gen2.switchOffSignal2.value = false;
  Gen2.switchOffSignal3.value = false;
  Gen3.switchOffSignal1.value = false;
  Gen3.switchOffSignal2.value = false;
  Gen3.switchOffSignal3.value = false;
  Gen6.switchOffSignal1.value = false;
  Gen6.switchOffSignal2.value = false;
  Gen6.switchOffSignal3.value = false;
  Gen8.switchOffSignal1.value = false;
  Gen8.switchOffSignal2.value = false;
  Gen8.switchOffSignal3.value = false;
  Load2.switchOffSignal1.value = false;
  Load2.switchOffSignal2.value = false;
  Load3.switchOffSignal1.value = false;
  Load3.switchOffSignal2.value = false;
  Load4.switchOffSignal1.value = false;
  Load4.switchOffSignal2.value = false;
  Load5.switchOffSignal1.value = false;
  Load5.switchOffSignal2.value = false;
  Load6.switchOffSignal1.value = false;
  Load6.switchOffSignal2.value = false;
  Load9.switchOffSignal1.value = false;
  Load9.switchOffSignal2.value = false;
  Load10.switchOffSignal1.value = false;
  Load10.switchOffSignal2.value = false;
  Load11.switchOffSignal1.value = false;
  Load11.switchOffSignal2.value = false;
  Load12.switchOffSignal1.value = false;
  Load12.switchOffSignal2.value = false;
  Load13.switchOffSignal1.value = false;
  Load13.switchOffSignal2.value = false;
  Load14.switchOffSignal1.value = false;
  Load14.switchOffSignal2.value = false;
  LineB10B11.switchOffSignal1.value = false;
  LineB10B11.switchOffSignal2.value = false;
  LineB12B13.switchOffSignal1.value = false;
  LineB12B13.switchOffSignal2.value = false;
  LineB13B14.switchOffSignal1.value = false;
  LineB13B14.switchOffSignal2.value = false;
  LineB1B5.switchOffSignal1.value = false;
  LineB1B2.switchOffSignal1.value = false;
  LineB2B3.switchOffSignal1.value = false;
  LineB2B3.switchOffSignal2.value = false;
  LineB2B4.switchOffSignal1.value = false;
  LineB2B4.switchOffSignal2.value = false;
  LineB2B5.switchOffSignal1.value = false;
  LineB3B4.switchOffSignal1.value = false;
  LineB3B4.switchOffSignal2.value = false;
  LineB4B5.switchOffSignal1.value = false;
  LineB4B5.switchOffSignal2.value = false;
  LineB6B11.switchOffSignal1.value = false;
  LineB6B11.switchOffSignal2.value = false;
  LineB6B12.switchOffSignal1.value = false;
  LineB6B12.switchOffSignal2.value = false;
  LineB6B13.switchOffSignal1.value = false;
  LineB6B13.switchOffSignal2.value = false;
  LineB7B8.switchOffSignal1.value = false;
  LineB7B8.switchOffSignal2.value = false;
  LineB7B9.switchOffSignal1.value = false;
  LineB7B9.switchOffSignal2.value = false;
  LineB9B10.switchOffSignal1.value = false;
  LineB9B10.switchOffSignal2.value = false;
  LineB9B14.switchOffSignal1.value = false;
  LineB9B14.switchOffSignal2.value = false;
  Tfo1.switchOffSignal1.value = false;
  Tfo1.switchOffSignal2.value = false;
  Tfo2.switchOffSignal1.value = false;
  Tfo2.switchOffSignal2.value = false;
  Tfo3.switchOffSignal1.value = false;
  Tfo3.switchOffSignal2.value = false;
  Bank9.switchOffSignal1.value = false;
  Bank9.switchOffSignal2.value = false;

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
  Documentation(info = "<html><head></head><body><div>The purpose of the current limit automatons is to disconnect the monitored component when the current is<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">&nbsp;higher than a predefined threshold during a certain amount of time.</span></div>At t =50s, the active power consumption of load 5 increases of 0.3 p.u. Thus, the current on the lines increases.&nbsp;<div>For LineB1B2 and LineB2B5, the current is now higher than IMax. The controller CLAB2B5 will react after tLagBeforeActing = 20 s to disconnect the LineB2B5 before any reaction from the controller CLAB1B2 that has a tLagBeforeActing = 30 s.</div><div>The disconnection of Lineb2B5 decreases the current on LineB1B2 which is now below IMax = 1.55 p.u. The current of LineB1B5 stays below IMax = 2 p.u.</div><div>The final steady state is reached after the restoration of the loads.</div><div><br></div><div>Another scenario will occur if we change tLagBeforeActing for CLAB1B2 to 20 s and tLagBeforeActing for CLAB2B5 to 30 s.</div><div>After the increase of Load5.PRefPu, the current will increase on all the lines. However, here CLAB1B2 will react after 20 s before CLAB2B5 to disconnect LineB1B2.</div><div>The current of LineB2B5 is now below IMax but the current of LineB1B5 increases and it is now higher than IMax = 2 p.u.&nbsp;</div><div>CLAB1B5 will react after 50s, at t = 120 s to disconnect LineB1B5. This event disconnects generator 1 and all the generated power now comes from generator 2. The simulation fails and stops at t = 120s.</div><div><br></div><div>These two scenarios show that a time-domain approach for steady-state calculation gives results closer to system's behavior that can not be described with a static load flow. It is important to consider the dynamics of the system that can influence the final steady-state result.</div><div><br></div><div><br></div><div><br></div></body></html>"));
end IEEE14CLA;
