within Dynawo.Electrical.Controls.Machines.Governors.Simplified;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GoverDTRI8

  parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
  parameter Types.Time tFirstOrderGover "First order time constant of governor (in seconds)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(transformation(origin = {-120, 46}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(transformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant OmegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-64, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KGover) annotation(
    Placement(visible = true, transformation(origin = {-24, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {16, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFirstOrderGover) annotation(
    Placement(visible = true, transformation(origin = {66, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-64, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";

equation
  connect(OmegaRefPu.y, add.u1) annotation(
    Line(points = {{-99, 0}, {-76, 0}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-53, -6}, {-36, -6}}, color = {0, 0, 127}));
  connect(gain.y, add1.u2) annotation(
    Line(points = {{-12, -6}, {4, -6}, {4, 28}}, color = {0, 0, 127}));
  connect(add1.y, firstOrder.u) annotation(
    Line(points = {{28, 34}, {54, 34}}, color = {0, 0, 127}));
  connect(firstOrder.y, PmPu) annotation(
    Line(points = {{78, 34}, {110, 34}}, color = {0, 0, 127}));
  connect(PmRefPu, division.u1) annotation(
    Line(points = {{-120, 46}, {-76, 46}}, color = {0, 0, 127}));
  connect(omegaPu, division.u2) annotation(
    Line(points = {{-120, -40}, {-90, -40}, {-90, 34}, {-76, 34}}, color = {0, 0, 127}));
  connect(division.y, add1.u1) annotation(
    Line(points = {{-52, 40}, {4, 40}}, color = {0, 0, 127}));
  connect(omegaPu, add.u2) annotation(
    Line(points = {{-120, -40}, {-90, -40}, {-90, -12}, {-76, -12}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.0.1")),
    Diagram);
end GoverDTRI8;
