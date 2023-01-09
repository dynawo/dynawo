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


model LimiterWithLag_INIT "LimiterWithLag INIT Model. Here the input is y0LF. This value will initialize the limiter's input variable, but since it could be out the saturation bounds, the initial value kept for y is y0 which is min(max(y0LF, UMin), UMax)"

  import Modelica.Constants;

  extends AdditionalIcons.Init;

  parameter Real UMin "Minimum allowed u";
  parameter Real UMax "Maximum allowed u";

  Real y0LF "Initial y from loadflow";
  Real u0 "Initial input";
  Real y0 "Initial output, =y0LF if compliant with saturations";
  discrete Types.Time tUMinReached0(start = Constants.inf) "Initial time when u went below UMin";
  discrete Types.Time tUMaxReached0(start = Constants.inf) "Initial time when u went above UMax";

equation

  u0 = y0LF;
  y0 = if (u0 < UMin) then UMin
         else if (u0 > UMax) then UMax
         else u0;

  // Lower Excitation Limit
  when u0 < UMin then
    tUMinReached0 = -Constants.inf;
  elsewhen u0 >= UMin then
    tUMinReached0 = Constants.inf;
  end when;

  // Upper Excitation Limit
  when u0 > UMax then
    tUMaxReached0 = -Constants.inf; // Init in steadystate, UMax has been reached for a long time
  elsewhen u0 <= UMax then
    tUMaxReached0 = Constants.inf;
  end when;

  annotation(preferredView = "text");
end LimiterWithLag_INIT;
