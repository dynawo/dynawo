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

model St4c "IEEE exciter type ST4C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt4;

  //Regulation parameters
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at inner loop output";
  parameter Integer PositionPss "Input location : (0) none, (1) voltage error summation, (2) after take-over UEL";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at inner loop output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at inner loop output";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Types.Time tG "Feedback time constant of inner loop field regulator in s";
  parameter Types.VoltageModulePu VgMaxPu "Maximum feedback voltage of inner loop field regulator in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-400, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k = Kg, T = tG, y_start = Kg * Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {250, 160}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-310, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-250, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-310, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min4 annotation(
    Placement(visible = true, transformation(origin = {70, 180}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VgMaxPu) annotation(
    Placement(visible = true, transformation(origin = {130, 200}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(Y0 = Efd0Pu / Vb0Pu, YMax = VaMaxPu, YMin = VaMinPu, tFilter = tA) annotation(
    Placement(visible = true, transformation(origin = {270, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";

equation
  if PositionPss == 1 then
    sum1.u[3] = UPssPu;
    add.u2 = 0;
  elseif PositionPss == 2 then
    sum1.u[3] = 0;
    add.u2 = UPssPu;
  else
    sum1.u[3] = 0;
    add.u2 = 0;
  end if;

  if PositionOel == 1 then
    sum1.u[4] = UOelPu;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
  elseif PositionOel == 2 then
    sum1.u[4] = 0;
    min1.u[2] = UOelPu;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 3 then
    sum1.u[4] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = UOelPu;
  else
    sum1.u[4] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
  end if;

  if PositionUel == 1 then
    sum1.u[5] = UUelPu;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  elseif PositionUel == 2 then
    sum1.u[5] = 0;
    max1.u[2] = UUelPu;
    max2.u[2] = max2.u[1];
  elseif PositionUel == 3 then
    sum1.u[5] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = UUelPu;
  else
    sum1.u[5] = 0;
    max1.u[2] = max1.u[1];
    max2.u[2] = max2.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[6] = USclOelPu + USclUelPu;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 2 then
    sum1.u[6] = 0;
    max1.u[3] = USclUelPu;
    min1.u[3] = USclOelPu;
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 3 then
    sum1.u[6] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = USclUelPu;
    min2.u[3] = USclOelPu;
  else
    sum1.u[6] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  end if;

  connect(division.y, rectifierRegulationCharacteristic.u) annotation(
    Line(points = {{101, -120}, {118, -120}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum1.u[1]) annotation(
    Line(points = {{-319, 80}, {-283, 80}}, color = {0, 0, 127}));
  connect(product.y, firstOrder1.u) annotation(
    Line(points = {{322, 0}, {360, 0}, {360, 160}, {262, 160}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, switch.u1) annotation(
    Line(points = {{-298, -140}, {-280, -140}, {-280, -172}, {-262, -172}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-298, -180}, {-262, -180}}, color = {255, 0, 255}));
  connect(const1.y, switch.u3) annotation(
    Line(points = {{-298, -220}, {-280, -220}, {-280, -188}, {-262, -188}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-238, -180}, {80, -180}, {80, -126}, {98, -126}}, color = {0, 0, 127}));
  connect(switch.y, product1.u2) annotation(
    Line(points = {{-238, -180}, {180, -180}, {180, -146}, {198, -146}}, color = {0, 0, 127}));
  connect(add.y, min1.u[1]) annotation(
    Line(points = {{-158, 80}, {-120, 80}}, color = {0, 0, 127}));
  connect(min1.yMin, limPI1.u) annotation(
    Line(points = {{-99, 74}, {-80, 74}, {-80, 80}, {-62, 80}}, color = {0, 0, 127}));
  connect(limPI2.y, max2.u[1]) annotation(
    Line(points = {{82, 80}, {120, 80}}, color = {0, 0, 127}));
  connect(const2.y, min4.u1) annotation(
    Line(points = {{120, 200}, {100, 200}, {100, 186}, {82, 186}}, color = {0, 0, 127}));
  connect(firstOrder1.y, min4.u2) annotation(
    Line(points = {{240, 160}, {100, 160}, {100, 174}, {82, 174}}, color = {0, 0, 127}));
  connect(min2.yMin, limitedFirstOrder.u) annotation(
    Line(points = {{222, 80}, {258, 80}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, product.u1) annotation(
    Line(points = {{282, 80}, {300, 80}, {300, 6}, {318, 6}}, color = {0, 0, 127}));
  connect(min4.y, feedback.u2) annotation(
    Line(points = {{60, 180}, {40, 180}, {40, 88}}, color = {0, 0, 127}));
  connect(limPI1.y, feedback.u1) annotation(
    Line(points = {{-38, 80}, {32, 80}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St4c;
