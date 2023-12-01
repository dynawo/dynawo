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

model Ac7c "IEEE exciter type AC7C model"

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kc1 "Rectifier loading factor proportional to commutating reactance (exciter)";
  parameter Types.PerUnit Kd "Exciter internal reactance";
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
  parameter Types.PerUnit Kr "Field voltage feedback gain";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output, (4) take-over at inner loop regulator output";
  parameter Integer PositionPss "Input location : (0) none, (1) voltage error summation, (2) after take-over UEL";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Boolean Sw2 "If true, power source derived from available exciter field voltage, if false, from rotating exciter output voltage";
  parameter Types.Time tDr "Derivative gain washout time constant in s";
  parameter Types.Time tE "Exciter field time constant in s";
  parameter Types.Time tF "Rate feedback time constant in s";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.PerUnit TolLi "Tolerance on limit crossing as a fraction of the difference between initial limits of limited integrator";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of limited PI in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of limited PI in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";
  parameter Types.VoltageModulePu VeMinPu "Minimum exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of limited PID in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of limited PID in pu (user-selected base voltage)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-500, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = Us0Pu) "Control voltage in pu (base UNom)" annotation(
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
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 999) annotation(
    Placement(visible = true, transformation(origin = {270, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -Kl) annotation(
    Placement(visible = true, transformation(origin = {330, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = Kf2, k2 = Kf1) annotation(
    Placement(visible = true, transformation(origin = {150, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {-210, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-150, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kc1) annotation(
    Placement(visible = true, transformation(origin = {-270, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-390, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-330, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-390, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-390, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min4 annotation(
    Placement(visible = true, transformation(origin = {-90, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = Sw2) annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kr) annotation(
    Placement(visible = true, transformation(origin = {390, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-330, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {50, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min3 annotation(
    Placement(visible = true, transformation(origin = {210, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameters (calculated by initialization model)
  parameter Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";
  parameter Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

equation
  if PositionPss == 1 then
    sum1.u[2] = UPssPu;
    add2.u2 = 0;
  elseif PositionPss == 2 then
    sum1.u[2] = 0;
    add2.u2 = UPssPu;
  else
    sum1.u[2] = 0;
    add2.u2 = 0;
  end if;

  if PositionOel == 1 then
    sum1.u[3] = UOelPu;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
    min3.u1 = min3.u2;
  elseif PositionOel == 2 then
    sum1.u[3] = 0;
    min1.u[2] = UOelPu;
    min2.u[2] = min2.u[1];
    min3.u1 = min3.u2;
  elseif PositionOel == 3 then
    sum1.u[3] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = UOelPu;
    min3.u1 = min3.u2;
  elseif PositionOel == 4 then
    sum1.u[3] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
    min3.u1 = UOelPu;
  else
    sum1.u[3] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
    min3.u1 = min3.u2;
  end if;

  if PositionUel == 1 then
    sum1.u[4] = UUelPu;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  elseif PositionUel == 2 then
    sum1.u[4] = 0;
    max1.u[2] = UUelPu;
    max2.u[2] = max2.u[1];
  elseif PositionUel == 3 then
    sum1.u[4] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = UUelPu;
  else
    sum1.u[4] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[5] = USclOelPu + USclUelPu;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 2 then
    sum1.u[5] = 0;
    max1.u[3] = USclUelPu;
    min1.u[3] = USclOelPu;
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 3 then
    sum1.u[5] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = USclUelPu;
    min2.u[3] = USclOelPu;
  else
    sum1.u[5] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  end if;

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
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{-259, 120}, {-223, 120}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product1.u1) annotation(
    Line(points = {{-199, 120}, {-180, 120}, {-180, 106}, {-163, 106}}, color = {0, 0, 127}));
  connect(gain1.y, division.u1) annotation(
    Line(points = {{-281, 160}, {-300, 160}, {-300, 126}, {-283, 126}}, color = {0, 0, 127}));
  connect(acRotatingExciter.VfePu, gain1.u) annotation(
    Line(points = {{422, -16}, {440, -16}, {440, 160}, {-258, 160}}, color = {0, 0, 127}));
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
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-379, 40}, {-360, 40}, {-360, 72}, {-343, 72}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-379, 80}, {-343, 80}}, color = {255, 0, 255}));
  connect(potentialCircuit.vE, switch.u1) annotation(
    Line(points = {{-379, 120}, {-360, 120}, {-360, 88}, {-343, 88}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-500, 140}, {-420, 140}, {-420, 124}, {-402, 124}}, color = {85, 170, 255}));
  connect(itPu, potentialCircuit.iT) annotation(
    Line(points = {{-500, 100}, {-420, 100}, {-420, 116}, {-402, 116}}, color = {85, 170, 255}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-319, 80}, {-300, 80}, {-300, 114}, {-282, 114}}, color = {0, 0, 127}));
  connect(switch.y, product1.u2) annotation(
    Line(points = {{-318, 80}, {-180, 80}, {-180, 94}, {-162, 94}}, color = {0, 0, 127}));
  connect(booleanConstant1.y, switch1.u2) annotation(
    Line(points = {{161, 80}, {197, 80}}, color = {255, 0, 255}));
  connect(const2.y, min4.u1) annotation(
    Line(points = {{-138, 140}, {-120, 140}, {-120, 126}, {-102, 126}}, color = {0, 0, 127}));
  connect(product1.y, min4.u2) annotation(
    Line(points = {{-138, 100}, {-120, 100}, {-120, 114}, {-102, 114}}, color = {0, 0, 127}));
  connect(min4.y, switch1.u1) annotation(
    Line(points = {{-78, 120}, {180, 120}, {180, 88}, {198, 88}}, color = {0, 0, 127}));
  connect(acRotatingExciter.EfdPu, gain2.u) annotation(
    Line(points = {{422, 0}, {460, 0}, {460, 60}, {402, 60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(gain2.y, switch1.u3) annotation(
    Line(points = {{380, 60}, {180, 60}, {180, 72}, {198, 72}}, color = {0, 0, 127}));
  connect(switch1.y, product.u1) annotation(
    Line(points = {{222, 80}, {240, 80}, {240, 6}, {258, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(add.y, sum1.u[1]) annotation(
    Line(points = {{-378, -40}, {-342, -40}}, color = {0, 0, 127}));
  connect(sum1.y, feedback.u1) annotation(
    Line(points = {{-318, -40}, {-288, -40}}, color = {0, 0, 127}));
  connect(feedback.y, max1.u[1]) annotation(
    Line(points = {{-270, -40}, {-240, -40}}, color = {0, 0, 127}));
  connect(max1.yMax, add2.u1) annotation(
    Line(points = {{-218, -34}, {-182, -34}}, color = {0, 0, 127}));
  connect(add2.y, min1.u[1]) annotation(
    Line(points = {{-158, -40}, {-140, -40}, {-140, -34}, {-120, -34}}, color = {0, 0, 127}));
  connect(min1.yMin, pid.u_s) annotation(
    Line(points = {{-98, -40}, {-82, -40}}, color = {0, 0, 127}));
  connect(pid.y, max2.u[1]) annotation(
    Line(points = {{-58, -40}, {-20, -40}}, color = {0, 0, 127}));
  connect(max2.yMax, min2.u[1]) annotation(
    Line(points = {{2, -34}, {40, -34}}, color = {0, 0, 127}));
  connect(min2.yMin, feedback1.u1) annotation(
    Line(points = {{62, -40}, {92, -40}}, color = {0, 0, 127}));
  connect(limitedPI.y, min3.u2) annotation(
    Line(points = {{162, -40}, {180, -40}, {180, -26}, {198, -26}}, color = {0, 0, 127}));
  connect(min3.y, product.u2) annotation(
    Line(points = {{222, -20}, {240, -20}, {240, -6}, {258, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-480, -240}, {480, 240}})));
end Ac7c;
