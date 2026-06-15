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

model GFM "Grid forming control block"
  extends Parameters.Gfm;
  extends Parameters.OmegaFlag;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = SystemBase.omega0Pu) "PLL measured frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency of the system in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Active power auxiliary control signal in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = PGen0Pu) "Active power generated at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Active power reference at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-209, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QAuxPu(start = 0) "Reactive power auxiliary control signal in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = QGen0Pu) "Reactive power generated at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QGen0Pu) "Reactive power reference at the converter's terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "voltage setpoint in pu (base UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {260, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {260, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdFilter0Pu) "D-axis voltage reference at the converter terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {260, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {-150, -180}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add addMinusOmega0(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-60, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addOmega annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addOmegaBasePu annotation(
    Placement(visible = true, transformation(origin = {220, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addP(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-60, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addQ(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-129, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-130, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-170, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constant3(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constant4(k = 1) annotation(
    Placement(visible = true, transformation(origin = {180, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOmega0(k = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant constOmegaFlag(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-110, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainK1(k = K1) annotation(
    Placement(visible = true, transformation(origin = {-20, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainK2(k = K2) annotation(
    Placement(visible = true, transformation(origin = {-20, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainK2dvoc(k = K2Dvoc) annotation(
    Placement(visible = true, transformation(origin = {-20, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gainKd(k = KD) annotation(
    Placement(visible = true, transformation(origin = {-21, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(initType = Modelica.Blocks.Types.Init.InitialState, k = 1 / tV, y_start = URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator2(k = SystemBase.omegaNom, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {220, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagOmega(T = tF, k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagP(T = tR, k = 1, y_start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagQ(T = tR, k = 1, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = DeltaOmegaMaxPu, uMin = DeltaOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {181, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchP(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {140, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ1(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ2(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-100, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQOutput(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-60, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression URefPu2(y = URefPu) annotation(
    Placement(visible = true, transformation(origin = {100, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant5(k = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-140, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add omegaSetPu(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-60, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ActivePowerPu PGen0Pu "Start value of the active power at the converter's terminal in pu (base SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu QGen0Pu "Start value of the reactive power at the converter's terminal in pu (base SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initial"));
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage reference at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  connect(QPu, lagQ.u) annotation(
    Line(points = {{-210, 10}, {-182, 10}}, color = {0, 0, 127}));
  connect(PPu, lagP.u) annotation(
    Line(points = {{-210, 120}, {-182, 120}}, color = {0, 0, 127}));
  connect(gainK2.y, add2.u1) annotation(
    Line(points = {{-9, 10}, {29.5, 10}, {29.5, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(product.y, add2.u2) annotation(
    Line(points = {{-9, -60}, {30, -60}, {30, -5.5}, {38, -5.5}, {38, -6}}, color = {0, 0, 127}));
  connect(product1.y, product.u2) annotation(
    Line(points = {{-49, -120}, {-40, -120}, {-40, -66}, {-32, -66}}, color = {0, 0, 127}));
  connect(feedback4.y, product1.u1) annotation(
    Line(points = {{-101, -110}, {-80.5, -110}, {-80.5, -114}, {-72, -114}}, color = {0, 0, 127}));
  connect(URefPu, feedback4.u1) annotation(
    Line(points = {{-210, -110}, {-118, -110}}, color = {0, 0, 127}));
  connect(add2.y, integrator1.u) annotation(
    Line(points = {{61, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(multiSwitchQ1.y, product.u1) annotation(
    Line(points = {{-49, -40}, {-43.5, -40}, {-43.5, -54}, {-32, -54}}, color = {0, 0, 127}));
  connect(constOmega0.y, addMinusOmega0.u2) annotation(
    Line(points = {{-159, 180}, {-100.5, 180}, {-100.5, 204}, {-72, 204}}, color = {0, 0, 127}));
  connect(constOmegaFlag.y, multiSwitchQ1.f) annotation(
    Line(points = {{-179, 60}, {-59.25, 60}, {-59.25, -28}, {-60, -28}}, color = {255, 127, 0}, pattern = LinePattern.Dash));
  connect(gainKd.y, addOmega.u1) annotation(
    Line(points = {{-10, 180}, {30, 180}, {30, 148}, {38, 148}}, color = {0, 0, 127}));
  connect(gainK1.y, addOmega.u2) annotation(
    Line(points = {{-9, 140}, {38, 140}}, color = {0, 0, 127}));
  connect(addOmega.y, lagOmega.u) annotation(
    Line(points = {{61, 140}, {78, 140}}, color = {0, 0, 127}));
  connect(lagOmega.y, multiSwitchP.u[2]) annotation(
    Line(points = {{101, 140}, {130, 140}}, color = {0, 0, 127}));
  connect(lagOmega.y, multiSwitchP.u[3]) annotation(
    Line(points = {{101, 140}, {130, 140}}, color = {0, 0, 127}));
  connect(lagOmega.y, multiSwitchP.u[4]) annotation(
    Line(points = {{101, 140}, {130, 140}}, color = {0, 0, 127}));
  connect(multiSwitchP.y, limiter.u) annotation(
    Line(points = {{151, 140}, {169, 140}}, color = {0, 0, 127}));
  connect(limiter.y, integrator2.u) annotation(
    Line(points = {{192, 140}, {200, 140}, {200, 120}, {208, 120}}, color = {0, 0, 127}));
  connect(QRefPu, addQ.u1) annotation(
    Line(points = {{-210, 30}, {-100, 30}, {-100, 18}, {-72, 18}}, color = {0, 0, 127}));
  connect(lagQ.y, addQ.u2) annotation(
    Line(points = {{-159, 10}, {-72, 10}}, color = {0, 0, 127}));
  connect(QAuxPu, addQ.u3) annotation(
    Line(points = {{-210, -10}, {-100, -10}, {-100, 2}, {-72, 2}}, color = {0, 0, 127}));
  connect(addQ.y, gainK2.u) annotation(
    Line(points = {{-49, 10}, {-32, 10}}, color = {0, 0, 127}));
  connect(PAuxPu, addP.u1) annotation(
    Line(points = {{-210, 160}, {-100, 160}, {-100, 148}, {-72, 148}}, color = {0, 0, 127}));
  connect(PRefPu, addP.u2) annotation(
    Line(points = {{-209, 140}, {-72, 140}}, color = {0, 0, 127}));
  connect(lagP.y, addP.u3) annotation(
    Line(points = {{-159, 120}, {-100, 120}, {-100, 132}, {-72, 132}}, color = {0, 0, 127}));
  connect(addP.y, gainK1.u) annotation(
    Line(points = {{-49, 140}, {-32, 140}}, color = {0, 0, 127}));
  connect(addMinusOmega0.y, gainKd.u) annotation(
    Line(points = {{-49, 210}, {-40, 210}, {-40, 180}, {-33, 180}}, color = {0, 0, 127}));
  connect(omegaPLLPu, addMinusOmega0.u1) annotation(
    Line(points = {{-210, 220}, {-99, 220}, {-99, 216}, {-72, 216}}, color = {0, 0, 127}));
  connect(const.y, multiSwitchQ1.u[1]) annotation(
    Line(points = {{-118, -40}, {-70, -40}}, color = {0, 0, 127}));
  connect(constant1.y, multiSwitchQ1.u[2]) annotation(
    Line(points = {{-119, -70}, {-90, -70}, {-90, -40}, {-70, -40}}, color = {0, 0, 127}));
  connect(constant1.y, multiSwitchQ1.u[3]) annotation(
    Line(points = {{-119, -70}, {-90, -70}, {-90, -40}, {-70, -40}}, color = {0, 0, 127}));
  connect(gainK2dvoc.y, multiSwitchQ1.u[4]) annotation(
    Line(points = {{-31, -90}, {-77, -90}, {-77, -40}, {-70, -40}}, color = {0, 0, 127}));
  connect(URefPu, add5.u2) annotation(
    Line(points = {{-210, -110}, {-181, -110}, {-181, -175}, {-162, -175}, {-162, -174}}, color = {0, 0, 127}));
  connect(multiSwitchQ2.y, product1.u2) annotation(
    Line(points = {{-89, -180}, {-80, -180}, {-80, -126}, {-72, -126}}, color = {0, 0, 127}));
  connect(multiSwitchQOutput.y, udFilterRefPu) annotation(
    Line(points = {{151, 0}, {260, 0}}, color = {0, 0, 127}));
  connect(addOmegaBasePu.y, omegaPu) annotation(
    Line(points = {{231, 170}, {260, 170}}, color = {0, 0, 127}));
  connect(limiter.y, addOmegaBasePu.u2) annotation(
    Line(points = {{192, 140}, {200, 140}, {200, 164}, {208, 164}}, color = {0, 0, 127}));
  connect(constant4.y, addOmegaBasePu.u1) annotation(
    Line(points = {{191, 200}, {200, 200}, {200, 176}, {208, 176}}, color = {0, 0, 127}));
  connect(integrator2.y, theta) annotation(
    Line(points = {{231, 120}, {260, 120}}, color = {0, 0, 127}));
  connect(constant3.y, multiSwitchQ2.u[1]) annotation(
    Line(points = {{-130, -219}, {-130, -180}, {-110, -180}}, color = {0, 0, 127}));
  connect(URefPu2.y, multiSwitchQOutput.u[1]) annotation(
    Line(points = {{111, 30}, {120, 30}, {120, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(integrator1.y, multiSwitchQOutput.u[2]) annotation(
    Line(points = {{101, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(integrator1.y, multiSwitchQOutput.u[3]) annotation(
    Line(points = {{101, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(integrator1.y, multiSwitchQOutput.u[4]) annotation(
    Line(points = {{101, 0}, {130, 0}}, color = {0, 0, 127}));
  connect(constant2.y, multiSwitchQ2.u[2]) annotation(
    Line(points = {{-170, -219}, {-170, -210}, {-130, -210}, {-130, -180}, {-110, -180}}, color = {0, 0, 127}));
  connect(constant2.y, multiSwitchQ2.u[3]) annotation(
    Line(points = {{-170, -219}, {-170, -210}, {-130, -210}, {-130, -180}, {-110, -180}}, color = {0, 0, 127}));
  connect(add5.y, multiSwitchQ2.u[4]) annotation(
    Line(points = {{-139, -180}, {-110, -180}}, color = {0, 0, 127}));
  connect(constOmegaFlag.y, multiSwitchQOutput.f) annotation(
    Line(points = {{-179, 60}, {140, 60}, {140, 12}}, color = {255, 127, 0}));
  connect(constOmegaFlag.y, multiSwitchP.f) annotation(
    Line(points = {{-179, 60}, {140, 60}, {140, 152}}, color = {255, 127, 0}));
  connect(constOmegaFlag.y, multiSwitchQ2.f) annotation(
    Line(points = {{-179, 60}, {-100, 60}, {-100, -168}}, color = {255, 127, 0}, pattern = LinePattern.Dash));
  connect(multiSwitchQOutput.y, gainK2dvoc.u) annotation(
    Line(points = {{151, 0}, {170, 0}, {170, -90}, {-8, -90}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(multiSwitchQOutput.y, feedback4.u2) annotation(
    Line(points = {{151, 0}, {170, 0}, {170, -140}, {-110, -140}, {-110, -118}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(multiSwitchQOutput.y, add5.u1) annotation(
    Line(points = {{151, 0}, {170, 0}, {170, -200}, {-180, -200}, {-180, -186}, {-162, -186}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(constant5.y, omegaSetPu.u2) annotation(
    Line(points = {{-129, 80}, {-99.5, 80}, {-99.5, 94}, {-72, 94}}, color = {0, 0, 127}));
  connect(omegaRefPu, omegaSetPu.u1) annotation(
    Line(points = {{-210, 100}, {-100, 100}, {-100, 106}, {-72, 106}}, color = {0, 0, 127}));
  connect(omegaSetPu.y, addOmega.u3) annotation(
    Line(points = {{-49, 100}, {30, 100}, {30, 132}, {38, 132}}, color = {0, 0, 127}));
  connect(addMinusOmega0.y, multiSwitchP.u[1]) annotation(
    Line(points = {{-49, 210}, {120, 210}, {120, 140}, {130, 140}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-0.5, 4}, extent = {{-73.5, 50}, {73.5, -50}}, textString = "GFM"), Rectangle(extent = {{-100, 100}, {100, -100}})}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-200, -250}, {250, 250}})));
end GFM;
