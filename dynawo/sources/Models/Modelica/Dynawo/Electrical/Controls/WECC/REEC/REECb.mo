within Dynawo.Electrical.Controls.WECC.REEC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model REECb "WECC Electrical Control type B"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;

  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationB currentLimitsCalculationB(IMaxPu = IMaxPu, PQFlag = PQFlag) annotation(
    Placement(visible = true, transformation(origin = {400, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 0.01, y_start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {440, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 0.01, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {440, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculationB.iqMaxPu) annotation(
    Placement(visible = true, transformation(origin = {130, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculationB.iqMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-39, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu3(y = UFilteredPu) annotation(
    Placement(transformation(origin = {190, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant VRefConst1(k = VRef1Pu) annotation(
    Placement(visible = true, transformation(origin = {-79, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(firstOrder3.y, currentLimitsCalculationB.ipCmdPu) annotation(
    Line(points = {{429, 50}, {420, 50}, {420, 34}, {411, 34}}, color = {0, 0, 127}));
  connect(firstOrder2.y, currentLimitsCalculationB.iqCmdPu) annotation(
    Line(points = {{429, 10}, {420, 10}, {420, 26}, {411, 26}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{389, 36}, {380, 36}, {380, 70}, {480, 70}, {480, -128}, {499, -128}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{389, 32}, {360, 32}, {360, 90}, {490, 90}, {490, -112}, {499, -112}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, firstOrder3.u) annotation(
    Line(points = {{522, -120}, {530, -120}, {530, -140}, {460, -140}, {460, 50}, {452, 50}}, color = {0, 0, 127}));
  connect(variableLimiter.y, firstOrder2.u) annotation(
    Line(points = {{521, 110}, {530, 110}, {530, 130}, {470, 130}, {470, 10}, {452, 10}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{389, 24}, {380, 24}, {380, -10}, {480, -10}, {480, 118}, {498, 118}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{389, 28}, {360, 28}, {360, -30}, {490, -30}, {490, 102}, {498, 102}}, color = {0, 0, 127}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{141, 130}, {150, 130}, {150, 118}, {168, 118}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{141, 90}, {150, 90}, {150, 106}, {168, 106}}, color = {0, 0, 127}));
  connect(switch1.y, add2.u2) annotation(
    Line(points = {{-109, 150}, {-100, 150}, {-100, 74}, {-51, 74}}, color = {0, 0, 127}));
  connect(VRefConst1.y, add2.u1) annotation(
    Line(points = {{-68, 100}, {-60, 100}, {-60, 86}, {-51, 86}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-219, -40}, {-91, -40}, {-91, -70}, {53, -70}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{192, -120}, {499, -120}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{215, 220}, {300, 220}, {300, 116}, {318, 116}}, color = {0, 0, 127}));
  connect(add2.y, switch.u3) annotation(
    Line(points = {{-28, 80}, {1, 80}, {1, 104}, {15, 104}}, color = {0, 0, 127}));
  connect(UFilteredPu3.y, varLimPIDFreeze.u_m) annotation(
    Line(points = {{190, 82}, {178, 82}, {178, 100}, {180, 100}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{142, -70}, {156, -70}, {156, -114}, {170, -114}}, color = {0, 0, 127}));
  connect(UPu, voltageCheck.UPu) annotation(
    Line(points = {{-270, 270}, {130, 270}}, color = {0, 0, 127}));
  connect(add1.y, variableLimiter.u) annotation(
    Line(points = {{342, 110}, {498, 110}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, multiSwitch.u[1]) annotation(
    Line(points = {{141, 54}, {263, 54}, {263, 105}}, color = {0, 0, 127}));
  connect(varLimPIDFreeze.y, multiSwitch.u[2]) annotation(
    Line(points = {{191, 112}, {226.5, 112}, {226.5, 106}, {261, 106}, {261, 108.5}, {263, 108.5}, {263, 105}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{389, 32}, {360, 32}, {360, 90}, {520, 90}, {520, 30}, {550, 30}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.ipMinPu, ipMinPu) annotation(
    Line(points = {{389, 36}, {380, 36}, {380, 70}, {510, 70}, {510, 10}, {550, 10}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{389, 24}, {380, 24}, {380, -10}, {550, -10}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationB.iqMinPu, iqMinPu) annotation(
    Line(points = {{389, 28}, {360, 28}, {360, -30}, {550, -30}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the electrical inverter control of the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> Following control modes can be activated:
<li> local coordinated V/Q control: QFlag = true, VFlag = true </li>
<li> only plant level control active: QFlag = false, VFlag = false</li>
<li> if plant level control not connected: local power factor control: PfFlag = true, otherwise PfFlag = false.</li>
<p> The block calculates the idCmdPu and iqCmdPu setpoint values for the generator control based on the selected control algorithm.
</ul> </p></html>"),
    Diagram(coordinateSystem(initialScale = 0.2)),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {137, 79}, extent = {{-23, 13}, {35, -21}}, textString = "idCmdPu"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "frtOn"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu"), Text(origin = {-9, 10}, extent = {{-43, 22}, {80, -38}}, textString = "REEC B")}, coordinateSystem(initialScale = 0.1, preserveAspectRatio = false)));
end REECb;
