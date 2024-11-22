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

model Ac8c "IEEE exciter type AC8C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc8(
    limitedFirstOrder.Y0 = Efe0Pu / Vb0Pu,
    pid.xi_start = Efe0Pu / (Ka * Vb0Pu),
    pid.y_start = Efe0Pu / (Ka * Vb0Pu));

  //Regulation parameters
  parameter Types.PerUnit Kc1 "Rectifier loading factor proportional to commutating reactance (exciter)";
  parameter Types.PerUnit Ki "Potential circuit (current) gain coefficient";
  parameter Types.PerUnit Kp "Potential source gain";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionPss "Input location : (0) none, (1) voltage error summation, (2) after take-over UEL";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Types.Angle Thetap "Potential circuit phase angle in rad";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";
  parameter Types.PerUnit XlPu "Reactance associated with potential source in pu (base SNom, UNom)";

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = UUel0Pu) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-380, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant constant1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-270, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-150, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {-90, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kc1) annotation(
    Placement(visible = true, transformation(origin = {-150, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.PotentialCircuit potentialCircuit(Ki = Ki, Kp = Kp, Theta = Thetap, X = XlPu) annotation(
    Placement(visible = true, transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-270, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min3 annotation(
    Placement(visible = true, transformation(origin = {30, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-30, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {130, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UUel0Pu = 0 "Underexcitation limitation initial output voltage in pu (base UNom)";

  //Initial parameter (calculated by initialization model)
  parameter Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";

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
  elseif PositionOel == 2 then
    sum1.u[3] = 0;
    min1.u[2] = UOelPu;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 3 then
    sum1.u[3] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = UOelPu;
  else
    sum1.u[3] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
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

  connect(product.y, acRotatingExciter.EfePu) annotation(
    Line(points = {{241, 0}, {276, 0}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, product.u2) annotation(
    Line(points = {{181, -40}, {200, -40}, {200, -6}, {218, -6}}, color = {0, 0, 127}));
  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{-139, 120}, {-103, 120}}, color = {0, 0, 127}));
  connect(rectifierRegulationCharacteristic.y, product1.u1) annotation(
    Line(points = {{-79, 120}, {-60, 120}, {-60, 106}, {-43, 106}}, color = {0, 0, 127}));
  connect(gain1.y, division.u1) annotation(
    Line(points = {{-161, 160}, {-180, 160}, {-180, 126}, {-163, 126}}, color = {0, 0, 127}));
  connect(acRotatingExciter.VfePu, gain1.u) annotation(
    Line(points = {{322, -16}, {340, -16}, {340, 160}, {-138, 160}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-259, 40}, {-240, 40}, {-240, 72}, {-223, 72}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-259, 80}, {-223, 80}}, color = {255, 0, 255}));
  connect(potentialCircuit.vE, switch.u1) annotation(
    Line(points = {{-259, 120}, {-240, 120}, {-240, 88}, {-223, 88}}, color = {0, 0, 127}));
  connect(utPu, potentialCircuit.uT) annotation(
    Line(points = {{-380, 140}, {-300, 140}, {-300, 124}, {-282, 124}}, color = {85, 170, 255}));
  connect(itPu, potentialCircuit.iT) annotation(
    Line(points = {{-380, 100}, {-300, 100}, {-300, 116}, {-282, 116}}, color = {85, 170, 255}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-199, 80}, {-180, 80}, {-180, 114}, {-162, 114}}, color = {0, 0, 127}));
  connect(switch.y, product1.u2) annotation(
    Line(points = {{-199, 80}, {-60, 80}, {-60, 94}, {-43, 94}}, color = {0, 0, 127}));
  connect(const2.y, min3.u1) annotation(
    Line(points = {{-19, 140}, {0, 140}, {0, 126}, {17, 126}}, color = {0, 0, 127}));
  connect(product1.y, min3.u2) annotation(
    Line(points = {{-19, 100}, {0, 100}, {0, 114}, {17, 114}}, color = {0, 0, 127}));
  connect(min3.y, product.u1) annotation(
    Line(points = {{41, 120}, {200, 120}, {200, 6}, {218, 6}}, color = {0, 0, 127}));
  connect(max1.yMax, add2.u1) annotation(
    Line(points = {{-139, -34}, {-103, -34}}, color = {0, 0, 127}));
  connect(add2.y, min1.u[1]) annotation(
    Line(points = {{-79, -40}, {-60, -40}, {-60, -34}, {-41, -34}}, color = {0, 0, 127}));
  connect(min1.yMin, pid.u_s) annotation(
    Line(points = {{-19, -40}, {18, -40}}, color = {0, 0, 127}));
  connect(pid.y, max2.u[1]) annotation(
    Line(points = {{41, -40}, {80, -40}}, color = {0, 0, 127}));
  connect(max2.yMax, min2.u[1]) annotation(
    Line(points = {{101, -34}, {120, -34}}, color = {0, 0, 127}));
  connect(sum1.y, max1.u[1]) annotation(
    Line(points = {{-199, -40}, {-160, -40}}, color = {0, 0, 127}));
  connect(min2.yMin, limitedFirstOrder.u) annotation(
    Line(points = {{141, -40}, {158, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac8c;
