within Dynawo.NonElectrical.Blocks.NonLinear;

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

model LimiterAtCurrentValueWithLag_INIT "Initialization model of LimiterAtCurrentValueWithLag"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag_INIT;

equation
  y0 = if u0 > UMax then UMax else u0;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>In this model, <i>y0</i> complies only with <b>UMax</b>.</body></html>"));
end LimiterAtCurrentValueWithLag_INIT;
