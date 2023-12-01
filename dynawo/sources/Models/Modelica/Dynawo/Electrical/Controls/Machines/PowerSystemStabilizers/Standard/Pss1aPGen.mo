within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

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

model Pss1aPGen "IEEE power system stabilizer type 1A, with active power input"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss1a(
    derivative.x_start = Ks * PGen0Pu * SystemBase.SnRef / SNom,
    firstOrder.y_start = PGen0Pu * SystemBase.SnRef / SNom);

  //Generator parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain1(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

equation
  connect(PGenPu, gain1.u) annotation(
    Line(points = {{-200, 0}, {-162, 0}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder.u) annotation(
    Line(points = {{-138, 0}, {-122, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss1aPGen;
