within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GovSteam "Speed governor and steam turbine"
  parameter Types.PerUnit dZMaxPu;
  parameter Types.PerUnit dZMinPu;
  parameter Types.PerUnit FHp;
  parameter Types.PerUnit FMp;
  parameter Types.PerUnit Sigma;
  parameter Types.Time tHp;
  parameter Types.PerUnit ivo "Intercept valve opening";
  parameter Types.Time tLp;
  parameter Types.Time tMeas;
  parameter Types.Time tR;
  parameter Types.Time tSm;
  parameter Types.PerUnit ZMaxPu;
  parameter Types.PerUnit ZMinPu;
  parameter Types.PerUnit PNom;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency (base omegaNom)"annotation(
    Placement(visible = true, transformation(origin = {-232, 80}, extent = {{-12, -12}, {12, 12}}, rotation = 0), iconTransformation(origin = {-240, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = Pm0Pu) "Reference power in pu (base PNomTurb)"annotation(
    Placement(visible = true, transformation(origin = {-233, 99}, extent = {{-13, -13}, {13, 13}}, rotation = 0), iconTransformation(origin = {-240, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {230, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {230, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-170, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / Sigma)  annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tMeas)  annotation(
    Placement(visible = true, transformation(origin = {-50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / tSm) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegrator limitedIntegrator(Y0 = Pm0Pu,YMax = ZMaxPu, YMin = ZMinPu)  annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = dZMaxPu, uMin = dZMinPu)  annotation(
    Placement(visible = true, transformation(origin = {90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {20, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tHp, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tR, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tLp, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = 1 - FHp - FMp) annotation(
    Placement(visible = true, transformation(origin = {90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 3)  annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = FMp) annotation(
    Placement(visible = true, transformation(origin = {50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = FHp) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = ivo)  annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu Pm0Pu;
equation
  connect(omegaPu, add.u1) annotation(
    Line(points = {{-232, 80}, {-160, 80}, {-160, 66}, {-142, 66}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, add.u2) annotation(
    Line(points = {{-159, 50}, {-153, 50}, {-153, 54}, {-143, 54}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-119, 60}, {-102, 60}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{-79, 60}, {-63, 60}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u2) annotation(
    Line(points = {{-39, 60}, {-33, 60}, {-33, 54}, {-23, 54}}, color = {0, 0, 127}));
  connect(PRefPu, add1.u1) annotation(
    Line(points = {{-233, 99}, {-29, 99}, {-29, 65}, {-23, 65}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{61, 60}, {78, 60}}, color = {0, 0, 127}));
  connect(limiter.y, limitedIntegrator.u) annotation(
    Line(points = {{101, 60}, {118, 60}}, color = {0, 0, 127}));
  connect(add1.y, feedback.u1) annotation(
    Line(points = {{1, 60}, {11, 60}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{29, 60}, {37, 60}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, feedback.u2) annotation(
    Line(points = {{142, 60}, {160, 60}, {160, 20}, {20, 20}, {20, 52}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, firstOrder1.u) annotation(
    Line(points = {{142, 60}, {180, 60}, {180, 0}, {-160, 0}, {-160, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, firstOrder2.u) annotation(
    Line(points = {{-118, -20}, {-82, -20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, product.u1) annotation(
    Line(points = {{-58, -20}, {-40, -20}, {-40, -14}, {-22, -14}}, color = {0, 0, 127}));
  connect(product.y, firstOrder3.u) annotation(
    Line(points = {{2, -20}, {38, -20}}, color = {0, 0, 127}));
  connect(firstOrder3.y, gain2.u) annotation(
    Line(points = {{62, -20}, {78, -20}}, color = {0, 0, 127}));
  connect(gain2.y, sum1.u[1]) annotation(
    Line(points = {{102, -20}, {120, -20}, {120, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(gain3.y, sum1.u[2]) annotation(
    Line(points = {{62, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(product.y, gain3.u) annotation(
    Line(points = {{2, -20}, {20, -20}, {20, -60}, {38, -60}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain4.u) annotation(
    Line(points = {{-118, -20}, {-100, -20}, {-100, -80}, {-82, -80}}, color = {0, 0, 127}));
  connect(gain4.y, sum1.u[3]) annotation(
    Line(points = {{-58, -80}, {120, -80}, {120, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(sum1.y, PmPu) annotation(
    Line(points = {{162, -60}, {230, -60}}, color = {0, 0, 127}));
  connect(const.y, product.u2) annotation(
    Line(points = {{-59, -50}, {-40, -50}, {-40, -26}, {-22, -26}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-220, -160}, {220, 160}})),
    Icon(coordinateSystem(extent = {{-220, -160}, {220, 160}})));
end GovSteam;
