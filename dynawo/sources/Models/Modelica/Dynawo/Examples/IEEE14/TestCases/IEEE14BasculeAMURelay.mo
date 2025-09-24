within Dynawo.Examples.IEEE14.TestCases;

model IEEE14BasculeAMURelay "IEEE 14-bus system benchmark formed with 14 buses, 5 generators (2 generators and 3 synchronous condensers), 1 shunt, 3 transformers , 17 lines and 11 loads."
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
  //extends Dynawo.Examples.IEEE14.BaseClasses.IEEE14BaseWithBreakers;
  extends Dynawo.Examples.IEEE14.BaseClasses.IEEE14BaseWithBreakersAMURelay;
  extends Modelica.Icons.Example;
  // Loads references
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load2 = 0.217000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load2 = 0.127000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load3 = 0.942000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load3 = 0.190000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load4 = 0.478000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load4 = -0.039000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load5 = 0.076000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load5 = 0.016000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load6 = 0.112000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load6 = 0.075000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load9 = 0.295000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load9 = 0.166000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load10 = 0.090000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load10 = 0.058000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load11 = 0.035000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load11 = 0.018000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load12 = 0.061000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load12 = 0.016000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load13 = 0.135000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load13 = 0.058000;
  parameter Dynawo.Types.ActivePowerPu P0Pu_Load14 = 0.149000;
  parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load14 = 0.050000;
  //parameter Dynawo.Types.ActivePowerPu P0Pu_Load121 = 0.0061000;
  //parameter Dynawo.Types.ReactivePowerPu Q0Pu_Load121 = 0.0016000;
  //parameter Real Angle = 1; 
equation
// Loads references
  Load2.PRefPu = P0Pu_Load2;
  Load2.QRefPu = Q0Pu_Load2;
  Load3.PRefPu = P0Pu_Load3;
  Load3.QRefPu = Q0Pu_Load3;
  Load4.PRefPu = P0Pu_Load4;
  Load4.QRefPu = Q0Pu_Load4;
  Load5.PRefPu = P0Pu_Load5;
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
  //Load121.PRefPu = P0Pu_Load121;
  //Load121.QRefPu = Q0Pu_Load121;
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
  //Load121.deltaP = 0;
  //Load121.deltaQ = 0;
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
  //Load121.switchOffSignal1.value = false;
  //Load121.switchOffSignal2.value = false;
  Load13.switchOffSignal1.value = false;
  Load13.switchOffSignal2.value = false;
  Load14.switchOffSignal1.value = false;
  Load14.switchOffSignal2.value = false;
  LineB10B11.switchOffSignal1.value = false;
  LineB10B11.switchOffSignal2.value = false;
  LineB12B13.switchOffSignal1 = idealSwitch_Bus12_LineB12B13.switchOffSignal1;
  LineB12B13.switchOffSignal2.value = false;
  //LineB12B121.switchOffSignal1 = idealSwitch_Bus121.switchOffSignal1;
  //LineB12B121.switchOffSignal2.value = false;
  //LineB12B132.switchOffSignal1 = idealSwitch_Bus13_LineB12B13.switchOffSignal1;
  //LineB12B132.switchOffSignal2.value = false;
  //LineB122B13.switchOffSignal1.value = false;
  //LineB122B13.switchOffSignal2.value = false;//idealSwitch_Bus13_LineB122B13.switchOffSignal1;
  LineB13B14.switchOffSignal1.value = false;
  LineB13B14.switchOffSignal2.value = false;
  LineB1B5.switchOffSignal1.value = false;
  LineB1B5.switchOffSignal2.value = false;
  LineB1B2.switchOffSignal1.value = false;
  LineB1B2.switchOffSignal2.value = false;
  LineB2B3.switchOffSignal1.value = false;
  LineB2B3.switchOffSignal2.value = false;
  LineB2B4.switchOffSignal1.value = false;
  LineB2B4.switchOffSignal2.value = false;
  LineB2B5.switchOffSignal1.value = false;
  LineB2B5.switchOffSignal2.value = false;
  LineB3B4.switchOffSignal1.value = false;
  LineB3B4.switchOffSignal2.value = false;
  LineB4B5.switchOffSignal1.value = false;
  LineB4B5.switchOffSignal2.value = false;
  LineB6B11.switchOffSignal1.value = false;
  LineB6B11.switchOffSignal2.value = false;
  LineB6B121.switchOffSignal1.value = false;
  LineB6B121.switchOffSignal2 = idealSwitch_Bus6_LineB6B121.switchOffSignal1;
  LineB12B121.switchOffSignal1.value = false;
  LineB12B121.switchOffSignal2 = idealSwitch_Bus12_LineB12B121.switchOffSignal1;
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
  idealSwitch_Bus12_LineB12B121.switchOffSignal1.value = false;//if time < 10 then false else true;//false;//if time < 10 then false else true;
  //idealSwitch_Bus12_LineB6B1212.switchOffSignal1.value = false;
  idealSwitch_Bus12_LineB12B13.switchOffSignal1 = AMU.switchOffSignal;//if time < 15 then false else true;//false;// if time < 100 then false else true;
  AMU.BusVoltage = sqrt(((idealSwitch_Bus12_LineB12B13.terminal1.V.re)^2)+((idealSwitch_Bus12_LineB12B13.terminal1.V.im)^2));
  AMU.busPhaseAngle = (Bus12.UPhase/(2*Modelica.Constants.pi))*360;
  AMU.uEquipmentMonitoredPu = sqrt((idealSwitch_Bus12_LineB12B13.terminal2.V.re)^2+(idealSwitch_Bus12_LineB12B13.terminal2.V.im)^2);
  AMU.equipmentPhaseAngle = (Bus13.UPhase/(2*Modelica.Constants.pi))*360;
  idealSwitch_Bus6_LineB6B121.switchOffSignal1.value = false;
  idealSwitchAdaptedV2_Bus13_LineB122B13.switchOffSignal1.value = if time < 10 then false else true;
  //idealSwitchAdaptedV2_Bus13_LineB122B13.VTerminal1 = Bus13.terminal.V;
  //idealSwitchAdaptedV2_Bus13_LineB122B13.VTerminal2 = LineB122B13.terminal2.V;
  //idealSwitch_Bus13_LineB122B13.switchOffSignal1.value = if time < 10 then false else true;
  //idealSwitch_Bus121.switchOffSignal1.value = if time < 10 then false else true;
  //idealSwitch_Bus13_LineB12B13.switchOffSignal1.value = false;
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-6, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"));
end IEEE14BasculeAMURelay;
