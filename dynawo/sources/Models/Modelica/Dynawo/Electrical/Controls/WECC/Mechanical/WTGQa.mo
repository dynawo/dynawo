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
    Placement(transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PePu(start = PInj0Pu) "Electrical active power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PRef0Pu(start = PInj0Pu) "Active power reference from the power plant controller in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-130, -12}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanInput freeze(start = false) "Boolean to freeze the regulation" annotation(
    Placement(transformation(origin = {100, 130}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {290, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PRefPu(start = PInj0Pu) "Active power reference for the electrical controller (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {290, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [P1, Spd1; P2, Spd2; P3, Spd3; P4, Spd4]) annotation(
    Placement(transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k = 1, T = tP, y_start = PInj0Pu) annotation(
    Placement(transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k = 1, T = tOmegaRef) annotation(
    Placement(transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {30, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1) annotation(
    Placement(transformation(origin = {-30, -6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = TFlag) annotation(
    Placement(transformation(origin = {36, 20}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gain(k = Kpp) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {150, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {250, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = TeMaxPu, uMin = TeMinPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {188, 20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegratorFreeze limitedIntegratorFreeze(K = Kip, YMax = TeMaxPu, YMin = TeMinPu, Y0 = PInj0Pu/SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(firstOrder1.y, add.u2) annotation(
    Line(points = {{1, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-79, 40}, {-68.25, 40}, {-68.25, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(PRef0Pu, add1.u2) annotation(
    Line(points = {{-130, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{40.4, 20}, {58.4, 20}}, color = {255, 0, 255}));
  connect(division.y, switch1.u1) annotation(
    Line(points = {{41, 0}, {51, 0}, {51, 12}, {58, 12}}, color = {0, 0, 127}));
  connect(add.y, switch1.u3) annotation(
    Line(points = {{41, 46}, {53, 46}, {53, 28}, {58, 28}}, color = {0, 0, 127}));
  connect(add2.y, limiter.u) annotation(
    Line(points = {{161, 20}, {176, 20}}, color = {0, 0, 127}));
  connect(omegaGPu, product.u1) annotation(
    Line(points = {{-130, 100}, {220, 100}, {220, 46}, {238, 46}}, color = {0, 0, 127}));
  connect(limitedIntegratorFreeze.y, add2.u1) annotation(
    Line(points = {{121, 40}, {128.5, 40}, {128.5, 26}, {138, 26}, {138, 26}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{81, 20}, {81, 19.75}, {85, 19.75}, {85, -0.5}, {98, -0.5}, {98, 0}}, color = {0, 0, 127}));
  connect(limiter.y, product.u2) annotation(
    Line(points = {{199, 20}, {219.5, 20}, {219.5, 34}, {238, 34}}, color = {0, 0, 127}));
  connect(product.y, PRefPu) annotation(
    Line(points = {{261, 40}, {290, 40}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], firstOrder1.u) annotation(
    Line(points = {{-39, 40}, {-22, 40}}, color = {0, 0, 127}));
  connect(PePu, firstOrder.u) annotation(
    Line(points = {{-130, 40}, {-102, 40}}, color = {0, 0, 127}));
  connect(firstOrder.y, combiTable1D.u[1]) annotation(
    Line(points = {{-79, 40}, {-62, 40}}, color = {0, 0, 127}));
  connect(freeze, limitedIntegratorFreeze.freeze) annotation(
    Line(points = {{100, 130}, {100, 88}, {102, 88}, {102, 52}}, color = {255, 0, 255}));
  connect(add1.y, division.u1) annotation(
    Line(points = {{-19, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(omegaGPu, division.u2) annotation(
    Line(points = {{-130, 100}, {6, 100}, {6, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, omegaRefPu) annotation(
    Line(points = {{1, 40}, {14, 40}, {14, 80}, {290, 80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(add.u1, omegaGPu) annotation(
    Line(points = {{18, 52}, {6, 52}, {6, 100}, {-130, 100}}, color = {0, 0, 127}));
  connect(gain.y, add2.u2) annotation(
    Line(points = {{121, 0}, {127, 0}, {127, 14}, {137, 14}}, color = {0, 0, 127}));
  connect(switch1.y, limitedIntegratorFreeze.u) annotation(
    Line(points = {{81, 20}, {85, 20}, {85, 40}, {97, 40}}, color = {0, 0, 127}));

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
