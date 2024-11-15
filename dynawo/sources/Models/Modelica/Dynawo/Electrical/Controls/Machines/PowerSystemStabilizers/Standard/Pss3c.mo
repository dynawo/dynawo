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

model Pss3c "IEEE power system stabilizer type 3C"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss3;

  //Regulation parameters
  parameter Types.ActivePowerPu PPssOffPu "Lower active power threshold for PSS activation in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PPssOnPu "Higher active power threshold for PSS activation in pu (base SNom) (generator convention)";

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uHigh = PPssOnPu, uLow = PPssOffPu, y(start = PGen0Pu * SystemBase.SnRef / SNom > PPssOffPu)) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(PGenPu, hysteresis.u) annotation(
    Line(points = {{-240, 60}, {-200, 60}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(hysteresis.y, switch.u2) annotation(
    Line(points = {{-158, 0}, {-80, 0}, {-80, -40}, {178, -40}}, color = {255, 0, 255}));
  connect(limiter2.y, switch.u1) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, -32}, {178, -32}}, color = {0, 0, 127}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{142, -80}, {160, -80}, {160, -48}, {178, -48}}, color = {0, 0, 127}));
  connect(switch.y, VPssPu) annotation(
    Line(points = {{202, -40}, {230, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss3c;
