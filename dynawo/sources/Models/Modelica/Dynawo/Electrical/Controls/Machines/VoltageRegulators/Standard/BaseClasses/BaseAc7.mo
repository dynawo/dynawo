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

partial model BaseAc7 "IEEE exciter type AC7 base model"

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kd "Demagnetizing factor, function of exciter alternator reactances";
  parameter Types.PerUnit Kdr "Regulator derivative gain";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.PerUnit Kf1 "Generator field voltage feedback gain";
  parameter Types.PerUnit Kf2 "Exciter field current feedback gain";
  parameter Types.PerUnit Kf3 "Rate feedback gain";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kia "Amplifier integral gain";
  parameter Types.PerUnit Kir "Regulator integral gain";
  parameter Types.PerUnit Kl "Exciter field current limiter gain";
  parameter Types.PerUnit Kp "Potential source gain";
  parameter Types.PerUnit Kpa "Amplifier proportional gain";
  parameter Types.PerUnit Kpr "Regulator proportional gain";
  parameter Types.Time tDr "Derivative gain washout time constant in s";
  parameter Types.Time tE "Exciter field time constant in s";
  parameter Types.Time tF "Rate feedback time constant in s";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.PerUnit TolLi "Tolerance on limit crossing as a fraction of the difference between initial limits of limited integrator";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of limited PI in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of limited PI in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMinPu "Minimum exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of limited PID in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of limited PID in pu (user-selected base voltage)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-500, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = Us0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {490, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    Placement(visible = true, transformation(origin = {400, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-450, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-390, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-280, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tF, k = Kf3, x_start = Efe0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -200}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pid(
    Nd = 1,
    Td = tDr,
    Ti = 1 / Kir,
    wd = Kdr / tDr,
    wp = Kpr,
    xi_start = Kf1 * Efd0Pu + Kf2 * Efe0Pu,
    y_start = Kf1 * Efd0Pu + Kf2 * Efe0Pu,
    yMax = VrMaxPu,
    yMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = Kia, Kp = Kpa, Y0 = Efe0Pu / Vb0Pu, YMax = VaMaxPu, YMin = VaMinPu) annotation(
    Placement(visible = true, transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 999) annotation(
    Placement(visible = true, transformation(origin = {270, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -Kl) annotation(
    Placement(visible = true, transformation(origin = {330, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = Kf2, k2 = Kf1) annotation(
    Placement(visible = true, transformation(origin = {150, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-390, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-330, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  //Initial parameter (input)
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameters (calculated by initialization model)
  parameter Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";
  parameter Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

equation
  connect(product.y, variableLimiter.u) annotation(
    Line(points = {{281, 0}, {317, 0}}, color = {0, 0, 127}));
  connect(variableLimiter.y, acRotatingExciter.EfePu) annotation(
    Line(points = {{341, 0}, {375, 0}}, color = {0, 0, 127}));
  connect(const.y, variableLimiter.limit1) annotation(
    Line(points = {{281, 40}, {300, 40}, {300, 8}, {317, 8}}, color = {0, 0, 127}));
  connect(gain.y, variableLimiter.limit2) annotation(
    Line(points = {{319, -40}, {300, -40}, {300, -8}, {317, -8}}, color = {0, 0, 127}));
  connect(acRotatingExciter.VfePu, gain.u) annotation(
    Line(points = {{422, -16}, {440, -16}, {440, -40}, {342, -40}}, color = {0, 0, 127}));
  connect(feedback1.y, limitedPI.u) annotation(
    Line(points = {{109, -40}, {137, -40}}, color = {0, 0, 127}));
  connect(add1.y, feedback1.u2) annotation(
    Line(points = {{139, -160}, {100, -160}, {100, -48}}, color = {0, 0, 127}));
  connect(acRotatingExciter.VfePu, add1.u1) annotation(
    Line(points = {{422, -16}, {440, -16}, {440, -140}, {180, -140}, {180, -154}, {162, -154}}, color = {0, 0, 127}));
  connect(acRotatingExciter.EfdPu, EfdPu) annotation(
    Line(points = {{422, 0}, {490, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(acRotatingExciter.EfdPu, add1.u2) annotation(
    Line(points = {{422, 0}, {460, 0}, {460, -180}, {180, -180}, {180, -166}, {162, -166}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(acRotatingExciter.VfePu, derivative.u) annotation(
    Line(points = {{422, -16}, {440, -16}, {440, -200}, {-58, -200}}, color = {0, 0, 127}));
  connect(IrPu, acRotatingExciter.IrPu) annotation(
    Line(points = {{-500, 200}, {360, 200}, {360, 16}, {376, 16}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(const1.y, pid.u_m) annotation(
    Line(points = {{-99, -80}, {-70, -80}, {-70, -52}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-500, -60}, {-462, -60}}, color = {0, 0, 127}));
  connect(UsRefPu, add.u1) annotation(
    Line(points = {{-500, -20}, {-420, -20}, {-420, -34}, {-402, -34}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u2) annotation(
    Line(points = {{-439, -60}, {-420, -60}, {-420, -46}, {-403, -46}}, color = {0, 0, 127}));
  connect(derivative.y, feedback.u2) annotation(
    Line(points = {{-81, -200}, {-280, -200}, {-280, -48}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-500, 140}, {-420, 140}, {-420, 124}, {-402, 124}}, color = {85, 170, 255}));
  connect(itPu, potentialCircuit.iT) annotation(
    Line(points = {{-500, 100}, {-420, 100}, {-420, 116}, {-402, 116}}, color = {85, 170, 255}));
  connect(add.y, sum1.u[1]) annotation(
    Line(points = {{-378, -40}, {-342, -40}}, color = {0, 0, 127}));
  connect(sum1.y, feedback.u1) annotation(
    Line(points = {{-318, -40}, {-288, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-480, -240}, {480, 240}})));
end BaseAc7;
