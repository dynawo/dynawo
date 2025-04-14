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

model Ac7c "IEEE exciter type AC7C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc7;

  //Regulation parameters
  parameter Types.PerUnit Kc1 "Rectifier loading factor proportional to commutating reactance (exciter)";
  parameter Types.PerUnit Kr "Field voltage feedback gain";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output, (4) take-over at inner loop regulator output";
  parameter Integer PositionPss "Input location : (0) none, (1) voltage error summation, (2) after take-over UEL";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Boolean Sw2 "If true, power source derived from available exciter field voltage, if false, from rotating exciter output voltage";
  parameter Types.VoltageModulePu VbMaxPu "Maximum available exciter field voltage in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, -180}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.RectifierRegulationCharacteristic rectifierRegulationCharacteristic annotation(
    Placement(visible = true, transformation(origin = {-210, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-150, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kc1) annotation(
    Placement(visible = true, transformation(origin = {-270, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-330, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-390, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-390, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VbMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min4 annotation(
    Placement(visible = true, transformation(origin = {-90, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = Sw2) annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kr) annotation(
    Placement(visible = true, transformation(origin = {390, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo min1 annotation(
    Placement(visible = true, transformation(origin = {-110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max2(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo min2 annotation(
    Placement(visible = true, transformation(origin = {50, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min3 annotation(
    Placement(visible = true, transformation(origin = {210, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu "Stator current underexcitation limitation initial output voltage in pu (base UNom)";

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
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    min2.u[2] = if PositionScl == 3 then USclOelPu else min2.u[1];
    min3.u1 = min3.u2;
  elseif PositionOel == 2 then
    sum1.u[3] = 0;
    min1.u[2] = if PositionScl == 2 then min(UOelPu, USclOelPu) else UOelPu;
    min2.u[2] = if PositionScl == 3 then USclOelPu else min2.u[1];
    min3.u1 = min3.u2;
  elseif PositionOel == 3 then
    sum1.u[3] = 0;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    min2.u[2] = if PositionScl == 3 then min(UOelPu, USclOelPu) else UOelPu;
    min3.u1 = min3.u2;
  elseif PositionOel == 4 then
    sum1.u[3] = 0;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    min2.u[2] = if PositionScl == 3 then USclOelPu else min2.u[1];
    min3.u1 = UOelPu;
  else
    sum1.u[3] = 0;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    min2.u[2] = if PositionScl == 3 then USclOelPu else min2.u[1];
    min3.u1 = min3.u2;
  end if;

  if PositionUel == 1 then
    sum1.u[4] = UUelPu;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    max2.u[2] = if PositionScl == 3 then USclUelPu else max2.u[1];
  elseif PositionUel == 2 then
    sum1.u[4] = 0;
    max1.u[2] = if PositionScl == 2 then max(UUelPu, USclUelPu) else UUelPu;
    max2.u[2] = if PositionScl == 3 then USclUelPu else max2.u[1];
  elseif PositionUel == 3 then
    sum1.u[4] = 0;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    max2.u[2] = if PositionScl == 3 then max(UUelPu, USclUelPu) else UUelPu;
  else
    sum1.u[4] = 0;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    max2.u[2] = if PositionScl == 3 then USclUelPu else max2.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[5] = USclOelPu + USclUelPu;
  elseif PositionScl == 2 then
    sum1.u[5] = 0;
  elseif PositionScl == 3 then
    sum1.u[5] = 0;
  else
    sum1.u[5] = 0;
  end if;

  connect(acRotatingExciter.EfdPu, EfdPu) annotation(
    Line(points = {{422, 0}, {490, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
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
  connect(limitedPI.y, min3.u2) annotation(
    Line(points = {{162, -40}, {180, -40}, {180, -26}, {198, -26}}, color = {0, 0, 127}));
  connect(min3.y, product.u2) annotation(
    Line(points = {{222, -20}, {240, -20}, {240, -6}, {258, -6}}, color = {0, 0, 127}));
  connect(min2.yMin, feedback1.u1) annotation(
    Line(points = {{62, -40}, {92, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac7c;
