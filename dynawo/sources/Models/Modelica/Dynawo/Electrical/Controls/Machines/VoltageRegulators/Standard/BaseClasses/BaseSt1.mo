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

partial model BaseSt1 "IEEE excitation system type ST1 base model"

  //Regulation parameters
  parameter Types.CurrentModulePu IlrPu "Exciter output current limit reference in pu (base SNom, user-selected base voltage)";
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kf "Exciter rate feedback gain";
  parameter Types.PerUnit Klr "Gain of field current limiter";
  parameter Integer PositionPss "Input location : (0) none, (1) voltage error summation, (2) summation at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.Time tB "Voltage regulator lag time constant in s";
  parameter Types.Time tB1 "Voltage regulator second lag time constant in s";
  parameter Types.Time tC "Voltage regulator lead time constant in s";
  parameter Types.Time tC1 "Voltage regulator second lead time constant in s";
  parameter Types.Time tF "Exciter rate feedback time constant in s";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu ViMaxPu "Maximum input voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu ViMinPu "Minimum input voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-440, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {430, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-370, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {tB, 1}, b = {tC, 1}, x_start = {Efd0Pu / Ka}, y_start = Efd0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = Ka, Y0 = Efd0Pu, YMax = VaMaxPu, YMin = VaMinPu, tFilter = tA) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(k = Kf, T = tF, x_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tB1, 1}, b = {tC1, 1}, x_start = {Efd0Pu / Ka}, y_start = Efd0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = ViMaxPu, uMin = ViMinPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-310, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = IlrPu) annotation(
    Placement(visible = true, transformation(origin = {-370, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Klr) annotation(
    Placement(visible = true, transformation(origin = {90, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {390, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = VrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {250, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {250, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -Kc) annotation(
    Placement(visible = true, transformation(origin = {310, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 4) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo3 min2 annotation(
    Placement(visible = true, transformation(origin = {310, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MaxDynawo max3 annotation(
    Placement(visible = true, transformation(origin = {-90, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-150, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu "Underexcitation limitation initial output voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Efd0Pu / Ka + Us0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  if PositionPss == 1 then
    add3.u1 = UPssPu;
    add1.u1 = 0;
  elseif PositionPss == 2 then
    add3.u1 = 0;
    add1.u1 = UPssPu;
  else
    add3.u1 = 0;
    add1.u1 = 0;
  end if;

  if PositionUel == 1 then
    sum1.u[3] = UUelPu;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  elseif PositionUel == 2 then
    sum1.u[3] = 0;
    max1.u[2] = UUelPu;
    max2.u[2] = max2.u[1];
  elseif PositionUel == 3 then
    sum1.u[3] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = UUelPu;
  else
    sum1.u[3] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  end if;

  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-440, -40}, {-382, -40}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(IrPu, add.u1) annotation(
    Line(points = {{-440, 200}, {-340, 200}, {-340, 166}, {-322, 166}}, color = {0, 0, 127}));
  connect(const.y, add.u2) annotation(
    Line(points = {{-359, 140}, {-340, 140}, {-340, 154}, {-323, 154}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{101, 140}, {140, 140}, {140, 8}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, feedback1.u1) annotation(
    Line(points = {{101, 0}, {132, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.y, transferFunction.u) annotation(
    Line(points = {{21, 0}, {37, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedFirstOrder.u) annotation(
    Line(points = {{61, 0}, {77, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u2) annotation(
    Line(points = {{-440, 0}, {-322, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u3) annotation(
    Line(points = {{-359, -40}, {-340, -40}, {-340, -8}, {-323, -8}}, color = {0, 0, 127}));
  connect(derivative.y, feedback.u2) annotation(
    Line(points = {{-161, -40}, {-200, -40}, {-200, -8}}, color = {0, 0, 127}));
  connect(feedback.y, limiter.u) annotation(
    Line(points = {{-191, 0}, {-163, 0}}, color = {0, 0, 127}));
  connect(UsPu, gain2.u) annotation(
    Line(points = {{-440, -40}, {-400, -40}, {-400, -80}, {238, -80}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UsPu, gain1.u) annotation(
    Line(points = {{-440, -40}, {-400, -40}, {-400, 100}, {238, 100}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain1.y, add2.u2) annotation(
    Line(points = {{261, 100}, {280, 100}, {280, 114}, {298, 114}}, color = {0, 0, 127}));
  connect(IrPu, add2.u1) annotation(
    Line(points = {{-440, 200}, {280, 200}, {280, 126}, {298, 126}}, color = {0, 0, 127}));
  connect(add2.y, variableLimiter.limit1) annotation(
    Line(points = {{321, 120}, {360, 120}, {360, 8}, {378, 8}}, color = {0, 0, 127}));
  connect(gain2.y, variableLimiter.limit2) annotation(
    Line(points = {{261, -80}, {360, -80}, {360, -8}, {378, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, EfdPu) annotation(
    Line(points = {{401, 0}, {429, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, add1.u2) annotation(
    Line(points = {{149, 0}, {160, 0}, {160, 14}, {177, 14}}, color = {0, 0, 127}));
  connect(add3.y, sum1.u[1]) annotation(
    Line(points = {{-299, 0}, {-262, 0}}, color = {0, 0, 127}));
  connect(sum1.y, feedback.u1) annotation(
    Line(points = {{-239, 0}, {-209, 0}}, color = {0, 0, 127}));
  connect(limiter.y, max1.u[1]) annotation(
    Line(points = {{-139, 0}, {-101, 0}}, color = {0, 0, 127}));
  connect(max2.yMax, min2.u[1]) annotation(
    Line(points = {{262, 6}, {300, 6}}, color = {0, 0, 127}));
  connect(min2.yMin, derivative.u) annotation(
    Line(points = {{322, 0}, {340, 0}, {340, -40}, {-138, -40}}, color = {0, 0, 127}));
  connect(add1.y, max2.u[1]) annotation(
    Line(points = {{202, 20}, {220, 20}, {220, 0}, {240, 0}}, color = {0, 0, 127}));
  connect(min2.yMin, variableLimiter.u) annotation(
    Line(points = {{322, 0}, {378, 0}}, color = {0, 0, 127}));
  connect(add.y, max3.u1) annotation(
    Line(points = {{-298, 160}, {-120, 160}, {-120, 146}, {-102, 146}}, color = {0, 0, 127}));
  connect(const1.y, max3.u2) annotation(
    Line(points = {{-138, 120}, {-120, 120}, {-120, 134}, {-102, 134}}, color = {0, 0, 127}));
  connect(max3.y, gain.u) annotation(
    Line(points = {{-78, 140}, {78, 140}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-420, -220}, {420, 220}})));
end BaseSt1;
