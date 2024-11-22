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

model Ac7b "IEEE exciter type AC7B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc7(
    sum1.nin = 3,
    Ki = 0,
    Thetap = 0,
    XlPu = 0);

equation
  connect(potentialCircuit.vE, product.u1) annotation(
    Line(points = {{-378, 120}, {240, 120}, {240, 6}, {258, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(feedback.y, pid.u_s) annotation(
    Line(points = {{-270, -40}, {-82, -40}}, color = {0, 0, 127}));
  connect(pid.y, feedback1.u1) annotation(
    Line(points = {{-58, -40}, {92, -40}}, color = {0, 0, 127}));
  connect(limitedPI.y, product.u2) annotation(
    Line(points = {{162, -40}, {240, -40}, {240, -6}, {258, -6}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[2]) annotation(
    Line(points = {{-500, -100}, {-360, -100}, {-360, -40}, {-342, -40}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[3]) annotation(
    Line(points = {{-500, -140}, {-360, -140}, {-360, -40}, {-342, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac7b;
