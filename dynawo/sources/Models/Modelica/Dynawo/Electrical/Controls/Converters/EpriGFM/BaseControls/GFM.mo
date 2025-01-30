within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

model GFM "Grid forming control block"
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
  extends Parameters.Gfm;
  extends Parameters.InitialGfm;
  //inputs
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = SystemBase.omega0Pu) "PLL measured frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Active power auxiliary control signal in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 113}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = PRef0Pu) "Active power generated at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QAuxPu(start = 0) "Reactive power auxiliary control signal in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = QRef0Pu) "Reactive power generated at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 11}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = UFilterRef0Pu) "voltage setpoint in pu (base UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-207, -115}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //outputs
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {260, 141}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {260, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UFilterRef0Pu) "D-axis voltage reference at the converter terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {260, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {17, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {-115, -173}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add addMinusOmega0(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-140, 145}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addOmega annotation(
    Placement(visible = true, transformation(origin = {52, 117}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addOmegaBasePu annotation(
    Placement(visible = true, transformation(origin = {225, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addP(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-61, 105}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addQ(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-66, 3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-106, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-105, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-88, -232}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constant3(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-56, -233}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constant4(k = 1) annotation(
    Placement(visible = true, transformation(origin = {180, 174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOmega0(k = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-175, 139}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant constOmegaFlag(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {-46.5, -12.5}, extent = {{-5.5, -5.5}, {5.5, 5.5}}, rotation = -90)));
  Modelica.Blocks.Sources.IntegerExpression constOmegaFlag2(y = constOmegaFlag.y) annotation(
    Placement(visible = true, transformation(origin = {135, 165}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.IntegerExpression constOmegaFlag3(y = constOmegaFlag.y) annotation(
    Placement(visible = true, transformation(origin = {-19, -161.5}, extent = {{-5.5, -7}, {5.5, 7}}, rotation = -90)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-86, -114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainK1(k = K1) annotation(
    Placement(visible = true, transformation(origin = {-14, 105}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainK2(k = K2) annotation(
    Placement(visible = true, transformation(origin = {-25, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainK2dvoc(k = K2Dvoc) annotation(
    Placement(visible = true, transformation(origin = {-57, -61}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gainKd(k = KD) annotation(
    Placement(visible = true, transformation(origin = {-13, 137}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainMinusOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {235.5, 120.5}, extent = {{-6.5, -6.5}, {6.5, 6.5}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(initType = Modelica.Blocks.Types.Init.InitialState, k = 1 / tV, y(start = UFilterRef0Pu), y_start = UFilterRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {85, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator2(k = 314.15, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {209, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagOmega(T = tF, k = 1) annotation(
    Placement(visible = true, transformation(origin = {85, 117}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagP(T = tR, k = 1, y(start = PRef0Pu), y_start = PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagQ(T = tR, k = 1, y(start = QRef0Pu), y_start = QRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {168, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchP(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {134, 135}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ1(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-58, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ2(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-18, -184}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQOutput(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {175, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression omegaFlag(y = constOmegaFlag.y) annotation(
    Placement(visible = true, transformation(origin = {175, 4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant omegaSetPu(k = SystemBase.omegaRef0Pu - SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-10, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-48, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression udFilterRefPu2(y = udFilterRefPu) annotation(
    Placement(visible = true, transformation(origin = {-159, -178}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression udFilterRefPu3(y = udFilterRefPu) annotation(
    Placement(visible = true, transformation(origin = {-108, -132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression URefPu2(y = URefPu) annotation(
    Placement(visible = true, transformation(origin = {150, -37}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(QPu, lagQ.u) annotation(
    Line(points = {{-210, -10}, {-182, -10}}, color = {0, 0, 127}));
  connect(PPu, lagP.u) annotation(
    Line(points = {{-210, 70}, {-182, 70}}, color = {0, 0, 127}));
  connect(gainK2.y, add2.u1) annotation(
    Line(points = {{-14, 4}, {5, 4}}, color = {0, 0, 127}));
  connect(product.y, add2.u2) annotation(
    Line(points = {{1, -39}, {5, -39}, {5, -8}}, color = {0, 0, 127}));
  connect(product1.y, product.u2) annotation(
    Line(points = {{-37, -120}, {-29, -120}, {-29, -45}, {-22, -45}}, color = {0, 0, 127}));
  connect(feedback4.y, product1.u1) annotation(
    Line(points = {{-77, -114}, {-60, -114}}, color = {0, 0, 127}));
  connect(URefPu, feedback4.u1) annotation(
    Line(points = {{-207, -115}, {-116.5, -115}, {-116.5, -114}, {-94, -114}}, color = {0, 0, 127}));
  connect(add2.y, integrator1.u) annotation(
    Line(points = {{28, -2}, {73, -2}}, color = {0, 0, 127}));
  connect(multiSwitchQ1.y, product.u1) annotation(
    Line(points = {{-47, -33}, {-22, -33}}, color = {0, 0, 127}));
  connect(omegaPLLPu, multiSwitchP.u[1]) annotation(
    Line(points = {{-210, 164}, {124, 164}, {124, 135}}, color = {0, 0, 127}));
  connect(integrator1.y, gainK2dvoc.u) annotation(
    Line(points = {{96, -2}, {117, -2}, {117, -61}, {-45, -61}}, color = {0, 0, 127}));
  connect(constOmega0.y, addMinusOmega0.u2) annotation(
    Line(points = {{-164, 139}, {-153, 139}}, color = {0, 0, 127}));
  connect(constOmegaFlag2.y, multiSwitchP.f) annotation(
    Line(points = {{135, 154}, {135, 150}, {134, 150}, {134, 147}}, color = {255, 127, 0}));
  connect(constOmegaFlag3.y, multiSwitchQ2.f) annotation(
    Line(points = {{-19, -168}, {-19, -170}, {-18, -170}, {-18, -172}}, color = {255, 127, 0}));
  connect(constOmegaFlag.y, multiSwitchQ1.f) annotation(
    Line(points = {{-46.5, -19}, {-59.25, -19}, {-59.25, -21}, {-58, -21}}, color = {255, 127, 0}));
  connect(gainKd.y, addOmega.u1) annotation(
    Line(points = {{-2, 137}, {28, 137}, {28, 125}, {40, 125}}, color = {0, 0, 127}));
  connect(gainK1.y, addOmega.u2) annotation(
    Line(points = {{-3, 105}, {11, 105}, {11, 117}, {40, 117}}, color = {0, 0, 127}));
  connect(omegaSetPu.y, addOmega.u3) annotation(
    Line(points = {{-119, 40}, {-40, 40}, {-40, 82}, {22, 82}, {22, 109}, {40, 109}}, color = {0, 0, 127}));
  connect(addOmega.y, lagOmega.u) annotation(
    Line(points = {{63, 117}, {73, 117}}, color = {0, 0, 127}));
  connect(lagOmega.y, multiSwitchP.u[2]) annotation(
    Line(points = {{96, 117}, {105, 117}, {105, 135}, {124, 135}}, color = {0, 0, 127}));
  connect(lagOmega.y, multiSwitchP.u[3]) annotation(
    Line(points = {{96, 117}, {105, 117}, {105, 135}, {124, 135}}, color = {0, 0, 127}));
  connect(lagOmega.y, multiSwitchP.u[4]) annotation(
    Line(points = {{96, 117}, {105, 117}, {105, 135}, {124, 135}}, color = {0, 0, 127}));
  connect(multiSwitchP.y, limiter.u) annotation(
    Line(points = {{145, 135}, {156, 135}}, color = {0, 0, 127}));
  connect(limiter.y, integrator2.u) annotation(
    Line(points = {{179, 135}, {190, 135}, {190, 120}, {197, 120}}, color = {0, 0, 127}));
  connect(QRefPu, addQ.u1) annotation(
    Line(points = {{-210, 11}, {-78, 11}}, color = {0, 0, 127}));
  connect(lagQ.y, addQ.u2) annotation(
    Line(points = {{-159, -10}, {-136, -10}, {-136, 3}, {-78, 3}}, color = {0, 0, 127}));
  connect(QAuxPu, addQ.u3) annotation(
    Line(points = {{-210, -35}, {-127, -35}, {-127, -5}, {-78, -5}}, color = {0, 0, 127}));
  connect(addQ.y, gainK2.u) annotation(
    Line(points = {{-55, 3}, {-37, 3}, {-37, 4}}, color = {0, 0, 127}));
  connect(PAuxPu, addP.u1) annotation(
    Line(points = {{-210, 113}, {-73, 113}}, color = {0, 0, 127}));
  connect(PRefPu, addP.u2) annotation(
    Line(points = {{-210, 98}, {-140, 98}, {-140, 105}, {-73, 105}}, color = {0, 0, 127}));
  connect(lagP.y, addP.u3) annotation(
    Line(points = {{-159, 70}, {-129, 70}, {-129, 97}, {-73, 97}}, color = {0, 0, 127}));
  connect(addP.y, gainK1.u) annotation(
    Line(points = {{-50, 105}, {-26, 105}}, color = {0, 0, 127}));
  connect(addMinusOmega0.y, gainKd.u) annotation(
    Line(points = {{-129, 145}, {-36, 145}, {-36, 137}, {-25, 137}}, color = {0, 0, 127}));
  connect(omegaFlag.y, multiSwitchQOutput.f) annotation(
    Line(points = {{175, -7}, {175, -14}}, color = {255, 127, 0}));
  connect(URefPu2.y, multiSwitchQOutput.u[1]) annotation(
    Line(points = {{161, -37}, {161, -26}, {165, -26}}, color = {0, 0, 127}));
  connect(integrator1.y, multiSwitchQOutput.u[2]) annotation(
    Line(points = {{96, -2}, {142, -2}, {142, -26}, {165, -26}}, color = {0, 0, 127}));
  connect(integrator1.y, multiSwitchQOutput.u[3]) annotation(
    Line(points = {{96, -2}, {142, -2}, {142, -26}, {165, -26}}, color = {0, 0, 127}));
  connect(integrator1.y, multiSwitchQOutput.u[4]) annotation(
    Line(points = {{96, -2}, {142, -2}, {142, -26}, {165, -26}}, color = {0, 0, 127}));
  connect(omegaPLLPu, addMinusOmega0.u1) annotation(
    Line(points = {{-210, 164}, {-157, 164}, {-157, 151}, {-152, 151}}, color = {0, 0, 127}));
  connect(const.y, multiSwitchQ1.u[1]) annotation(
    Line(points = {{-95, -33}, {-68, -33}}, color = {0, 0, 127}));
  connect(constant1.y, multiSwitchQ1.u[2]) annotation(
    Line(points = {{-94, -63}, {-89, -63}, {-89, -33}, {-68, -33}}, color = {0, 0, 127}));
  connect(constant1.y, multiSwitchQ1.u[3]) annotation(
    Line(points = {{-94, -63}, {-89, -63}, {-89, -33}, {-68, -33}}, color = {0, 0, 127}));
  connect(gainK2dvoc.y, multiSwitchQ1.u[4]) annotation(
    Line(points = {{-68, -61}, {-77, -61}, {-77, -33}, {-68, -33}}, color = {0, 0, 127}));
  connect(URefPu, add5.u2) annotation(
    Line(points = {{-207, -115}, {-147, -115}, {-147, -167}, {-127, -167}}, color = {0, 0, 127}));
  connect(constant3.y, multiSwitchQ2.u[1]) annotation(
    Line(points = {{-56, -222}, {-56, -184}, {-28, -184}}, color = {0, 0, 127}));
  connect(constant2.y, multiSwitchQ2.u[2]) annotation(
    Line(points = {{-88, -221}, {-87, -221}, {-87, -184}, {-28, -184}}, color = {0, 0, 127}));
  connect(constant2.y, multiSwitchQ2.u[3]) annotation(
    Line(points = {{-88, -221}, {-87, -221}, {-87, -184}, {-28, -184}}, color = {0, 0, 127}));
  connect(add5.y, multiSwitchQ2.u[4]) annotation(
    Line(points = {{-104, -173}, {-41, -173}, {-41, -184}, {-28, -184}}, color = {0, 0, 127}));
  connect(multiSwitchQ2.y, product1.u2) annotation(
    Line(points = {{-7, -184}, {4, -184}, {4, -148}, {-70, -148}, {-70, -126}, {-60, -126}}, color = {0, 0, 127}));
  connect(udFilterRefPu2.y, add5.u1) annotation(
    Line(points = {{-148, -178}, {-127, -178}, {-127, -179}}, color = {0, 0, 127}));
  connect(udFilterRefPu3.y, feedback4.u2) annotation(
    Line(points = {{-97, -132}, {-86, -132}, {-86, -122}}, color = {0, 0, 127}));
  connect(integrator2.y, gainMinusOne.u) annotation(
    Line(points = {{220, 120}, {228, 120}, {228, 121}}, color = {0, 0, 127}));
  connect(gainMinusOne.y, theta) annotation(
    Line(points = {{243, 121}, {260, 121}, {260, 120}}, color = {0, 0, 127}));
  connect(multiSwitchQOutput.y, udFilterRefPu) annotation(
    Line(points = {{186, -26}, {223, -26}, {223, -25}, {260, -25}}, color = {0, 0, 127}));
  connect(addOmegaBasePu.u2, limiter.y) annotation(
    Line(points = {{213, 150}, {189, 150}, {189, 135}, {179, 135}}, color = {0, 0, 127}));
  connect(addOmegaBasePu.y, omegaPu) annotation(
    Line(points = {{236, 156}, {260, 156}, {260, 141}}, color = {0, 0, 127}));
  connect(constant4.y, addOmegaBasePu.u1) annotation(
    Line(points = {{191, 174}, {213, 174}, {213, 162}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Rectangle(extent = {{-99, 100}, {99, -100}}), Text(origin = {-0.5, 4}, extent = {{-73.5, 50}, {73.5, -50}}, textString = "GFM")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-200, -250}, {250, 200}})));
end GFM;
