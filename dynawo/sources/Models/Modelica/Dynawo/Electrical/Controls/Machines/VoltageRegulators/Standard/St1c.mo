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

model St1c "IEEE excitation system type ST1C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt1;

  //Regulation parameters
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR input, (3) take-over at AVR output";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-440, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-30, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu USclOel0Pu "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu "Stator current underexcitation limitation initial output voltage in pu (base UNom)";

equation
  if PositionOel == 1 then
    sum1.u[2] = UOelPu;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
  elseif PositionOel == 2 then
    sum1.u[2] = 0;
    min1.u[2] = UOelPu;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 3 then
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = UOelPu;
  else
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    min2.u[2] = min2.u[1];
  end if;

  if PositionScl == 1 then
    sum1.u[4] = USclOelPu + USclUelPu;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 2 then
    sum1.u[4] = 0;
    max1.u[3] = USclUelPu;
    min1.u[3] = USclOelPu;
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  elseif PositionScl == 3 then
    sum1.u[4] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = USclUelPu;
    min2.u[3] = USclOelPu;
  else
    sum1.u[4] = 0;
    max1.u[3] = max1.u[1];
    min1.u[3] = min1.u[1];
    max2.u[3] = max2.u[1];
    min2.u[3] = min2.u[1];
  end if;

  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{-79, 6}, {-41, 6}}, color = {0, 0, 127}));
  connect(min1.yMin, transferFunction1.u) annotation(
    Line(points = {{-19, 0}, {-3, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St1c;
