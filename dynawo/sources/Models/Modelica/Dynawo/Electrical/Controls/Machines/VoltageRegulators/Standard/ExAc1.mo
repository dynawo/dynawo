within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model ExAc1 "IEEE exciter type EXAC1 model, defined in IEEE 1981 Excitation System Models for Power System Stability Studies"

  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Kc "Rectifier load factor";
  parameter Types.PerUnit Kd "Exciter demagnetizing factor";
  parameter Types.PerUnit Ke "Exciter field gain";
  parameter Types.PerUnit Kf "Exciter rate feedback gain";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.Time tB "Voltage regulator lead time constant in s";
  parameter Types.Time tC "Voltage regulator lag time constant in s";
  parameter Types.Time tE "Exciter time constant in s";
  parameter Types.Time tF "Exciter rate feedback time constant in s";
  parameter Types.Time tR "Stator voltage time constant in s";
  parameter Real UHigh = 0.75 "Upper limit of non-linear mode of rectifier characteristic";
  parameter Real ULow = 0.433 "Lower limit of non-linear mode of rectifier characteristic";
  parameter Types.VoltageModulePu VExcHighPu "Higher abscissa of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VExcLowPu "Lower abscissa of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VExcSatHighPu "Higher ordinate of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VExcSatLowPu "Lower ordinate of saturation characteristic in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";

  final parameter Real A1 = (1 - sqrt(UHigh - ULow ^ 2)) / ULow "Rectifier characteristic coefficient of first linear mode";
  final parameter Real A2 = sqrt(UHigh / (1 - UHigh)) "Rectifier characteristic coefficient of second linear mode";
  final parameter Types.PerUnit Bsq = if VExcHighPu > VExcThresholdPu then VExcHighPu * VExcSatHighPu / (VExcHighPu - VExcThresholdPu) ^ 2 else 0 "Proportional coefficient of saturation characteristic";
  final parameter Types.PerUnit Sq = if (VExcHighPu > 0 and VExcSatHighPu > 0) then sqrt(VExcLowPu * VExcSatLowPu / (VExcHighPu * VExcSatHighPu)) else 0 "Ratio of staturation characteristic";
  final parameter Types.VoltageModulePu VExcThresholdPu = (VExcLowPu - VExcHighPu * Sq) / (1 - Sq) "Input voltage below which saturation function output is zero, in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-300, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction leadLag(a = {tB, 1}, b = {tC, 1}, initType = Modelica.Blocks.Types.Init.SteadyState, u_start = Vr0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = Ke, k3 = Kd) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {150, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {90, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.SatChar satChar(Asq = VExcThresholdPu, Bsq = Bsq, Sq = Sq, UHigh = VExcHighPu, ULow = VExcLowPu, YHigh = VExcSatHighPu, YLow = VExcSatLowPu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Max2 max1 annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(k = {1, 1, 1, 1, -1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-190, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-140, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = Ka, tFilter = tA, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(k = Kf, T = tF, x_start = Vr0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tE, y_start = VExc0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {190, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Real Ua0 = Kc / (1 + A1 * Kc) "Estimated initial input for first linear mode of rectifier characteristic";
  final parameter Real Ub0 = Kc * sqrt(UHigh / (1 + Kc ^ 2)) "Estimated initial input for quadratic mode of rectifier characteristic";
  final parameter Real Uc0 = Kc * A2 / (1 + A2 * Kc) "Estimated initial input for second linear mode of rectifier characteristic";
  final parameter Types.VoltageModulePu UsRef0Pu = Vr0Pu / Ka + Us0Pu "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu VExc0Pu = Efd0Pu / Y0 "Output voltage of integrator in pu (user-selected base voltage)";
  final parameter Types.VoltageModulePu Vr0Pu = (if VExc0Pu > VExcThresholdPu then Bsq * (VExc0Pu - VExcThresholdPu) ^ 2 else 0) + Ke * VExc0Pu + Kd * Ir0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  final parameter Real Y0 = if Ua0 <= 0 then 1 elseif Ua0 <= ULow then 1 - A1 * Ua0 elseif Uc0 >= 1 then 0 elseif Uc0 >= UHigh then A2 * (1 - Uc0) else sqrt(UHigh - Ub0 ^ 2) "Estimated initial output of rectifier characteristic";

