within Dynawo.Electrical.Controls.WECC.REEC;

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

model REECc "WECC Electrical Control type C"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECc;

  // Input variable
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary input in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {227.5, -149.5}, extent = {{-13.5, -13.5}, {13.5, 13.5}}, rotation = 0), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculation1.iqMaxPu) annotation(
    Placement(visible = true, transformation(origin = {130, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculation1.iqMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {279, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {279, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu3(y = UFilteredPu) annotation(
    Placement(transformation(origin = {190, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu5(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {249, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationC currentLimitsCalculation1(IMaxPu = IMaxPu, PQFlag = PQFlag, SOC0Pu = SOC0Pu, SOCMaxPu = SOCMaxPu, SOCMinPu = SOCMinPu) annotation(
    Placement(visible = true, transformation(origin = {400, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {311, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tBattery) annotation(
    Placement(visible = true, transformation(origin = {270, -250}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {320, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = SOCMaxPu, uMin = SOCMinPu) annotation(
    Placement(visible = true, transformation(origin = {360, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(visible = true, transformation(origin = {264, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant SOCinit(k = SOC0Pu) annotation(
    Placement(visible = true, transformation(origin = {269, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameter
  parameter Types.PerUnit SOC0Pu "Initial state of charge in pu (base SNom)";

equation
  connect(limiter1.y, add1.u1) annotation(
    Line(points = {{275, 220}, {300, 220}, {300, 116}, {318, 116}}, color = {0, 0, 127}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{141, 130}, {156, 130}, {156, 118}, {168, 118}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{141, 90}, {157, 90}, {157, 106}, {168, 106}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IqmaxFromUPu.u) annotation(
    Line(points = {{260, 2}, {263, 2}, {263, -18}, {267, -18}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculation1.iqVdlPu) annotation(
    Line(points = {{290, -18}, {340, -18}, {340, -3.5}, {389, -3.5}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IpmaxFromUPu.u) annotation(
    Line(points = {{260, 2}, {263, 2}, {263, 22}, {267, 22}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculation1.ipVdlPu) annotation(
    Line(points = {{290, 22}, {343.5, 22}, {343.5, 4}, {389, 4}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{411, 7}, {480, 7}, {480, -112}, {499, -112}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{411, -3}, {480, -3}, {480, 118}, {498, 118}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{411, -7}, {470, -7}, {470, 102}, {498, 102}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-219, -40}, {-91, -40}, {-91, -70}, {53, -70}}, color = {0, 0, 127}));
  connect(division1.y, add2.u1) annotation(
    Line(points = {{192, -120}, {280, -120}, {280, -114}, {299, -114}}, color = {0, 0, 127}));
  connect(PAuxPu, add2.u2) annotation(
    Line(points = {{227.5, -149.5}, {280, -149.5}, {280, -126}, {299, -126}}, color = {0, 0, 127}));
  connect(add2.y, variableLimiter1.u) annotation(
    Line(points = {{322, -120}, {499, -120}}, color = {0, 0, 127}));
  connect(switch.u3, switch1.y) annotation(
    Line(points = {{15, 104}, {1, 104}, {1, 60}, {-100, 60}, {-100, 150}, {-109, 150}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{215, 220}, {252, 220}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{411, 3}, {470, 3}, {470, -128}, {499, -128}}, color = {0, 0, 127}));
  connect(feedback.y, limiter4.u) annotation(
    Line(points = {{329, -210}, {348, -210}}, color = {0, 0, 127}));
  connect(limiter4.y, currentLimitsCalculation1.SOCPu) annotation(
    Line(points = {{371, -210}, {400, -210}, {400, -11}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipCmdPu, variableLimiter1.y) annotation(
    Line(points = {{389, 8}, {370, 8}, {370, 20}, {530, 20}, {530, -120}, {522, -120}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqCmdPu, variableLimiter.y) annotation(
    Line(points = {{389, -7}, {370, -7}, {370, -20}, {530, -20}, {530, 110}, {521, 110}}, color = {0, 0, 127}));
  connect(integrator.y, feedback.u2) annotation(
    Line(points = {{281, -250}, {320, -250}, {320, -218}}, color = {0, 0, 127}));
  connect(PInjPu, integrator.u) annotation(
    Line(points = {{-270, 170}, {-249, 170}, {-249, -250}, {258, -250}}, color = {0, 0, 127}));
  connect(SOCinit.y, feedback.u1) annotation(
    Line(points = {{280, -210}, {312, -210}}, color = {0, 0, 127}));
  connect(UFilteredPu3.y, varLimPIDFreeze.u_m) annotation(
    Line(points = {{190, 82}, {180, 82}, {180, 100}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{142, -70}, {152, -70}, {152, -114}, {170, -114}}, color = {0, 0, 127}));
  connect(UPu, voltageCheck.UPu) annotation(
    Line(points = {{-270, 270}, {132, 270}, {132, 272}}, color = {0, 0, 127}));
  connect(add1.y, variableLimiter.u) annotation(
    Line(points = {{342, 110}, {498, 110}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, multiSwitch.u[1]) annotation(
    Line(points = {{141, 54}, {263, 54}, {263, 105}}, color = {0, 0, 127}));
  connect(varLimPIDFreeze.y, multiSwitch.u[2]) annotation(
    Line(points = {{191, 112}, {226.5, 112}, {226.5, 106}, {261, 106}, {261, 108.5}, {263, 108.5}, {263, 105}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{411, 7}, {510, 7}, {510, 30}, {550, 30}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, ipMinPu) annotation(
    Line(points = {{411, 3}, {520, 3}, {520, 10}, {550, 10}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{411, -3}, {520, -3}, {520, -10}, {550, -10}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, iqMinPu) annotation(
    Line(points = {{411, -7}, {510, -7}, {510, -30}, {550, -30}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {-19, 11}, extent = {{-45, 23}, {84, -40}}, textString = "REEC C"), Text(origin = {-48, 129}, extent = {{-18, 6}, {28, -8}}, textString = "PAuxPu")}));
end REECc;
