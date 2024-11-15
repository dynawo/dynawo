within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model BasePss1a "IEEE power system stabilizer type 1A (base model)"

  //Regulation parameters
  parameter Types.Time A1 "First coefficient of notch filter in s";
  parameter Types.PerUnit A2 "Second coefficient of notch filter in s ^ 2";
  parameter Types.PerUnit Ks "Gain of power system stabilizer";
  parameter Types.Time t1 "First lead time constant in s";
  parameter Types.Time t2 "First lag time constant in s";
  parameter Types.Time t3 "Second lead time constant in s";
  parameter Types.Time t4 "Second lag time constant in s";
  parameter Types.Time t5 "Washout time constant in s";
  parameter Types.Time t6 "Transducer time constant in s";
  parameter Types.VoltageModulePu VPssMaxPu "Maximum voltage output of power system stabilizer in pu (base UNom)";
  parameter Types.VoltageModulePu VPssMinPu "Minimum voltage output of power system stabilizer in pu (base UNom)";

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput VPssPu(start = 0) "Voltage output of power system stabilizer in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VPssMaxPu, uMin = VPssMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {t4, 1}, b = {t3, 1}) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = {t2, 1}, b = {t1, 1}) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.SecondOrder secondOrder(A1 = A1, A2 = A2) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout(tW = t5) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ks) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = t6) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(firstOrder.y, gain.u) annotation(
    Line(points = {{-98, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(gain.y, washout.u) annotation(
    Line(points = {{-58, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(washout.y, secondOrder.u) annotation(
    Line(points = {{-18, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(secondOrder.y, transferFunction1.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, transferFunction.u) annotation(
    Line(points = {{62, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, limiter.u) annotation(
    Line(points = {{102, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(limiter.y, VPssPu) annotation(
    Line(points = {{142, 0}, {170, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-180, -100}, {160, 100}})));
end BasePss1a;
