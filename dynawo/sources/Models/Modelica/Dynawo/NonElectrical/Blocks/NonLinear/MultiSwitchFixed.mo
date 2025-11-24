within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

block MultiSwitchFixed "Switch between N Real signals, with fixed selection"

  parameter Integer nu(min=0) = 0 "Number of input connections" annotation(
    Dialog(connectorSizing=true), HideResult=true);
  parameter Integer f "Integer parameter to select the output signal";

  Modelica.Blocks.Interfaces.RealVectorInput u[nu] "Connector of Real vector input signal" annotation(
    Placement(transformation(extent={{-120,70},{-80,-70}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  Real v[nu];

equation
  assert(f + 1 <= nu, "MultiSwitch: Inputs must be consistent. However, there are not enough inputs connected :
    f + 1 (= " + String(f + 1) + ") > nu (= " + String(nu) + ")");
  assert(f >= 0, "MultiSwitch: f must be positive. However, f = " + String(f));

  for i in 1:nu loop
    if i == f+1 then
      v[i] = u[i];
    else
      v[i] = 0;
    end if;
  end for;

  y = sum(v);

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Line(points = {{-40, 44}, {2, -4}}, color = {0, 0, 127}, thickness = 1), Line(origin = {-2, -36}, points = {{-100, 80}, {-38, 80}}, color = {0, 0, 127}), Line(origin = {0, 40},points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(points = {{8, 0}, {100, 0}}, color = {0, 0, 127}), Ellipse(origin = {-8, 0}, lineColor = {0, 0, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{2, -8}, {18, 8}}, endAngle = 360), Line(origin = {0, 60}, points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(origin = {0, 100}, points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127}), Line(origin = {0, 80}, points = {{-100, -80}, {-40, -80}, {-40, -80}}, color = {0, 0, 127})}));
end MultiSwitchFixed;
