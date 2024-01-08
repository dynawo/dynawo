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

model REECa "WECC Renewable Energy Electrical Control model a"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC(limiter2.uMax = QMaxPu, limiter2.uMin = QMinPu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECaParameters;

  //Input variable
  Modelica.Blocks.Interfaces.RealInput omegaGPu(start = SystemBase.omegaRef0Pu) "Generator frequency from drive train control in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -120}, extent = {{-20, 20}, {20, -20}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));

  Modelica.Blocks.Sources.BooleanConstant booleanConstant3(k = PFlag) annotation(
    Placement(visible = true, transformation(origin = {-30, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch pflagswitch annotation(
    Placement(visible = true, transformation(origin = {30, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-90, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant VRefConst1(k = VRef1Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-60, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRT4(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {290, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {290, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.IqInjectionLogic iqInjectionLogic(IqFrzPu = IqFrzPu, tHld = tHld) annotation(
    Placement(visible = true, transformation(origin = {210, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationA currentLimitsCalculation(IMaxPu = IMaxPu, PQFlag = PQFlag, tHld2 = tHld2) annotation(
    Placement(visible = true, transformation(origin = {380, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRT5(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {180, 210}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  connect(omegaGPu, product2.u1) annotation(
    Line(points = {{-120, -120}, {-120, -154}, {-102, -154}}, color = {0, 0, 127}));
  connect(booleanConstant3.y, pflagswitch.u2) annotation(
    Line(points = {{-18, -160}, {18, -160}}, color = {255, 0, 255}));
  connect(product2.y, pflagswitch.u1) annotation(
    Line(points = {{-78, -160}, {-60, -160}, {-60, -140}, {0, -140}, {0, -152}, {18, -152}}, color = {0, 0, 127}));
  connect(pflagswitch.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{42, -160}, {118, -160}}, color = {0, 0, 127}));
  connect(VRefConst1.y, add2.u1) annotation(
    Line(points = {{-79, -40}, {-66, -40}, {-66, -22}}, color = {0, 0, 127}));
  connect(add2.y, uflagswitch.u3) annotation(
    Line(points = {{-60, 2}, {-60, 32}, {-42, 32}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product2.u2) annotation(
    Line(points = {{-138, -160}, {-120, -160}, {-120, -166}, {-102, -166}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, pflagswitch.u3) annotation(
    Line(points = {{-138, -160}, {-120, -160}, {-120, -180}, {0, -180}, {0, -168}, {18, -168}}, color = {0, 0, 127}));
  connect(limiter1.y, iqInjectionLogic.iqVPu) annotation(
    Line(points = {{102, 160}, {197, 160}}, color = {0, 0, 127}));
  connect(pfflagswitch.y, division.u1) annotation(
    Line(points = {{-258, 40}, {-240, 40}, {-240, -60}, {0, -60}, {0, -54}, {18, -54}}, color = {0, 0, 127}));
  connect(FRT5.y, iqInjectionLogic.vDip) annotation(
    Line(points = {{180, 200}, {180, 168}, {198, 168}}, color = {255, 0, 255}));
  connect(limiter.y, varLimPIFreeze.u_s) annotation(
    Line(points = {{22, 40}, {78, 40}}, color = {0, 0, 127}));
  connect(pfflagswitch.y, add2.u2) annotation(
    Line(points = {{-258, 40}, {-240, 40}, {-240, -60}, {-54, -60}, {-54, -22}}, color = {0, 0, 127}));
  connect(UInjPu, voltageCheck.UPu) annotation(
    Line(points = {{-220, 200}, {-180, 200}, {-180, 220}, {-100, 220}}, color = {0, 0, 127}));
  connect(UFilt2.y, IqmaxFromUPu.u) annotation(
    Line(points = {{-78, -100}, {240, -100}, {240, 20}, {278, 20}}, color = {0, 0, 127}));
  connect(UFilt2.y, IpmaxFromUPu.u) annotation(
    Line(points = {{-78, -100}, {240, -100}, {240, -20}, {278, -20}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{388, 22}, {388, 72}, {398, 72}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{372, 22}, {372, 88}, {398, 88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{372, -22}, {372, -88}, {398, -88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{388, -22}, {388, -72}, {398, -72}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{302, -80}, {398, -80}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{182, -160}, {260, -160}, {260, -86}, {278, -86}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, currentLimitsCalculation.ipCmdPu) annotation(
    Line(points = {{422, -80}, {440, -80}, {440, -12}, {402, -12}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculation.iqCmdPu) annotation(
    Line(points = {{422, 80}, {440, 80}, {440, 12}, {402, 12}}, color = {0, 0, 127}));
  connect(FRT4.y, currentLimitsCalculation.vDip) annotation(
    Line(points = {{322, 0}, {358, 0}}, color = {255, 0, 255}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculation.ipVdlPu) annotation(
    Line(points = {{302, -20}, {340, -20}, {340, -12}, {358, -12}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculation.iqVdlPu) annotation(
    Line(points = {{302, 20}, {340, 20}, {340, 12}, {358, 12}}, color = {0, 0, 127}));
  connect(iqInjectionLogic.iqInjPu, add1.u1) annotation(
    Line(points = {{222, 160}, {240, 160}, {240, 86}, {278, 86}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC electrical inverter control model type A – used typically with type 3 and 4 WTGs. It is depicted in the EPRI document Model User Guide for Generic Renewable Energy System Models (page 65), available for download at : <a href='https://www.epri.com/research/products/3002014083'>https://www.epri.com/research/products/3002014083 </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REECa.png\" alt=\"Renewable energy electrical controls model A (reec_a)\">
    <p> Following control modes can be activated: </p>
    <li> Local coordinated V/Q control: QFlag = true, UFlag = true </li>
    <li> Only plant level control active: QFlag = false, UFlag = false </li>
    <li> If plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false </li>
    <li> Active power can be dependent or independent on drive train speed by setting PFlag to false (independent from drive train speed) or true. If PFlag is set to false, the model behaves as a Wind turbine generator type 4B, where the drive train is neglected by setting the speed to constant 1 </li>
    <p> The block calculates the ip and iq setpoint values for the generator converter based on the selected control algorithm. The control modes are summed up below (page 41 of the EPRI document). </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REECaPathOptions.png\" alt=\"Options for the reactive power control path in the reec_a model\">
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "A")}));
end REECa;
