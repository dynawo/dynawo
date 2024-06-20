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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PControl "Active power control module for wind power plants (IEC N°61400-27-1)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.PControlParameters;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //PControl parameters
  parameter Types.PerUnit DPRefMaxPu "Maximum positive ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPRefMinPu "Minimum negative ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMaxPu "Maximum positive ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMinPu "Minimum negative ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit KwppRef "Power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMaxPu "Maximum control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMinPu "Minimum negative control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMaxPu "Maximum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMinPu "Minimum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMaxPu "Maximum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMinPu "Minimum PD power reference in pu (base SNom)" annotation(
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

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TablePwpBiasfwpFiltCom) annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DPwpRefMaxPu, DuMin = DPwpRefMinPu, Y0 = -P0Pu * SystemBase.SnRef / SNom, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KwppRef) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpwpp) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = PErrMaxPu, uMin = PErrMinPu) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31 annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = DPRefMaxPu, DyMin = DPRefMinPu, Y0 = (KwppRef - 1) * P0Pu * SystemBase.SnRef / SNom, YMax = PKiwppMaxPu, YMin = PKiwppMinPu, tI = if Kiwpp > 1e-5 then 1 / Kiwpp else 1 / Modelica.Constants.eps) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreezeLimDetection absLimRateLimFeedthroughFreezeLimDetection(DyMax = 999, DyMin = -999, U0 = -P0Pu * SystemBase.SnRef / SNom, Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = PRefMaxPu, YMin = PRefMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(PWPRefComPu, rampLimiter.u) annotation(
    Line(points = {{-180, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(rampLimiter.y, add3.u2) annotation(
    Line(points = {{-118, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(omegaWPFiltComPu, combiTable1Ds.u) annotation(
    Line(points = {{-180, -40}, {-142, -40}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], add3.u3) annotation(
    Line(points = {{-118, -40}, {-110, -40}, {-110, -8}, {-102, -8}}, color = {0, 0, 127}));
  connect(PWPHookPu, add3.u1) annotation(
    Line(points = {{-180, 40}, {-110, 40}, {-110, 8}, {-102, 8}}, color = {0, 0, 127}));
  connect(add3.y, feedback.u1) annotation(
    Line(points = {{-78, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-78, 0}, {-60, 0}, {-60, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(feedback.y, limiter.u) annotation(
    Line(points = {{-30, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(limiter.y, antiWindupIntegrator.u) annotation(
    Line(points = {{22, 0}, {30, 0}, {30, -40}, {38, -40}}, color = {0, 0, 127}));
  connect(limiter.y, gain1.u) annotation(
    Line(points = {{22, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(gain1.y, add31.u2) annotation(
    Line(points = {{62, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(gain.y, add31.u1) annotation(
    Line(points = {{22, 80}, {70, 80}, {70, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add31.u3) annotation(
    Line(points = {{62, -40}, {70, -40}, {70, -8}, {78, -8}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, feedback.u2) annotation(
    Line(points = {{-180, -80}, {-40, -80}, {-40, -8}}, color = {0, 0, 127}));
  connect(add31.y, absLimRateLimFeedthroughFreezeLimDetection.u) annotation(
    Line(points = {{102, 0}, {120, 0}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.y, PPDRefPu) annotation(
    Line(points = {{142, 0}, {170, 0}}, color = {0, 0, 127}));
  connect(fWPFrt, absLimRateLimFeedthroughFreezeLimDetection.freeze) annotation(
    Line(points = {{0, -120}, {0, -80}, {130, -80}, {130, -10}}, color = {255, 0, 255}));
  connect(fWPFrt, or1.u[1]) annotation(
    Line(points = {{0, -120}, {0, -80}, {130, -80}, {130, -40}, {120, -40}}, color = {255, 0, 255}));
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
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, 24}, extent = {{-86, 52}, {-2, 6}}, textString = "WP"), Text(origin = {-10, 0}, extent = {{-94, 60}, {116, -54}}, textString = "PControl"), Text(origin = {22, -92}, extent = {{-94, 60}, {48, 12}}, textString = "Module")}));
end PControl;
