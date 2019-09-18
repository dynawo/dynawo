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

model FirstOrderWithNonWindUpLimiter_INIT

  parameter Real K = 1 "Gain";
  parameter Real YMin  "Minimum allowed u";
  parameter Real YMax  "Maximum allowed u";

  Real y0LF "Initial y from loadflow";
  Real u0 "Initial input";
  Real y0 "Initial output, =y0LF if compliant with saturations";

equation

  K * u0 = y0LF;
  y0 = if (y0LF < YMin)  then YMin
         else if (y0LF > YMax) then YMax
         else y0LF;

end FirstOrderWithNonWindUpLimiter_INIT;
