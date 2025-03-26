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

model St9c "IEEE exciter type ST9C model (2016 standard)"

  //Regulation parameters
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Kas "Power converter gain proportional to supply voltage";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kp "Potential circuit gain";
  parameter Types.PerUnit Ku "Gain associated with activation of takeover UEL";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.Time tAs "Equivalent time constant of power converter firing control in s";
  parameter Types.Time tAUel "Time constant of underexcitation limiter in s";
  parameter Types.Time tBd "Filter time constant of differential part of voltage regulator in s";
  parameter Types.Time tCd "Time constant of differential part of voltage regulator in s";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.Time tR "Stator voltage filter time constant in s";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu ZaPu "Dead-band for differential part influence on voltage regulator in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-340, 180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = Us0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {330, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const(k = 1 / tA) annotation(
    Placement(visible = true, transformation(origin = {110, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-290, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {290, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {200, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tAs, k = Kas, y_start = Efd0Pu / Vb0Pu) annotation(
    Placement(visible = true, transformation(origin = {230, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ka) annotation(
    Placement(visible = true, transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Max3 max1 annotation(
    Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Min3 min1 annotation(
    Placement(visible = true, transformation(origin = {170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VrMaxPu, uMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Efd0Pu / (Kas * Vb0Pu)) annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {170, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tBd, k = tCd, x_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(k = {1, -1, -1, 1, 1, 1, 1, -1}, nin = 8) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = ZaPu) annotation(
    Placement(visible = true, transformation(origin = {-170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-170, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-50, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Min2 min2 annotation(
    Placement(visible = true, transformation(origin = {110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {50, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Ku) annotation(
    Placement(visible = true, transformation(origin = {30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 1, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {70, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = 1 / tAUel - 1 / tA) annotation(
    Placement(visible = true, transformation(origin = {110, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = if (PositionUel == 2 or PositionScl == 2) then max1.y - gain.y else 0) annotation(
    Placement(visible = true, transformation(origin = {-160, -120}, extent = {{-140, -10}, {140, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu "Stator current underexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameter (calculated by initialization model)
  parameter Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";

equation
  if PositionOel == 1 then
    sum1.u[6] = UOelPu;
    min1.u[2] = min1.u[1];
  elseif PositionOel == 2 then
    sum1.u[6] = 0;
    min1.u[2] = UOelPu;
  else
    sum1.u[6] = 0;
    min1.u[2] = min1.u[1];
  end if;

  if PositionUel == 1 then
    sum1.u[7] = UUelPu;
    max1.u[2] = max1.u[1];
  elseif PositionUel == 2 then
    sum1.u[7] = 0;
    max1.u[2] = UUelPu;
  else
    sum1.u[7] = 0;
    max1.u[2] = max1.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[8] = USclOelPu + USclUelPu;
    min1.u[3] = min1.u[1];
    max1.u[3] = max1.u[1];
  elseif PositionScl == 2 then
    sum1.u[8] = 0;
    min1.u[3] = USclOelPu;
    max1.u[3] = USclUelPu;
  else
    sum1.u[8] = 0;
    min1.u[3] = min1.u[1];
    max1.u[3] = max1.u[1];
  end if;

  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-340, -20}, {-302, -20}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-340, 140}, {-200, 140}, {-200, 124}, {-182, 124}}, color = {85, 170, 255}));
  connect(itPu, potentialCircuit.iT) annotation(
    Line(points = {{-340, 100}, {-200, 100}, {-200, 116}, {-182, 116}}, color = {85, 170, 255}));
  connect(product.y, EfdPu) annotation(
    Line(points = {{301, 80}, {329, 80}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u2) annotation(
    Line(points = {{241, 20}, {260, 20}, {260, 74}, {278, 74}}, color = {0, 0, 127}));
  connect(min1.y, firstOrder1.u) annotation(
    Line(points = {{181, 20}, {218, 20}}, color = {0, 0, 127}));
  connect(min1.y, feedback.u1) annotation(
    Line(points = {{181, 20}, {200, 20}, {200, -12}}, color = {0, 0, 127}));
  connect(feedback.y, product1.u1) annotation(
    Line(points = {{200, -29}, {200, -54}, {182, -54}}, color = {0, 0, 127}));
  connect(product1.y, integrator.u) annotation(
    Line(points = {{159, -60}, {122, -60}}, color = {0, 0, 127}));
  connect(limiter.y, min1.u[1]) annotation(
    Line(points = {{121, 20}, {160, 20}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{81, 20}, {98, 20}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{99, -60}, {40, -60}, {40, 14}, {58, 14}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u2) annotation(
    Line(points = {{99, -60}, {40, -60}, {40, -20}, {192, -20}}, color = {0, 0, 127}));
  connect(max1.y, add.u1) annotation(
    Line(points = {{1, -20}, {20, -20}, {20, 26}, {58, 26}}, color = {0, 0, 127}));
  connect(gain.y, max1.u[1]) annotation(
    Line(points = {{-59, -20}, {-21, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, derivative.u) annotation(
    Line(points = {{-279, -20}, {-243, -20}}, color = {0, 0, 127}));
  connect(derivative.y, limiter2.u) annotation(
    Line(points = {{-219, -20}, {-183, -20}}, color = {0, 0, 127}));
  connect(limiter2.y, sum1.u[1]) annotation(
    Line(points = {{-159, -20}, {-123, -20}}, color = {0, 0, 127}));
  connect(derivative.y, sum1.u[2]) annotation(
    Line(points = {{-219, -20}, {-200, -20}, {-200, 0}, {-140, 0}, {-140, -20}, {-123, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[3]) annotation(
    Line(points = {{-279, -20}, {-260, -20}, {-260, -40}, {-140, -40}, {-140, -20}, {-123, -20}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-340, -100}, {-140, -100}, {-140, -20}, {-122, -20}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[5]) annotation(
    Line(points = {{-340, -60}, {-140, -60}, {-140, -20}, {-122, -20}}, color = {0, 0, 127}));
  connect(sum1.y, gain.u) annotation(
    Line(points = {{-99, -20}, {-83, -20}}, color = {0, 0, 127}));
  connect(IrPu, gain2.u) annotation(
    Line(points = {{-340, 180}, {-182, 180}}, color = {0, 0, 127}));
  connect(gain2.y, division.u1) annotation(
    Line(points = {{-159, 180}, {-80, 180}, {-80, 126}, {-63, 126}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, switch.u1) annotation(
    Line(points = {{-159, 120}, {-140, 120}, {-140, 88}, {-123, 88}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-159, 80}, {-123, 80}}, color = {255, 0, 255}));
  connect(const1.y, switch.u3) annotation(
    Line(points = {{-159, 40}, {-140, 40}, {-140, 72}, {-123, 72}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-99, 80}, {-80, 80}, {-80, 114}, {-63, 114}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{-39, 120}, {-23, 120}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product2.u1) annotation(
    Line(points = {{1, 120}, {20, 120}, {20, 106}, {37, 106}}, color = {0, 0, 127}));
  connect(switch.y, product2.u2) annotation(
    Line(points = {{-99, 80}, {20, 80}, {20, 94}, {37, 94}}, color = {0, 0, 127}));
  connect(const2.y, min2.u1) annotation(
    Line(points = {{61, 180}, {80, 180}, {80, 146}, {98, 146}}, color = {0, 0, 127}));
  connect(product2.y, min2.u2) annotation(
    Line(points = {{61, 100}, {80, 100}, {80, 134}, {98, 134}}, color = {0, 0, 127}));
  connect(min2.y, product.u1) annotation(
    Line(points = {{121, 140}, {260, 140}, {260, 86}, {278, 86}}, color = {0, 0, 127}));
  connect(gain1.y, limiter1.u) annotation(
    Line(points = {{41, -120}, {57, -120}}, color = {0, 0, 127}));
  connect(limiter1.y, gain3.u) annotation(
    Line(points = {{81, -120}, {97, -120}}, color = {0, 0, 127}));
  connect(gain3.y, add1.u1) annotation(
    Line(points = {{121, -120}, {140, -120}, {140, -134}, {157, -134}}, color = {0, 0, 127}));
  connect(const.y, add1.u2) annotation(
    Line(points = {{121, -180}, {140, -180}, {140, -146}, {157, -146}}, color = {0, 0, 127}));
  connect(add1.y, product1.u2) annotation(
    Line(points = {{181, -140}, {200, -140}, {200, -66}, {182, -66}}, color = {0, 0, 127}));
  connect(realExpression.y, gain1.u) annotation(
    Line(points = {{-6, -120}, {18, -120}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-320, -200}, {320, 200}})));
end St9c;
