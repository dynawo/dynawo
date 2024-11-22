within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP;

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

model WPPPControl2015 "Active power control module for wind power plants (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseWPPPControl;

  //PControl parameters
  parameter Types.Time tpft "Lead time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tpfv "Lag time constant in the reference value transfer function in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tWPfFiltP "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.Time tWPPFiltP "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "PControlWP"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaWPPu(start = SystemBase.omegaRef0Pu) "Angular frequency communicated to WP in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power communicated to PD in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {240, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tWPPFiltP, k = 1, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tWPfFiltP, k = 1, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-136, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(visible = true, transformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or1(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction( a = {tpfv, 1},b = {tpft, 1}, x_start = {-P0Pu*SystemBase.SnRef/SNom}, y_start = -P0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreeze absLimRateLimFeedthroughFreeze(DyMax = DPRefMaxPu, DyMin = DPRefMinPu, U0 = -P0Pu*SystemBase.SnRef/SNom, Y0 = -P0Pu*SystemBase.SnRef/SNom, YMax = PRefMaxPu, YMin = PRefMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {204, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

equation
  connect(PWPRefPu, rampLimiter.u) annotation(
    Line(points = {{-180, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(PWPPu, firstOrder.u) annotation(
    Line(points = {{-180, -80}, {-142, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u2) annotation(
    Line(points = {{-118, -80}, {-40, -80}, {-40, -8}}, color = {0, 0, 127}));
  connect(add.y, feedback.u1) annotation(
    Line(points = {{-58, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], add.u2) annotation(
    Line(points = {{-90, -40}, {-88, -40}, {-88, -6}, {-82, -6}}, color = {0, 0, 127}));
  connect(omegaWPPu, firstOrder1.u) annotation(
    Line(points = {{-180, -40}, {-148, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, combiTable1Ds.u) annotation(
    Line(points = {{-124, -40}, {-114, -40}}, color = {0, 0, 127}));
  connect(rampLimiter.y, add.u1) annotation(
    Line(points = {{-118, 0}, {-98, 0}, {-98, 6}, {-82, 6}}, color = {0, 0, 127}));
  connect(add.y, gain.u) annotation(
    Line(points = {{-58, 0}, {-54, 0}, {-54, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{-30, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(feedback.y, antiWindupIntegrator.u) annotation(
    Line(points = {{-30, 0}, {0, 0}, {0, -40}, {38, -40}}, color = {0, 0, 127}));
  connect(booleanConstant.y, absLimRateLimFeedthroughFreezeLimDetection.freeze) annotation(
    Line(points = {{122, -90}, {130, -90}, {130, -10}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMax, or1.u[1]) annotation(
    Line(points = {{142, -6}, {148, -6}, {148, -40}, {120, -40}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMin, or1.u[2]) annotation(
    Line(points = {{142, 6}, {150, 6}, {150, -40}, {120, -40}}, color = {255, 0, 255}));
  connect(or1.y, antiWindupIntegrator.fMin) annotation(
    Line(points = {{98, -40}, {80, -40}, {80, -60}, {54, -60}, {54, -52}}, color = {255, 0, 255}));
  connect(or1.y, antiWindupIntegrator.fMax) annotation(
    Line(points = {{98, -40}, {80, -40}, {80, -60}, {58, -60}, {58, -52}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.y, transferFunction.u) annotation(
    Line(points = {{142, 0}, {158, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, absLimRateLimFeedthroughFreeze.u) annotation(
    Line(points = {{182, 0}, {194, 0}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreeze.y, PWTRefPu) annotation(
    Line(points = {{215, 0}, {240, 0}}, color = {0, 0, 127}));
  connect(booleanConstant.y, absLimRateLimFeedthroughFreeze.freeze) annotation(
    Line(points = {{122, -90}, {204, -90}, {204, -11}}, color = {255, 0, 255}));

  annotation(
    Icon(graphics = {Text(origin = {24, -110}, extent = {{-94, 60}, {48, 12}}, textString = "2015")}),
    Diagram(coordinateSystem(extent = {{-160, -100}, {230, 100}})));
end WPPPControl2015;