equation
  connect(IrPu, gain1.u) annotation(
    Line(points = {{-300, -120}, {78, -120}}, color = {0, 0, 127}));
  connect(limiter.y, product1.u1) annotation(
    Line(points = {{101, 80}, {220, 80}, {220, 6}, {238, 6}}, color = {0, 0, 127}));
  connect(limiter.y, max1.u1) annotation(
    Line(points = {{101, 80}, {120, 80}, {120, 0}, {60, 0}, {60, -54}, {78, -54}}, color = {0, 0, 127}));
  connect(feedback.y, leadLag.u) annotation(
    Line(points = {{-131, 80}, {-102, 80}}, color = {0, 0, 127}));
  connect(leadLag.y, limitedFirstOrder.u) annotation(
    Line(points = {{-79, 80}, {-63, 80}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, feedback1.u1) annotation(
    Line(points = {{-39, 80}, {-9, 80}}, color = {0, 0, 127}));
  connect(add3.y, derivative.u) annotation(
    Line(points = {{-41, -40}, {-78, -40}}, color = {0, 0, 127}));
  connect(derivative.y, feedback.u2) annotation(
    Line(points = {{-101, -40}, {-140, -40}, {-140, 72}}, color = {0, 0, 127}));
  connect(IrPu, add3.u3) annotation(
    Line(points = {{-300, -120}, {0, -120}, {0, -48}, {-18, -48}}, color = {0, 0, 127}));
  connect(add3.y, feedback1.u2) annotation(
    Line(points = {{-41, -40}, {-60, -40}, {-60, 40}, {0, 40}, {0, 72}}, color = {0, 0, 127}));
  connect(feedback1.y, integrator.u) annotation(
    Line(points = {{9, 80}, {37, 80}}, color = {0, 0, 127}));
  connect(integrator.y, limiter.u) annotation(
    Line(points = {{61, 80}, {77, 80}}, color = {0, 0, 127}));
  connect(gain1.y, division.u1) annotation(
    Line(points = {{101, -120}, {120, -120}, {120, -106}, {138, -106}}, color = {0, 0, 127}));
  connect(const.y, max1.u2) annotation(
    Line(points = {{41, -80}, {60, -80}, {60, -66}, {78, -66}}, color = {0, 0, 127}));
  connect(max1.y, division.u2) annotation(
    Line(points = {{101, -60}, {120, -60}, {120, -94}, {138, -94}}, color = {0, 0, 127}));
  connect(limiter.y, satChar.u) annotation(
    Line(points = {{101, 80}, {120, 80}, {120, 0}, {41, 0}}, color = {0, 0, 127}));
  connect(limiter.y, add3.u2) annotation(
    Line(points = {{101, 80}, {120, 80}, {120, 0}, {60, 0}, {60, -40}, {-19, -40}}, color = {0, 0, 127}));
  connect(satChar.y, add3.u1) annotation(
    Line(points = {{19, 0}, {0, 0}, {0, -32}, {-19, -32}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{161, -100}, {177, -100}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product1.u2) annotation(
    Line(points = {{201, -100}, {220, -100}, {220, -6}, {237, -6}}, color = {0, 0, 127}));
  connect(UOelPu, sum1.u[1]) annotation(
    Line(points = {{-300, 80}, {-202, 80}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-300, 40}, {-220, 40}, {-220, 80}, {-202, 80}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-300, 0}, {-220, 0}, {-220, 80}, {-202, 80}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-300, -40}, {-220, -40}, {-220, 80}, {-202, 80}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-300, -80}, {-262, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[5]) annotation(
    Line(points = {{-238, -80}, {-220, -80}, {-220, 80}, {-202, 80}}, color = {0, 0, 127}));
  connect(sum1.y, feedback.u1) annotation(
    Line(points = {{-178, 80}, {-148, 80}}, color = {0, 0, 127}));
  connect(product1.y, EfdPu) annotation(
    Line(points = {{262, 0}, {290, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-280, -140}, {280, 140}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 0}, extent = {{-100, 100}, {100, -100}}, textString = "EXAC1")}));
end ExAc1;
