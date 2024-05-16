within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model St5c "IEEE excitation system type ST5C model"

  //Regulation parameters
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kr "Gain of voltage after overexcitation and underexcitation limitations";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input";
  parameter Types.Time t1 "Inverse timing current constant in s";
  parameter Types.Time tB1 "Second lag time constant in s";
  parameter Types.Time tB2 "First lag time constant in s";
  parameter Types.Time tC1 "Second lead time constant in s";
  parameter Types.Time tC2 "First lead time constant in s";
  parameter Types.Time tOB1 "Second lag time constant (overexcitation limitation) in s";
  parameter Types.Time tOB2 "First lag time constant (overexcitation limitation) in s";
  parameter Types.Time tOC1 "Second lead time constant (overexcitation limitation) in s";
  parameter Types.Time tOC2 "First lead time constant (overexcitation limitation) in s";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.Time tUB1 "Second lag time constant (underexcitation limitation) in s";
  parameter Types.Time tUB2 "First lag time constant (underexcitation limitation) in s";
  parameter Types.Time tUC1 "Second lead time constant (underexcitation limitation) in s";
  parameter Types.Time tUC2 "First lead time constant (underexcitation limitation) in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-440, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {430, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-370, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tB2, 1}, b = {tC2, 1}, x_scaled(start = {Vr0Pu}), x_start = {Vr0Pu}, y(start = Vr0Pu)) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {230, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {280, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {390, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = VrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {330, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {330, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 4) annotation(
    Placement(visible = true, transformation(origin = {-270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-150, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = t1, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VrMaxPu, uMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain6(k = Kr) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag(t1 = tC1, t2 = tB1, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag1(t1 = tUC1, t2 = tUB1, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = {tUB2, 1}, b = {tUC2, 1}, x_scaled(start = {Vr0Pu}), x_start = {Vr0Pu}, y(start = Vr0Pu)) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction2(a = {tOB2, 1}, b = {tOC2, 1}, x_scaled(start = {Vr0Pu}), x_start = {Vr0Pu}, y(start = Vr0Pu)) annotation(
    Placement(visible = true, transformation(origin = {10, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag2(t1 = tOC1, t2 = tOB1, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Us0Pu + Vr0Pu / Kr "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Vr0Pu = Efd0Pu + Kc * Ir0Pu "Initial field voltage in pu (user-selected base voltage)";

equation
  if PositionOel == 1 then
    sum1.u[2] = UOelPu;
    min1.u[2] = min1.u[1];
  elseif PositionOel == 2 then
    sum1.u[2] = 0;
    min1.u[2] = UOelPu;
  else
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
  end if;

  if PositionUel == 1 then
    sum1.u[3] = UUelPu;
    max1.u[2] = max1.u[1];
  elseif PositionUel == 2 then
    sum1.u[3] = 0;
    max1.u[2] = UUelPu;
  else
    sum1.u[3] = 0;
    max1.u[2] = max1.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[4] = USclOelPu + USclUelPu;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
  elseif PositionScl == 2 then
    sum1.u[4] = 0;
    max1.u[3] = USclUelPu;
    min1.u[3] = USclOelPu;
  else
    sum1.u[4] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
  end if;

  if PositionOel == 2 and min1.yMin < sum1.y then
    limiter.u = limitedLeadLag2.y;
  elseif PositionUel == 2 and max1.yMax > sum1.y then
    limiter.u = limitedLeadLag1.y;
  else
    limiter.u = limitedLeadLag.y;
  end if;

  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-440, -20}, {-382, -20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{241, 200}, {280, 200}, {280, 8}}, color = {0, 0, 127}));
  connect(UsPu, gain2.u) annotation(
    Line(points = {{-440, -20}, {-400, -20}, {-400, -120}, {318, -120}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UsPu, gain1.u) annotation(
    Line(points = {{-440, -20}, {-400, -20}, {-400, 120}, {318, 120}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain2.y, variableLimiter.limit2) annotation(
    Line(points = {{341, -120}, {360, -120}, {360, -8}, {378, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, EfdPu) annotation(
    Line(points = {{401, 0}, {430, 0}}, color = {0, 0, 127}));
  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{-199, 6}, {-160, 6}}, color = {0, 0, 127}));
  connect(add3.y, sum1.u[1]) annotation(
    Line(points = {{-299, 0}, {-282, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u1) annotation(
    Line(points = {{-440, 20}, {-340, 20}, {-340, 6}, {-322, 6}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u2) annotation(
    Line(points = {{-358, -20}, {-340, -20}, {-340, -6}, {-322, -6}}, color = {0, 0, 127}));
  connect(UPssPu, add1.u1) annotation(
    Line(points = {{-440, 60}, {-120, 60}, {-120, 26}, {-102, 26}}, color = {0, 0, 127}));
  connect(min1.yMin, add1.u2) annotation(
    Line(points = {{-139, 0}, {-120, 0}, {-120, 14}, {-102, 14}}, color = {0, 0, 127}));
  connect(limiter.y, feedback1.u1) annotation(
    Line(points = {{241, 0}, {272, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, firstOrder1.u) annotation(
    Line(points = {{289, 0}, {318, 0}}, color = {0, 0, 127}));
  connect(add1.y, gain6.u) annotation(
    Line(points = {{-79, 20}, {-62, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, variableLimiter.u) annotation(
    Line(points = {{342, 0}, {378, 0}}, color = {0, 0, 127}));
  connect(sum1.y, max1.u[1]) annotation(
    Line(points = {{-258, 0}, {-220, 0}}, color = {0, 0, 127}));
  connect(gain6.y, transferFunction.u) annotation(
    Line(points = {{-38, 20}, {-20, 20}, {-20, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(gain6.y, transferFunction1.u) annotation(
    Line(points = {{-38, 20}, {-20, 20}, {-20, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(gain6.y, transferFunction2.u) annotation(
    Line(points = {{-38, 20}, {-20, 20}, {-20, -80}, {-2, -80}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedLeadLag.u) annotation(
    Line(points = {{21, 80}, {37, 80}}, color = {0, 0, 127}));
  connect(transferFunction1.y, limitedLeadLag1.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(transferFunction2.y, limitedLeadLag2.u) annotation(
    Line(points = {{21, -80}, {37, -80}}, color = {0, 0, 127}));
  connect(gain1.y, variableLimiter.limit1) annotation(
    Line(points = {{341, 120}, {360, 120}, {360, 8}, {378, 8}}, color = {0, 0, 127}));
  connect(IrPu, gain.u) annotation(
    Line(points = {{-440, 200}, {218, 200}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-420, -220}, {420, 220}})));
end St5c;
