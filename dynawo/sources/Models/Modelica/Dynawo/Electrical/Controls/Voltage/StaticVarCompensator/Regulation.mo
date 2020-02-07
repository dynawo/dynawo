within Dynawo.Electrical.Controls.Voltage.StaticVarCompensator;

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

model Regulation "Variable susceptance calculation"
  import Modelica;

  extends Parameters.Params_Regulation;
  extends Parameters.Params_Limitations;

  Modelica.Blocks.Interfaces.RealInput UPu "Voltage at the static var compensator terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-174, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, 21}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu "Reactive power injected by the static var compensator in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-174, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu "Voltage reference for the regulation in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-174, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IPu "Current of the static var compensator in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-174, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, -79}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked "Wheter the static var compensator is blocked due to very low voltages" annotation(
    Placement(visible = true, transformation(origin = {72, 84}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput BVarPu "Variable susceptance of the static var compensator in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {170, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-52, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-96, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain lambda(k = Lambda)  annotation(
    Placement(visible = true, transformation(origin = {-134, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kg)  annotation(
    Placement(visible = true, transformation(origin = {-16, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k1 = Kp, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {20, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Ti, k = 1, y_start = BVar0Pu)  annotation(
    Placement(visible = true, transformation(origin = {72, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {76, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  StaticVarCompensator.Limitations limitations(BMaxPu = BMaxPu, BMinPu = BMinPu, IMaxPu = IMaxPu, IMinPu = IMinPu, KCurrentLimiter = KCurrentLimiter)  annotation(
    Placement(visible = true, transformation(origin = {-31, 45}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {132, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
    parameter Types.PerUnit BVar0Pu "Start value of variable susceptance in p.u (base SNom)";

equation
  connect(variableLimiter.y, firstOrder.u) annotation(
    Line(points = {{87, -16}, {111, -16}, {111, -56}, {83, -56}}, color = {0, 0, 127}));
  connect(zero.y, switch.u1) annotation(
    Line(points = {{102, 30}, {110, 30}, {110, 0}, {120, 0}, {120, 0}}, color = {0, 0, 127}));
  connect(blocked, switch.u2) annotation(
    Line(points = {{72, 84}, {72, 10}, {94, 10}, {94, -8}, {120, -8}}, color = {255, 0, 255}));
  connect(lambda.y, add2.u2) annotation(
    Line(points = {{-123, -72}, {-118, -72}, {-118, -42}, {-108, -42}}, color = {0, 0, 127}));
  connect(QPu, lambda.u) annotation(
    Line(points = {{-174, -72}, {-146, -72}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u2) annotation(
    Line(points = {{61, -56}, {0, -56}, {0, -22}, {8, -22}}, color = {0, 0, 127}));
  connect(switch.y, BVarPu) annotation(
    Line(points = {{143, -8}, {163, -8}, {163, -8}, {169, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, switch.u3) annotation(
    Line(points = {{87, -16}, {117, -16}, {117, -16}, {119, -16}}, color = {0, 0, 127}));
  connect(add3.y, variableLimiter.u) annotation(
    Line(points = {{31, -16}, {63, -16}}, color = {0, 0, 127}));
  connect(limitations.BVarMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{-12.3, 51.8}, {53.4, 51.8}, {53.4, -8.4}, {63.4, -8.4}}, color = {0, 0, 127}));
  connect(limitations.BVarMinPu, variableLimiter.limit2) annotation(
    Line(points = {{-12.3, 38.2}, {43.4, 38.2}, {43.4, -23.6}, {63.4, -23.6}}, color = {0, 0, 127}));
  connect(gain.y, add3.u1) annotation(
    Line(points = {{-5, -10}, {7, -10}}, color = {0, 0, 127}));
  connect(UPu, add2.u1) annotation(
    Line(points = {{-174, -30}, {-108, -30}}, color = {0, 0, 127}));
  connect(add2.y, add1.u2) annotation(
    Line(points = {{-85, -36}, {-83, -36}, {-83, -36}, {-81, -36}, {-81, -16}, {-72.5, -16}, {-72.5, -16}, {-64, -16}}, color = {0, 0, 127}));
  connect(add1.y, gain.u) annotation(
    Line(points = {{-41, -10}, {-28, -10}}, color = {0, 0, 127}));
  connect(IPu, limitations.IPu) annotation(
    Line(points = {{-174, 44}, {-51, 44}, {-51, 45}}, color = {0, 0, 127}));
  connect(URefPu, add1.u1) annotation(
    Line(points = {{-174, 6}, {-82, 6}, {-82, -4}, {-64, -4}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-40, 20}, extent = {{-50, 14}, {136, -52}}, textString = "Regulation"), Text(origin = {137, 26}, extent = {{-27, 12}, {53, -22}}, textString = "BVarPu"), Text(origin = {-172, -66}, extent = {{-28, 16}, {30, -14}}, textString = "IPu"), Text(origin = {-170, -18}, extent = {{-32, 16}, {30, -14}}, textString = "QPu"), Text(origin = {-172, 34}, extent = {{-30, 16}, {30, -14}}, textString = "UPu")}, coordinateSystem(initialScale = 0.1)));
end Regulation;
