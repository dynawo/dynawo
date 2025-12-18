within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model QLimiter2015 "Reactive power limitation module for wind turbines (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseQLimiter;

  //Qlimiter parameters
  parameter Types.Time tPFiltql "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.Time tUFiltql "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "QLimiter"));

  //Input variables
  Modelica.Blocks.Interfaces.IntegerInput fUvrt(start = 0) "Fault status (0: Normal operation, 1: During fault, 2: Post-fault)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWTPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze(DyMax = 999, Y0 = U0Pu, YMax = 999, tI = tUFiltql) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze1(DyMax = 999, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = 999, tI = tPFiltql) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(UWTPu, absLimRateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-140, 60}, {-82, 60}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, combiTable1Ds.u) annotation(
    Line(points = {{-59, 60}, {-50, 60}, {-50, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, combiTable1Ds1.u) annotation(
    Line(points = {{-59, 60}, {-50, 60}, {-50, 40}, {-42, 40}}, color = {0, 0, 127}));
  connect(fUvrt, integerToBoolean.u) annotation(
    Line(points = {{-140, 0}, {-102, 0}}, color = {255, 127, 0}));
  connect(integerToBoolean.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, 72}}, color = {255, 0, 255}));
  connect(PWTPu, absLimRateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-140, -60}, {-82, -60}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze1.y, combiTable1Ds2.u) annotation(
    Line(points = {{-58, -60}, {-50, -60}, {-50, -40}, {-42, -40}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze1.y, combiTable1Ds3.u) annotation(
    Line(points = {{-58, -60}, {-50, -60}, {-50, -80}, {-42, -80}}, color = {0, 0, 127}));
  connect(integerToBoolean.y, absLimRateLimFirstOrderFreeze1.freeze) annotation(
    Line(points = {{-78, 0}, {-70, 0}, {-70, -48}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-19, -26}, extent = {{-25, 22}, {61, -60}}, textString = "2015")}));
end QLimiter2015;
