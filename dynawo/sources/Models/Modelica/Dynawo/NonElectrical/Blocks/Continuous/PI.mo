within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suit of time domain simulation tools for power systems.
*/
block PI "Dynawo usable version of the proportional integrator"

  import Dynawo.Connectors;
  import Dynawo.Types;
  import Modelica;
  import Dynawo.Connectors;

  Connectors.ZPin u(value(start = 0.0)) "Input connector" annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


  parameter Types.VoltageModule Y0 "Start value of the PI";
  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Time integration constant";

  //Modelica.Blocks.Interfaces.RealInput U(start = 0) "Value to be integrated" annotation(
  //  Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI pi(T = tIntegral, k = Gain, x_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y "Output value after integration." annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(u.value, pi.u) annotation(
    Line(points = {{-100, 0}, {-13, 0}, {-13, 0}, {-12, 0}}, color = {0, 0, 127}));
  //u.value = pi.u annotation(
  //  Line(points = {{-100, 0}, {-13, 0}, {-13, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(pi.y, y) annotation(
    Line(points = {{11, 0}, {101, 0}, {101, 0}, {110, 0}}, color = {0, 0, 127}));

end PI;
