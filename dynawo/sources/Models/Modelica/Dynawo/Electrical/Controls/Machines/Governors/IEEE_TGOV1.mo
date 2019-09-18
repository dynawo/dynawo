within Dynawo.Electrical.Controls.Machines.Governors;

model IEEE_TGOV1
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
  import Modelica.Blocks;
  import Modelica.Blocks.Interfaces;
  import Dynawo.NonElectrical.Blocks.NonLinear.FirstOrderWithNonWindUpLimiter;
  import Dynawo.NonElectrical.Blocks.NonLinear.LeadLag;
  parameter Types.PerUnit VMax = 1 "Maximum gate limit in p.u.";
  parameter Types.PerUnit VMin = 0 "Minimum gate limit in p.u.";
  parameter Types.PerUnit R = 0.05 "Controller Droop";
  parameter Types.PerUnit Dt = 0 "Frictional losses factor";
  parameter Types.Time T1 = 0.5 "Governor time constant";
  parameter Types.Time T2 = 3 "Turbine derivative time constant";
  parameter Types.Time T3 = 10 "Turbine delay time constant";
  Interfaces.RealInput RefLPu(start = RefL0Pu) "Reference frequency/load input [pu]" annotation(
    Placement(visible = true, transformation(origin = {-140, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Interfaces.RealInput omegaPu(start = omega0Pu) "Frequency [pu]" annotation(
    Placement(visible = true, transformation(origin = {-140, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Interfaces.RealOutput PMechPu(start = PMech0Pu) "Mechanical turbine power [pu]" annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Math.Feedback errPu annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Feedback deltaOmegaPu annotation(
    Placement(visible = true, transformation(origin = {-90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-90, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Blocks.Math.Gain gainDt(k = Dt) annotation(
    Placement(visible = true, transformation(origin = {10, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain gainDivR(k = 1 / R) annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  FirstOrderWithNonWindUpLimiter firstOrderLim(T = T1, K = 1, YMax = VMax, YMin = VMin, y0 = PMech0Pu, u0 = PMech0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  LeadLag leadLag(T1 = T2, T2 = T3, K = 1, y0 = PMech0Pu, u0 = PMech0Pu) annotation(
    Placement(visible = true, transformation(origin = {46, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Feedback sumPMechPu annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin PmPu(value(start = PMech0Pu)) "Mechanical power";
protected
  parameter Types.VoltageModulePu RefL0Pu "Initial control voltage";
  // p.u. = Unom
  parameter Types.VoltageModulePu omega0Pu = 1 "Initial stator voltage";
  // p.u. = Unom
  parameter Types.VoltageModulePu PMech0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";
equation
  connect(firstOrderLim.y, leadLag.u) annotation(
    Line(points = {{21, 50}, {29, 50}, {29, 52}, {34, 52}}, color = {0, 0, 127}));
  connect(leadLag.y, sumPMechPu.u1) annotation(
    Line(points = {{57, 52}, {71, 52}, {71, 50}, {81, 50}}, color = {0, 0, 127}));
  connect(gainDivR.y, firstOrderLim.u) annotation(
    Line(points = {{-19, 50}, {-3, 50}, {-3, 50}, {-3, 50}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, deltaOmegaPu.u2) annotation(
    Line(points = {{-90, -58}, {-90, -58}, {-90, -38}, {-90, -38}}, color = {0, 0, 127}));
  connect(gainDt.y, sumPMechPu.u2) annotation(
    Line(points = {{22, -30}, {90, -30}, {90, 42}, {90, 42}}, color = {0, 0, 127}));
  connect(deltaOmegaPu.y, gainDt.u) annotation(
    Line(points = {{-80, -30}, {-2, -30}, {-2, -30}, {-2, -30}}, color = {0, 0, 127}));
  connect(deltaOmegaPu.y, errPu.u2) annotation(
    Line(points = {{-80, -30}, {-70, -30}, {-70, 42}, {-70, 42}}, color = {0, 0, 127}));
  connect(sumPMechPu.y, PMechPu) annotation(
    Line(points = {{99, 50}, {121, 50}, {121, 50}, {129, 50}}, color = {0, 0, 127}));
  connect(errPu.y, gainDivR.u) annotation(
    Line(points = {{-61, 50}, {-43, 50}, {-43, 50}, {-43, 50}}, color = {0, 0, 127}));
  connect(RefLPu, errPu.u1) annotation(
    Line(points = {{-140, 50}, {-78, 50}}, color = {0, 0, 127}));
  connect(omegaPu, deltaOmegaPu.u1) annotation(
    Line(points = {{-140, -30}, {-100, -30}, {-100, -30}, {-98, -30}}, color = {0, 0, 127}));
  connect(PmPu.value, PMechPu);
  annotation(
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Rectangle(origin = {-1, -1}, extent = {{-99, 101}, {101, -99}}), Text(origin = {37, -9}, extent = {{-105, 67}, {31, -47}}, textString = "TGOV1")}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">The class implements a model of a simple steam turbine governor according to the&nbsp;</span><span style=\"font-size: 12px;\">IEEE technical report PES-TR1 Jan 2013.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">The type implemented is the TGOV1, described in the chapter 2.2 of the same&nbsp;IEEE technical report PES-TR1 Jan 2013.</div><div style=\"font-size: 12px;\"><br></div></body></html>"));
end IEEE_TGOV1;
