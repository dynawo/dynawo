within Dynawo.Electrical.Controls.WECC.REPC;

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

model REPCc "WECC Renewable Energy Plant Controller REPC model c"
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC(rateLimFirstOrderFreeze.UseRateLim = true, rateLimFirstOrderFreeze.UseFreeze = true, limPIFreeze.YMax = PiMaxPu, limPIFreeze.YMin = PiMinPu, limPIFreeze1.YMax = QUMaxPu, limPIFreeze1.YMin = QUMinPu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.REPCcParameters;

  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tFreq, y_start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-360, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFilterPC, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tFilterPC, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(uMax = DfMaxPu, uMin = DfMinPu) annotation(
    Placement(visible = true, transformation(origin = {-270, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tC, k = Kc, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-350, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter5(uMax = URefMaxPu, uMin = URefMinPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UAux annotation(
    Placement(visible = true, transformation(origin = {0, 220}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {4, 212}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFaRef annotation(
    Placement(visible = true, transformation(origin = {-420, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-410, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter8(uMax = PfMax, uMin = PfMin) annotation(
    Placement(visible = true, transformation(origin = {-350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Tan tan annotation(
    Placement(visible = true, transformation(origin = {-270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAux annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {14, 222}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter1(Falling = DPrMinPu, Rising = DPrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-350, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {0, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {90, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter6(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {190, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant3(k = FfwrdFlag) annotation(
    Placement(visible = true, transformation(origin = {30, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const5(k = 0) annotation(
    Placement(visible = true, transformation(origin = {30, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant4(k = PefdFlag) annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = PrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {190, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = PrMinPu) annotation(
    Placement(visible = true, transformation(origin = {190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Falling = DQRefMinPu, Rising = DQRefMaxPu, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter7(uMax = QRefMaxPu, uMin = QRefMinPu) annotation(
    Placement(visible = true, transformation(origin = {-350, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = RefFlag) annotation(
    Placement(visible = true, transformation(origin = {130, 140}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter2(Falling = QUrMinPu, Rising = QUrMaxPu, y_start = QInjRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {330, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(omegaPu, firstOrder4.u) annotation(
    Line(points = {{-360, -220}, {-360, -182}}, color = {0, 0, 127}));
  connect(firstOrder4.y, feedback2.u2) annotation(
    Line(points = {{-360, -158}, {-360, -148}}, color = {0, 0, 127}));
  connect(deadZone.y, limiter4.u) annotation(
    Line(points = {{-298, -140}, {-282, -140}}, color = {0, 0, 127}));
  connect(limiter4.y, gain.u) annotation(
    Line(points = {{-258, -140}, {-240, -140}, {-240, -160}, {-222, -160}}, color = {0, 0, 127}));
  connect(limiter4.y, gain1.u) annotation(
    Line(points = {{-258, -140}, {-240, -140}, {-240, -120}, {-222, -120}}, color = {0, 0, 127}));
  connect(QRegPu, firstOrder5.u) annotation(
    Line(points = {{-420, 80}, {-380, 80}, {-380, 100}, {-362, 100}}, color = {0, 0, 127}));
  connect(firstOrder5.y, add1.u2) annotation(
    Line(points = {{-338, 100}, {-220, 100}, {-220, 94}, {-202, 94}}, color = {0, 0, 127}));
  connect(switch11.y, add4.u3) annotation(
    Line(points = {{-58, 120}, {20, 120}, {20, 132}, {38, 132}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U1Pu, firstOrder3.u) annotation(
    Line(points = {{-298, 172}, {-160, 172}, {-160, 160}, {-142, 160}}, color = {0, 0, 127}));
  connect(firstOrder3.y, switch11.u1) annotation(
    Line(points = {{-118, 160}, {-100, 160}, {-100, 128}, {-82, 128}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U2Pu, firstOrder2.u) annotation(
    Line(points = {{-298, 148}, {-280, 148}, {-280, 140}, {-262, 140}}, color = {0, 0, 127}));
  connect(firstOrder2.y, voltageCheck.UPu) annotation(
    Line(points = {{-238, 140}, {-200, 140}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add1.u1) annotation(
    Line(points = {{-238, 140}, {-220, 140}, {-220, 106}, {-202, 106}}, color = {0, 0, 127}));
  connect(URefPu, limiter5.u) annotation(
    Line(points = {{-60, 220}, {-60, 140}, {-42, 140}}, color = {0, 0, 127}));
  connect(limiter5.y, add4.u2) annotation(
    Line(points = {{-19, 140}, {38, 140}}, color = {0, 0, 127}));
  connect(UAux, add4.u1) annotation(
    Line(points = {{0, 220}, {0, 148}, {38, 148}}, color = {0, 0, 127}));
  connect(PFaRef, limiter8.u) annotation(
    Line(points = {{-420, 0}, {-362, 0}}, color = {0, 0, 127}));
  connect(PRefPu, slewRateLimiter1.u) annotation(
    Line(points = {{-420, -80}, {-362, -80}}, color = {0, 0, 127}));
  connect(slewRateLimiter1.y, add3.u2) annotation(
    Line(points = {{-338, -80}, {-62, -80}}, color = {0, 0, 127}));
  connect(PAux, add3.u1) annotation(
    Line(points = {{-120, -60}, {-80, -60}, {-80, -72}, {-62, -72}}, color = {0, 0, 127}));
  connect(feedback2.y, limiter2.u) annotation(
    Line(points = {{10, -80}, {38, -80}}, color = {0, 0, 127}));
  connect(add3.y, feedback2.u1) annotation(
    Line(points = {{-38, -80}, {-8, -80}}, color = {0, 0, 127}));
  connect(limPIFreeze.y, add2.u1) annotation(
    Line(points = {{102, -80}, {120, -80}, {120, -74}, {138, -74}}, color = {0, 0, 127}));
  connect(switch4.y, add2.u2) annotation(
    Line(points = {{102, -140}, {120, -140}, {120, -86}, {138, -86}}, color = {0, 0, 127}));
  connect(add2.y, limiter6.u) annotation(
    Line(points = {{162, -80}, {178, -80}}, color = {0, 0, 127}));
  connect(limiter6.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{202, -80}, {218, -80}}, color = {0, 0, 127}));
  connect(booleanConstant3.y, switch4.u2) annotation(
    Line(points = {{42, -140}, {78, -140}}, color = {255, 0, 255}));
  connect(add3.y, switch4.u1) annotation(
    Line(points = {{-38, -80}, {-20, -80}, {-20, -120}, {60, -120}, {60, -132}, {78, -132}}, color = {0, 0, 127}));
  connect(booleanConstant4.y, switch3.u2) annotation(
    Line(points = {{-78, -20}, {-42, -20}}, color = {255, 0, 255}));
  connect(switch3.y, feedback2.u2) annotation(
    Line(points = {{-19, -20}, {0, -20}, {0, -72}}, color = {0, 0, 127}));
  connect(firstOrder.y, switch3.u1) annotation(
    Line(points = {{-298, -40}, {-60, -40}, {-60, -28}, {-42, -28}}, color = {0, 0, 127}));
  connect(limiter8.y, tan.u) annotation(
    Line(points = {{-338, 0}, {-282, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, product.u2) annotation(
    Line(points = {{-298, -40}, {-200, -40}, {-200, -6}, {-182, -6}}, color = {0, 0, 127}));
  connect(tan.y, product.u1) annotation(
    Line(points = {{-258, 0}, {-200, 0}, {-200, 6}, {-182, 6}}, color = {0, 0, 127}));
  connect(product.y, feedback3.u1) annotation(
    Line(points = {{-158, 0}, {-140, 0}, {-140, 20}, {-48, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{-298, 80}, {-40, 80}, {-40, 28}}, color = {0, 0, 127}));
  connect(booleanExpression.y, rateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{280, 160}, {280, 120}, {260, 120}, {260, 0}, {224, 0}, {224, -92}}, color = {255, 0, 255}));
  connect(booleanExpression.y, limPIFreeze.freeze) annotation(
    Line(points = {{280, 160}, {280, 120}, {260, 120}, {260, 0}, {84, 0}, {84, -68}}, color = {255, 0, 255}));
  connect(QRefPu, limiter7.u) annotation(
    Line(points = {{-420, 40}, {-362, 40}}, color = {0, 0, 127}));
  connect(limiter7.y, slewRateLimiter.u) annotation(
    Line(points = {{-338, 40}, {-282, 40}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, feedback1.u1) annotation(
    Line(points = {{-258, 40}, {-8, 40}}, color = {0, 0, 127}));
  connect(multiSwitch.y, deadZone1.u) annotation(
    Line(points = {{122, 80}, {158, 80}}, color = {0, 0, 127}));
  connect(add4.y, multiSwitch.u[2]) annotation(
    Line(points = {{62, 140}, {80, 140}, {80, 84}, {100, 84}}, color = {0, 0, 127}));
  connect(feedback1.y, multiSwitch.u[1]) annotation(
    Line(points = {{10, 40}, {60, 40}, {60, 80}, {100, 80}}, color = {0, 0, 127}));
  connect(feedback3.y, multiSwitch.u[3]) annotation(
    Line(points = {{-30, 20}, {80, 20}, {80, 76}, {100, 76}}, color = {0, 0, 127}));
  connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{120, 140}, {110, 140}, {110, 92}}, color = {255, 127, 0}));
  connect(const4.y, rateLimFirstOrderFreeze.dyMin) annotation(
    Line(points = {{202, -40}, {210, -40}, {210, -74}, {218, -74}}, color = {0, 0, 127}));
  connect(const3.y, rateLimFirstOrderFreeze.dyMax) annotation(
    Line(points = {{202, -120}, {210, -120}, {210, -86}, {218, -86}}, color = {0, 0, 127}));
  connect(const1.y, switch3.u3) annotation(
    Line(points = {{100, -40}, {20, -40}, {20, 0}, {-60, 0}, {-60, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(limPIFreeze1.y, slewRateLimiter2.u) annotation(
    Line(points = {{302, 80}, {318, 80}}, color = {0, 0, 127}));
  connect(slewRateLimiter2.y, transferFunction.u) annotation(
    Line(points = {{342, 80}, {358, 80}}, color = {0, 0, 127}));
  connect(const5.y, switch4.u3) annotation(
    Line(points = {{42, -180}, {60, -180}, {60, -148}, {78, -148}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC plant level control model type C according to the WECC document Modeling Updates 021623 Rev27 (page 18) : <a href='https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf'>https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REPCc.png\" alt=\"Renewable energy plant controller model C (repc_c)\">
    <p> Compared to REPCa, this plant controller includes limits, rate limits, measurement time constants, auxiliary inputs, and the Power Factor Control. </p>
    <p> The logic for coordinated switching of mechanically switched shunts (MSS) has also been added:
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REPCmss.png\" alt=\"MSS switching logic\"> </p>
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "C")}));
end REPCc;
