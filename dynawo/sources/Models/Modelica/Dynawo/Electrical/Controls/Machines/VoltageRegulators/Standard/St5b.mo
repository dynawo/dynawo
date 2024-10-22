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

model St5b "IEEE exciter type ST5B model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt5(
    max1.nu = 2,
    min1.nu = 2);

equation
  if min1.yMin < add3.y then
    limiter.u = limitedLeadLag2.y;
  elseif max1.yMax > add3.y then
    limiter.u = limitedLeadLag1.y;
  else
    limiter.u = limitedLeadLag.y;
  end if;

  max1.u[2] = UUelPu;
  min1.u[2] = UOelPu;

  connect(add3.y, max1.u[1]) annotation(
    Line(points = {{-239, -20}, {-160, -20}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St5b;
