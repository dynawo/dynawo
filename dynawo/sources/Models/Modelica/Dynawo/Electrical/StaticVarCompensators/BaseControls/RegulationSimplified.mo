within Dynawo.Electrical.StaticVarCompensators.BaseControls;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model RegulationSimplified "Simplified variable susceptance calculation"
  import Modelica;

  parameter Types.ApparentPowerModule SNom "Static Var Compensator nominal apparent power in MVA";
  parameter Types.PerUnit Lambda "Statism of the regulation law URefPu = UPu + Lambda*QPu in p.u (base UNom, SNom)";
  parameter Types.PerUnit Kp "Proportional gain of the PI controller";
  parameter Types.Time Ti "Integral time constant of the PI controller";
  parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in p.u (base SNom)";
  parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in p.u (base SNom)";

  Modelica.Blocks.Interfaces.RealInput UPu "Voltage at the static var compensator terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-173, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, 21}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu "Reactive power injected by the static var compensator in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-173, -56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu "Voltage reference for the regulation in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-173, 22}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput BVarPu "Variable susceptance of the static var compensator in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {171, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-51, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-95, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain lambda(k = Lambda)  annotation(
    Placement(visible = true, transformation(origin = {-133, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = BMaxPu, uMin = BMinPu)  annotation(
    Placement(visible = true, transformation(origin = {113, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k1 = Kp, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {69, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(initType = Modelica.Blocks.Types.Init.InitialState, k = 1 / Ti, y_start = BVar0Pu)  annotation(
    Placement(visible = true, transformation(origin = {25, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {-13, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {85, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
protected
    parameter Types.PerUnit BVar0Pu "Start value of variable susceptance in p.u (base SNom)";
equation
  connect(feedback1.y, add4.u2) annotation(
    Line(points = {{76, -44}, {-34, -44}, {-34, -24}, {-25, -24}}, color = {0, 0, 127}));
  connect(limiter.y, feedback1.u1) annotation(
    Line(points = {{124, 0}, {132, 0}, {132, -44}, {93, -44}}, color = {0, 0, 127}));
  connect(add3.y, feedback1.u2) annotation(
    Line(points = {{80, 0}, {85, 0}, {85, -36}}, color = {0, 0, 127}));
  connect(add1.y, add4.u1) annotation(
    Line(points = {{-40, 6}, {-34, 6}, {-34, -12}, {-25, -12}}, color = {0, 0, 127}));
  connect(add1.y, add3.u1) annotation(
    Line(points = {{-40, 6}, {57, 6}}, color = {0, 0, 127}));
  connect(add4.y, integrator.u) annotation(
    Line(points = {{-2, -18}, {13, -18}}, color = {0, 0, 127}));
  connect(integrator.y, add3.u2) annotation(
    Line(points = {{36, -18}, {45, -18}, {45, -6}, {57, -6}}, color = {0, 0, 127}));
  connect(add3.y, limiter.u) annotation(
    Line(points = {{80, 0}, {101, 0}}, color = {0, 0, 127}));
  connect(add1.y, add3.u1) annotation(
    Line(points = {{-40, 6}, {57, 6}}, color = {0, 0, 127}));
  connect(lambda.y, add2.u2) annotation(
    Line(points = {{-122, -56}, {-118, -56}, {-118, -26}, {-107, -26}}, color = {0, 0, 127}));
  connect(QPu, lambda.u) annotation(
    Line(points = {{-173, -56}, {-145, -56}}, color = {0, 0, 127}));
  connect(UPu, add2.u1) annotation(
    Line(points = {{-173, -14}, {-107, -14}}, color = {0, 0, 127}));
  connect(add2.y, add1.u2) annotation(
    Line(points = {{-84, -20}, {-81, -20}, {-81, 0}, {-63, 0}}, color = {0, 0, 127}));
  connect(URefPu, add1.u1) annotation(
    Line(points = {{-173, 22}, {-82, 22}, {-82, 12}, {-63, 12}}, color = {0, 0, 127}));
  connect(limiter.y, BVarPu) annotation(
    Line(points = {{124, 0}, {171, 0}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-40, 20}, extent = {{-50, 14}, {136, -52}}, textString = "Regulation"), Text(origin = {137, 26}, extent = {{-27, 12}, {53, -22}}, textString = "BVarPu"), Text(origin = {-170, -18}, extent = {{-32, 16}, {30, -14}}, textString = "QPu"), Text(origin = {-172, 34}, extent = {{-30, 16}, {30, -14}}, textString = "UPu")}, coordinateSystem(initialScale = 0.1)));
end RegulationSimplified;
