within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

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

model DQTrafo "Dq transformation in EPRI Grid Forming model"
  extends Parameters.OmegaFlag;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput phi(start = Modelica.ComplexMath.arg(u0Pu)) "Voltage phase at injector in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "D-axis reference modulation voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "Q-axis reference modulation voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput uiSourcePu(start = u0Pu.im) "Voltage imaginary part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput urSourcePu(start = u0Pu.re) "Voltage real part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.IntegerConstant integerConstant6(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {30, -12}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch6(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {70, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  connect(transformDQtoRI.ui, uiSourcePu) annotation(
    Line(points = {{81, 4}, {94, 4}, {94, -20}, {110, -20}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ur, urSourcePu) annotation(
    Line(points = {{81, 16}, {94, 16}, {94, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(uqConvRefPu, transformDQtoRI.uq) annotation(
    Line(points = {{-110, 20}, {0, 20}, {0, 13}, {59, 13}}, color = {0, 0, 127}));
  connect(integerConstant6.y, multiSwitch6.f) annotation(
    Line(points = {{30, -23}, {30, -48}}, color = {255, 127, 0}));
  connect(multiSwitch6.y, transformDQtoRI.phi) annotation(
    Line(points = {{41, -60}, {54, -60}, {54, 4}, {59, 4}}, color = {0, 0, 127}));
  connect(phi, multiSwitch6.u[1]) annotation(
    Line(points = {{-110, -50}, {-39, -50}, {-39, -60}, {20, -60}}, color = {0, 0, 127}));
  connect(theta, multiSwitch6.u[2]) annotation(
    Line(points = {{-110, -80}, {20, -80}, {20, -60}}, color = {0, 0, 127}));
  connect(theta, multiSwitch6.u[3]) annotation(
    Line(points = {{-110, -80}, {20, -80}, {20, -60}}, color = {0, 0, 127}));
  connect(theta, multiSwitch6.u[4]) annotation(
    Line(points = {{-110, -80}, {20, -80}, {20, -60}}, color = {0, 0, 127}));
  connect(udConvRefPu, transformDQtoRI.ud) annotation(
    Line(points = {{-110, 60}, {40, 60}, {40, 17}, {59, 17}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {-1, 0}, points = {{-99, -100}, {101, 100}}), Text(origin = {-41, 51}, extent = {{-33, 25}, {33, -25}}, textString = "dq"), Text(origin = {34, -47}, extent = {{-24, 25}, {24, -25}}, textString = "ri")}));
end DQTrafo;
