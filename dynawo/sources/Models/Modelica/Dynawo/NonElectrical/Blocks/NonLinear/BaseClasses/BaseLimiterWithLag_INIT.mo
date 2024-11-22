within Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses;

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

model BaseLimiterWithLag_INIT "Base initialization model for LimiterWithLag and LimiterAtCurrentValueWithLag"
  import Modelica.Constants;

  extends AdditionalIcons.Init;

  parameter Real UMax "Maximum allowed u";
  parameter Real UMin "Minimum allowed u";

  discrete Types.Time tUMaxReached0(start = Constants.inf) "Initial time when u went above UMax";
  discrete Types.Time tUMinReached0(start = Constants.inf) "Initial time when u went below UMin";

  Real u0 "Initial input";
  Real y0 "Initial output, =y0LF if compliant with saturations";
  Real y0LF "Initial y from loadflow";

equation
  u0 = y0LF;

  when u0 > UMax then
    tUMaxReached0 = -Constants.inf; // Init in steadystate, UMax has been reached for a long time
  elsewhen u0 <= UMax then
    tUMaxReached0 = Constants.inf;
  end when;

  when u0 < UMin then
    tUMinReached0 = -Constants.inf;
  elsewhen u0 >= UMin then
    tUMinReached0 = Constants.inf;
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The input of this model is <i>y0LF</i>. This value will initialize the limiter input variable, but since it could be out the saturation bounds, the initial value kept for y is <i>y0</i>.<div><br></div><div>If <i>u0</i> exceeds <b>UMax</b>, it is assumed that <b>UMax</b> has been crossed long before the simulation, hence <i>tUMaxReached0</i> is equal to minus infinity.<br><br>The same assumption is made regarding <b>UMin</b> and <i>tUMinReached0</i>.</div></body></html>"));
end BaseLimiterWithLag_INIT;
