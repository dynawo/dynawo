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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Pss2c "IEEE power system stabilizer type 2C"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss2;

  //Regulation parameters
  parameter Types.ActivePowerPu PPssOffPu "Active power threshold for PSS deactivation in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PPssOnPu "Active power threshold for PSS activation in pu (base SNom) (generator convention)";
  parameter Types.Time t10 "Third lead time constant in s";
  parameter Types.Time t11 "Third lag time constant in s";
  parameter Types.Time t12 "Fourth lead time constant in s";
  parameter Types.Time t13 "Fourth lag time constant in s";

  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction2(a = {t11, 1}, b = {t10, 1}) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction3(a = {t13, 1}, b = {t12, 1}) annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh = PPssOnPu, uLow = PPssOffPu, y(start = PGen0Pu * SystemBase.SnRef / SNom > PPssOffPu)) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {330, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {270, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(transferFunction1.y, transferFunction2.u) annotation(
    Line(points = {{161, 0}, {177, 0}}, color = {0, 0, 127}));
  connect(transferFunction2.y, transferFunction3.u) annotation(
    Line(points = {{201, 0}, {217, 0}}, color = {0, 0, 127}));
  connect(transferFunction3.y, limiter2.u) annotation(
    Line(points = {{241, 0}, {257, 0}}, color = {0, 0, 127}));
  connect(gain.y, hysteresis.u) annotation(
    Line(points = {{-298, 60}, {-280, 60}, {-280, 0}, {-262, 0}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch.u2) annotation(
    Line(points = {{-239, 0}, {-120, 0}, {-120, -40}, {318, -40}}, color = {255, 0, 255}));
  connect(limiter2.y, switch.u1) annotation(
    Line(points = {{282, 0}, {300, 0}, {300, -32}, {318, -32}}, color = {0, 0, 127}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{282, -80}, {300, -80}, {300, -48}, {318, -48}}, color = {0, 0, 127}));
  connect(switch.y, VPssPu) annotation(
    Line(points = {{342, -40}, {370, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-340, -180}, {360, 180}})));
end Pss2c;
