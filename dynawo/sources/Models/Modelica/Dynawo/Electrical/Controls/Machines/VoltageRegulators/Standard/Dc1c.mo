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

model Dc1c "IEEE excitation system type DC1C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseDc1;

  //Regulation parameters
  parameter Types.VoltageModulePu EfdMinPu "Minimum excitation voltage in pu (user-selected base voltage)";
  parameter Integer PositionOel "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR output";
  parameter Integer PositionScl "Input location : (0) none, (1) voltage error summation, (2) take-over at AVR output";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = UOel0Pu) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclOelPu(start = USclOel0Pu) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput USclUelPu(start = USclUel0Pu) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-320, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1 / tE, outMax = 999, outMin = EfdMinPu, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax min1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {10, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters (inputs)
  parameter Types.VoltageModulePu UOel0Pu = 0 "Overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclOel0Pu = 0 "Stator current overexcitation limitation initial output voltage in pu (base UNom)";
  parameter Types.VoltageModulePu USclUel0Pu = 0 "Stator current underexcitation limitation initial output voltage in pu (base UNom)";

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

  connect(feedback1.y, limIntegrator.u) annotation(
    Line(points = {{109, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, EfdPu) annotation(
    Line(points = {{201, 0}, {310, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, derivative.u) annotation(
    Line(points = {{201, 0}, {280, 0}, {280, -100}, {62, -100}}, color = {0, 0, 127}));
  connect(limIntegrator.y, power.u) annotation(
    Line(points = {{202, 0}, {280, 0}, {280, -40}, {262, -40}}, color = {0, 0, 127}));
  connect(limIntegrator.y, product.u2) annotation(
    Line(points = {{202, 0}, {280, 0}, {280, -100}, {160, -100}, {160, -86}, {142, -86}}, color = {0, 0, 127}));
  connect(max1.yMax, min1.u[1]) annotation(
    Line(points = {{-19, 6}, {0, 6}}, color = {0, 0, 127}));
  connect(min1.yMin, limitedFirstOrder.u) annotation(
    Line(points = {{21, 0}, {37, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Dc1c;
