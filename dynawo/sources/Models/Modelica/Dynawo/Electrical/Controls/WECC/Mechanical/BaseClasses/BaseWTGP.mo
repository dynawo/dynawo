within Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseWTGP "Base Pitch Controller"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsWTGP;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput POrdPu(start = PInj0Pu) "Active power order in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, -42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 66}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaTPu(start = SystemBase.omegaRef0Pu) "Turbine frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-62, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-69, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput Theta(start = theta0) "Pitch angle in degrees" annotation(
    Placement(transformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Feedback sum annotation(
    Placement(transformation(origin = {-60, -42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Kcc(k = kcc) annotation(
    Placement(transformation(origin = {-48, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Sum sum1(nin = 3, each final k = {1, -1, 1}) annotation(
    Placement(transformation(origin = {-48, 66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Kpc(k = kpc) annotation(
    Placement(transformation(origin = {-22, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {6, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Kpw(k = kpw) annotation(
    Placement(transformation(origin = {-20, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {4, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = thetaMax, uMin = thetaMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {32, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = thetaMax, uMin = thetaMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {34, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {60, 42}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreezeLimDetection absLimRateLimFirstOrderFreezeLimDetection(DyMax = thetaRMax, DyMin = thetaRMin, tI = tTheta, YMax = thetaMax, YMin = thetaMin, Y0 = theta0) annotation(
    Placement(transformation(origin = {86, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(transformation(origin = {74, 82}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(POrdPu, sum.u1) annotation(
    Line(points = {{-110, -42}, {-68, -42}}, color = {0, 0, 127}));
  connect(PRefPu, sum.u2) annotation(
    Line(points = {{-60, -110}, {-60, -50}}, color = {0, 0, 127}));
  connect(sum.y, Kcc.u) annotation(
    Line(points = {{-50, -42}, {-48, -42}, {-48, -8}}, color = {0, 0, 127}));
  connect(omegaTPu, sum1.u[1]) annotation(
    Line(points = {{-62, 110}, {-62, 66}, {-60, 66}}, color = {0, 0, 127}));
  connect(omegaRefPu, sum1.u[2]) annotation(
    Line(points = {{-110, 66}, {-60, 66}}, color = {0, 0, 127}));
  connect(Kcc.y, sum1.u[3]) annotation(
    Line(points = {{-48, 16}, {-60, 16}, {-60, 66}}, color = {0, 0, 127}));
  connect(sum.y, Kpc.u) annotation(
    Line(points = {{-50, -42}, {-34, -42}, {-34, -58}}, color = {0, 0, 127}));
  connect(Kpc.y, add.u2) annotation(
    Line(points = {{-11, -58}, {-6, -58}, {-6, -50}}, color = {0, 0, 127}));
  connect(Kpw.y, add1.u2) annotation(
    Line(points = {{-9, 48}, {-8, 48}, {-8, 58}}, color = {0, 0, 127}));
  connect(sum1.y, Kpw.u) annotation(
    Line(points = {{-36, 66}, {-32, 66}, {-32, 48}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{17, -44}, {22, -44}}, color = {0, 0, 127}));
  connect(add1.y, limiter.u) annotation(
    Line(points = {{15, 64}, {20, 64}}, color = {0, 0, 127}));
  connect(limiter.y, add2.u1) annotation(
    Line(points = {{44, 64}, {48, 64}, {48, 48}}, color = {0, 0, 127}));
  connect(limiter1.y, add2.u2) annotation(
    Line(points = {{46, -44}, {48, -44}, {48, 36}}, color = {0, 0, 127}));
  connect(add2.y, absLimRateLimFirstOrderFreezeLimDetection.u) annotation(
    Line(points = {{72, 42}, {74, 42}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreezeLimDetection.y, Theta) annotation(
    Line(points = {{98, 42}, {110, 42}}, color = {0, 0, 127}));
  connect(booleanConstant.y, absLimRateLimFirstOrderFreezeLimDetection.freeze) annotation(
    Line(points = {{86, 82}, {86, 54}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram);
end BaseWTGP;
