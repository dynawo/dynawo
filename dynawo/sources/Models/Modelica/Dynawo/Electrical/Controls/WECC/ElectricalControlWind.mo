within Dynawo.Electrical.Controls.WECC;

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

model ElectricalControlWind "WECC Wind Electrical Control REEC"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.Controls.WECC.BaseControls.ElectricalControlCommon;

  parameter Types.VoltageComponent VDLIp11;
  parameter Types.VoltageComponent VDLIp12;
  parameter Types.VoltageComponent VDLIp21;
  parameter Types.VoltageComponent VDLIp22;
  parameter Types.VoltageComponent VDLIq11;
  parameter Types.VoltageComponent VDLIq12;
  parameter Types.VoltageComponent VDLIq21;
  parameter Types.VoltageComponent VDLIq22;
  parameter Types.VoltageComponent VDLIpPoints[:, :] = [VDLIp11, VDLIp12 ; VDLIp21, VDLIp22] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]";
  parameter Types.VoltageComponent VDLIqPoints[:, :] = [VDLIq11, VDLIq12 ; VDLIq21, VDLIq22]"Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]";
  parameter Types.PerUnit VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)";
  parameter Types.Time HoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after voltage dip in s";
  parameter Types.Time HoldIq "Absolute value of HoldIq defines seconds to hold current injection after voltage dip ended. HoldIq < 0 for constant, 0 for no injection after voltage dip, HoldIq > 0 for voltage-dependent injection (typical: -1 .. 1 s)";
  parameter Types.PerUnit IqFrzPu "Constant reactive current injection value in pu (base UNom, SNom) (typical: -0.1 .. 0.1 pu)";
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)";

  Modelica.Blocks.Interfaces.RealInput omegaGPu(start= SystemBase.omegaRef0Pu) "Generator frequency from drive train control in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-269, 134}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-51, -110}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));

  Modelica.Blocks.Sources.RealExpression UFilteredPu5(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {340, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculation1.iqMaxPu) annotation(
    Placement(visible = true, transformation(origin = {130, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculation1.iqMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn2(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {44, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn4(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {395, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn5(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {292, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant VRefConst1(k = VRef1Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PFlagConst(k = PFlag) annotation(
    Placement(visible = true, transformation(origin = {-190, 174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant DPMax0(k = 999) annotation(
    Placement(visible = true, transformation(origin = {-40, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant DPMin0(k = -999) annotation(
    Placement(visible = true, transformation(origin = {-40, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(limitsAtInit = true, uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, 175}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Falling = DPMin, Rising = DPMax, initType = Modelica.Blocks.Types.Init.InitialState, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch pflagswitch annotation(
    Placement(visible = true, transformation(origin = {-90, 175}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = +1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-39, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {370, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {370, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.BaseControls.IqInjectionLogic iqInjectionLogic(IqFrzPu = IqFrzPu, HoldIq = HoldIq) annotation(
    Placement(visible = true, transformation(origin = {311, 12}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationWind currentLimitsCalculation1(IMaxPu = IMaxPu, PPriority = PPriority, HoldIpMax = HoldIpMax) annotation(
    Placement(visible = true, transformation(origin = {432, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tPord, UseFreeze = true, UseRateLim = true, Y0 = PInj0Pu, k = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 175}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(rateLimFirstOrderFreeze.y, limiter3.u) annotation(
    Line(points = {{61, 175}, {118, 175}}, color = {0, 0, 127}));
  connect(FRTOn2.y, rateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{44, 151}, {44, 163}}, color = {255, 0, 255}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{141, -6}, {150, -6}, {150, -13}, {168, -13}, {168, -13}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{141, -33}, {150, -33}, {150, -25}, {168, -25}}, color = {0, 0, 127}));
  connect(limiter1.y, iqInjectionLogic.iqVPu) annotation(
    Line(points = {{291, 30}, {311, 30}, {311, 22}}, color = {0, 0, 127}));
  connect(iqInjectionLogic.iqInjPu, add1.u1) annotation(
    Line(points = {{311, 2}, {311, -15}, {318, -15}}, color = {0, 0, 127}));
  connect(VRefConst1.y, add2.u1) annotation(
    Line(points = {{-69, -30}, {-60, -30}, {-60, -44}, {-51, -44}}, color = {0, 0, 127}));
  connect(switch1.y, add2.u2) annotation(
    Line(points = {{-109, 20}, {-100, 20}, {-100, -56}, {-51, -56}}, color = {0, 0, 127}));
  connect(FRTOn4.y, currentLimitsCalculation1.vDip) annotation(
    Line(points = {{406, 30}, {421, 30}}, color = {255, 0, 255}));
  connect(FRTOn5.y, iqInjectionLogic.vDip) annotation(
    Line(points = {{303, 60}, {319, 60}, {319, 22}}, color = {255, 0, 255}));
  connect(product2.y, pflagswitch.u1) annotation(
    Line(points = {{-179, 140}, {-160, 140}, {-160, 167}, {-102, 167}}, color = {0, 0, 127}));
  connect(omegaGPu, product2.u2) annotation(
    Line(points = {{-269, 134}, {-202, 134}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product2.u1) annotation(
    Line(points = {{-219, 210}, {-210, 210}, {-210, 146}, {-202, 146}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, pflagswitch.u3) annotation(
    Line(points = {{-219, 210}, {-160, 210}, {-160, 183}, {-102, 183}}, color = {0, 0, 127}));
  connect(pflagswitch.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-79, 175}, {38, 175}}, color = {0, 0, 127}));
  connect(PFlagConst.y, pflagswitch.u2) annotation(
    Line(points = {{-179, 174}, {-102, 174}, {-102, 175}}, color = {255, 0, 255}));
  connect(currentLimitsCalculation1.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{443, 37}, {450, 37}, {450, 50}, {420, 50}, {420, 88}, {445, 88}, {445, 87}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{443, 33}, {460, 33}, {460, 60}, {430, 60}, {430, 71}, {445, 71}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{443, 27}, {460, 27}, {460, 0}, {430, 0}, {430, -13}, {445, -13}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{443, 23}, {450, 23}, {450, 10}, {420, 10}, {420, -29}, {445, -29}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IpmaxFromUPu.u) annotation(
    Line(points = {{351, 30}, {354, 30}, {354, 50}, {358, 50}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IqmaxFromUPu.u) annotation(
    Line(points = {{351, 30}, {354, 30}, {354, 10}, {358, 10}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculation1.iqVdlPu) annotation(
    Line(points = {{381, 10}, {410, 10}, {410, 26.5}, {421, 26.5}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculation1.ipVdlPu) annotation(
    Line(points = {{381, 50}, {410, 50}, {410, 34}, {421, 34}}, color = {0, 0, 127}));
  connect(add1.y, currentLimitsCalculation1.iqCmdPu) annotation(
    Line(points = {{341, -20}, {415, -20}, {415, 23}, {421, 23}}, color = {0, 0, 127}));
  connect(division1.y, currentLimitsCalculation1.ipCmdPu) annotation(
    Line(points = {{101, 80}, {415, 80}, {415, 38}, {421, 38}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{141, 175}, {150, 175}, {150, 86}, {168, 86}}, color = {0, 0, 127}));
  connect(DPMax0.y, rateLimFirstOrderFreeze.dyMax) annotation(
    Line(points = {{-29, 200}, {0, 200}, {0, 182}, {38, 182}}, color = {0, 0, 127}));
  connect(DPMin0.y, rateLimFirstOrderFreeze.dyMin) annotation(
    Line(points = {{-29, 150}, {0, 150}, {0, 169}, {38, 169}}, color = {0, 0, 127}));
  connect(PInjRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-270, 210}, {-242, 210}}, color = {0, 0, 127}));
  connect(add2.y, switch.u3) annotation(
    Line(points = {{-28, -50}, {-20, -50}, {-20, -26}, {-2, -26}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p style=\"font-size: 12px;\">This block contains the electrical inverter control of the generic WECC Wind model according to (in case page cannot be found, copy link in browser):<br><a href=\"https://www.wecc.org/Reliability/WECC%20Wind%20Plant%20Dynamic%20Modeling%20Guidelines.pdf\">https://www.wecc.org/Reliability/WECC%20Wind%20Plant%20Dynamic%20Modeling%20Guidelines.pdf</a></p>
  <p style=\"font-size: 12px;\">
  Following control modes can be activated:</p>
  <li style=\"font-size: 12px;\">Local coordinated V/Q control: QFlag = true, VFlag = true</li>
  <li style=\"font-size: 12px;\">Only plant level control active: QFlag = false, VFlag = false</li>
  <li style=\"font-size: 12px;\">If plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false.</li>
  <li style=\"font-size: 12px;\"> Active power can be dependent or independent on drive train speed by setting PFlag to false (independent from drive train speed) or true. If PFlag is set to false, the model behaves as a Wind turbine generator type 4B, where the drive train is neglected by setting the speed to constant 1 </li>
    <p style=\"font-size: 12px;\">The block calculates the Id and Iq setpoint values for the generator control based on the selected control algorithm.</p></body></html>"),
    Diagram(coordinateSystem(extent = {{-260, -130}, {540, 250}}, grid = {1, 1})),
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-30.3275, -106.118}, extent = {{-14.6724, 6.11766}, {22.3276, -9.88234}}, textString = "omegaG"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "frtOn"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1})));
end ElectricalControlWind;
