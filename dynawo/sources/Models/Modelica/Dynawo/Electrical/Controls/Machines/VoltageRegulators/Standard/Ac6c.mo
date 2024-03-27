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

model Ac6c "IEEE excitation system type AC6C model"

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.VoltageModulePu EfeMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfeMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kd "Exciter internal reactance";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.PerUnit Kh "Exciter field current feedback gain";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR output";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR output";
  parameter Types.Time tA "First lag time constant in s";
  parameter Types.Time tB "Second lag time constant in s";
  parameter Types.Time tC "Second lead time constant in s";
  parameter Types.Time tE "Exciter field time constant in s";
  parameter Types.Time tH "Feedback lag time constant in s";
  parameter Types.Time tJ "Feedback lead time constant in s";
  parameter Types.Time tK "First lead time constant in s";
  parameter Types.PerUnit TolLi "Tolerance on limit crossing as a fraction of the difference between initial limits of limited integrator";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMinPu "Minimum exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VfeLimPu "Threshold of field current signal for feedback in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VhMaxPu "Maximum feedback voltage in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-360, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tA, 1}, b = {tK, 1}, x_scaled(start = {Va0Pu}), x_start = {Va0Pu}, y(start = Va0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ka) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag(Y0 = Va0Pu, YMax = VaMaxPu, YMin = VaMinPu, t1 = tC, t2 = tB) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.AcRotatingExciter acRotatingExciter(
    AEx = AEx,
    BEx = BEx,
    Efd0Pu = Efd0Pu,
    Efe0Pu = Efe0Pu,
    Ir0Pu = Ir0Pu,
    Kc = Kc,
    Kd = Kd,
    Ke = Ke,
    tE = tE,
    TolLi = TolLi,
    Ve0Pu = Ve0Pu,
    VeMax0Pu = VeMax0Pu,
    VeMinPu = VeMinPu,
    VfeMaxPu = VfeMaxPu) annotation(
    Placement(visible = true, transformation(origin = {260, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {270, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = VfeLimPu) annotation(
    Placement(visible = true, transformation(origin = {330, -100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kh) annotation(
    Placement(visible = true, transformation(origin = {230, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VhMaxPu, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {190, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = {tH, 1}, b = {tJ, 1}, x_scaled(start = {Vh0Pu}), x_start = {Vh0Pu}, y(start = Vh0Pu)) annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = EfeMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-230, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = EfeMinPu) annotation(
    Placement(visible = true, transformation(origin = {-230, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 4) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {70, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameters (calculated by initialization model)
  parameter Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

  final parameter Types.VoltageModulePu UsRef0Pu = Va0Pu / Ka + Us0Pu "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Va0Pu = Efe0Pu + Vh0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  final parameter Types.VoltageModulePu Vh0Pu = max(0, min(VhMaxPu, Kh * (Efe0Pu - VfeLimPu))) "Initial feedback voltage in pu (user-selected base voltage)";

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
    min1.u[3] = min1.u[1];
    max1.u[3] = max1.u[1];
  elseif PositionScl == 2 then
    sum1.u[4] = 0;
    min1.u[3] = USclOelPu;
    max1.u[3] = USclUelPu;
  else
    sum1.u[4] = 0;
    min1.u[3] = min1.u[1];
    max1.u[3] = max1.u[1];
  end if;

  connect(UPssPu, add3.u1) annotation(
    Line(points = {{-360, 40}, {-260, 40}, {-260, 8}, {-242, 8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-360, 0}, {-302, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u2) annotation(
    Line(points = {{-279, 0}, {-243, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, add3.u3) annotation(
    Line(points = {{-360, -40}, {-260, -40}, {-260, -8}, {-242, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(transferFunction.y, limitedLeadLag.u) annotation(
    Line(points = {{-79, 0}, {-63, 0}}, color = {0, 0, 127}));
  connect(acRotatingExciter.VfePu, add.u1) annotation(
    Line(points = {{282, -16}, {300, -16}, {300, -74}, {282, -74}}, color = {0, 0, 127}));
  connect(const.y, add.u2) annotation(
    Line(points = {{319, -100}, {300, -100}, {300, -86}, {281, -86}}, color = {0, 0, 127}));
  connect(acRotatingExciter.EfdPu, EfdPu) annotation(
    Line(points = {{282, 0}, {350, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, acRotatingExciter.EfePu) annotation(
    Line(points = {{202, 0}, {236, 0}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{259, -80}, {241, -80}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{219, -80}, {201, -80}}, color = {0, 0, 127}));
  connect(limiter.y, transferFunction1.u) annotation(
    Line(points = {{179, -80}, {161, -80}}, color = {0, 0, 127}));
  connect(transferFunction1.y, feedback.u2) annotation(
    Line(points = {{139, -80}, {120, -80}, {120, -8}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(feedback.y, variableLimiter.u) annotation(
    Line(points = {{130, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(gain.y, transferFunction.u) annotation(
    Line(points = {{-118, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UsPu, gain2.u) annotation(
    Line(points = {{-360, 0}, {-320, 0}, {-320, 60}, {-242, 60}}, color = {0, 0, 127}));
  connect(UsPu, gain3.u) annotation(
    Line(points = {{-360, 0}, {-320, 0}, {-320, -60}, {-242, -60}}, color = {0, 0, 127}));
  connect(gain2.y, variableLimiter.limit1) annotation(
    Line(points = {{-218, 60}, {160, 60}, {160, 8}, {178, 8}}, color = {0, 0, 127}));
  connect(gain3.y, variableLimiter.limit2) annotation(
    Line(points = {{-218, -60}, {160, -60}, {160, -8}, {178, -8}}, color = {0, 0, 127}));
  connect(IrPu, acRotatingExciter.IrPu) annotation(
    Line(points = {{-360, 160}, {220, 160}, {220, 16}, {236, 16}}, color = {0, 0, 127}));
  connect(sum1.y, gain.u) annotation(
    Line(points = {{-158, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(limitedLeadLag.y, max1.u[1]) annotation(
    Line(points = {{-38, 0}, {0, 0}}, color = {0, 0, 127}));
  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{22, 6}, {60, 6}}, color = {0, 0, 127}));
  connect(min1.yMin, feedback.u1) annotation(
    Line(points = {{82, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(add3.y, sum1.u[1]) annotation(
    Line(points = {{-218, 0}, {-182, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-340, -180}, {340, 180}})));
end Ac6c;
