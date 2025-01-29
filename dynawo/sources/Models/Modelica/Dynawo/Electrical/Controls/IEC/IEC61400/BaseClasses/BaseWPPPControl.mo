within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseWPPPControl "Base active power control module for wind power plants (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Wind.IEC.Parameters.TablePControl;

  //Nominal parameter
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.IntegrationTimeStep;

  //PControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWPP;
  
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TablePwpBiasfwpFiltCom) annotation(
    Placement(visible = true, transformation(origin = {-102, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KwppRef) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpwpp) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31 annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = DPRefMaxPu, DyMin = DPRefMinPu, Y0 = (KwppRef - 1) * P0Pu * SystemBase.SnRef / SNom, YMax = PKiwppMaxPu, YMin = PKiwppMinPu, tI = if Kiwpp > 1e-5 then 1 / Kiwpp else 1 / Modelica.Constants.eps) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreezeLimDetection absLimRateLimFeedthroughFreezeLimDetection(DyMax = 999, DyMin = -999, U0 = -P0Pu * SystemBase.SnRef / SNom, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = PRefMaxPu, YMin = PRefMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DPwpRefMaxPu, DuMin = DPwpRefMinPu, Y0 = -P0Pu * SystemBase.SnRef / SNom, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPGrid;
  
equation
  connect(gain1.y, add31.u2) annotation(
    Line(points = {{62, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(gain.y, add31.u1) annotation(
    Line(points = {{22, 80}, {70, 80}, {70, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add31.u3) annotation(
    Line(points = {{62, -40}, {70, -40}, {70, -8}, {78, -8}}, color = {0, 0, 127}));
  connect(add31.y, absLimRateLimFeedthroughFreezeLimDetection.u) annotation(
    Line(points = {{102, 0}, {120, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, 50}, extent = {{-86, 52}, {-2, 6}}, textString = "WP"), Text(origin = {-10, 26}, extent = {{-94, 60}, {116, -54}}, textString = "PControl"), Text(origin = {22, -66}, extent = {{-94, 60}, {48, 12}}, textString = "Module")}));
end BaseWPPPControl;
