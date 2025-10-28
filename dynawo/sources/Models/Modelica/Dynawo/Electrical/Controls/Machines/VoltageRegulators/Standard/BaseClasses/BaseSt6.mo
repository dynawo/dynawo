within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseSt6 "IEEE exciter type ST6 base model"

  //Regulation parameters
  parameter Types.CurrentModulePu IlrPu "Exciter output current limit reference in pu (base SNom, user-selected base voltage)";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kcl "Field current limiter conversion factor";
  parameter Types.PerUnit Kff "Feedforward gain of inner loop field regulator";
  parameter Types.PerUnit Kg "Feedback gain constant of inner loop field regulator";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kia "Integral gain of PI";
  parameter Types.PerUnit Klr "Gain of field current limiter";
  parameter Types.PerUnit Km "Gain of error of inner loop field regulator";
  parameter Types.PerUnit Kp "Potential circuit gain";
  parameter Types.PerUnit Kpa "Proportional gain of PI";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) AVR input summation, (4) take-over at AVR output";
  parameter Types.Time tG "Feedback time constant of inner loop field regulator in s";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of PI in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of PI in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of regulator in pu (user-selected base voltage)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-460, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.BooleanInput running(start = true) "Running value of generator" annotation(
    Placement(visible = true,transformation(origin = {-460, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, -200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = Us0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {430, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedDivision division(YMax = 1, YMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Min2 min5 annotation(
    Placement(visible = true, transformation(origin = {-10, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-70, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {-130, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupVariableLimits limPI1(Ki = Kia, Kp = Kpa, Y0 = Va0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-410, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {370, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-230, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-350, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = Kff, k2 = Km) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VrMaxPu, uMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Min2 min4 annotation(
    Placement(visible = true, transformation(origin = {270, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tG, k = Kg, y_start = Kg * Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {310, -200}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-370, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-280, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = IlrPu * Kcl) annotation(
    Placement(visible = true, transformation(origin = {-330, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Klr) annotation(
    Placement(visible = true, transformation(origin = {-230, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Max2 max3 annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-230, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = VaMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = VaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 4) annotation(
    Placement(visible = true, transformation(origin = {-290, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum2(nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameter (calculated by initialization model)
  parameter Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu Va0Pu = Efd0Pu * (Kg * Km + 1 / Vb0Pu) / (Km + Kff) "Initial output voltage of PI in pu (user-selected base voltage)";

equation
  connect(const.y, min5.u1) annotation(
    Line(points = {{-59, 200}, {-40, 200}, {-40, 166}, {-22, 166}}, color = {0, 0, 127}));
  connect(product1.y, min5.u2) annotation(
    Line(points = {{-59, 140}, {-40, 140}, {-40, 154}, {-22, 154}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{-159, 160}, {-142, 160}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-460, -80}, {-422, -80}}, color = {0, 0, 127}));
  connect(product.y, EfdPu) annotation(
    Line(points = {{381, 0}, {430, 0}}, color = {0, 0, 127}));
  connect(gain1.y, division.u1) annotation(
    Line(points = {{-219, 200}, {-200, 200}, {-200, 166}, {-182, 166}}, color = {0, 0, 127}));
  connect(IrPu, gain1.u) annotation(
    Line(points = {{-460, 200}, {-242, 200}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(limPI1.y, feedback.u1) annotation(
    Line(points = {{-39, -100}, {-8, -100}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product1.u1) annotation(
    Line(points = {{-119, 160}, {-100, 160}, {-100, 146}, {-82, 146}}, color = {0, 0, 127}));
  connect(UsRefPu, add.u1) annotation(
    Line(points = {{-460, -40}, {-380, -40}, {-380, -54}, {-362, -54}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-399, -80}, {-380, -80}, {-380, -66}, {-362, -66}}, color = {0, 0, 127}));
  connect(limPI1.y, add2.u1) annotation(
    Line(points = {{-39, -100}, {-20, -100}, {-20, -74}, {38, -74}}, color = {0, 0, 127}));
  connect(feedback.y, add2.u2) annotation(
    Line(points = {{9, -100}, {20, -100}, {20, -86}, {38, -86}}, color = {0, 0, 127}));
  connect(add2.y, limiter.u) annotation(
    Line(points = {{61, -80}, {78, -80}}, color = {0, 0, 127}));
  connect(product.y, firstOrder1.u) annotation(
    Line(points = {{381, 0}, {400, 0}, {400, -200}, {322, -200}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback.u2) annotation(
    Line(points = {{299, -200}, {0, -200}, {0, -108}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-460, 160}, {-400, 160}, {-400, 146}, {-382, 146}}, color = {85, 170, 255}));
  connect(itPu, potentialCircuit.iT) annotation(
    Line(points = {{-460, 120}, {-400, 120}, {-400, 134}, {-382, 134}}, color = {85, 170, 255}));
  connect(min5.y, product.u1) annotation(
    Line(points = {{1, 160}, {340, 160}, {340, 6}, {358, 6}}, color = {0, 0, 127}));
  connect(IrPu, feedback1.u2) annotation(
    Line(points = {{-460, 200}, {-280, 200}, {-280, 28}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(const1.y, feedback1.u1) annotation(
    Line(points = {{-319, 20}, {-288, 20}}, color = {0, 0, 127}));
  connect(max3.y, min4.u1) annotation(
    Line(points = {{-159, 40}, {240, 40}, {240, -14}, {258, -14}}, color = {0, 0, 127}));
  connect(const4.y, limPI1.limitMin) annotation(
    Line(points = {{-99, -200}, {-80, -200}, {-80, -106}, {-62, -106}}, color = {0, 0, 127}));
  connect(UPssPu, sum2.u[2]) annotation(
    Line(points = {{-460, -200}, {-140, -200}, {-140, -100}, {-122, -100}}, color = {0, 0, 127}));
  connect(sum2.y, limPI1.u) annotation(
    Line(points = {{-99, -100}, {-63, -100}}, color = {0, 0, 127}));
  connect(add.y, sum1.u[1]) annotation(
    Line(points = {{-338, -60}, {-302, -60}}, color = {0, 0, 127}));
  connect(const2.y, max3.u1) annotation(
    Line(points = {{-219, 60}, {-200, 60}, {-200, 46}, {-183, 46}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-270, 20}, {-242, 20}}, color = {0, 0, 127}));
  connect(gain.y, max3.u2) annotation(
    Line(points = {{-219, 20}, {-200, 20}, {-200, 34}, {-183, 34}}, color = {0, 0, 127}));
  connect(running, potentialCircuit.running) annotation(
    Line(points = {{-460, 80}, {-420, 80}, {-420, 140}, {-382, 140}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-440, -220}, {420, 220}})));
end BaseSt6;
