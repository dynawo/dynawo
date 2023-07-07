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

model REECd "WECC Renewable Energy Electrical Control model d"
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREEC(limiter2(uMax = QUMaxPu, uMin = QUMinPu));
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECdParameters;

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iInjPu(re(start = iInj0Pu.re), im(start = iInj0Pu.im)) "Complex current at injector in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaGPu(start = SystemBase.omegaRef0Pu) "Generator frequency from drive train control in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -120}, extent = {{-20, 20}, {20, -20}}, rotation = -90), iconTransformation(origin = {-40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {200, -200}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(re(start = uInj0Pu.re), im(start = uInj0Pu.im)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-500, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput POrdPu(start = PInj0Pu) "Inverter power order lag in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {160, -250}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {40, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {230, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tR1, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch vcmpflagswitch annotation(
    Placement(visible = true, transformation(origin = {-210, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant4(k = UCmpFlag) annotation(
    Placement(visible = true, transformation(origin = {-270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationD currentLimitsCalculation(IMaxPu = IMaxPu, IqFrzPu = IqFrzPu, Ke = Ke, PQFlag = PQFlag, UBlkHPu = UBlkHPu, UBlkLPu = UBlkLPu, tBlkDelay = tBlkDelay, tHld = tHld, tHld2 = tHld2) annotation(
    Placement(visible = true, transformation(origin = {380, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRT4(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {310, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {290, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(visible = true, transformation(origin = {290, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentCompensation currentCompensation(RcPu = RcPu, XcPu = XcPu) annotation(
    Placement(visible = true, transformation(origin = {-360, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4(k2 = Kc) annotation(
    Placement(visible = true, transformation(origin = {-370, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilt3(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {450, 0}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

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
  connect(limiter2.y, division.u1) annotation(
    Line(points = {{-198, 40}, {-180, 40}, {-180, -60}, {0, -60}, {0, -54}, {18, -54}}, color = {0, 0, 127}));
  connect(limiter2.y, add2.u2) annotation(
    Line(points = {{-198, 40}, {-180, 40}, {-180, -60}, {-54, -60}, {-54, -22}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{22, 40}, {32, 40}}, color = {0, 0, 127}));
  connect(feedback.y, varLimPIDFreeze.u_s) annotation(
    Line(points = {{50, 40}, {78, 40}}, color = {0, 0, 127}));
  connect(PAuxPu, add3.u2) annotation(
    Line(points = {{200, -200}, {200, -166}, {218, -166}}, color = {0, 0, 127}));
  connect(limiter3.y, add3.u1) annotation(
    Line(points = {{182, -160}, {200, -160}, {200, -154}, {218, -154}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u2) annotation(
    Line(points = {{-78, 100}, {0, 100}, {0, 60}, {40, 60}, {40, 48}}, color = {0, 0, 127}));
  connect(booleanConstant4.y, vcmpflagswitch.u2) annotation(
    Line(points = {{-258, 100}, {-222, 100}}, color = {255, 0, 255}));
  connect(vcmpflagswitch.y, firstOrder2.u) annotation(
    Line(points = {{-198, 100}, {-102, 100}}, color = {0, 0, 127}));
  connect(firstOrder.y, voltageCheck.UPu) annotation(
    Line(points = {{-138, 180}, {-120, 180}, {-120, 220}, {-100, 220}}, color = {0, 0, 127}));
  connect(limiter3.y, POrdPu) annotation(
    Line(points = {{182, -160}, {190, -160}, {190, -180}, {160, -180}, {160, -250}}, color = {0, 0, 127}));
  connect(UInjPu, add4.u1) annotation(
    Line(points = {{-220, 200}, {-400, 200}, {-400, 106}, {-382, 106}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(add4.y, vcmpflagswitch.u3) annotation(
    Line(points = {{-358, 100}, {-300, 100}, {-300, 80}, {-240, 80}, {-240, 92}, {-222, 92}}, color = {0, 0, 127}));
  connect(iInjPu, currentCompensation.iPu) annotation(
    Line(points = {{-500, 200}, {-440, 200}, {-440, 172}, {-382, 172}}, color = {85, 170, 255}));
  connect(uInjPu, currentCompensation.uPu) annotation(
    Line(points = {{-500, 120}, {-440, 120}, {-440, 148}, {-382, 148}}, color = {85, 170, 255}));
  connect(currentCompensation.UPu, vcmpflagswitch.u1) annotation(
    Line(points = {{-338, 160}, {-240, 160}, {-240, 108}, {-222, 108}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, currentLimitsCalculation.ipCmdPu) annotation(
    Line(points = {{422, -80}, {440, -80}, {440, -12}, {402, -12}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculation.iqCmdPu) annotation(
    Line(points = {{422, 80}, {440, 80}, {440, 12}, {402, 12}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{388, 22}, {388, 72}, {398, 72}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{372, 22}, {372, 88}, {398, 88}}, color = {0, 0, 127}));
  connect(FRT4.y, currentLimitsCalculation.vDip) annotation(
    Line(points = {{322, 0}, {358, 0}}, color = {255, 0, 255}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculation.iqVdlPu) annotation(
    Line(points = {{302, 20}, {340, 20}, {340, 12}, {358, 12}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculation.ipVdlPu) annotation(
    Line(points = {{302, -20}, {340, -20}, {340, -12}, {358, -12}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{302, -80}, {398, -80}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{372, -22}, {372, -88}, {398, -88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{388, -22}, {388, -72}, {398, -72}}, color = {0, 0, 127}));
  connect(add3.y, division1.u1) annotation(
    Line(points = {{242, -160}, {260, -160}, {260, -86}, {278, -86}}, color = {0, 0, 127}));
  connect(UFilt3.y, IqmaxFromUPu.u) annotation(
    Line(points = {{-78, -100}, {240, -100}, {240, 20}, {278, 20}}, color = {0, 0, 127}));
  connect(UFilt3.y, IpmaxFromUPu.u) annotation(
    Line(points = {{-78, -100}, {240, -100}, {240, -20}, {278, -20}}, color = {0, 0, 127}));
  connect(limiter1.y, add1.u1) annotation(
    Line(points = {{102, 160}, {240, 160}, {240, 86}, {278, 86}}, color = {0, 0, 127}));
  connect(QInjPu, add4.u2) annotation(
    Line(points = {{-140, -20}, {-140, -40}, {-240, -40}, {-240, 60}, {-400, 60}, {-400, 94}, {-382, 94}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UFilt3.y, currentLimitsCalculation.UFilteredPu) annotation(
    Line(points = {{440, 0}, {402, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC electrical inverter control model type D – recommended for new WTs and BESS. It is depicted in the WECC document Modeling Updates 021623 Rev27 (page 12) : <a href='https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf'>https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REECd.png\" alt=\"Renewable energy electrical controls model D (reec_d)\">
    <p> Following control modes can be activated: </p>
    <li> Local coordinated V/Q control: QFlag = true, UFlag = true </li>
    <li> Only plant level control active: QFlag = false, UFlag = false </li>
    <li> If plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false </li>
    <li> Active power can be dependent or independent on drive train speed by setting PFlag to false (independent from drive train speed) or true. If PFlag is set to false, the model behaves as a Wind turbine generator type 4B, where the drive train is neglected by setting the speed to constant 1 </li>
    <p> The block calculates the ip and iq setpoint values for the generator converter based on the selected control algorithm. </p>
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "D"), Text(origin = {-110, 132}, extent = {{-22, 16}, {36, -28}}, textString = "PAuxPu"), Text(origin = {138, -108}, extent = {{-22, 16}, {36, -28}}, textString = "POrdPu"), Text(origin = {-66, -126}, extent = {{-22, 16}, {36, -28}}, textString = "omegaGPu"), Text(origin = {57, 131}, extent = {{-13, 9}, {21, -16}}, textString = "uPu"), Text(origin = {96, 131}, extent = {{-12, 9}, {20, -17}}, textString = "iPu")}));
end REECd;
