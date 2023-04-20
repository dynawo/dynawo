within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.OEL;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model MAXEX2
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  
  parameter Types.PerUnit Kmx = 0.2 "Over excitation limitation integrator gain coefficient.";
  parameter Types.PerUnit ULowPu = -0.05 "Lower limit of over excitation limitation.";
  parameter Types.PerUnit XfdRatedPu = 2.6355 "Synchronous generator rated field current or voltage";
  parameter Types.PerUnit XfdDesPu = 1 "Field current or voltage setpoint";
  parameter Types.PerUnit Xfd0Pu "Initial value of input XfdPu";
  parameter Types.PerUnit XfdRef0Pu = XfdRatedPu * E3 "Initial value of XfdRefPu";
  parameter Types.PerUnit Uoel0Pu = 0 "Initial value of UoelPu";
  parameter Types.Time T1 = 60 "Time of first characteristic point in s";
  parameter Types.Time T2 = 30 "Time of second characteristic point in s";
  parameter Types.Time T3 = 15 "Time of third characteristic point in s";
  parameter Types.PerUnit E1 = 1.1 "First field current or field voltage reference characteristic point in pu (base XfdRatedPu)";
  parameter Types.PerUnit E2 = 1.2 "Second field current or field voltage reference characteristic point in pu (base XfdRatedPu)";
  parameter Types.PerUnit E3 = 1.5 "Third field current or field voltage reference characteristic point in pu (base XfdRatedPu)";
  parameter Types.PerUnit XfdPu_activation_threshold = E1 "XfdPu threshold where the OEL activates, should be the rightmost point in the characteristic (in the RVS case, it's 1.5 XfdPu)"; 
  parameter Types.PerUnit XfdPu_deactivation_threshold = 0.98 * XfdPu_activation_threshold "XfdPu threshold where the OEL deactivates";
  
  Modelica.Blocks.Interfaces.RealInput XfdPu "Synchronous generator field voltage or current. (non-reciprocal pu base)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UoelPu "Over excitation limitation output, usually as negative addition term to stator voltage." annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.OEL.InvTimeChar invTimeChar(E1 = E1, E2 = E2, E3 = E3, T1 = T1, T2 = T2, T3 = T3,Xfd0Pu = Xfd0Pu, XfdDesPu = XfdDesPu, XfdPu_activation_threshold = XfdPu_activation_threshold, XfdPu_deactivation_threshold = XfdPu_deactivation_threshold, XfdRatedPu = XfdRatedPu, XfdRef0Pu = XfdRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-20, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kmx, outMax = 0, outMin = -0.05, strict = true)  annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {20, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(XfdPu, invTimeChar.XfdPu) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 40}, {-30, 40}}, color = {0, 0, 127}));
  connect(limIntegrator.y, UoelPu) annotation(
    Line(points = {{72, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(add.y, limIntegrator.u) annotation(
    Line(points = {{31, 6}, {40, 6}, {40, 0}, {48, 0}}, color = {0, 0, 127}));
  connect(invTimeChar.XfdRefPu, add.u1) annotation(
    Line(points = {{-10, 40}, {0, 40}, {0, 12}, {8, 12}}, color = {0, 0, 127}));
  connect(XfdPu, add.u2) annotation(
    Line(points = {{-120, 0}, {8, 0}}, color = {0, 0, 127}));
annotation(
    Diagram(coordinateSystem(extent = {{-100, -60}, {100, 60}})));
end MAXEX2;
