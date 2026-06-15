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

model BaseWPPQControl "Reactive power control base module for wind power plants (IEC N°61400-27-1)"
  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //QControl parameters
  parameter Types.PerUnit DXRefMaxPu "Maximum positive ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit DXRefMinPu "Minimum negative ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power or voltage PI controller integral gain in pu/s (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power or voltage PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit KwpqRef "Reactive power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tUqFilt "Time constant for the UQ static mode in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqDipPu "Voltage threshold for UVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMaxPu "Maximum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMinPu "Minimum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMaxPu "Maximum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMinPu "Minimum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint) annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = UwpqDipPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = MwpqMode) annotation(
    Placement(visible = true, transformation(origin = {-110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kwpqu) annotation(
    Placement(visible = true, transformation(origin = {-110, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = KwpqRef) annotation(
    Placement(visible = true, transformation(origin = {170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kpwpx) annotation(
    Placement(visible = true, transformation(origin = {170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {230, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreezeLimDetection absLimRateLimFeedthroughFreezeLimDetection(DyMax = 9999, DyMin = -9999, U0 = XWT0Pu, Y0 = XWT0Pu, YMax = XRefMaxPu, YMin = XRefMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {260, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze(DyMax = 999, Y0 = Q0Pu, YMax = 999, tI = tUqFilt) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {230, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = 999, Y0 = (1 - KwpqRef) * XWT0Pu, YMax = XKiwpxMaxPu, YMin = XKiwpxMinPu, tI = if Kiwpx > 1e-5 then 1 / Kiwpx else 1 / Modelica.Constants.eps) annotation(
    Placement(visible = true, transformation(origin = {170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit X0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(feedback.y, combiTable1Ds2.u) annotation(
    Line(points = {{-211, 0}, {-180, 0}, {-180, 20}, {-162, 20}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u2) annotation(
    Line(points = {{182, 100}, {218, 100}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u1) annotation(
    Line(points = {{182, 140}, {200, 140}, {200, 108}, {218, 108}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], absLimRateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-138, 20}, {-122, 20}}, color = {0, 0, 127}));
  connect(product.y, multiSwitch.u[2]) annotation(
    Line(points = {{-138, 60}, {-120, 60}, {-120, 100}, {-80, 100}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, multiSwitch.u[3]) annotation(
    Line(points = {{-98, 20}, {-90, 20}, {-90, 98}, {-80, 98}}, color = {0, 0, 127}));
  connect(const.y, multiSwitch.u[4]) annotation(
    Line(points = {{-40, 40}, {-88, 40}, {-88, 96}, {-80, 96}}, color = {0, 0, 127}));
  connect(feedback2.y, multiSwitch1.u[1]) annotation(
    Line(points = {{29, 100}, {40, 100}, {40, 102}, {60, 102}}, color = {0, 0, 127}));
  connect(feedback2.y, multiSwitch1.u[2]) annotation(
    Line(points = {{29, 100}, {60, 100}}, color = {0, 0, 127}));
  connect(feedback2.y, multiSwitch1.u[3]) annotation(
    Line(points = {{29, 100}, {40, 100}, {40, 98}, {60, 98}}, color = {0, 0, 127}));
  connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{-98, 120}, {-70, 120}, {-70, 112}}, color = {255, 127, 0}));
  connect(integerConstant.y, multiSwitch1.f) annotation(
    Line(points = {{-98, 120}, {70, 120}, {70, 112}}, color = {255, 127, 0}));
  connect(antiWindupIntegrator.y, add3.u3) annotation(
    Line(points = {{182, 60}, {200, 60}, {200, 92}, {218, 92}}, color = {0, 0, 127}));
  connect(add3.y, absLimRateLimFeedthroughFreezeLimDetection.u) annotation(
    Line(points = {{242, 100}, {250, 100}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMax, or2.u[2]) annotation(
    Line(points = {{272, 106}, {280, 106}, {280, 20}, {240, 20}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMin, or2.u[3]) annotation(
    Line(points = {{272, 94}, {280, 94}, {280, 20}, {240, 20}}, color = {255, 0, 255}));
  connect(feedback1.y, multiSwitch1.u[4]) annotation(
    Line(points = {{-51, -60}, {40, -60}, {40, 96}, {60, 96}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{-98, -72}, {-60, -72}, {-60, -68}}, color = {0, 0, 127}));
  connect(feedback.y, feedback1.u1) annotation(
    Line(points = {{-210, 0}, {-80, 0}, {-80, -60}, {-68, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-320, -160}, {350, 160}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, 50}, extent = {{-86, 52}, {-2, 6}}, textString = "WP"), Text(origin = {-10, 26}, extent = {{-94, 60}, {116, -54}}, textString = "QControl"), Text(origin = {22, -66}, extent = {{-94, 60}, {48, 12}}, textString = "Module"), Text(origin = {22, -66}, extent = {{-94, 60}, {48, 12}}, textString = "Module")}));
end BaseWPPQControl;
