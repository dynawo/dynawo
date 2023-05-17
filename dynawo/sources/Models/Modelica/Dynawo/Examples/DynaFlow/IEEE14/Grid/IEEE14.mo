within Dynawo.Examples.DynaFlow.IEEE14.Grid;

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

model IEEE14 "IEEE 14-bus system benchmark formed with 14 buses, 5 generators, 1 shunt, 3 transformers , 17 lines and 11 loads."
  import Modelica;
  import Dynawo.Electrical;
  import Dynawo.Examples;
  import Dynawo.Types;

  extends Examples.DynaFlow.IEEE14.Grid.BaseClasses.IEEE14Base;

  // Generators control
  Electrical.Controls.Frequency.SignalN ModelSignalN;
  Types.Angle Theta_Bus1;

  // Loads references
  Electrical.Controls.Basics.SetPoint PrefPu_Load2(Value0 = P0Pu_Load2);
  Electrical.Controls.Basics.SetPoint QrefPu_Load2(Value0 = Q0Pu_Load2);
  Electrical.Controls.Basics.SetPoint PrefPu_Load3(Value0 = P0Pu_Load3);
  Electrical.Controls.Basics.SetPoint QrefPu_Load3(Value0 = Q0Pu_Load3);
  Electrical.Controls.Basics.SetPoint PrefPu_Load4(Value0 = P0Pu_Load4);
  Electrical.Controls.Basics.SetPoint QrefPu_Load4(Value0 = Q0Pu_Load4);
  Electrical.Controls.Basics.SetPoint PrefPu_Load5(Value0 = P0Pu_Load5);
  Electrical.Controls.Basics.SetPoint QrefPu_Load5(Value0 = Q0Pu_Load5);
  Electrical.Controls.Basics.SetPoint PrefPu_Load6(Value0 = P0Pu_Load6);
  Electrical.Controls.Basics.SetPoint QrefPu_Load6(Value0 = Q0Pu_Load6);
  Electrical.Controls.Basics.SetPoint PrefPu_Load9(Value0 = P0Pu_Load9);
  Electrical.Controls.Basics.SetPoint QrefPu_Load9(Value0 = Q0Pu_Load9);
  Electrical.Controls.Basics.SetPoint PrefPu_Load10(Value0 = P0Pu_Load10);
  Electrical.Controls.Basics.SetPoint QrefPu_Load10(Value0 = Q0Pu_Load10);
  Electrical.Controls.Basics.SetPoint PrefPu_Load11(Value0 = P0Pu_Load11);
  Electrical.Controls.Basics.SetPoint QrefPu_Load11(Value0 = Q0Pu_Load11);
  Electrical.Controls.Basics.SetPoint PrefPu_Load12(Value0 = P0Pu_Load12);
  Electrical.Controls.Basics.SetPoint QrefPu_Load12(Value0 = Q0Pu_Load12);
  Electrical.Controls.Basics.SetPoint PrefPu_Load13(Value0 = P0Pu_Load13);
  Electrical.Controls.Basics.SetPoint QrefPu_Load13(Value0 = Q0Pu_Load13);
  Electrical.Controls.Basics.SetPoint PrefPu_Load14(Value0 = P0Pu_Load14);
  Electrical.Controls.Basics.SetPoint QrefPu_Load14(Value0 = Q0Pu_Load14);

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

equation
// Loads references
  Load2.PRefPu = PrefPu_Load2.setPoint.value;
  Load2.QRefPu = QrefPu_Load2.setPoint.value;
  Load3.PRefPu = PrefPu_Load3.setPoint.value;
  Load3.QRefPu = QrefPu_Load3.setPoint.value;
  Load4.PRefPu = PrefPu_Load4.setPoint.value;
  Load4.QRefPu = QrefPu_Load4.setPoint.value;
  Load5.PRefPu = PrefPu_Load5.setPoint.value;
  Load5.QRefPu = QrefPu_Load5.setPoint.value;
  Load6.PRefPu = PrefPu_Load6.setPoint.value;
  Load6.QRefPu = QrefPu_Load6.setPoint.value;
  Load9.PRefPu = PrefPu_Load9.setPoint.value;
  Load9.QRefPu = QrefPu_Load9.setPoint.value;
  Load10.PRefPu = PrefPu_Load10.setPoint.value;
  Load10.QRefPu = QrefPu_Load10.setPoint.value;
  Load11.PRefPu = PrefPu_Load11.setPoint.value;
  Load11.QRefPu = QrefPu_Load11.setPoint.value;
  Load12.PRefPu = PrefPu_Load12.setPoint.value;
  Load12.QRefPu = QrefPu_Load12.setPoint.value;
  Load13.PRefPu = PrefPu_Load13.setPoint.value;
  Load13.QRefPu = QrefPu_Load13.setPoint.value;
  Load14.PRefPu = PrefPu_Load14.setPoint.value;
  Load14.QRefPu = QrefPu_Load14.setPoint.value;
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

// Generators controls and references
  ModelSignalN.thetaRef = Theta_Bus1;
  Theta_Bus1 = Modelica.ComplexMath.arg(Bus1.terminal.V);
  Gen1.N = ModelSignalN.N;
  Gen2.N = ModelSignalN.N;
  Gen3.N = ModelSignalN.N;
  Gen6.N = ModelSignalN.N;
  Gen8.N = ModelSignalN.N;
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

  annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "euler", ls = "klu", nls = "kinsol"));
end IEEE14;
