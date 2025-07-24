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
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC(add3(k2 = 1), firstOrder(UseFreeze = true, UseRateLim = true), limPID(Y0 = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then PInj0Pu - PGen0Pu else PInj0Pu, YMax = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then PiMaxPu else PMaxPu, YMin = if FfwrdFlag == true and PefdFlag == true and Kig > 0 then PiMinPu else PMinPu), RefFlag0(k = if RefFlag == 2 and abs(PInj0Pu / (sqrt(PInj0Pu ^ 2 + QInj0Pu ^ 2))) < 0.01 then 0 else RefFlag), multiSwitch(nu = 3));

  //Parameters REPC_C
  parameter Types.AngularVelocityPu DfMaxPu "Maximum limit on frequency deviation in pu (base omegaNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.AngularVelocityPu DfMinPu "Minimum limit on frequency deviation in pu (base omegaNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DPrMax "Maximum rate of increase of plant Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DPrMin "Maximum rate of decrease of plant Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DQRefMax "Maximum rate of increase of Q reference in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DQRefMin "Maximum rate of decrease of Q reference in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Boolean FfwrdFlag "Enable or disable feedforward path" annotation(
    Dialog(tab = "Plant Control"));
  parameter Boolean PefdFlag "Enable or disable electrical power feedback" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PfMax "Maximum limit on power factor" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PfMin "Minimum limit on power factor" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu PiMaxPu "Maximum limit of the active power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu PiMinPu "Minimum limit of the active power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PrMaxPu "Maximum rate of increase of Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PrMinPu "Maximum rate of decrease of Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ReactivePowerPu QRefMaxPu "Maximum limit on Qref in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ReactivePowerPu QRefMinPu "Minimum limit on Qref in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Boolean QVFlag "Disable volt/var control completely, or  enable volt/var control" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit QvrMax "Maximum rate of increase of Qext in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit QvrMin "Maximum rate of decrease of Qext in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tC "Time constant associated with reactive power measurement/filtering for the reactive droop function, in s";
  parameter Types.Time tFrq "Frequency transducer/filter time constant in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tFrz "Time delay during which the states are kept frozen after the filtered voltage recovers above Ufrz, in s";
  parameter Types.VoltageModulePu UFreqPu "If the voltage at the bus where frequency is monitored < UFreqPu then measured frequency is set to 1 pu, in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.VoltageModulePu URefMaxPu "Maximum limit on Uref in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.VoltageModulePu URefMinPu "Minimum limit on Uref in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) "Auxiliary power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-311, -81}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UAuxPu(start = 0) "Auxiliary voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-84, 160}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-82, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Sources.RealExpression PfPu(y = PGen0Pu / (sqrt(PGen0Pu ^ 2 + QGen0Pu ^ 2))) annotation(
    Placement(transformation(origin = {-272, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression PrMax0(y = PrMaxPu) annotation(
    Placement(transformation(origin = {66, -6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression PrMin0(y = PrMinPu) annotation(
    Placement(transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression freeze1(y = freeze) annotation(
    Placement(transformation(origin = {-26, -116}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant FfwrdFlag0(k = if PefdFlag == true and Kig > 0 then FfwrdFlag else false) annotation(
    Placement(transformation(origin = {-124, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant PefdFlag0(k = PefdFlag) annotation(
    Placement(transformation(origin = {-152, -16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant QVFlag0(k = QVFlag) annotation(
    Placement(transformation(origin = {132, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Acos acos annotation(
    Placement(transformation(origin = {-144, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4(k1 = -1) annotation(
    Placement(transformation(origin = {-54, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(transformation(origin = {44, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add6(k1 = 1, k2 = -1) annotation(
    Placement(transformation(origin = {-54, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 1) annotation(
    Placement(transformation(origin = {-254, -102}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFrq, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-254, -136}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tFilterPC, y_start = UInj0Pu) annotation(
    Placement(transformation(origin = {-230, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tFilterPC, y_start = U0Pu) annotation(
    Placement(transformation(origin = {-240, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tC, y_start = Kc * QGen0Pu) annotation(
    Placement(transformation(origin = {-218, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = 1e-4)  annotation(
    Placement(transformation(origin = {160, 112}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(uMax = DfMaxPu, uMin = DfMinPu) annotation(
    Placement(transformation(origin = {-180, -130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter5(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(transformation(origin = {76, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter6(uMax = URefMaxPu, uMin = URefMinPu) annotation(
    Placement(transformation(origin = {-50, 132}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter limiter7(uMax = QRefMaxPu, uMin = QRefMinPu) annotation(
    Placement(transformation(origin = {-272, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter4(uMax = PfMax, uMin = PfMin) annotation(
    Placement(transformation(origin = {-180, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(transformation(origin = {-200, 94}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Not not2 annotation(
    Placement(transformation(origin = {-144, 108}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.MathBoolean.OnDelay onDelay(delayTime = tFrz) annotation(
    Placement(transformation(origin = {-174, 108}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-82, 28}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DPrMax, DuMin = DPrMin, tS = 0.01, Y0 = PInj0Pu) annotation(
    Placement(transformation(origin = {-236, -30}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter1(DuMax = DQRefMax, DuMin = DQRefMin, tS = 0.01, Y0 = QGen0Pu) annotation(
    Placement(transformation(origin = {-198, -6}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter2(DuMax = QvrMax, DuMin = QvrMin, tS = 0.01, Y0 = QInj0Pu) annotation(
    Placement(transformation(origin = {182, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(transformation(origin = {-92, -12}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(transformation(origin = {-52, -72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch5 annotation(
    Placement(transformation(origin = {188, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch6 annotation(
    Placement(transformation(origin = {-280, -136}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch7 annotation(
    Placement(transformation(origin = {158, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Tan tan annotation(
    Placement(transformation(origin = {-116, 28}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck1(UMaxPu = 999, UMinPu = UFreqPu) annotation(
    Placement(transformation(origin = {-284, -102}, extent = {{-10, -10}, {10, 10}})));

equation
  assert((FfwrdFlag == true and PefdFlag == true and Kig > 0) or FfwrdFlag == false, "Incompatible value for the FfwrdFlag, it is set to false", AssertionLevel.warning);
  assert(not (initial() and RefFlag == 2 and abs(PfPu.y) < 0.01), "Constant power factor control at very low loads does not make sense, RefFlag0 turned to 0 for constant Q control", AssertionLevel.warning);

  connect(deadZone1.y, limiter3.u) annotation(
    Line(points = {{-206, -130}, {-192, -130}}, color = {0, 0, 127}));
  connect(limiter3.y, gain2.u) annotation(
    Line(points = {{-169, -130}, {-166, -130}}, color = {0, 0, 127}));
  connect(limiter3.y, gain1.u) annotation(
    Line(points = {{-169, -130}, {-165, -130}, {-165, -90}, {-168, -90}}, color = {0, 0, 127}));
  connect(PRefPu, rampLimiter.u) annotation(
    Line(points = {{-310, -30}, {-248, -30}}, color = {0, 0, 127}));
  connect(add4.y, PRefLim.u) annotation(
    Line(points = {{-43, -30}, {-35, -30}, {-35, -50}, {-36, -50}}, color = {0, 0, 127}));
  connect(add3.y, add4.u2) annotation(
    Line(points = {{-68, -50}, {-66, -50}, {-66, -36}}, color = {0, 0, 127}));
  connect(switch3.y, add4.u1) annotation(
    Line(points = {{-81, -12}, {-76, -12}, {-76, -24}, {-66, -24}}, color = {0, 0, 127}));
  connect(PefdFlag0.y, switch3.u2) annotation(
    Line(points = {{-141, -16}, {-122.5, -16}, {-122.5, -12}, {-104, -12}}, color = {255, 0, 255}));
  connect(freeze1.y, limPID.freeze) annotation(
    Line(points = {{-14, -116}, {4, -116}, {4, -62}}, color = {255, 0, 255}));
  connect(freeze1.y, firstOrder.freeze) annotation(
    Line(points = {{-14, -116}, {4, -116}, {4, -70}, {104, -70}, {104, -62}}, color = {255, 0, 255}));
  connect(PrMax0.y, firstOrder.dyMax) annotation(
    Line(points = {{77, -6}, {98, -6}, {98, -44}}, color = {0, 0, 127}));
  connect(PrMin0.y, firstOrder.dyMin) annotation(
    Line(points = {{77, -20}, {89.5, -20}, {89.5, -56}, {98, -56}}, color = {0, 0, 127}));
  connect(limPID.y, add5.u1) annotation(
    Line(points = {{22, -50}, {32, -50}, {32, -44}}, color = {0, 0, 127}));
  connect(limiter5.y, firstOrder.u) annotation(
    Line(points = {{87, -50}, {98, -50}}, color = {0, 0, 127}));
  connect(add5.y, limiter5.u) annotation(
    Line(points = {{55, -50}, {64, -50}}, color = {0, 0, 127}));
  connect(firstOrder.y, switch.u1) annotation(
    Line(points = {{122, -50}, {138, -50}, {138, -74}, {90, -74}, {90, -82}, {98, -82}}, color = {0, 0, 127}));
  connect(add3.y, switch4.u1) annotation(
    Line(points = {{-68, -50}, {-64, -50}, {-64, -64}}, color = {0, 0, 127}));
  connect(Zero.y, switch4.u3) annotation(
    Line(points = {{-18, -90}, {-12, -90}, {-12, -104}, {-64, -104}, {-64, -80}}, color = {0, 0, 127}));
  connect(FfwrdFlag0.y, switch4.u2) annotation(
    Line(points = {{-113, -60}, {-104, -60}, {-104, -72}, {-64, -72}}, color = {255, 0, 255}));
  connect(switch4.y, add5.u2) annotation(
    Line(points = {{-40, -72}, {32, -72}, {32, -56}}, color = {0, 0, 127}));
  connect(switch2.y, UCtrlErr.u2) annotation(
    Line(points = {{-98, 80}, {-60, 80}, {-60, 90}, {-50, 90}}, color = {0, 0, 127}));
  connect(UAuxPu, UCtrlErr.u3) annotation(
    Line(points = {{-84, 160}, {-84, 82}, {-50, 82}}, color = {0, 0, 127}));
  connect(URefPu, limiter6.u) annotation(
    Line(points = {{-50, 160}, {-50, 144}}, color = {0, 0, 127}));
  connect(limiter6.y, UCtrlErr.u1) annotation(
    Line(points = {{-50, 122}, {-56, 122}, {-56, 98}, {-50, 98}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, firstOrder4.u) annotation(
    Line(points = {{-258, 106}, {-248, 106}, {-248, 120}, {-242, 120}}, color = {0, 0, 127}));
  connect(firstOrder4.y, switch2.u1) annotation(
    Line(points = {{-218, 120}, {-130, 120}, {-130, 88}, {-122, 88}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, firstOrder5.u) annotation(
    Line(points = {{-258, 94}, {-252, 94}, {-252, 70}}, color = {0, 0, 127}));
  connect(firstOrder5.y, QVCtrlErr.u1) annotation(
    Line(points = {{-228, 70}, {-220, 70}, {-220, 62}, {-194, 62}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder6.u) annotation(
    Line(points = {{-258, 50}, {-244, 50}, {-244, 42}, {-230, 42}}, color = {0, 0, 127}));
  connect(firstOrder6.y, QVCtrlErr.u2) annotation(
    Line(points = {{-207, 42}, {-194, 42}, {-194, 50}}, color = {0, 0, 127}));
  connect(QRefPu, limiter7.u) annotation(
    Line(points = {{-308, 0}, {-284, 0}}, color = {0, 0, 127}));
  connect(limiter7.y, rampLimiter1.u) annotation(
    Line(points = {{-261, 0}, {-249.25, 0}, {-249.25, -4}, {-249.5, -4}, {-249.5, -6}, {-210, -6}}, color = {0, 0, 127}));
  connect(rampLimiter1.y, QCtrlErr.u2) annotation(
    Line(points = {{-186, -6}, {-174, -6}, {-174, 6}, {-52, 6}, {-52, -2}, {-44, -2}}, color = {0, 0, 127}));
  connect(limiter4.y, acos.u) annotation(
    Line(points = {{-169, 28}, {-156, 28}}, color = {0, 0, 127}));
  connect(acos.y, tan.u) annotation(
    Line(points = {{-133, 28}, {-128, 28}}, color = {0, 0, 127}));
  connect(tan.y, product.u1) annotation(
    Line(points = {{-104, 28}, {-94, 28}, {-94, 34}}, color = {0, 0, 127}));
  connect(product.y, add6.u1) annotation(
    Line(points = {{-70, 28}, {-66, 28}, {-66, 34}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add6.u2) annotation(
    Line(points = {{-218, 10}, {-66, 10}, {-66, 22}}, color = {0, 0, 127}));
  connect(QCtrlErr.y, multiSwitch.u[1]) annotation(
    Line(points = {{-20, 4}, {-20, 50}, {-10, 50}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, multiSwitch.u[2]) annotation(
    Line(points = {{-26, 90}, {-20, 90}, {-20, 50}, {-10, 50}}, color = {0, 0, 127}));
  connect(add6.y, multiSwitch.u[3]) annotation(
    Line(points = {{-42, 28}, {-40, 28}, {-40, 50}, {-10, 50}}, color = {0, 0, 127}));
  connect(rampLimiter2.y, switch5.u1) annotation(
    Line(points = {{193, 50}, {193, 36}, {176, 36}, {176, 30}}, color = {0, 0, 127}));
  connect(Zero1.y, switch5.u3) annotation(
    Line(points = {{110, 96}, {106, 96}, {106, 66}, {116, 66}, {116, 14}, {176, 14}}, color = {0, 0, 127}));
  connect(QVFlag0.y, switch5.u2) annotation(
    Line(points = {{144, 22}, {176, 22}}, color = {255, 0, 255}));
  connect(switch5.y, QInjRefPu) annotation(
    Line(points = {{199, 22}, {199, 50}, {210, 50}}, color = {0, 0, 127}));
  connect(rampLimiter.y, add3.u1) annotation(
    Line(points = {{-224, -30}, {-92, -30}, {-92, -42}}, color = {0, 0, 127}));
  connect(PAuxPu, add3.u2) annotation(
    Line(points = {{-310, -80}, {-178, -80}, {-178, -50}, {-92, -50}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u2) annotation(
    Line(points = {{-258, -50}, {-188, -50}, {-188, -22}, {-164, -22}, {-164, 14}, {-94, 14}, {-94, 22}}, color = {0, 0, 127}));
  connect(firstOrder1.y, switch3.u1) annotation(
    Line(points = {{-258, -50}, {-188, -50}, {-188, -38}, {-114, -38}, {-114, -20}, {-104, -20}}, color = {0, 0, 127}));
  connect(PfPu.y, limiter4.u) annotation(
    Line(points = {{-260, 26}, {-192, 26}, {-192, 28}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, not1.u) annotation(
    Line(points = {{-218, 94}, {-212, 94}}, color = {255, 0, 255}));
  connect(not1.y, onDelay.u) annotation(
    Line(points = {{-188, 94}, {-188, 108}}, color = {255, 0, 255}));
  connect(onDelay.y, not2.u) annotation(
    Line(points = {{-162, 108}, {-156, 108}}, color = {255, 0, 255}));
  connect(not2.y, freeze) annotation(
    Line(points = {{-132, 108}, {-122, 108}, {-122, 102}, {-102, 102}}, color = {255, 0, 255}));
  connect(not2.y, limPIDFreeze.freeze) annotation(
    Line(points = {{-132, 108}, {90, 108}, {90, 62}}, color = {255, 0, 255}));
  connect(Zero.y, switch3.u3) annotation(
    Line(points = {{-18, -90}, {-12, -90}, {-12, -104}, {-64, -104}, {-64, -78}, {-108, -78}, {-108, -4}, {-104, -4}}, color = {0, 0, 127}));
  connect(firstOrder5.y, voltageCheck.UPu) annotation(
    Line(points = {{-228, 70}, {-226, 70}, {-226, 82}, {-246, 82}, {-246, 94}, {-240, 94}}, color = {0, 0, 127}));
  connect(omegaPu, switch6.u3) annotation(
    Line(points = {{-310, -140}, {-310, -144}, {-292, -144}}, color = {0, 0, 127}));
  connect(const1.y, switch6.u1) annotation(
    Line(points = {{-242, -102}, {-242, -122}, {-292, -122}, {-292, -128}}, color = {0, 0, 127}));
  connect(voltageCheck1.freeze, switch6.u2) annotation(
    Line(points = {{-272, -102}, {-270, -102}, {-270, -116}, {-298, -116}, {-298, -136}, {-292, -136}}, color = {255, 0, 255}));
  connect(lineDropCompensation1.U2Pu, voltageCheck1.UPu) annotation(
    Line(points = {{-258, 94}, {-256, 94}, {-256, -84}, {-300, -84}, {-300, -102}, {-294, -102}}, color = {0, 0, 127}));
  connect(firstOrder3.y, wCtrlErr.u2) annotation(
    Line(points = {{-243, -136}, {-236, -136}}, color = {0, 0, 127}));
  connect(switch6.y, firstOrder3.u) annotation(
    Line(points = {{-269, -136}, {-266, -136}}, color = {0, 0, 127}));
  connect(switch7.y, rampLimiter2.u) annotation(
    Line(points = {{169, 80}, {169, 63}, {170, 63}, {170, 50}}, color = {0, 0, 127}));
  connect(leadLag.y, switch7.u3) annotation(
    Line(points = {{146, 50}, {146, 72}}, color = {0, 0, 127}));
  connect(not2.y, switch7.u2) annotation(
    Line(points = {{-132, 108}, {90, 108}, {90, 80}, {146, 80}}, color = {255, 0, 255}));
  connect(switch7.y, fixedDelay.u) annotation(
    Line(points = {{169, 80}, {184, 80}, {184, 112}, {172, 112}}, color = {0, 0, 127}));
  connect(fixedDelay.y, switch7.u1) annotation(
    Line(points = {{150, 112}, {136, 112}, {136, 88}, {146, 88}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {-45, -130}, extent = {{-23, 10}, {21, -10}}, textString = "PAuxPu"), Text(origin = {-93, -130}, extent = {{-23, 10}, {21, -10}}, textString = "UAuxPu"), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC C")}),
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power(0), voltage control(1) or power factor(2) dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = 1), voltage at remote bus can be controlled when VcompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu).PefdFlag allows to ignore the electrical power feedback. FfwrdFlag creates a feedforward path for the active current.  </p>
</html>"));
end REPCc;
