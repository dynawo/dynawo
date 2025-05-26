within Dynawo.Electrical.Controls.WECC.Mechanical;

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

model WTGQa "WECC Torque Controller Type A"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsWTGQa;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaGPu(start = SystemBase.omegaRef0Pu) "Generator frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PePu(start = PInj0Pu) "Electrical active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRef0Pu(start = PInj0Pu) "Active power reference from the power plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze(start = false) "Boolean to freeze the regulation" annotation(
    Placement(transformation(origin = {94, 134}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {290, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = PInj0Pu) "Active power reference for the electrical controller (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {290, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [p1, spd1; p2, spd2; p3, spd3; p4, spd4], smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints) annotation(
    Placement(transformation(origin = {-32, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k = 1, T = tp, y_start = PInj0Pu) annotation(
    Placement(transformation(origin = {-62, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k = 1, T = tOmegaRef) annotation(
    Placement(transformation(origin = {-4, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {30, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {-32, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {42, -12}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {74, 14}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Modelica.Blocks.Sources.BooleanConstant TFlag(k = tFlag) annotation(
    Placement(transformation(origin = {36, 14}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gain(k = kpp) annotation(
    Placement(transformation(origin = {104, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {154, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {226, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = tEMax, uMin = tEMin, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {188, 16}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegratorFreeze limitedIntegratorFreeze(K = kip, YMax = tEMax, YMin = tEMin, Y0 = PInj0Pu/SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {102, 26}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(omegaGPu, add.u1) annotation(
    Line(points = {{-120, 88}, {16, 88}, {16, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add.u2) annotation(
    Line(points = {{7, 28}, {18, 28}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-51, 28}, {-51, -12}, {-44, -12}}, color = {0, 0, 127}));
  connect(PRef0Pu, add1.u2) annotation(
    Line(points = {{-120, -20}, {-46, -20}, {-46, -24}, {-44, -24}}, color = {0, 0, 127}));
  connect(TFlag.y, switch1.u2) annotation(
    Line(points = {{40, 14}, {62, 14}}, color = {255, 0, 255}));
  connect(division.y, switch1.u1) annotation(
    Line(points = {{53, -12}, {63, -12}, {63, 6}, {62, 6}}, color = {0, 0, 127}));
  connect(add.y, switch1.u3) annotation(
    Line(points = {{41, 34}, {45, 34}, {45, 22}, {62, 22}}, color = {0, 0, 127}));
  connect(add2.y, limiter.u) annotation(
    Line(points = {{165, 16}, {176, 16}}, color = {0, 0, 127}));
  connect(omegaGPu, product.u1) annotation(
    Line(points = {{-120, 88}, {204, 88}, {204, 28}, {214, 28}}, color = {0, 0, 127}));
  connect(limitedIntegratorFreeze.y, add2.u1) annotation(
    Line(points = {{113, 26}, {142, 26}, {142, 22}}, color = {0, 0, 127}));
  connect(switch1.y, limitedIntegratorFreeze.u) annotation(
    Line(points = {{85, 14}, {85, 27}, {90, 27}, {90, 26}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{85, 14}, {85, 5.5}, {92, 5.5}, {92, 4}}, color = {0, 0, 127}));
  connect(gain.y, add2.u2) annotation(
    Line(points = {{115, 4}, {115, 3}, {142, 3}, {142, 10}}, color = {0, 0, 127}));
  connect(limiter.y, product.u2) annotation(
    Line(points = {{199, 16}, {214, 16}}, color = {0, 0, 127}));
  connect(product.y, PRefPu) annotation(
    Line(points = {{238, 22}, {290, 22}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], firstOrder1.u) annotation(
    Line(points = {{-20, 28}, {-16, 28}}, color = {0, 0, 127}));
  connect(PePu, firstOrder.u) annotation(
    Line(points = {{-120, 28}, {-74, 28}}, color = {0, 0, 127}));
  connect(firstOrder.y, combiTable1D.u[1]) annotation(
    Line(points = {{-50, 28}, {-44, 28}}, color = {0, 0, 127}));
  connect(freeze, limitedIntegratorFreeze.freeze) annotation(
    Line(points = {{94, 134}, {94, 38}}, color = {255, 0, 255}));
  connect(add1.y, division.u1) annotation(
    Line(points = {{-20, -18}, {30, -18}}, color = {0, 0, 127}));
  connect(omegaGPu, division.u2) annotation(
    Line(points = {{-120, 88}, {12, 88}, {12, -6}, {30, -6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, omegaRefPu) annotation(
    Line(points = {{7, 28}, {14, 28}, {14, -34}, {274, -34}, {274, -16}, {290, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the Torque controller model TypeA for a WindTurbineGenerator Type 3 according to <br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p><p>&nbsp;It is a simplified generic
model. The model is relatively simple. It takes in the speed of the generator (ωg), the electrical
power developed by the generator (Pe), and the power reference coming from the power plant
controller (Prefo), and thus determines the electrical-torque needed.<!--EndFragment-->&nbsp;</p><p>&nbsp;The flag, Tflag, allows the user to determine whether the torque is changed based on
the speed reference and change in generator speed, or the power reference.</p><!--StartFragment--><!--EndFragment-->
<p>
 </p><p></p></body></html>"),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram(coordinateSystem(extent = {{-120, 120}, {280, -40}})),
    version = "",
    Icon(graphics = {Text(origin = {-117, 94}, extent = {{-19, 12}, {19, -12}}, textString = "wg"), Text(origin = {-127, 32}, extent = {{-15, 12}, {15, -12}}, textString = "Pe"), Text(origin = {-126, -38}, extent = {{-22, 16}, {22, -16}}, textString = "Pref0"), Text(origin = {-1, 2}, extent = {{-59, 42}, {59, -42}}, textString = "WTGQ A"), Text(origin = {119, 84}, extent = {{-19, 12}, {19, -12}}, textString = "Pref"), Text(origin = {121, -37}, extent = {{-23, 11}, {23, -11}}, textString = "wref"), Text(origin = {52, -108}, extent = {{14, 20}, {-14, -20}}, textString = "Freeze"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGQa;
