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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model REECa "WECC Electrical Control type A"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC;
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREECa;

  // Input variable
  Modelica.Blocks.Interfaces.RealInput omegaGPu(start = SystemBase.omegaRef0Pu) "Generator frequency from drive train control in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, -121}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-51, -110}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IMaxPu) "p-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = 0) "p-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IMaxPu) "q-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = - IMaxPu) "q-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput POrdPu(start = PInj0Pu) "Active power order in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {551, -153}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -89}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.RealExpression UFilteredPu5(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {249, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculation1.iqMaxPu) annotation(
    Placement(visible = true, transformation(origin = {130, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculation1.iqMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn4(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {304, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn5(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {290, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant VRefConst1(k = VRef1Pu) annotation(
    Placement(visible = true, transformation(origin = {-79, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PFlagConst(k = PFlag) annotation(
    Placement(visible = true, transformation(origin = {-175, -71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-75, -70}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-42, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-175, -115}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {279, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {279, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(visible = true, transformation(origin = {264, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.IqInjectionLogic iqInjectionLogic(IqFrzPu = IqFrzPu, tHoldIq = tHoldIq) annotation(
    Placement(visible = true, transformation(origin = {309, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationA currentLimitsCalculation1(IMaxPu = IMaxPu, PQFlag = PQFlag, tHoldIpMax = tHoldIpMax) annotation(
    Placement(visible = true, transformation(origin = {403, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(FRTOn4.y, currentLimitsCalculation1.vDip) annotation(
    Line(points = {{315, 0}, {392, 0}}, color = {255, 0, 255}));
  connect(product2.y, switch3.u1) annotation(
    Line(points = {{-164, -115}, {-145, -115}, {-145, -78}, {-87, -78}}, color = {0, 0, 127}));
  connect(omegaGPu, product2.u2) annotation(
    Line(points = {{-270, -121}, {-187, -121}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, switch3.u3) annotation(
    Line(points = {{-219, -40}, {-145, -40}, {-145, -62}, {-87, -62}}, color = {0, 0, 127}));
  connect(switch3.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-64, -70}, {53, -70}}, color = {0, 0, 127}));
  connect(PFlagConst.y, switch3.u2) annotation(
    Line(points = {{-164, -71}, {-87, -71}, {-87, -70}}, color = {255, 0, 255}));
  connect(UFilteredPu5.y, IpmaxFromUPu.u) annotation(
    Line(points = {{260, 2}, {263, 2}, {263, 22}, {267, 22}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IqmaxFromUPu.u) annotation(
    Line(points = {{260, 2}, {263, 2}, {263, -18}, {267, -18}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculation1.iqVdlPu) annotation(
    Line(points = {{290, -18}, {340, -18}, {340, -3.5}, {392, -3.5}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculation1.ipVdlPu) annotation(
    Line(points = {{290, 22}, {343.5, 22}, {343.5, 4}, {392, 4}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product2.u1) annotation(
    Line(points = {{-219, -40}, {-210, -40}, {-210, -110}, {-187, -110}, {-187, -109}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{414, 7}, {480, 7}, {480, -112}, {499, -112}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{414, 3}, {470, 3}, {470, -128}, {499, -128}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{414, -3}, {480, -3}, {480, 118}, {498, 118}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{414, -7}, {470, -7}, {470, 102}, {498, 102}}, color = {0, 0, 127}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{141, 130}, {156, 130}, {156, 118}, {168, 118}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{141, 90}, {157, 90}, {157, 106}, {168, 106}}, color = {0, 0, 127}));
  connect(limiter1.y, iqInjectionLogic.iqVPu) annotation(
    Line(points = {{275, 220}, {309, 220}, {309, 202}}, color = {0, 0, 127}));
  connect(iqInjectionLogic.iqInjPu, add1.u1) annotation(
    Line(points = {{309, 179}, {309, 116}, {318, 116}}, color = {0, 0, 127}));
  connect(FRTOn5.y, iqInjectionLogic.vDip) annotation(
    Line(points = {{301, 240}, {317, 240}, {317, 202}}, color = {255, 0, 255}));
  connect(variableLimiter1.y, currentLimitsCalculation1.ipCmdPu) annotation(
    Line(points = {{522, -120}, {530, -120}, {530, 20}, {380, 20}, {380, 8}, {392, 8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculation1.iqCmdPu) annotation(
    Line(points = {{521, 110}, {530, 110}, {530, -21}, {380, -21}, {380, -7}, {392, -7}}, color = {0, 0, 127}));
  connect(switch1.y, add2.u2) annotation(
    Line(points = {{-109, 150}, {-100, 150}, {-100, 72}, {-54, 72}}, color = {0, 0, 127}));
  connect(VRefConst1.y, add2.u1) annotation(
    Line(points = {{-68, 100}, {-60, 100}, {-60, 84}, {-54, 84}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{192, -120}, {499, -120}}, color = {0, 0, 127}));
  connect(add2.y, switch.u3) annotation(
    Line(points = {{-31, 78}, {1, 78}, {1, 104}, {15, 104}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{215, 220}, {252, 220}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, POrdPu) annotation(
    Line(points = {{76, -70}, {101, -70}, {101, -153}, {551, -153}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{414, 7}, {480, 7}, {480, 30}, {550, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(currentLimitsCalculation1.ipMinPu, ipMinPu) annotation(
    Line(points = {{414, 3}, {480, 3}, {480, 10}, {550, 10}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(currentLimitsCalculation1.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{414, -3}, {480, -3}, {480, -10}, {550, -10}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(currentLimitsCalculation1.iqMinPu, iqMinPu) annotation(
    Line(points = {{414, -7}, {470, -7}, {470, -30}, {550, -30}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\">This block contains the electrical inverter control of the generic WECC Wind (or PV) model according to (in case page cannot be found, copy link in browser):<br><a href=\"https://www.wecc.org/Reliability/WECC%20Wind%20Plant%20Dynamic%20Modeling%20Guidelines.pdf\">https://www.wecc.org/Reliability/WECC%20Wind%20Plant%20Dynamic%20Modeling%20Guidelines.pdf</a></p>
  <p style=\"font-size: 12px;\">
  Following control modes can be activated:</p>
  <li style=\"font-size: 12px;\">Local coordinated V/Q control: QFlag = true, VFlag = true</li>
  <li style=\"font-size: 12px;\">Only plant level control active: QFlag = false, VFlag = false</li>
  <li style=\"font-size: 12px;\">If plant level control not connected: local power factor control: PfFlag = true, otherwise PfFlag = false.</li>
  <li style=\"font-size: 12px;\"> Active power can be dependent or independent on drive train speed by setting PFlag to false (independent from drive train speed) or true. If PFlag is set to false, the model behaves as a Wind turbine generator type 4B, where the drive train is neglected by setting the speed to constant 1 </li>
    <p style=\"font-size: 12px;\">The block calculates the Id and Iq setpoint values for the generator control based on the selected control algorithm.</p></body></html>"),
    Diagram(coordinateSystem(extent = {{-260, -280}, {540, 280}}, grid = {1, 1})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-30.3275, -106.118}, extent = {{-14.6724, 6.11766}, {22.3276, -9.88234}}, textString = "omegaG"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "frtOn"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu"), Text(origin = {-12, 9}, extent = {{-43, 22}, {80, -38}}, textString = "REEC A"), Text(origin = {-104, 133}, extent = {{-23, 13}, {35, -21}}, textString = "ipMaxPu"), Text(origin = {55, 132}, extent = {{-23, 13}, {35, -21}}, textString = "iqMaxPu"), Text(origin = {-45, 134}, extent = {{-23, 13}, {35, -21}}, textString = "ipMinPu"), Text(origin = {114, 132}, extent = {{-23, 13}, {35, -21}}, textString = "iqMinPu")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})));
end REECa;
