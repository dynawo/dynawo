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

model St9c "IEEE exciter type ST9C model"

  //Regulation parameters
  parameter Types.PerUnit Ka "Voltage regulator gain";
  parameter Types.PerUnit Kas "Power converter gain proportional to supply voltage";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kp "Potential circuit gain";
  parameter Types.PerUnit Ku "Gain associated with activation of takeover underexcitation limiter";
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
  parameter Types.VoltageModulePu VaMaxPu "Maximum output voltage of limited first order in pu";
  parameter Types.VoltageModulePu VaMinPu "Minimum output voltage of limited first order in pu";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";
  parameter Types.VoltageModulePu VrMaxPu "Maximum field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";
  parameter Types.PerUnit Za "Dead-band for differential part influence on voltage regulator";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-340, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = Us0Pu) "Control voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {330, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {110, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {200, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tAs, k = Kas, y_start = Efd0Pu / Vb0Pu) annotation(
    Placement(visible = true, transformation(origin = {230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ka) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {170, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VrMaxPu, uMin = VrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Efd0Pu / (Kas * Vb0Pu)) annotation(
    Placement(visible = true, transformation(origin = {110, -120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {170, -120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {110, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = 1 / tAUel, k2 = -1 / tA, k3 = 1 / tA) annotation(
    Placement(visible = true, transformation(origin = {170, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Ku) annotation(
    Placement(visible = true, transformation(origin = {70, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tBd, k = tCd, x_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sum sum1(k = {1, -1, -1, 1, 1, 1, 1, -1}, nin = 8) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = Za) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-170, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {-10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {50, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min2 annotation(
    Placement(visible = true, transformation(origin = {110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {50, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    Line(points = {{-340, 0}, {-302, 0}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-340, 160}, {-200, 160}, {-200, 144}, {-182, 144}}, color = {85, 170, 255}));
  connect(itPu, potentialCircuit.iT) annotation(
    Line(points = {{-340, 120}, {-200, 120}, {-200, 136}, {-182, 136}}, color = {85, 170, 255}));
  connect(product.y, EfdPu) annotation(
    Line(points = {{301, 0}, {329, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u2) annotation(
    Line(points = {{241, -40}, {260, -40}, {260, -6}, {277, -6}}, color = {0, 0, 127}));
  connect(min1.yMin, firstOrder1.u) annotation(
    Line(points = {{181, -40}, {217, -40}}, color = {0, 0, 127}));
  connect(min1.yMin, feedback.u1) annotation(
    Line(points = {{181, -40}, {200, -40}, {200, -72}}, color = {0, 0, 127}));
  connect(feedback.y, product1.u1) annotation(
    Line(points = {{200, -89}, {200, -115}, {182, -115}}, color = {0, 0, 127}));
  connect(product1.y, integrator.u) annotation(
    Line(points = {{159, -120}, {121, -120}}, color = {0, 0, 127}));
  connect(limiter.y, min1.u[1]) annotation(
    Line(points = {{121, -40}, {140, -40}, {140, -34}, {159, -34}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{81, -40}, {97, -40}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{99, -120}, {40, -120}, {40, -46}, {57, -46}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u2) annotation(
    Line(points = {{99, -120}, {40, -120}, {40, -80}, {191, -80}}, color = {0, 0, 127}));
  connect(max1.yMax, add.u1) annotation(
    Line(points = {{1, 6}, {40, 6}, {40, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(max1.yMax, feedback1.u1) annotation(
    Line(points = {{1, 6}, {20, 6}, {20, -32}}, color = {0, 0, 127}));
  connect(gain.y, max1.u[1]) annotation(
    Line(points = {{-59, 0}, {-21, 0}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{-59, 0}, {-40, 0}, {-40, -40}, {11, -40}}, color = {0, 0, 127}));
  connect(add3.y, product1.u2) annotation(
    Line(points = {{181, -180}, {200, -180}, {200, -126}, {181, -126}}, color = {0, 0, 127}));
  connect(feedback1.y, gain1.u) annotation(
    Line(points = {{20, -49}, {20, -161}, {58, -161}}, color = {0, 0, 127}));
  connect(gain1.y, limiter1.u) annotation(
    Line(points = {{81, -160}, {97, -160}}, color = {0, 0, 127}));
  connect(limiter1.y, add3.u1) annotation(
    Line(points = {{121, -160}, {140, -160}, {140, -172}, {157, -172}}, color = {0, 0, 127}));
  connect(limiter1.y, add3.u2) annotation(
    Line(points = {{121, -160}, {140, -160}, {140, -180}, {157, -180}}, color = {0, 0, 127}));
  connect(const.y, add3.u3) annotation(
    Line(points = {{121, -200}, {140, -200}, {140, -188}, {157, -188}}, color = {0, 0, 127}));
  connect(firstOrder.y, derivative.u) annotation(
    Line(points = {{-279, 0}, {-243, 0}}, color = {0, 0, 127}));
  connect(derivative.y, limiter2.u) annotation(
    Line(points = {{-219, 0}, {-183, 0}}, color = {0, 0, 127}));
  connect(limiter2.y, sum1.u[1]) annotation(
    Line(points = {{-159, 0}, {-123, 0}}, color = {0, 0, 127}));
  connect(derivative.y, sum1.u[2]) annotation(
    Line(points = {{-219, 0}, {-200, 0}, {-200, 20}, {-140, 20}, {-140, 0}, {-123, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[3]) annotation(
    Line(points = {{-279, 0}, {-260, 0}, {-260, -20}, {-140, -20}, {-140, 0}, {-123, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-340, -80}, {-140, -80}, {-140, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[5]) annotation(
    Line(points = {{-340, -40}, {-140, -40}, {-140, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(sum1.y, gain.u) annotation(
    Line(points = {{-98, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(IrPu, gain2.u) annotation(
    Line(points = {{-340, 200}, {-182, 200}}, color = {0, 0, 127}));
  connect(gain2.y, division.u1) annotation(
    Line(points = {{-158, 200}, {-80, 200}, {-80, 146}, {-62, 146}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, switch.u1) annotation(
    Line(points = {{-158, 140}, {-140, 140}, {-140, 108}, {-122, 108}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-158, 100}, {-122, 100}}, color = {255, 0, 255}));
  connect(const1.y, switch.u3) annotation(
    Line(points = {{-158, 60}, {-140, 60}, {-140, 92}, {-122, 92}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-98, 100}, {-80, 100}, {-80, 134}, {-62, 134}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{-38, 140}, {-22, 140}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product2.u1) annotation(
    Line(points = {{2, 140}, {20, 140}, {20, 126}, {38, 126}}, color = {0, 0, 127}));
  connect(switch.y, product2.u2) annotation(
    Line(points = {{-98, 100}, {20, 100}, {20, 114}, {38, 114}}, color = {0, 0, 127}));
  connect(const2.y, min2.u1) annotation(
    Line(points = {{62, 160}, {80, 160}, {80, 146}, {98, 146}}, color = {0, 0, 127}));
  connect(product2.y, min2.u2) annotation(
    Line(points = {{62, 120}, {80, 120}, {80, 134}, {98, 134}}, color = {0, 0, 127}));
  connect(min2.y, product.u1) annotation(
    Line(points = {{122, 140}, {260, 140}, {260, 6}, {278, 6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-320, -220}, {320, 220}})));
end St9c;
