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

model St6c "IEEE exciter type ST6C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt6;

  //Regulation parameters
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) AVR input summation, (4) take-over at AVR output";
  parameter Integer PositionUel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) AVR input summation, (4) take-over at AVR output";
  parameter Boolean Sw1 "If true, power source derived from terminal voltage, if false, independent from terminal voltage";
  parameter Types.Time tA "Voltage regulator time constant in s";
  parameter Types.VoltageModulePu VmMaxPu "Maximum output voltage of limited first order in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VmMinPu "Minimum output voltage of limited first order in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-460, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(Y0 = Efd0Pu / Vb0Pu, YMax = VmMaxPu, YMin = VmMinPu, tFilter = tA) annotation(
    Placement(visible = true, transformation(origin = {310, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinMaxDynawo max2 annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-330, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {-390, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-390, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinDynawo min3 annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu USclOel0Pu "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu "Stator current underexcitation limitation initial output voltage in pu (base UNom)";

equation
  if PositionOel == 1 then
    sum1.u[2] = UOelPu;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    sum2.u[3] = 0;
    min2.u[2] = if PositionScl == 4 then USclOelPu else min2.u[1];
  elseif PositionOel == 2 then
    sum1.u[2] = 0;
    min1.u[2] = if PositionScl == 2 then min(UOelPu, USclOelPu) else UOelPu;
    sum2.u[3] = 0;
    min2.u[2] = if PositionScl == 4 then USclOelPu else min2.u[1];
  elseif PositionOel == 3 then
    sum1.u[2] = 0;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    sum2.u[3] = UOelPu;
    min2.u[2] = if PositionScl == 4 then USclOelPu else min2.u[1];
  elseif PositionOel == 4 then
    sum1.u[2] = 0;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    sum2.u[3] = 0;
    min2.u[2] = if PositionScl == 4 then min(UOelPu, USclOelPu) else UOelPu;
  else
    sum1.u[2] = 0;
    min1.u[2] = if PositionScl == 2 then USclOelPu else min1.u[1];
    sum2.u[3] = 0;
    min2.u[2] = if PositionScl == 4 then USclOelPu else min2.u[1];
  end if;

  if PositionUel == 1 then
    sum1.u[3] = UUelPu;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    sum2.u[4] = 0;
    max2.u[2] = if PositionScl == 4 then USclUelPu else max2.u[1];
  elseif PositionUel == 2 then
    sum1.u[3] = 0;
    max1.u[2] = if PositionScl == 2 then max(UUelPu, USclUelPu) else UUelPu;
    sum2.u[4] = 0;
    max2.u[2] = if PositionScl == 4 then USclUelPu else max2.u[1];
  elseif PositionUel == 3 then
    sum1.u[3] = 0;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    sum2.u[4] = UUelPu;
    max2.u[2] = if PositionScl == 4 then USclUelPu else max2.u[1];
  elseif PositionUel == 4 then
    sum1.u[3] = 0;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    sum2.u[4] = 0;
    max2.u[2] = if PositionScl == 4 then max(UUelPu, USclUelPu) else UUelPu;
  else
    sum1.u[3] = 0;
    max1.u[2] = if PositionScl == 2 then USclUelPu else max1.u[1];
    sum2.u[4] = 0;
    max2.u[2] = if PositionScl == 4 then USclUelPu else max2.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[4] = USclOelPu + USclUelPu;
    sum2.u[5] = 0;
  elseif PositionScl == 2 then
    sum1.u[4] = 0;
    sum2.u[5] = 0;
  elseif PositionScl == 3 then
    sum1.u[4] = 0;
    sum2.u[5] = USclOelPu + USclUelPu;
  elseif PositionScl == 4 then
    sum1.u[4] = 0;
    sum2.u[5] = 0;
  else
    sum1.u[4] = 0;
    sum2.u[5] = 0;
  end if;

  connect(limiter.y, max2.u[1]) annotation(
    Line(points = {{102, -80}, {140, -80}}, color = {0, 0, 127}));
  connect(max2.yMax, min2.u[1]) annotation(
    Line(points = {{162, -74}, {200, -74}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, switch.u1) annotation(
    Line(points = {{-378, 140}, {-360, 140}, {-360, 108}, {-342, 108}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-378, 100}, {-342, 100}}, color = {255, 0, 255}));
  connect(const5.y, switch.u3) annotation(
    Line(points = {{-378, 60}, {-360, 60}, {-360, 92}, {-342, 92}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-318, 100}, {-200, 100}, {-200, 154}, {-182, 154}}, color = {0, 0, 127}));
  connect(switch.y, product1.u2) annotation(
    Line(points = {{-318, 100}, {-100, 100}, {-100, 134}, {-82, 134}}, color = {0, 0, 127}));
  connect(min4.y, limitedFirstOrder.u) annotation(
    Line(points = {{281, -20}, {298, -20}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, product.u2) annotation(
    Line(points = {{321, -20}, {340, -20}, {340, -6}, {358, -6}}, color = {0, 0, 127}));
  connect(max3.y, min3.u1) annotation(
    Line(points = {{-159, 40}, {-140, 40}, {-140, 26}, {-122, 26}}, color = {0, 0, 127}));
  connect(const3.y, min3.u2) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, 14}, {-122, 14}}, color = {0, 0, 127}));
  connect(min3.y, limPI1.limitMax) annotation(
    Line(points = {{-99, 20}, {-80, 20}, {-80, -94}, {-62, -94}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St6c;
