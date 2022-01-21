within Dynawo.Electrical.Controls.Machines.Governors.IEEE;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model TGOV1 "IEEE Governor type TGOV1"

  import Modelica;
  import Modelica.Blocks.Interfaces;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  //Input variables
  Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-140, -50}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Interfaces.RealInput PmRefPu(start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-140, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));

  //Output variables
  Interfaces.RealOutput PmPu(start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit R "Controller droop";
  parameter Types.Time Tg1 "Governor time constant in s";
  parameter Types.Time Tg2 "Turbine derivative time constant in s";
  parameter Types.Time Tg3 "Turbine delay time constant in s";
  parameter Types.PerUnit Dt "Frictional losses factor";
  parameter Types.PerUnit VMin "Minimum gate limit";
  parameter Types.PerUnit VMax "Maximum gate limit";

  Modelica.Blocks.Math.Gain droop(k = 1 / R) annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderLimiter firstOrderLim(T = Tg1,yMax = VMax, yMin = VMin, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LeadLag leadLag(T1 = Tg2, T2 = Tg3, y_start = Pm0Pu)  annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain friction(k = Dt) annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-100, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in p.u (base PNom)";

equation
  connect(firstOrderLim.y, leadLag.u) annotation(
    Line(points = {{-9, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(leadLag.y, feedback1.u1) annotation(
    Line(points = {{41, 0}, {72, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, PmPu) annotation(
    Line(points = {{90, 0}, {110, 0}, {110, 0}, {116, 0}}, color = {0, 0, 127}));
  connect(friction.y, feedback1.u2) annotation(
    Line(points = {{-18, -50}, {80, -50}, {80, -10}, {80, -10}, {80, -8}}, color = {0, 0, 127}));
  connect(omegaPu, feedback2.u1) annotation(
    Line(points = {{-140, -50}, {-108, -50}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback2.u2) annotation(
    Line(points = {{-119, -80}, {-100, -80}, {-100, -58}}, color = {0, 0, 127}));
  connect(feedback2.y, friction.u) annotation(
    Line(points = {{-91, -50}, {-42, -50}}, color = {0, 0, 127}));
  connect(droop.y, feedback.u2) annotation(
    Line(points = {{-70, -18}, {-70, -18}, {-70, -8}, {-70, -8}}, color = {0, 0, 127}));
  connect(feedback2.y, droop.u) annotation(
    Line(points = {{-91, -50}, {-70, -50}, {-70, -42}}, color = {0, 0, 127}));
  connect(feedback.y, firstOrderLim.u) annotation(
    Line(points = {{-60, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(PmRefPu, feedback.u1) annotation(
    Line(points = {{-140, 0}, {-80, 0}, {-80, 0}, {-78, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")));
end TGOV1;
