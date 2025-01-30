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
  extends Parameters.OmegaFlag_;
  extends Parameters.InitialUdqConv;
  extends Parameters.InitialTerminalU;
  extends Parameters.InitialTheta;

  //inputs
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "D-axis reference modulation voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "Q-axis reference modulation voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //outputs
  Modelica.Blocks.Interfaces.RealOutput uiSourcePu(start = u0Pu.im) "Voltage imaginary part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput urSourcePu(start = u0Pu.re) "Voltage real part in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Sources.IntegerConstant integerConstant6(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {32, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch6(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {32, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 700, Kp = 20, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = Complex(1.0, 0)) annotation(
    Placement(visible = true, transformation(origin = {-30, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(transformDQtoRI.uiPu, uiSourcePu) annotation(
    Line(points = {{91, -6}, {94, -6}, {94, -20}, {110, -20}}, color = {0, 0, 127}));
  connect(transformDQtoRI.urPu, urSourcePu) annotation(
    Line(points = {{91, 6}, {94, 6}, {94, 20}, {110, 20}}, color = {0, 0, 127}));
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-49, -50}, {-44, -50}, {-44, -42}, {-39, -42}}, color = {0, 0, 127}));
  connect(uqConvRefPu, transformDQtoRI.uqPu) annotation(
    Line(points = {{-110, 30}, {8, 30}, {8, 3}, {69, 3}}, color = {0, 0, 127}));
  connect(pll.phi, multiSwitch6.u[1]) annotation(
    Line(points = {{-19, -37}, {0, -37}, {0, -52}, {22, -52}}, color = {0, 0, 127}));
  connect(integerConstant6.y, multiSwitch6.f) annotation(
    Line(points = {{32, -33}, {32, -40}}, color = {255, 127, 0}));
  connect(multiSwitch6.y, transformDQtoRI.phi) annotation(
    Line(points = {{43, -52}, {54, -52}, {54, -6}, {69, -6}}, color = {0, 0, 127}));
  connect(theta, multiSwitch6.u[2]) annotation(
    Line(points = {{-110, -80}, {22, -80}, {22, -52}}, color = {0, 0, 127}));
  connect(theta, multiSwitch6.u[3]) annotation(
    Line(points = {{-110, -80}, {22, -80}, {22, -52}}, color = {0, 0, 127}));
  connect(theta, multiSwitch6.u[4]) annotation(
    Line(points = {{-110, -80}, {22, -80}, {22, -52}}, color = {0, 0, 127}));
  connect(udConvRefPu, transformDQtoRI.udPu) annotation(
    Line(points = {{-110, 60}, {42, 60}, {42, 7}, {69, 7}}, color = {0, 0, 127}));
  connect(uInjPu, pll.uPu) annotation(
    Line(points = {{-110, -10}, {-70, -10}, {-70, -32}, {-41, -32}}, color = {85, 170, 255}));
  
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {-1, 0}, points = {{-99, -100}, {101, 100}}), Text(origin = {-41, 51}, extent = {{-33, 25}, {33, -25}}, textString = "dq"), Text(origin = {34, -47}, extent = {{-24, 25}, {24, -25}}, textString = "ri")}));
end DQTrafo;
