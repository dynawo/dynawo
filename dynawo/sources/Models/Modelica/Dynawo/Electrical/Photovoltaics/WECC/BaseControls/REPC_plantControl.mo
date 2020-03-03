within Dynawo.Electrical.Photovoltaics.WECC.BaseControls;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/


model REPC_plantControl "Renewable Energy Plant Control"
  import Modelica.Blocks;
  import Modelica.ComplexBlocks;
  import Dynawo.Types;
  import Dynawo.Electrical.Photovoltaics.WECC.Utilities;

  parameter Boolean RefFlag "Plant level reactive power (0) or voltage control (1)";
  parameter Boolean VcompFlag "Reactive droop (0) or line drop compensation (1) if RefFlag true";
  parameter Boolean FreqFlag "Governor response disable (0) or enable (1)";
  parameter Types.PerUnit Rc "Line drop compensation resistance when VcompFlag = 1 (typical: -)";
  parameter Types.PerUnit Xc "Line drop compensation reactance when VcompFlag = 1 (typical: -)";
  parameter Types.PerUnit Kc "Reactive droop when VcompFlag = 0 (typical: -)";
  parameter Types.Time Tfltr "Voltage and reactive power filter time constant (typical: 0.01..0.02, chosen: 0.04)";
  parameter Types.PerUnit dbd "Reactive power deadband when RefFlag = 0; Voltage deadband when RefFlag = 1  (typical: -, chosen: 0.01)";
  parameter Types.PerUnit eMax "Maximum Volt/VAR error (typical: -, chosen: 999)";
  parameter Types.PerUnit eMin "Minimum Volt/VAR error (typical: -, chosen: -999)";
  parameter Types.PerUnit QMax "Maximum plant level reactive power command  (typical: -, chosen: 0.4)";
  parameter Types.PerUnit QMin "Minimum plant level reactive power command  (typical: -, chosen: -0.4)";
  parameter Types.Time Tft "Plant controller Q output lead time constant  (typical: -, chosen: 0)";
  parameter Types.Time Tfv "Plant controller Q output lag time constant  (typical: 0.15..5, chosen: 0.1)";
  parameter Types.Time Tp "Active power filter time constant (typical: 0.01..0.02, chosen: 0.04)";
  parameter Types.PerUnit fdbd1 "Overfrequency deadband for governor response (typical: 0.004, chosen: 0.004)";
  parameter Types.PerUnit fdbd2 "Underfrequency deadband for governor response (typical: 0.004, chosen: 1)";
  parameter Types.PerUnit Ddn "Down regulation droop (typical: 20..33.3, chosen: 20)";
  parameter Types.PerUnit Dup "Up regulation droop (typical: 0, chosen: 0)";
  parameter Types.PerUnit feMax "Maximum power error in droop regulator (typical: -, chosen: 999)";
  parameter Types.PerUnit feMin "Minimum power error in droop regulator (typical: -, chosen: -999)";
  parameter Types.PerUnit PMax "Maximum plant level active power command (typical: 1, chosen: 1)";
  parameter Types.PerUnit PMin "Minimum plant level active power command (typical: 0, chosen: 0)";
  parameter Types.Time Tlag "Plant controller P output lag time constant (typical: 0.15..5, chosen: 0.1)";
  parameter Types.PerUnit Kp "Volt/VAR regulator proportional gain (typical: -, chosen: 0.1)";
  parameter Types.PerUnit Ki "Volt/VAR regulator integral gain (typical: -, chosen: 1.5)";
  parameter Types.PerUnit Kpg "Droop regulator proportional gain (typical: -, chosen: 0.05)";
  parameter Types.PerUnit Kig "Droop regulator integral gain (typical: -, chosen: 2.36)";
  parameter Types.PerUnit Vfrz "Voltage for freezing Volt/VAR regulator integrator (typical: 0..0.9, chosen: 0)";

  // Inputs_setpoints:
  Blocks.Interfaces.RealInput PRefPu_PC "Plant level active power setpoint, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-308, -36}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-300, 120}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Blocks.Interfaces.RealInput QRefPu_PC "Plant level reactive power setpoint, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-308, -4}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-300, 40}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Blocks.Interfaces.RealInput OmegaRefPu_PC "Plant level frequency setpoint" annotation(
    Placement(visible = true, transformation(origin = {-308, -118}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-298, -120}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  // Inputs_measurements from regulated bus, injector convention:
  Blocks.Interfaces.RealInput PRegPu(start = PReg0Pu) "Measured active power at regulated bus, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-170, -160}, extent = {{-17, -17}, {17, 17}}, rotation = 90), iconTransformation(origin = {10, -152}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Measured reactive power at regulated bus, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-202, -160}, extent = {{-17, -17}, {17, 17}}, rotation = 90), iconTransformation(origin = {-70, -152}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  ComplexBlocks.Interfaces.ComplexInput uRegPu(re(start = uReg0Pu.re), im(start = uReg0Pu.im)) "Complex voltage at regulated bus" annotation(
    Placement(visible = true, transformation(origin = {-236, -156}, extent = {{-17, -17}, {17, 17}}, rotation = 90), iconTransformation(origin = {-148, -152}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));
  ComplexBlocks.Interfaces.ComplexInput iRegPu(re(start = iReg0Pu.re), im(start = iReg0Pu.im)) "Complex current at regulated bus, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-272, -156}, extent = {{-17, -17}, {17, 17}}, rotation = 90), iconTransformation(origin = {-253, -151}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Blocks.Interfaces.RealInput OmegaPu "Frequency at regulated bus (pu base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, -160}, extent = {{-17, -17}, {17, 17}}, rotation = 90), iconTransformation(origin = {90, -152}, extent = {{9, -9}, {-9, 9}}, rotation = -90)));

  // Outputs:
  Blocks.Interfaces.RealOutput PRefPu_EC(start = P0Pu) "Setpoint active power from plant level, injector convention, pu base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -73}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {202, -118}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput Q_VRefPu_EC(start = Q0Pu) "Setpoint inductive reactive power from plant level, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {208, 87}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {202, -58}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));

  //Blocks:
  Blocks.Logical.Switch FreqFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {170, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.BooleanConstant FreqFlag_const(k = FreqFlag) annotation(
    Placement(visible = true, transformation(origin = {130, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Pref_lag(T = Tlag, initType = Modelica.Blocks.Types.Init.SteadyState) annotation(
    Placement(visible = true, transformation(origin = {130, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {70, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter Pref_Lim(limitsAtInit = true, uMax = feMax, uMin = feMin) annotation(
    Placement(visible = true, transformation(origin = {70, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.LimPID PID_P(Ti = Kpg / Kig, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.InitPID.SteadyState, k = Kpg, limitsAtInit = true, xi_start = P0Pu / Kpg, yMax = PMax, yMin = PMin, y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {100, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add3 PCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {10, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Pbranch_Filt(T = Tp, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = PReg0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter QVErr_Lim(limitsAtInit = true, uMax = eMax, uMin = eMin) annotation(
    Placement(visible = true, transformation(origin = {110, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.TransferFunction QVext_LeadLag(a = {Tfv, 1}, b = {Tft, 1}, initType = Modelica.Blocks.Types.Init.NoInit) annotation(
    Placement(visible = true, transformation(origin = {170, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {114, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.BooleanConstant RefFlag_const(k = RefFlag) annotation(
    Placement(visible = true, transformation(origin = {-18, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch RefFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {50, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.DeadZone QVext_dbd(uMax = dbd, uMin = -dbd) annotation(
    Placement(visible = true, transformation(origin = {80, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Qbranch_Filt(T = Tfltr, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = QReg0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add QCtrlErr(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {10, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {10, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Ubranch_Filt(T = Tfltr, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = if VcompFlag == true then URefPu else UReg0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.calcUPCC calcUPCC1(Rc = Rc, Xc = Xc) annotation(
    Placement(visible = true, transformation(origin = {-174, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch VCompFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {-80, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.BooleanConstant VCompFlag_const(k = VcompFlag) annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add QVCtrlErr annotation(
    Placement(visible = true, transformation(origin = {-130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain GainKc(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-164, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add wCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-122, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.DeadZone Frq_dbd(deadZoneAtInit = true, uMax = fdbd2, uMin = -fdbd1) annotation(
    Placement(visible = true, transformation(origin = {-90, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add dPfreq annotation(
    Placement(visible = true, transformation(origin = {30, -118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain dPfreq_down(k = Ddn) annotation(
    Placement(visible = true, transformation(origin = {-42, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain dPfreq_up(k = Dup) annotation(
    Placement(visible = true, transformation(origin = {-42, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter dPfreq_down_lim(limitsAtInit = true, uMax = 0, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-10, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter dPfreq_up_lim(limitsAtInit = true, uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant const(k = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.LimPID_freeze PID_Q(Td = 0, Ti = Kp / Ki, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.InitPID.InitialState, k = Kp, limitsAtInit = true, xi_start = Q0Pu / Kp, yMax = QMax, yMin = QMin, y_start = Q0Pu) annotation(
    Placement(visible = true, transformation(origin = {140, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.Voltage_check voltage_check1(Vdip = Vfrz, Vup = 999) annotation(
    Placement(visible = true, transformation(origin = {68, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant uRefPu(k = URefPu) annotation(
    Placement(visible = true, transformation(origin = {-82, 128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.PerUnit PReg0Pu "Initial value active power at regulated bus, injector convention, base SNom";
  parameter Types.PerUnit QReg0Pu "Initial value reactive power at regulated bus, injector convention, base SNom";
  parameter Types.PerUnit UReg0Pu "Initial value voltage at regulated bus";
  parameter Types.ComplexPerUnit uReg0Pu "Initial value complex voltage at regulated bus";
  parameter Types.ComplexPerUnit iReg0Pu "Initial value complex current at regulated bus, injector convention, base SNom";
  parameter Types.PerUnit Omega0Pu "Initial value frequency at regulated bus";
  parameter Types.PerUnit P0Pu "Initial value terminal active power, injector convention, base SNom";
  parameter Types.PerUnit Q0Pu "Initial value terminal reactive power, injector convention, base SNom";
  final parameter Types.PerUnit URefPu = if VcompFlag == true then sqrt((uReg0Pu.re + Rc * iReg0Pu.re - Xc * iReg0Pu.im) ^ 2 + (uReg0Pu.im + Rc * iReg0Pu.im + Xc * iReg0Pu.re) ^ 2) else (UReg0Pu + Kc * QReg0Pu) "Setpoint voltage for plant level control, calculated depending on VcompFlag.";

equation

  connect(uRefPu.y, UCtrlErr.u1) annotation(
    Line(points = {{-71, 128}, {-20, 128}, {-20, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(voltage_check1.freeze, PID_Q.freeze) annotation(
    Line(points = {{80, 34}, {134, 34}, {134, 70}, {134.5, 70}, {134.5, 74}, {133, 74}}, color = {255, 0, 255}));
  connect(iRegPu, calcUPCC1.iPu) annotation(
    Line(points = {{-272, -156}, {-272, 118}, {-184, 118}}, color = {0, 0, 127}));
  connect(calcUPCC1.UPu, QVCtrlErr.u1) annotation(
    Line(points = {{-164, 106}, {-153.8, 106}, {-153.8, 56}, {-141.8, 56}}, color = {0, 0, 127}));
  connect(calcUPCC1.UPuLineDrop, VCompFlagSwitch.u1) annotation(
    Line(points = {{-164, 118}, {-112, 118}, {-112, 96}, {-92, 96}}, color = {0, 0, 127}));
  connect(uRegPu, calcUPCC1.uPu) annotation(
    Line(points = {{-236, -156}, {-237, -156}, {-237, 106}, {-184, 106}}, color = {85, 170, 255}));
  connect(calcUPCC1.UPu, voltage_check1.Vt) annotation(
    Line(points = {{-164, 106}, {-148, 106}, {-148, 34}, {56, 34}}, color = {0, 0, 127}));
  connect(QVErr_Lim.y, PID_Q.u_s) annotation(
    Line(points = {{122, 86}, {128, 86}}, color = {0, 0, 127}));
  connect(PID_Q.y, QVext_LeadLag.u) annotation(
    Line(points = {{151, 86}, {158, 86}}, color = {0, 0, 127}));
  connect(Zero1.y, PID_Q.u_m) annotation(
    Line(points = {{125, 16}, {140, 16}, {140, 74}}, color = {0, 0, 127}));
  connect(PRegPu, Pbranch_Filt.u) annotation(
    Line(points = {{-170, -160}, {-170, -58}, {-62, -58}}, color = {0, 0, 127}));
  connect(QRegPu, Qbranch_Filt.u) annotation(
    Line(points = {{-202, -160}, {-202, 16}, {-62, 16}}, color = {0, 0, 127}));
  connect(GainKc.u, QRegPu) annotation(
    Line(points = {{-176, 44}, {-202, 44}, {-202, -160}}, color = {0, 0, 127}));
  connect(OmegaPu, wCtrlErr.u2) annotation(
    Line(points = {{-140, -160}, {-141, -160}, {-141, -130}, {-134, -130}}, color = {0, 0, 127}));
  connect(FreqFlagSwitch.y, PRefPu_EC) annotation(
    Line(points = {{181, -74}, {197, -74}, {197, -72}, {209, -72}}, color = {0, 0, 127}));
  connect(QVext_LeadLag.y, Q_VRefPu_EC) annotation(
    Line(points = {{181, 86}, {208, 86}, {208, 87}}, color = {0, 0, 127}));
  connect(OmegaRefPu_PC, wCtrlErr.u1) annotation(
    Line(points = {{-308, -118}, {-134, -118}}, color = {0, 0, 127}));
  connect(wCtrlErr.y, Frq_dbd.u) annotation(
    Line(points = {{-111, -124}, {-103, -124}, {-103, -124}, {-103, -124}}, color = {0, 0, 127}));
  connect(Frq_dbd.y, dPfreq_down.u) annotation(
    Line(points = {{-79, -124}, {-69, -124}, {-69, -90}, {-55, -90}, {-55, -90}}, color = {0, 0, 127}));
  connect(Frq_dbd.y, dPfreq_up.u) annotation(
    Line(points = {{-79, -124}, {-57, -124}, {-57, -124}, {-55, -124}}, color = {0, 0, 127}));
  connect(dPfreq_down_lim.y, dPfreq.u1) annotation(
    Line(points = {{1, -90}, {9, -90}, {9, -112}, {17, -112}, {17, -112}}, color = {0, 0, 127}));
  connect(dPfreq.y, PCtrlErr.u3) annotation(
    Line(points = {{41, -118}, {45, -118}, {45, -62}, {-17, -62}, {-17, -52}, {-3, -52}, {-3, -52}}, color = {0, 0, 127}));
  connect(dPfreq_up_lim.y, dPfreq.u2) annotation(
    Line(points = {{1, -124}, {17, -124}, {17, -124}, {17, -124}}, color = {0, 0, 127}));
  connect(dPfreq_up.y, dPfreq_up_lim.u) annotation(
    Line(points = {{-31, -124}, {-23, -124}, {-23, -124}, {-23, -124}}, color = {0, 0, 127}));
  connect(PRefPu_PC, PCtrlErr.u1) annotation(
    Line(points = {{-308, -36}, {-2, -36}}, color = {0, 0, 127}));
  connect(const.y, FreqFlagSwitch.u3) annotation(
    Line(points = {{141, -112}, {149, -112}, {149, -82}, {157, -82}, {157, -82}}, color = {0, 0, 127}));
  connect(FreqFlag_const.y, FreqFlagSwitch.u2) annotation(
    Line(points = {{141, -74}, {157, -74}, {157, -74}, {157, -74}}, color = {255, 0, 255}));
  connect(Pref_lag.y, FreqFlagSwitch.u1) annotation(
    Line(points = {{141, -44}, {149, -44}, {149, -66}, {157, -66}, {157, -66}}, color = {0, 0, 127}));
  connect(PID_P.y, Pref_lag.u) annotation(
    Line(points = {{111, -44}, {117, -44}, {117, -44}, {117, -44}}, color = {0, 0, 127}));
  connect(Zero.y, PID_P.u_m) annotation(
    Line(points = {{81, -94}, {99, -94}, {99, -56}, {99, -56}}, color = {0, 0, 127}));
  connect(Pref_Lim.y, PID_P.u_s) annotation(
    Line(points = {{81, -44}, {85, -44}, {85, -44}, {87, -44}}, color = {0, 0, 127}));
  connect(PCtrlErr.y, Pref_Lim.u) annotation(
    Line(points = {{21, -44}, {57, -44}, {57, -44}, {57, -44}, {57, -44}}, color = {0, 0, 127}));
  connect(Pbranch_Filt.y, PCtrlErr.u2) annotation(
    Line(points = {{-39, -58}, {-31, -58}, {-31, -44}, {-3, -44}, {-3, -44}}, color = {0, 0, 127}));
  connect(QVext_dbd.y, QVErr_Lim.u) annotation(
    Line(points = {{91, 86}, {95, 86}, {95, 86}, {97, 86}}, color = {0, 0, 127}));
  connect(RefFlag_const.y, RefFlagSwitch.u2) annotation(
    Line(points = {{-7, 66}, {25, 66}, {25, 86}, {37, 86}, {37, 86}}, color = {255, 0, 255}));
  connect(RefFlagSwitch.y, QVext_dbd.u) annotation(
    Line(points = {{61, 86}, {67, 86}, {67, 86}, {67, 86}}, color = {0, 0, 127}));
  connect(QCtrlErr.y, RefFlagSwitch.u3) annotation(
    Line(points = {{21, 2}, {31, 2}, {31, 78}, {37, 78}, {37, 78}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, RefFlagSwitch.u1) annotation(
    Line(points = {{21, 94}, {35, 94}, {35, 94}, {37, 94}, {37, 94}}, color = {0, 0, 127}));
  connect(QRefPu_PC, QCtrlErr.u2) annotation(
    Line(points = {{-308, -4}, {-2, -4}}, color = {0, 0, 127}));
  connect(Qbranch_Filt.y, QCtrlErr.u1) annotation(
    Line(points = {{-39, 16}, {-19, 16}, {-19, 8}, {-3, 8}, {-3, 8}}, color = {0, 0, 127}));
  connect(Ubranch_Filt.y, UCtrlErr.u2) annotation(
    Line(points = {{-39, 88}, {-5, 88}, {-5, 88}, {-3, 88}}, color = {0, 0, 127}));
  connect(dPfreq_down.y, dPfreq_down_lim.u) annotation(
    Line(points = {{-31, -90}, {-23, -90}, {-23, -90}, {-23, -90}}, color = {0, 0, 127}));
  connect(VCompFlagSwitch.y, Ubranch_Filt.u) annotation(
    Line(points = {{-69, 88}, {-63, 88}, {-63, 88}, {-63, 88}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, VCompFlagSwitch.u3) annotation(
    Line(points = {{-119, 50}, {-101, 50}, {-101, 80}, {-93, 80}, {-93, 80}}, color = {0, 0, 127}));
  connect(VCompFlag_const.y, VCompFlagSwitch.u2) annotation(
    Line(points = {{-119, 80}, {-105, 80}, {-105, 88}, {-93, 88}, {-93, 88}}, color = {255, 0, 255}));
  connect(GainKc.y, QVCtrlErr.u2) annotation(
    Line(points = {{-153, 44}, {-143, 44}, {-143, 44}, {-143, 44}}, color = {0, 0, 127}));

  annotation(
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled when VcompFlag == true. Therefore, Rc and Xc shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, Vcomp should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uRegPu, iRegPu). </p>
</html>"),
    Diagram(coordinateSystem(extent = {{-300, -150}, {200, 150}})),
    Icon(coordinateSystem(extent = {{-300, -150}, {200, 150}}, initialScale = 0.1), graphics = {Rectangle(extent = {{-300, 150}, {200, -150}}), Text(origin = {-65, 2}, extent = {{-133, 108}, {133, -106}}, textString = "Plant
Ctrl")}),
    version = "",
    uses(Modelica(version = "3.2.3")),
    __OpenModelica_commandLineOptions = "");

end REPC_plantControl;
