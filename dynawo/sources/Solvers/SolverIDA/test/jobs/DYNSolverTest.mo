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

//DYNSolverTestAlpha
//Test for simple "IF"
model DYNSolverTestAlpha
  Real x (start = -2);
  Real y;
equation
  der(x) = 1;
  if ( x <=  0 ) then
    y = -1;
  else
    y = 1;
  end if;
end DYNSolverTestAlpha;

//DYNSolverTestBeta
//Test for simple "when"
model DYNSolverTestBeta
//  Real x (start = -2.5);
  Real x (start = -2);
  discrete Real y;
equation
  der(x) = 1 ;
  when ( x <=  0 ) then
    y = -1;
  elsewhen ( x > 0 ) then
    y = 1;
  end when;
end DYNSolverTestBeta;

connector ZPin "connector for propagating discrete values (and events)"
  public
    discrete Real value;
end ZPin;

model DYNDisconnection
  ZPin switchOff (value(start = 2));
equation
  when (time > 1) then
    switchOff.value = 1;
  end when;
end DYNDisconnection;

connector ACPower "connector for AC power (described using complex V and i variables)"
  public
    Complex V "Complex AC voltage";
    flow Complex i "Complex AC current (positive when entering the device)";
  annotation(Icon(graphics = {Rectangle(extent = {{-100, 98}, {100, -102}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid)}));
end ACPower;

model DYNInfiniteBus "Infinite bus"

  import Complex "Complex numbers foundation class";
  import Modelica.ComplexMath "Complex numbers operators (+, - , *, exp, abs...)";
  import Modelica.SIunits "Modelica SI units";

  ACPower terminal;
  parameter Real U = 1;
  parameter Real Teta = 0;

equation
  terminal.V = U * ComplexMath.exp(ComplexMath.j * Teta);
end DYNInfiniteBus;

connector ImPin "connector for continuous real value"
  public
    Real value;
end ImPin;

model DYNDerivative
  Real y (start = 0);
  ImPin x;
equation
  der(y) = x.value;
end DYNDerivative;
