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

model REECc "WECC Renewable Energy Electrical Control model c"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC(limiter2.uMax = QMaxPu, limiter2.uMin = QMinPu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECcParameters;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {320, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Generated active power setpoint at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-360, -200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {290, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {290, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationC currentLimitsCalculation(IMaxPu = IMaxPu, PQFlag = PQFlag, SOC0 = SOC0, SOCMax = SOCMaxPu, SOCMin = SOCMinPu) annotation(
    Placement(visible = true, transformation(origin = {380, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {350, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / tBattery) annotation(
    Placement(visible = true, transformation(origin = {-290, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-150, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter5(uMax = SOCMaxPu, uMin = SOCMinPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = SOC0) annotation(
    Placement(visible = true, transformation(origin = {-290, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.ActivePowerPu PGen0Pu "Initial active power at terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit SOC0 "Initial state of charge in pu (base SNom)" annotation(
    Dialog(group = "Initialization"));

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
  connect(PGenPu, integrator.u) annotation(
    Line(points = {{-360, -200}, {-302, -200}}, color = {0, 0, 127}));
  connect(integrator.y, add5.u1) annotation(
    Line(points = {{-278, -200}, {-220, -200}, {-220, -214}, {-162, -214}}, color = {0, 0, 127}));
  connect(add5.y, limiter5.u) annotation(
    Line(points = {{-138, -220}, {-102, -220}}, color = {0, 0, 127}));
  connect(const.y, add5.u2) annotation(
    Line(points = {{-278, -240}, {-220, -240}, {-220, -226}, {-162, -226}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{372, 22}, {372, 88}, {398, 88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{388, 22}, {388, 72}, {398, 72}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{372, -22}, {372, -88}, {398, -88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{388, -22}, {388, -72}, {398, -72}}, color = {0, 0, 127}));
  connect(add3.y, variableLimiter1.u) annotation(
    Line(points = {{362, -80}, {398, -80}}, color = {0, 0, 127}));
  connect(PAuxPu, add3.u2) annotation(
    Line(points = {{320, -140}, {320, -86}, {338, -86}}, color = {0, 0, 127}));
  connect(division1.y, add3.u1) annotation(
    Line(points = {{302, -80}, {320, -80}, {320, -74}, {338, -74}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{182, -160}, {260, -160}, {260, -86}, {278, -86}}, color = {0, 0, 127}));
  connect(limiter5.y, currentLimitsCalculation.SOC) annotation(
    Line(points = {{-78, -220}, {380, -220}, {380, -22}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, currentLimitsCalculation.ipCmdPu) annotation(
    Line(points = {{422, -80}, {440, -80}, {440, -12}, {402, -12}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculation.iqCmdPu) annotation(
    Line(points = {{422, 80}, {440, 80}, {440, 12}, {402, 12}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculation.iqVdlPu) annotation(
    Line(points = {{302, 20}, {340, 20}, {340, 12}, {358, 12}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculation.ipVdlPu) annotation(
    Line(points = {{302, -20}, {340, -20}, {340, -12}, {358, -12}}, color = {0, 0, 127}));
  connect(UFilt2.y, IqmaxFromUPu.u) annotation(
    Line(points = {{-78, -100}, {240, -100}, {240, 20}, {278, 20}}, color = {0, 0, 127}));
  connect(UFilt2.y, IpmaxFromUPu.u) annotation(
    Line(points = {{-78, -100}, {240, -100}, {240, -20}, {278, -20}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC electrical inverter control model type C – recommended for BESS. It is depicted in the EPRI document Model User Guide for Generic Renewable Energy System Models (page 67), available for download at : <a href='https://www.epri.com/research/products/3002014083'>https://www.epri.com/research/products/3002014083 </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REECc.png\" alt=\"Renewable energy electrical controls model C (reec_c)\">
    <p> PGen is obtained from the measurement after the line. </p>
    <p> Following control modes can be activated: </p>
    <li> local coordinated V/Q control: QFlag = true, UFlag = true </li>
    <li> only plant level control active: QFlag = false, UFlag = false </li>
    <li> if plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false.</li>
    <p> The block calculates the ip and iq setpoint values for the generator converter based on the selected control algorithm. </p>
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "C"), Text(origin = {-110, 132}, extent = {{-22, 16}, {36, -28}}, textString = "PAuxPu"), Text(origin = {-64, -125}, extent = {{-20, 15}, {34, -27}}, textString = "PGenPu")}));
end REECc;
