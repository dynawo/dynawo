within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPPPControl2020 "Active power control module for wind power plants (IEC N°61400-27-1:2020)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseWPPPControl;

  //PControl parameters
  parameter Types.ActivePowerPu PErrMaxPu "Maximum control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMinPu "Minimum negative control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput fWPFrt(start = false) "True if fault status" annotation(
    Placement(visible = true, transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaWPFiltComPu(start = SystemBase.omegaRef0Pu) "Filtered angular frequency communicated to WP in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPFiltComPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPHookPu(start = 0) "WP hook active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PWPRefComPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PPDRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power communicated to PD in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = PErrMaxPu, uMin = PErrMinPu) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(PWPRefComPu, rampLimiter.u) annotation(
    Line(points = {{-180, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(feedback.y, limiter.u) annotation(
    Line(points = {{-30, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(limiter.y, antiWindupIntegrator.u) annotation(
    Line(points = {{22, 0}, {30, 0}, {30, -40}, {38, -40}}, color = {0, 0, 127}));
  connect(limiter.y, gain1.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(rampLimiter.y, add3.u2) annotation(
    Line(points = {{-118, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(PWPHookPu, add3.u1) annotation(
    Line(points = {{-180, 40}, {-110, 40}, {-110, 8}, {-102, 8}}, color = {0, 0, 127}));
  connect(add3.y, feedback.u1) annotation(
    Line(points = {{-78, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-78, 0}, {-60, 0}, {-60, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, feedback.u2) annotation(
    Line(points = {{-180, -80}, {-40, -80}, {-40, -8}}, color = {0, 0, 127}));
  connect(omegaWPFiltComPu, combiTable1Ds.u) annotation(
    Line(points = {{-180, -40}, {-114, -40}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], add3.u3) annotation(
    Line(points = {{-90, -40}, {-80, -40}, {-80, -20}, {-110, -20}, {-110, -8}, {-102, -8}}, color = {0, 0, 127}));
  connect(fWPFrt, absLimRateLimFeedthroughFreezeLimDetection.freeze) annotation(
    Line(points = {{0, -120}, {0, -80}, {130, -80}, {130, -10}}, color = {255, 0, 255}));
  connect(fWPFrt, or1.u[1]) annotation(
    Line(points = {{0, -120}, {0, -80}, {130, -80}, {130, -40}, {120, -40}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.y, PPDRefPu) annotation(
    Line(points = {{142, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMax, or1.u[2]) annotation(
    Line(points = {{142, -6}, {148, -6}, {148, -40}, {120, -40}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMin, or1.u[3]) annotation(
    Line(points = {{142, 6}, {150, 6}, {150, -40}, {120, -40}}, color = {255, 0, 255}));
  connect(or1.y, antiWindupIntegrator.fMin) annotation(
    Line(points = {{98, -40}, {80, -40}, {80, -60}, {54, -60}, {54, -52}}, color = {255, 0, 255}));
  connect(or1.y, antiWindupIntegrator.fMax) annotation(
    Line(points = {{98, -40}, {80, -40}, {80, -60}, {58, -60}, {58, -52}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {24, -110}, extent = {{-94, 60}, {48, 12}}, textString = "2020")}));
end WPPPControl2020;
