within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model LimiterWithLag_INIT "Initialization model of LimiterWithLag"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag_INIT;

equation
  y0 = if u0 < UMin then UMin elseif u0 > UMax then UMax else u0;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>In this model, <i>y0</i> complies with both <b>UMax</b> and <b>UMin</b>.</body></html>"));
end LimiterWithLag_INIT;
