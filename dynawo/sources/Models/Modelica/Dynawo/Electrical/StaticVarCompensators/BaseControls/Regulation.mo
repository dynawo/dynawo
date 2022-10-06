within Dynawo.Electrical.StaticVarCompensators.BaseControls;

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
  import Dynawo.NonElectrical.Blocks.NonLinear;

  extends Parameters.Params_Regulation;
  extends Parameters.Params_Limitations;

  Modelica.Blocks.Interfaces.RealInput UPu "Voltage at the static var compensator terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-174, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, 21}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QPu "Reactive power injected by the static var compensator in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-174, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, -29}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu "Voltage reference for the regulation in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-174, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, 67}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IPu "Current of the static var compensator in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-174, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-117, -79}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked "Whether the static var compensator is blocked due to very low voltages" annotation(
    Placement(visible = true, transformation(origin = {122, 84}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput BVarPu "Variable susceptance of the static var compensator in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {220, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-52, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-96, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain lambda(k = Lambda)  annotation(
    Placement(visible = true, transformation(origin = {-134, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {112, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Limitations limitations(BMaxPu = BMaxPu, BMinPu = BMinPu, IMaxPu = IMaxPu, IMinPu = IMinPu, KCurrentLimiter = KCurrentLimiter)  annotation(
    Placement(visible = true, transformation(origin = {-31, 45}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {182, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {140, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k1 = Kp, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(initType = Modelica.Blocks.Types.Init.InitialState, k = 1 / Ti, y_start = BVar0Pu)  annotation(
    Placement(visible = true, transformation(origin = {24, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {-14, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {84, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  parameter Types.PerUnit BVar0Pu "Start value of variable susceptance in pu (base SNom)";

equation
  connect(variableLimiter.y, switch.u3) annotation(
    Line(points = {{124, -16}, {170, -16}, {170, -16}, {170, -16}}, color = {0, 0, 127}));
  connect(blocked, switch.u2) annotation(
    Line(points = {{122, 84}, {122, 10}, {146, 10}, {146, -8}, {170, -8}}, color = {255, 0, 255}));
  connect(feedback1.y, add4.u2) annotation(
    Line(points = {{74, -60}, {-34, -60}, {-34, -40}, {-26, -40}, {-26, -40}, {-26, -40}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback1.u1) annotation(
    Line(points = {{124, -16}, {132, -16}, {132, -60}, {92, -60}}, color = {0, 0, 127}));
  connect(add3.y, feedback1.u2) annotation(
    Line(points = {{80, -16}, {84, -16}, {84, -52}}, color = {0, 0, 127}));
  connect(add1.y, add4.u1) annotation(
    Line(points = {{-40, -10}, {-34, -10}, {-34, -28}, {-26, -28}, {-26, -28}}, color = {0, 0, 127}));
  connect(add1.y, add3.u1) annotation(
    Line(points = {{-40, -10}, {54, -10}, {54, -10}, {56, -10}}, color = {0, 0, 127}));
  connect(add4.y, integrator.u) annotation(
    Line(points = {{-3, -34}, {3, -34}, {3, -34}, {9, -34}, {9, -34}, {10, -34}, {10, -34}, {11, -34}}, color = {0, 0, 127}));
  connect(integrator.y, add3.u2) annotation(
    Line(points = {{35, -34}, {40, -34}, {40, -34}, {45, -34}, {45, -22}, {55, -22}, {55, -22}, {55, -22}, {55, -22}}, color = {0, 0, 127}));
  connect(add3.y, variableLimiter.u) annotation(
    Line(points = {{79, -16}, {97, -16}, {97, -16}, {99, -16}}, color = {0, 0, 127}));
  connect(add1.y, add3.u1) annotation(
    Line(points = {{-40, -10}, {56, -10}}, color = {0, 0, 127}));
  connect(limitations.BVarMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{-12, 52}, {92, 52}, {92, -8}, {100, -8}}, color = {0, 0, 127}));
  connect(limitations.BVarMinPu, variableLimiter.limit2) annotation(
    Line(points = {{-12, 38}, {88, 38}, {88, -24}, {100, -24}}, color = {0, 0, 127}));
  connect(zero.y, switch.u1) annotation(
    Line(points = {{151, 30}, {157, 30}, {157, 30}, {161, 30}, {161, 0}, {171, 0}, {171, 0}, {169, 0}, {169, 0}}, color = {0, 0, 127}));
  connect(switch.y, BVarPu) annotation(
    Line(points = {{193, -8}, {204, -8}, {204, -8}, {215, -8}, {215, -8}, {217, -8}, {217, -8}, {219, -8}}, color = {0, 0, 127}));
  connect(lambda.y, add2.u2) annotation(
    Line(points = {{-123, -72}, {-118, -72}, {-118, -42}, {-108, -42}}, color = {0, 0, 127}));
  connect(QPu, lambda.u) annotation(
    Line(points = {{-174, -72}, {-146, -72}}, color = {0, 0, 127}));
  connect(UPu, add2.u1) annotation(
    Line(points = {{-174, -30}, {-108, -30}}, color = {0, 0, 127}));
  connect(add2.y, add1.u2) annotation(
    Line(points = {{-85, -36}, {-83, -36}, {-83, -36}, {-81, -36}, {-81, -16}, {-72.5, -16}, {-72.5, -16}, {-64, -16}}, color = {0, 0, 127}));
  connect(IPu, limitations.IPu) annotation(
    Line(points = {{-174, 44}, {-51, 44}, {-51, 45}}, color = {0, 0, 127}));
  connect(URefPu, add1.u1) annotation(
    Line(points = {{-174, 6}, {-82, 6}, {-82, -4}, {-64, -4}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-40, 20}, extent = {{-50, 14}, {136, -52}}, textString = "Regulation"), Text(origin = {137, 26}, extent = {{-27, 12}, {53, -22}}, textString = "BVarPu"), Text(origin = {-172, -66}, extent = {{-28, 16}, {30, -14}}, textString = "IPu"), Text(origin = {-170, -18}, extent = {{-32, 16}, {30, -14}}, textString = "QPu"), Text(origin = {-172, 34}, extent = {{-30, 16}, {30, -14}}, textString = "UPu")}, coordinateSystem(initialScale = 0.1)));
end Regulation;
