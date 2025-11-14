within Dynawo.Electrical.Controls.WECC.REPC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model REPCc "WECC Plant Control type C"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPCc;
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC(add3(k2 = 1), firstOrder(UseFreeze = true, UseRateLim = true), limPID(Xi0 = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then (PInj0Pu - PGen0Pu) / Kpg else PInj0Pu / Kpg, Y0 = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then PInj0Pu - PGen0Pu else PInj0Pu, YMax = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then PiMaxPu else PMaxPu, YMin = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then PiMinPu else PMinPu), RefFlag0(k = if RefFlag == 2 and abs(PInj0Pu / (sqrt(PInj0Pu ^ 2 + QInj0Pu ^ 2))) < 0.01 then 0 else RefFlag), multiSwitch(nu = 3));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UAuxPu(start = 0) "Auxiliary voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Sources.Constant PfPu(k = PGen0Pu / (sqrt(PGen0Pu ^ 2 + QGen0Pu ^ 2))) annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PrMax0(y = PrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {450, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PrMin0(y = PrMinPu) annotation(
    Placement(visible = true, transformation(origin = {450, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression freeze1(y = freeze) annotation(
    Placement(visible = true, transformation(origin = {170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant FfwrdFlag0(k = if PefdFlag == true and Kig > 0 then FfwrdFlag else false) annotation(
    Placement(visible = true, transformation(origin = {-10, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PefdFlag0(k = PefdFlag) annotation(
    Placement(visible = true, transformation(origin = {-270, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant QVFlag0(k = QVFlag) annotation(
    Placement(visible = true, transformation(origin = {510, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Acos acos annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {90, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {410, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add6(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-510, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFrq, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-410, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tFilterPC, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-350, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tFilterPC, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-470, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tC, y_start = Kc * QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-350, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = 1e-4)  annotation(
    Placement(visible = true, transformation(origin = {450, 180}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(uMax = DfMaxPu, uMin = DfMinPu) annotation(
    Placement(visible = true, transformation(origin = {-270, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter5(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {450, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter6(uMax = URefMaxPu, uMin = URefMinPu) annotation(
    Placement(visible = true, transformation(origin = {-350, 260}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Nonlinear.Limiter limiter7(uMax = QRefMaxPu, uMin = QRefMinPu) annotation(
    Placement(visible = true, transformation(origin = {-570, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(uMax = PfMax, uMin = PfMin) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {150, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not2 annotation(
    Placement(visible = true, transformation(origin = {230, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.OnDelay onDelay(delayTime = tFrz) annotation(
    Placement(visible = true, transformation(origin = {190, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DPrMax, DuMin = DPrMin, tS = 0.01, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-510, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter1(DuMax = DQRefMax, DuMin = DQRefMin, tS = 0.01, Y0 = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-510, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter2(DuMax = QvrMax, DuMin = QvrMin, tS = 0.01, Y0 = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {510, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-210, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {50, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch5 annotation(
    Placement(visible = true, transformation(origin = {570, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch6 annotation(
    Placement(visible = true, transformation(origin = {-450, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch7 annotation(
    Placement(visible = true, transformation(origin = {450, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Tan tan annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck1(UMaxPu = 999, UMinPu = UFreqPu) annotation(
    Placement(visible = true, transformation(origin = {-470, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {510, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero3(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-270, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero4(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  assert((FfwrdFlag == true and PefdFlag == true and Kig > 0) or FfwrdFlag == false, "Incompatible value for the FfwrdFlag, it is set to false", AssertionLevel.warning);
  assert(not(initial() and RefFlag == 2 and abs(PfPu.y) < 0.01), "Constant power factor control at very low loads does not make sense, RefFlag0 turned to 0 for constant Q control", AssertionLevel.warning);

  connect(deadZone1.y, limiter3.u) annotation(
    Line(points = {{-298, -180}, {-282, -180}}, color = {0, 0, 127}));
  connect(limiter3.y, gain2.u) annotation(
    Line(points = {{-258, -180}, {-200, -180}, {-200, -220}, {-182, -220}}, color = {0, 0, 127}));
  connect(limiter3.y, gain1.u) annotation(
    Line(points = {{-258, -180}, {-200, -180}, {-200, -140}, {-182, -140}}, color = {0, 0, 127}));
  connect(PRefPu, rampLimiter.u) annotation(
    Line(points = {{-610, -40}, {-522, -40}}, color = {0, 0, 127}));
  connect(add4.y, PRefLim.u) annotation(
    Line(points = {{101, -100}, {120, -100}, {120, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(add3.y, add4.u1) annotation(
    Line(points = {{2, -60}, {60, -60}, {60, -94}, {78, -94}}, color = {0, 0, 127}));
  connect(switch3.y, add4.u2) annotation(
    Line(points = {{-199, -100}, {60, -100}, {60, -106}, {78, -106}}, color = {0, 0, 127}));
  connect(PefdFlag0.y, switch3.u2) annotation(
    Line(points = {{-259, -100}, {-222, -100}}, color = {255, 0, 255}));
  connect(freeze1.y, limPID.freeze) annotation(
    Line(points = {{181, -140}, {194, -140}, {194, -72}}, color = {255, 0, 255}));
  connect(freeze1.y, firstOrder.freeze) annotation(
    Line(points = {{181, -140}, {420, -140}, {420, -60}, {504, -60}, {504, -52}}, color = {255, 0, 255}));
  connect(PrMax0.y, firstOrder.dyMax) annotation(
    Line(points = {{461, 0}, {480, 0}, {480, -34}, {498, -34}}, color = {0, 0, 127}));
  connect(PrMin0.y, firstOrder.dyMin) annotation(
    Line(points = {{461, -80}, {480, -80}, {480, -46}, {498, -46}}, color = {0, 0, 127}));
  connect(limPID.y, add5.u1) annotation(
    Line(points = {{212, -60}, {340, -60}, {340, -34}, {398, -34}}, color = {0, 0, 127}));
  connect(limiter5.y, firstOrder.u) annotation(
    Line(points = {{462, -40}, {498, -40}}, color = {0, 0, 127}));
  connect(add5.y, limiter5.u) annotation(
    Line(points = {{421, -40}, {438, -40}}, color = {0, 0, 127}));
  connect(firstOrder.y, switch.u1) annotation(
    Line(points = {{522, -40}, {540, -40}, {540, -72}, {558, -72}}, color = {0, 0, 127}));
  connect(add3.y, switch4.u1) annotation(
    Line(points = {{2, -60}, {20, -60}, {20, -192}, {38, -192}}, color = {0, 0, 127}));
  connect(Zero4.y, switch4.u3) annotation(
    Line(points = {{1, -240}, {20, -240}, {20, -208}, {37, -208}}, color = {0, 0, 127}));
  connect(FfwrdFlag0.y, switch4.u2) annotation(
    Line(points = {{1, -200}, {38, -200}}, color = {255, 0, 255}));
  connect(switch4.y, add5.u2) annotation(
    Line(points = {{61, -200}, {380, -200}, {380, -46}, {398, -46}}, color = {0, 0, 127}));
  connect(switch2.y, UCtrlErr.u2) annotation(
    Line(points = {{-198, 140}, {-62, 140}}, color = {0, 0, 127}));
  connect(UAuxPu, UCtrlErr.u3) annotation(
    Line(points = {{-110, 120}, {-80, 120}, {-80, 132}, {-62, 132}}, color = {0, 0, 127}));
  connect(URefPu, limiter6.u) annotation(
    Line(points = {{-610, 260}, {-362, 260}}, color = {0, 0, 127}));
  connect(limiter6.y, UCtrlErr.u1) annotation(
    Line(points = {{-339, 260}, {-80, 260}, {-80, 148}, {-62, 148}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, firstOrder4.u) annotation(
    Line(points = {{-538, 106}, {-520, 106}, {-520, 220}, {-362, 220}}, color = {0, 0, 127}));
  connect(firstOrder4.y, switch2.u1) annotation(
    Line(points = {{-339, 220}, {-240, 220}, {-240, 148}, {-222, 148}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, firstOrder5.u) annotation(
    Line(points = {{-538, 94}, {-500, 94}, {-500, 120}, {-482, 120}}, color = {0, 0, 127}));
  connect(firstOrder5.y, QVCtrlErr.u1) annotation(
    Line(points = {{-459, 120}, {-300, 120}, {-300, 106}, {-282, 106}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder6.u) annotation(
    Line(points = {{-380, 80}, {-362, 80}}, color = {0, 0, 127}));
  connect(firstOrder6.y, QVCtrlErr.u2) annotation(
    Line(points = {{-339, 80}, {-300, 80}, {-300, 94}, {-282, 94}}, color = {0, 0, 127}));
  connect(QRefPu, limiter7.u) annotation(
    Line(points = {{-608, 0}, {-582, 0}}, color = {0, 0, 127}));
  connect(limiter7.y, rampLimiter1.u) annotation(
    Line(points = {{-559, 0}, {-522, 0}}, color = {0, 0, 127}));
  connect(rampLimiter1.y, QCtrlErr.u2) annotation(
    Line(points = {{-498, 0}, {-320, 0}, {-320, -6}, {-282, -6}}, color = {0, 0, 127}));
  connect(limiter4.y, acos.u) annotation(
    Line(points = {{-159, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(acos.y, tan.u) annotation(
    Line(points = {{-119, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(tan.y, product.u1) annotation(
    Line(points = {{-79, 0}, {-60, 0}, {-60, -14}, {-42, -14}}, color = {0, 0, 127}));
  connect(product.y, add6.u2) annotation(
    Line(points = {{-19, -20}, {0, -20}, {0, 54}, {18, 54}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add6.u1) annotation(
    Line(points = {{-338, 40}, {-240, 40}, {-240, 80}, {0, 80}, {0, 66}, {18, 66}}, color = {0, 0, 127}));
  connect(QCtrlErr.y, multiSwitch.u[1]) annotation(
    Line(points = {{-258, 0}, {-240, 0}, {-240, 20}, {180, 20}, {180, 60}, {190, 60}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, multiSwitch.u[2]) annotation(
    Line(points = {{-38, 140}, {180, 140}, {180, 60}, {190, 60}}, color = {0, 0, 127}));
  connect(add6.y, multiSwitch.u[3]) annotation(
    Line(points = {{41, 60}, {190, 60}}, color = {0, 0, 127}));
  connect(rampLimiter2.y, switch5.u1) annotation(
    Line(points = {{521, 100}, {540, 100}, {540, 68}, {558, 68}}, color = {0, 0, 127}));
  connect(Zero2.y, switch5.u3) annotation(
    Line(points = {{522, 20}, {540, 20}, {540, 52}, {558, 52}}, color = {0, 0, 127}));
  connect(QVFlag0.y, switch5.u2) annotation(
    Line(points = {{521, 60}, {558, 60}}, color = {255, 0, 255}));
  connect(switch5.y, QInjRefPu) annotation(
    Line(points = {{581, 60}, {610, 60}}, color = {0, 0, 127}));
  connect(rampLimiter.y, add3.u1) annotation(
    Line(points = {{-498, -40}, {-40, -40}, {-40, -52}, {-22, -52}}, color = {0, 0, 127}));
  connect(PAuxPu, add3.u2) annotation(
    Line(points = {{-70, -60}, {-22, -60}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u2) annotation(
    Line(points = {{-558, -80}, {-240, -80}, {-240, -26}, {-42, -26}}, color = {0, 0, 127}));
  connect(firstOrder1.y, switch3.u1) annotation(
    Line(points = {{-398, -80}, {-240, -80}, {-240, -92}, {-222, -92}}, color = {0, 0, 127}));
  connect(PfPu.y, limiter4.u) annotation(
    Line(points = {{-199, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, not1.u) annotation(
    Line(points = {{122, 280}, {138, 280}}, color = {255, 0, 255}));
  connect(not1.y, onDelay.u) annotation(
    Line(points = {{161, 280}, {176, 280}}, color = {255, 0, 255}));
  connect(onDelay.y, not2.u) annotation(
    Line(points = {{202, 280}, {218, 280}}, color = {255, 0, 255}));
  connect(not2.y, freeze) annotation(
    Line(points = {{241, 280}, {610, 280}}, color = {255, 0, 255}));
  connect(not2.y, limPIDFreeze.freeze) annotation(
    Line(points = {{241, 280}, {334, 280}, {334, 72}}, color = {255, 0, 255}));
  connect(Zero3.y, switch3.u3) annotation(
    Line(points = {{-259, -140}, {-240, -140}, {-240, -108}, {-222, -108}}, color = {0, 0, 127}));
  connect(firstOrder5.y, voltageCheck.UPu) annotation(
    Line(points = {{-459, 120}, {-440, 120}, {-440, 280}, {100, 280}}, color = {0, 0, 127}));
  connect(omegaPu, switch6.u3) annotation(
    Line(points = {{-610, -220}, {-580, -220}, {-580, -280}, {-480, -280}, {-480, -248}, {-462, -248}}, color = {0, 0, 127}));
  connect(const1.y, switch6.u1) annotation(
    Line(points = {{-499, -200}, {-480, -200}, {-480, -232}, {-462, -232}}, color = {0, 0, 127}));
  connect(voltageCheck1.freeze, switch6.u2) annotation(
    Line(points = {{-459, 80}, {-440, 80}, {-440, 60}, {-540, 60}, {-540, -240}, {-462, -240}}, color = {255, 0, 255}));
  connect(lineDropCompensation1.U2Pu, voltageCheck1.UPu) annotation(
    Line(points = {{-538, 94}, {-500, 94}, {-500, 80}, {-481, 80}}, color = {0, 0, 127}));
  connect(firstOrder3.y, wCtrlErr.u2) annotation(
    Line(points = {{-398, -240}, {-380, -240}, {-380, -186}, {-362, -186}}, color = {0, 0, 127}));
  connect(switch6.y, firstOrder3.u) annotation(
    Line(points = {{-439, -240}, {-422, -240}}, color = {0, 0, 127}));
  connect(switch7.y, rampLimiter2.u) annotation(
    Line(points = {{461, 120}, {480, 120}, {480, 101}, {498, 101}, {498, 100}}, color = {0, 0, 127}));
  connect(leadLag.y, switch7.u3) annotation(
    Line(points = {{402, 60}, {420, 60}, {420, 112}, {438, 112}}, color = {0, 0, 127}));
  connect(not2.y, switch7.u2) annotation(
    Line(points = {{241, 280}, {400, 280}, {400, 120}, {438, 120}}, color = {255, 0, 255}));
  connect(switch7.y, fixedDelay.u) annotation(
    Line(points = {{461, 120}, {480, 120}, {480, 180}, {462, 180}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch7.u1) annotation(
    Line(points = {{439, 180}, {420, 180}, {420, 128}, {438, 128}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {-45, -130}, extent = {{-23, 10}, {21, -10}}, textString = "PAuxPu"), Text(origin = {-93, -130}, extent = {{-23, 10}, {21, -10}}, textString = "UAuxPu"), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC C")}),
    Diagram(coordinateSystem(extent = {{-600, -300}, {600, 300}})),
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power(0), voltage control(1) or power factor(2) dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = 1), voltage at remote bus can be controlled when VcompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu).PefdFlag allows to ignore the electrical power feedback. FfwrdFlag creates a feedforward path for the active current.  </p>
</html>"));
end REPCc;
