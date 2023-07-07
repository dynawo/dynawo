within Dynawo.Electrical.Controls.WECC.REEC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model REECb "WECC Renewable Energy Electrical Control model b"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC(limiter2.uMax = QMaxPu, limiter2.uMin = QMinPu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECbParameters;

  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationB currentLimitsCalculation(IMaxPu = IMaxPu, PQFlag = PQFlag) annotation(
    Placement(visible = true, transformation(origin = {380, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(slewRateLimiter.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-138, -160}, {118, -160}}, color = {0, 0, 127}));
  connect(pfflagswitch.y, uflagswitch.u3) annotation(
    Line(points = {{-258, 40}, {-240, 40}, {-240, -60}, {-60, -60}, {-60, 32}, {-42, 32}}, color = {0, 0, 127}));
  connect(pfflagswitch.y, division.u1) annotation(
    Line(points = {{-258, 40}, {-240, 40}, {-240, -60}, {0, -60}, {0, -54}, {18, -54}}, color = {0, 0, 127}));
  connect(limiter.y, varLimPIDFreeze.u_s) annotation(
    Line(points = {{22, 40}, {78, 40}}, color = {0, 0, 127}));
  connect(UInjPu, voltageCheck.UPu) annotation(
    Line(points = {{-220, 200}, {-180, 200}, {-180, 220}, {-100, 220}}, color = {0, 0, 127}));
  connect(limiter1.y, add1.u1) annotation(
    Line(points = {{102, 160}, {240, 160}, {240, 86}, {278, 86}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{182, -160}, {260, -160}, {260, -86}, {278, -86}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{302, -80}, {398, -80}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, currentLimitsCalculation.ipCmdPu) annotation(
    Line(points = {{422, -80}, {440, -80}, {440, -12}, {402, -12}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculation.iqCmdPu) annotation(
    Line(points = {{422, 80}, {440, 80}, {440, 12}, {402, 12}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{388, 22}, {388, 72}, {398, 72}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{372, 22}, {372, 88}, {398, 88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{372, -22}, {372, -88}, {398, -88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{388, -22}, {388, -72}, {398, -72}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC electrical inverter control model type B – recommended for PV. It is depicted in the EPRI document Model User Guide for Generic Renewable Energy System Models (page 66), available for download at : <a href='https://www.epri.com/research/products/3002014083'>https://www.epri.com/research/products/3002014083 </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REECb.png\" alt=\"Renewable energy electrical controls model B (reec_b)\">
    <p> Following control modes can be activated: </p>
    <li> local coordinated V/Q control: QFlag = true, UFlag = true </li>
    <li> only plant level control active: QFlag = false, UFlag = false </li>
    <li> if plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false.</li>
    <p> The block calculates the ip and iq setpoint values for the generator converter based on the selected control algorithm. </p>
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "B")}));
end REECb;
