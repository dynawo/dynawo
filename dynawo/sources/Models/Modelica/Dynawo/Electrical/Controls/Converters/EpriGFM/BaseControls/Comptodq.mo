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

model Comptodq "Computation of dq components from grid measurements in EPRI Grid Forming model"
  extends Parameters.OmegaFlag_;
  extends Parameters.Pll;
  extends Parameters.InitialTerminalUi;
  extends Parameters.InitialUFilter;
  extends Parameters.InitialIdqConv;
  
  // inputs
  Modelica.Blocks.Interfaces.BooleanInput Frz(start = false) "Boolean low voltage freeze signal" annotation(
    Placement(visible = true, transformation(origin = {-220, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iInjPu(re(start = i0Pu.re), im(start = i0Pu.im)) "Complex current in pu (base UNom, SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaGFM(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-220, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // outputs
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "D-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {160, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "Q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {160, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = SystemBase.omega0Pu) "PLL measured frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "D-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {160, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = UqFilter0Pu) "Q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {160, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-190, 24}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Product idSquare annotation(
    Placement(visible = true, transformation(origin = {64, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iMagPu annotation(
    Placement(visible = true, transformation(origin = {160, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {-11, -57}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Math.Product iqSquare annotation(
    Placement(visible = true, transformation(origin = {64, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-12, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant one(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KIPll, Kp = KPPll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-44, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.PolarToComplex polarToComplex annotation(
    Placement(visible = true, transformation(origin = {-126, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product annotation(
    Placement(visible = true, transformation(origin = {-110, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {134, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add sumidiq annotation(
    Placement(visible = true, transformation(origin = {102, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-154, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {24, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1 annotation(
    Placement(visible = true, transformation(origin = {26, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-162, -42}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

equation
  connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-69, -4}, {-55, -4}}, color = {0, 0, 127}));
  connect(transformRItoDQ.udPu, udFilterPu) annotation(
    Line(points = {{35, 48}, {93.5, 48}, {93.5, 50}, {160, 50}}, color = {0, 0, 127}));
  connect(transformRItoDQ.uqPu, uqFilterPu) annotation(
    Line(points = {{35, 36}, {93.5, 36}, {93.5, 30}, {160, 30}}, color = {0, 0, 127}));
  connect(omegaPLLPu, pll.omegaPLLPu) annotation(
    Line(points = {{160, -30}, {-20, -30}, {-20, 7}, {-33, 7}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.uPu, iInjPu) annotation(
    Line(points = {{15, 8}, {-11, 8}, {-11, 80}, {-210, 80}}, color = {85, 170, 255}));
  connect(uInjPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-210, 48}, {14, 48}}, color = {85, 170, 255}));
  connect(pll.phi, multiSwitch.u[1]) annotation(
    Line(points = {{-33, 3}, {-26, 3}, {-26, -88}, {-22, -88}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[2]) annotation(
    Line(points = {{-220, -90}, {-22, -90}, {-22, -88}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[3]) annotation(
    Line(points = {{-220, -90}, {-64, -90}, {-64, -88}, {-22, -88}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[4]) annotation(
    Line(points = {{-220, -90}, {-64, -90}, {-64, -88}, {-22, -88}}, color = {0, 0, 127}));
  connect(multiSwitch.y, transformRItoDQ1.phi) annotation(
    Line(points = {{-1, -88}, {8, -88}, {8, -4}, {16, -4}}, color = {0, 0, 127}));
  connect(transformRItoDQ.phi, multiSwitch.y) annotation(
    Line(points = {{14, 36}, {8, 36}, {8, -88}, {-1, -88}}, color = {0, 0, 127}));
  connect(product.y, pll.uPu) annotation(
    Line(points = {{-98, 14}, {-58, 14}, {-58, 8}, {-55, 8}}, color = {85, 170, 255}));
  connect(uInjPu, product.u1) annotation(
    Line(points = {{-210, 48}, {-146, 48}, {-146, 20}, {-122, 20}}, color = {85, 170, 255}));
  connect(switch1.u2, Frz) annotation(
    Line(points = {{-166, 6}, {-220, 6}}, color = {255, 0, 255}));
  connect(zero.y, polarToComplex.phi) annotation(
    Line(points = {{-155, -42}, {-155, -41}, {-138, -41}, {-138, -40}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u1) annotation(
    Line(points = {{-183, 24}, {-176, 24}, {-176, 14}, {-166, 14}}, color = {0, 0, 127}));
  connect(one.y, switch1.u3) annotation(
    Line(points = {{-184, -20}, {-180, -20}, {-180, -2}, {-166, -2}}, color = {0, 0, 127}));
  connect(polarToComplex.len, switch1.y) annotation(
    Line(points = {{-138, -28}, {-138, -11}, {-142, -11}, {-142, 6}}, color = {0, 0, 127}));
  connect(polarToComplex.y, product.u2) annotation(
    Line(points = {{-114, -34}, {-106, -34}, {-106, 4}, {-122, 4}, {-122, 8}}, color = {85, 170, 255}));
  connect(sumidiq.y, sqrt1.u) annotation(
    Line(points = {{114, -72}, {122, -72}}, color = {0, 0, 127}));
  connect(sqrt1.y, iMagPu) annotation(
    Line(points = {{146, -72}, {160, -72}}, color = {0, 0, 127}));
  connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{-11, -62.5}, {-11, -69}, {-12, -69}, {-12, -76}}, color = {255, 127, 0}));
  connect(sumidiq.u1, idSquare.y) annotation(
    Line(points = {{90, -66}, {82, -66}, {82, -54}, {76, -54}}, color = {0, 0, 127}));
  connect(iqSquare.y, sumidiq.u2) annotation(
    Line(points = {{76, -86}, {84, -86}, {84, -78}, {90, -78}}, color = {0, 0, 127}));
  connect(idSquare.u1, transformRItoDQ1.udPu) annotation(
    Line(points = {{52, -48}, {52, 8}, {38, 8}}, color = {0, 0, 127}));
  connect(idSquare.u2, transformRItoDQ1.udPu) annotation(
    Line(points = {{52, -60}, {52, 8}, {38, 8}}, color = {0, 0, 127}));
  connect(iqSquare.u1, transformRItoDQ1.uqPu) annotation(
    Line(points = {{52, -80}, {46, -80}, {46, -4}, {38, -4}}, color = {0, 0, 127}));
  connect(iqSquare.u2, transformRItoDQ1.uqPu) annotation(
    Line(points = {{52, -92}, {46, -92}, {46, -4}, {38, -4}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.udPu, idConvPu) annotation(
    Line(points = {{38, 8}, {160, 8}, {160, 10}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.uqPu, iqConvPu) annotation(
    Line(points = {{38, -4}, {160, -4}, {160, -10}}, color = {0, 0, 127}));
  
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, 3}, extent = {{-83, 65}, {83, -65}}, textString = "computation
to
dq")}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {150, 100}})));
end Comptodq;
