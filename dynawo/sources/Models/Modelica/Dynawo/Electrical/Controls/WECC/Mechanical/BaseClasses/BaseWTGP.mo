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
    Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-80, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaTPu(start = SystemBase.omegaRef0Pu) "Turbine frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-69, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Pitch angle in degree" annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Feedback sum annotation(
    Placement(transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = Kcc) annotation(
    Placement(transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Sum sum1(nin = 3, each final k = {1, -1, 1}) annotation(
    Placement(transformation(origin = {-60, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain2(k = Kpc) annotation(
    Placement(transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain3(k = Kpw) annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {2, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = ThetaMax, uMin = ThetaMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = ThetaMax, uMin = ThetaMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {58, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(transformation(origin = {74, 82}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(POrdPu, sum.u1) annotation(
    Line(points = {{-110, -40}, {-88, -40}}, color = {0, 0, 127}));
  connect(PRefPu, sum.u2) annotation(
    Line(points = {{-80, -110}, {-80, -48}}, color = {0, 0, 127}));
  connect(omegaRefPu, sum1.u[2]) annotation(
    Line(points = {{-110, 60}, {-72, 60}}, color = {0, 0, 127}));
  connect(sum.y, gain2.u) annotation(
    Line(points = {{-71, -40}, {-59.75, -40}, {-59.75, -60}, {-42, -60}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{11, -40}, {18, -40}}, color = {0, 0, 127}));
  connect(add1.y, limiter.u) annotation(
    Line(points = {{13, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(gain1.y, sum1.u[3]) annotation(
    Line(points = {{-80, 22}, {-80, 60}, {-72, 60}}, color = {0, 0, 127}));
  connect(omegaTPu, sum1.u[1]) annotation(
    Line(points = {{-80, 110}, {-80, 60}, {-72, 60}}, color = {0, 0, 127}));
  connect(sum1.y, gain3.u) annotation(
    Line(points = {{-48, 60}, {-48, 40}, {-42, 40}}, color = {0, 0, 127}));
  connect(gain2.y, add.u2) annotation(
    Line(points = {{-18, -60}, {-18, -46}, {-12, -46}}, color = {0, 0, 127}));
  connect(gain3.y, add1.u2) annotation(
    Line(points = {{-18, 40}, {-16, 40}, {-16, 54}, {-10, 54}}, color = {0, 0, 127}));
  connect(limiter.y, add2.u1) annotation(
    Line(points = {{42, 60}, {42, 46}, {46, 46}}, color = {0, 0, 127}));
  connect(limiter1.y, add2.u2) annotation(
    Line(points = {{42, -40}, {42, 34}, {46, 34}}, color = {0, 0, 127}));
  connect(sum.y, gain1.u) annotation(
    Line(points = {{-70, -40}, {-72, -40}, {-72, -20}, {-80, -20}, {-80, -2}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram);
end BaseWTGP;
