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

model Pss2b "IEEE power system stabilizer type 2B"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss2;

  //Regulation parameters
  parameter Types.Time t10 "Third lead time constant in s";
  parameter Types.Time t11 "Third lag time constant in s";

  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction2(a = {t11, 1}, b = {t10, 1}) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(transferFunction1.y, transferFunction2.u) annotation(
    Line(points = {{162, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(transferFunction2.y, limiter2.u) annotation(
    Line(points = {{202, 0}, {258, 0}}, color = {0, 0, 127}));
  connect(limiter2.y, VPssPu) annotation(
    Line(points = {{282, 0}, {300, 0}, {300, -40}, {370, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss2b;
