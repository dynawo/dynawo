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

model St6b "IEEE exciter type ST6B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt6(
    Ki = 0,
    XlPu = 0,
    sum1.nin = 2,
    sum2.nin = 3);

equation
  if PositionOel == 1 then
    sum1.u[2] = UOelPu;
    min1.u[2] = min1.u[1];
    sum2.u[3] = 0;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 2 then
    sum1.u[2] = 0;
    min1.u[2] = UOelPu;
    sum2.u[3] = 0;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 3 then
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    sum2.u[3] = UOelPu;
    min2.u[2] = min2.u[1];
  elseif PositionOel == 4 then
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    sum2.u[3] = 0;
    min2.u[2] = UOelPu;
  else
    sum1.u[2] = 0;
    min1.u[2] = min1.u[1];
    sum2.u[3] = 0;
    min2.u[2] = min2.u[1];
  end if;

  connect(limiter.y, min2.u[1]) annotation(
    Line(points = {{102, -80}, {160, -80}, {160, -74}, {200, -74}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, division.u2) annotation(
    Line(points = {{-378, 140}, {-200, 140}, {-200, 154}, {-182, 154}}, color = {0, 0, 127}));
  connect(potentialCircuit.vE, product1.u2) annotation(
    Line(points = {{-378, 140}, {-200, 140}, {-200, 134}, {-82, 134}}, color = {0, 0, 127}));
  connect(min4.y, product.u2) annotation(
    Line(points = {{281, -20}, {340, -20}, {340, -6}, {358, -6}}, color = {0, 0, 127}));
  connect(UUelPu, max1.u[2]) annotation(
    Line(points = {{-460, -120}, {-260, -120}, {-260, -60}, {-240, -60}}, color = {0, 0, 127}));
  connect(const3.y, limPI1.limitMax) annotation(
    Line(points = {{-158, 0}, {-80, 0}, {-80, -94}, {-62, -94}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St6b;
