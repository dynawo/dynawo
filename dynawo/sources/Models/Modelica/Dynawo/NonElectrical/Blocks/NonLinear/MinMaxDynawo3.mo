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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block MinMaxDynawo3 "Output the minimum and the maximum element of the three signals"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealVectorInput u[3] annotation (Placement(transformation(extent={{-120,70},{-80,-70}})));
  Modelica.Blocks.Interfaces.RealOutput yMax annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput yMin annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

equation
  if u[1] < u[2] and u[1] < u[3] then
    yMin = u[1];
  elseif u[2] < u[1] and u[2] < u[3] then
    yMin = u[2];
  else
    yMin = u[3];
  end if;

  if u[1] > u[2] and u[1] > u[3] then
    yMax = u[1];
  elseif u[2] > u[1] and u[2] > u[3] then
    yMax = u[2];
  else
    yMax = u[3];
  end if;

  annotation (Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Text(
            extent={{-12,80},{100,40}},
            textString="yMax"), Text(
            extent={{-10,-40},{100,-80}},
            textString="yMin")}), Documentation(info="<html>
<p>
Determines the minimum and maximum element of the input vector and
provide both values as output.
</p>
</html>"));
end MinMaxDynawo3;
