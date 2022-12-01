within Dynawo.Electrical.Controls.IEC.BaseControls.WPP;

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

model QControl "Reactive power control module for wind power plants (IEC N°61400-27-1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.IEC.Parameters.QControlParameters;

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
  parameter Types.PerUnit RwpDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tUqFilt "Time constant for the UQ static mode in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqDipPu "Voltage threshold for UVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqRisePu "Voltage threshold for OVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMaxPu "Maximum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMinPu "Minimum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMaxPu "Maximum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMinPu "Minimum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMaxPu "Maximum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMinPu "Minimum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XwpDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PWPFiltComPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Filtered active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWPFiltComPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWPFiltComPu(start = U0Pu) "Filtered voltage module communicated to WP in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWPRefComPu(start = X0Pu) "Reference reactive power or voltage communicated to WP in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.BooleanOutput fWPFrt(start = false) "True if fault status" annotation(
    Placement(visible = true, transformation(origin = {330, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput xPDRefPu(start = XWT0Pu) "Reference reactive power or voltage communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {330, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.BaseClasses.VDrop vDrop(P0Pu = P0Pu, Q0Pu = Q0Pu, RDropPu = RwpDropPu, U0Pu = U0Pu, XDropPu = XwpDropPu) annotation(
    Placement(visible = true, transformation(origin = {-220, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = TableQwpMaxPwpFiltCom) annotation(
    Placement(visible = true, transformation(origin = {-190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = TableQwpMinPwpFiltCom) annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-220, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, table = TableQwpUErr) annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = UwpqRisePu) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = UwpqDipPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {-10, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = MwpqMode) annotation(
    Placement(visible = true, transformation(origin = {-110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kwpqu) annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = KwpqRef) annotation(
    Placement(visible = true, transformation(origin = {170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kpwpx) annotation(
    Placement(visible = true, transformation(origin = {170, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = XErrMaxPu, uMin = XErrMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {70, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {20, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {230, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreezeLimDetection absLimRateLimFeedthroughFreezeLimDetection(DyMax = DXRefMaxPu, DyMin = DXRefMinPu, Y0 = XWT0Pu, YMax = XRefMaxPu, YMin = XRefMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {270, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderFreeze absLimRateLimFirstOrderFreeze(DyMax = 999, Y0 = Q0Pu, YMax = 999, tI = tUqFilt) annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = 999, Y0 = (1 - KwpqRef) * XWT0Pu, YMax = XKiwpxMaxPu, YMin = XKiwpxMinPu, tI = if Kiwpx > 1e-5 then 1 / Kiwpx else 1 / Modelica.Constants.eps) annotation(
    Placement(visible = true, transformation(origin = {170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or or2(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {230, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit X0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(UWPFiltComPu, vDrop.UPu) annotation(
    Line(points = {{-340, -120}, {-300, -120}, {-300, -132}, {-242, -132}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, lessThreshold.u) annotation(
    Line(points = {{-198, -120}, {-160, -120}, {-160, -140}, {-122, -140}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, greaterThreshold.u) annotation(
    Line(points = {{-198, -120}, {-160, -120}, {-160, -100}, {-122, -100}}, color = {0, 0, 127}));
  connect(vDrop.UDropPu, feedback.u2) annotation(
    Line(points = {{-198, -120}, {-160, -120}, {-160, -80}, {-220, -80}, {-220, -68}}, color = {0, 0, 127}));
  connect(QWPFiltComPu, vDrop.QPu) annotation(
    Line(points = {{-340, -40}, {-280, -40}, {-280, -120}, {-242, -120}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, vDrop.PPu) annotation(
    Line(points = {{-340, 40}, {-260, 40}, {-260, -108}, {-242, -108}}, color = {0, 0, 127}));
  connect(xWPRefComPu, feedback.u1) annotation(
    Line(points = {{-340, 120}, {-240, 120}, {-240, -60}, {-228, -60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(lessThreshold.y, or1.u2) annotation(
    Line(points = {{-98, -140}, {-60, -140}, {-60, -128}, {-22, -128}}, color = {255, 0, 255}));
  connect(greaterThreshold.y, or1.u1) annotation(
    Line(points = {{-98, -100}, {-60, -100}, {-60, -120}, {-22, -120}}, color = {255, 0, 255}));
  connect(or1.y, fWPFrt) annotation(
    Line(points = {{2, -120}, {330, -120}}, color = {255, 0, 255}));
  connect(feedback.y, feedback1.u1) annotation(
    Line(points = {{-210, -60}, {-68, -60}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, product.u2) annotation(
    Line(points = {{-340, 40}, {-200, 40}, {-200, 54}, {-162, 54}}, color = {0, 0, 127}));
  connect(xWPRefComPu, product.u1) annotation(
    Line(points = {{-340, 120}, {-240, 120}, {-240, 66}, {-162, 66}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(PWPFiltComPu, combiTable1Ds1.u) annotation(
    Line(points = {{-340, 40}, {-300, 40}, {-300, 100}, {-202, 100}}, color = {0, 0, 127}));
  connect(PWPFiltComPu, combiTable1Ds.u) annotation(
    Line(points = {{-340, 40}, {-300, 40}, {-300, 140}, {-202, 140}}, color = {0, 0, 127}));
  connect(feedback.y, combiTable1Ds2.u) annotation(
    Line(points = {{-210, -60}, {-180, -60}, {-180, 20}, {-162, 20}}, color = {0, 0, 127}));
  connect(QWPFiltComPu, gain.u) annotation(
    Line(points = {{-340, -40}, {-280, -40}, {-280, -20}, {-122, -20}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{-98, -20}, {-60, -20}, {-60, -52}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add3.u3) annotation(
    Line(points = {{182, 60}, {200, 60}, {200, 92}, {218, 92}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u2) annotation(
    Line(points = {{182, 100}, {218, 100}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u1) annotation(
    Line(points = {{182, 140}, {200, 140}, {200, 108}, {218, 108}}, color = {0, 0, 127}));
  connect(limiter.y, gain2.u) annotation(
    Line(points = {{122, 100}, {158, 100}}, color = {0, 0, 127}));
  connect(limiter.y, antiWindupIntegrator.u) annotation(
    Line(points = {{122, 100}, {140, 100}, {140, 60}, {158, 60}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, limiter.u) annotation(
    Line(points = {{82, 100}, {98, 100}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], variableLimiter.limit1) annotation(
    Line(points = {{-178, 140}, {-50, 140}, {-50, 108}, {-42, 108}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(multiSwitch.y, variableLimiter.u) annotation(
    Line(points = {{-59, 100}, {-42, 100}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.y[1], absLimRateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-138, 20}, {-122, 20}}, color = {0, 0, 127}));
  connect(xWPRefComPu, multiSwitch.u[1]) annotation(
    Line(points = {{-340, 120}, {-140, 120}, {-140, 102}, {-80, 102}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(product.y, multiSwitch.u[2]) annotation(
    Line(points = {{-138, 60}, {-120, 60}, {-120, 100}, {-80, 100}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderFreeze.y, multiSwitch.u[3]) annotation(
    Line(points = {{-98, 20}, {-90, 20}, {-90, 98}, {-80, 98}}, color = {0, 0, 127}));
  connect(const.y, multiSwitch.u[4]) annotation(
    Line(points = {{-40, 40}, {-88, 40}, {-88, 96}, {-80, 96}}, color = {0, 0, 127}));
  connect(QWPFiltComPu, feedback2.u2) annotation(
    Line(points = {{-340, -40}, {-280, -40}, {-280, -20}, {-140, -20}, {-140, 0}, {20, 0}, {20, 92}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback2.u1) annotation(
    Line(points = {{-19, 100}, {12, 100}}, color = {0, 0, 127}));
  connect(feedback2.y, multiSwitch1.u[1]) annotation(
    Line(points = {{29, 100}, {40, 100}, {40, 102}, {60, 102}}, color = {0, 0, 127}));
  connect(feedback2.y, multiSwitch1.u[2]) annotation(
    Line(points = {{29, 100}, {60, 100}}, color = {0, 0, 127}));
  connect(feedback2.y, multiSwitch1.u[3]) annotation(
    Line(points = {{29, 100}, {40, 100}, {40, 98}, {60, 98}}, color = {0, 0, 127}));
  connect(feedback1.y, multiSwitch1.u[4]) annotation(
    Line(points = {{-50, -60}, {40, -60}, {40, 96}, {60, 96}}, color = {0, 0, 127}));
  connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{-98, 120}, {-70, 120}, {-70, 112}}, color = {255, 127, 0}));
  connect(integerConstant.y, multiSwitch1.f) annotation(
    Line(points = {{-98, 120}, {70, 120}, {70, 112}}, color = {255, 127, 0}));
  connect(add3.y, absLimRateLimFeedthroughFreezeLimDetection.u) annotation(
    Line(points = {{242, 100}, {260, 100}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.y, xPDRefPu) annotation(
    Line(points = {{282, 100}, {330, 100}}, color = {0, 0, 127}));
  connect(variableLimiter.y, gain1.u) annotation(
    Line(points = {{-19, 100}, {0, 100}, {0, 140}, {158, 140}}, color = {0, 0, 127}));
  connect(or1.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{2, -120}, {20, -120}, {20, -10}, {-110, -10}, {-110, 8}}, color = {255, 0, 255}));
  connect(or1.y, absLimRateLimFeedthroughFreezeLimDetection.freeze) annotation(
    Line(points = {{2, -120}, {270, -120}, {270, 90}}, color = {255, 0, 255}));
  connect(or1.y, or2.u[1]) annotation(
    Line(points = {{2, -120}, {270, -120}, {270, 20}, {240, 20}}, color = {255, 0, 255}));
  connect(or2.y, antiWindupIntegrator.fMin) annotation(
    Line(points = {{218, 20}, {174, 20}, {174, 48}}, color = {255, 0, 255}));
  connect(or2.y, antiWindupIntegrator.fMax) annotation(
    Line(points = {{218, 20}, {178, 20}, {178, 48}}, color = {255, 0, 255}));
  connect(combiTable1Ds1.y[1], variableLimiter.limit2) annotation(
    Line(points = {{-178, 100}, {-160, 100}, {-160, 80}, {-50, 80}, {-50, 92}, {-42, 92}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMax, or2.u[2]) annotation(
    Line(points = {{282, 94}, {290, 94}, {290, 20}, {240, 20}}, color = {255, 0, 255}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.fMin, or2.u[3]) annotation(
    Line(points = {{282, 106}, {300, 106}, {300, 20}, {240, 20}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-320, -160}, {320, 160}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {44, 24}, extent = {{-86, 52}, {-2, 6}}, textString = "WP"), Text(origin = {-10, 0}, extent = {{-94, 60}, {116, -54}}, textString = "QControl"), Text(origin = {22, -92}, extent = {{-94, 60}, {48, 12}}, textString = "Module")}));
end QControl;
