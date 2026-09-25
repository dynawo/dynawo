within Dynawo.Electrical.Wind.WECC;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model WTCurrentSource_INIT "Initialization model for WECC WT models with a current source as interface with the grid"
  extends Dynawo.Electrical.Controls.WECC.BaseClasses_INIT.WECCInverterCurrentSource_INIT;

  // Torque control parameters
  parameter Types.PerUnit P1 = 0 "1st power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd1 = 1 "1st speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit P2 = 1 "2nd power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd2 = 1 "2nd speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit P3 = 2 "3rd power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd3 = 1 "3rd speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit P4 = 3 "4th power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd4 = 1 "4th speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));

  Types.AngularVelocityPu omegaRefWTGQ0Pu "Start value of reference angular frequency of torque control in pu (base omegaNom)";

  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [P1, Spd1; P2, Spd2; P3, Spd3; P4, Spd4]) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = PInj0Pu) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  omegaRefWTGQ0Pu = combiTable1D.y[1];

  connect(realExpression.y, combiTable1D.u[1]) annotation(
    Line(points = {{-48, 0}, {-12, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "text");
end WTCurrentSource_INIT;
