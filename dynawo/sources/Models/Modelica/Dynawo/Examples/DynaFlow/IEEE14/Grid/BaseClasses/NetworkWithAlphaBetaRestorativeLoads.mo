within Dynawo.Examples.DynaFlow.IEEE14.Grid.BaseClasses;

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

model NetworkWithAlphaBetaRestorativeLoads "Network base for IEEE 14 test case with loads, buses, lines and transformers. External equations (mainly for switch off signals) are added directly in this model without using components defined in IEEE14.Components"
  import Dynawo;


  extends Grid.BaseClasses.Network;

  // Loads
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load2(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.196308, -0.139089), s0Pu = Complex(0.217000, 0.127000), tFilter = 10, u0Pu = Complex(1.041127, -0.090721)) annotation(
    Placement(visible = true, transformation(origin = {-78, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load3(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.868294, -0.389016), s0Pu = Complex(0.942000, 0.190000), tFilter = 10, u0Pu = Complex(0.985173, -0.222561)) annotation(
    Placement(visible = true, transformation(origin = {112, -126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load4(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.468972, -0.046384), s0Pu = Complex(0.478000, -0.039000), tFilter = 10, u0Pu = Complex(1.001230, -0.182187)) annotation(
    Placement(visible = true, transformation(origin = {70, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load5(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.071279, -0.026881), s0Pu = Complex(0.076000, 0.016000), tFilter = 10, u0Pu = Complex(1.007583, -0.155511)) annotation(
    Placement(visible = true, transformation(origin = {-22, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load6(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.084225, -0.093633), s0Pu = Complex(0.112000, 0.075000), tFilter = 10, u0Pu = Complex(1.037496, -0.262912)) annotation(
    Placement(visible = true, transformation(origin = {-16, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load9(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.229406, -0.223911), s0Pu = Complex(0.295000, 0.166000), tFilter = 10, u0Pu = Complex(1.020247, -0.272201)) annotation(
    Placement(visible = true, transformation(origin = {42, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load10(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.068305, -0.075586), s0Pu = Complex(0.090000, 0.058000), tFilter = 10, u0Pu = Complex(1.014711, -0.273737)) annotation(
    Placement(visible = true, transformation(origin = {24, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load11(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.027671, -0.024921), s0Pu = Complex(0.035000, 0.018000), tFilter = 10, u0Pu = Complex(1.021886, -0.269814)) annotation(
    Placement(visible = true, transformation(origin = {-10, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load12(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.051876, -0.029677), s0Pu = Complex(0.061000, 0.016000), tFilter = 10, u0Pu = Complex(1.018873, -0.274446)) annotation(
    Placement(visible = true, transformation(origin = {-108, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load13(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.109617, -0.086901), s0Pu = Complex(0.135000, 0.058000), tFilter = 10, u0Pu = Complex(1.013840, -0.274628)) annotation(
    Placement(visible = true, transformation(origin = {-30, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBetaRestorative Load14(Alpha = 1.5, Beta = 2.5, UMaxPu = 1.05, UMinPu = 0.95, i0Pu = Complex(0.124816, -0.086053), s0Pu = Complex(0.149000, 0.050000), tFilter = 10, u0Pu = Complex(0.996351, -0.286332)) annotation(
    Placement(visible = true, transformation(origin = {30, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // set point for loads
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load2(Value0 = P0Pu_Load2);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load2(Value0 = Q0Pu_Load2);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load3(Value0 = P0Pu_Load3);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load3(Value0 = Q0Pu_Load3);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load4(Value0 = P0Pu_Load4);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load4(Value0 = Q0Pu_Load4);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load5(Value0 = P0Pu_Load5);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load5(Value0 = Q0Pu_Load5);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load6(Value0 = P0Pu_Load6);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load6(Value0 = Q0Pu_Load6);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load9(Value0 = P0Pu_Load9);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load9(Value0 = Q0Pu_Load9);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load10(Value0 = P0Pu_Load10);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load10(Value0 = Q0Pu_Load10);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load11(Value0 = P0Pu_Load11);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load11(Value0 = Q0Pu_Load11);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load12(Value0 = P0Pu_Load12);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load12(Value0 = Q0Pu_Load12);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load13(Value0 = P0Pu_Load13);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load13(Value0 = Q0Pu_Load13);
  Dynawo.Electrical.Controls.Basics.SetPoint PrefPu_Load14(Value0 = P0Pu_Load14);
  Dynawo.Electrical.Controls.Basics.SetPoint QrefPu_Load14(Value0 = Q0Pu_Load14);

  // Loads Power initialisation
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

  // Shunt
  Dynawo.Electrical.Shunts.ShuntB Bank9(BPu = 0.099769 * ZBASE2, i0Pu = Complex(-0.0455016, -0.186237), s0Pu = Complex(0, 0.193446), u0Pu = Complex(1.020247, -0.272201)) annotation(
    Placement(visible = true, transformation(origin = {26, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  // Loads Reference values
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

  // Switch off signals
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
  Bank9.switchOffSignal1.value = false;
  Bank9.switchOffSignal2.value = false;

  // Network connections
  connect(Load2.terminal, Bus2.terminal) annotation(
    Line(points = {{-78, -108}, {-78, -100}}, color = {0, 0, 255}));
  connect(Bus3.terminal, Load3.terminal) annotation(
    Line(points = {{112, -120}, {112, -126}}, color = {0, 0, 255}));
  connect(Bus4.terminal, Load4.terminal) annotation(
    Line(points = {{70, -80}, {70, -86}}, color = {0, 0, 255}));
  connect(Load5.terminal, Bus5.terminal) annotation(
    Line(points = {{-22, -68}, {-30, -68}, {-30, -60}}, color = {0, 0, 255}));
  connect(Load6.terminal, Bus6.terminal) annotation(
    Line(points = {{-16, -8}, {-30, -8}, {-30, 0}}, color = {0, 0, 255}));
  connect(Load9.terminal, Bus9.terminal) annotation(
    Line(points = {{42, 12}, {50, 12}, {50, 20}}, color = {0, 0, 255}));
  connect(Bank9.terminal, Bus9.terminal) annotation(
    Line(points = {{26, 12}, {50, 12}, {50, 20}}, color = {0, 0, 255}));
  connect(Bus11.terminal, Load11.terminal) annotation(
    Line(points = {{-10, 60}, {-10, 54}}, color = {0, 0, 255}));
  connect(Bus13.terminal, Load13.terminal) annotation(
    Line(points = {{-30, 100}, {-30, 94}}, color = {0, 0, 255}));
  connect(Load12.terminal, Bus12.terminal) annotation(
    Line(points = {{-108, 44}, {-100, 44}, {-100, 50}}, color = {0, 0, 255}));
  connect(Bus14.terminal, Load14.terminal) annotation(
    Line(points = {{30, 80}, {30, 74}}, color = {0, 0, 255}));
  connect(Bus10.terminal, Load10.terminal) annotation(
    Line(points = {{24, 40}, {24, 36}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 2000, Tolerance = 1e-06, Interval = 10),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(ls = "klu", lv = "LOG_STATS", nls = "kinsol", s = "euler"),
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end NetworkWithAlphaBetaRestorativeLoads;
