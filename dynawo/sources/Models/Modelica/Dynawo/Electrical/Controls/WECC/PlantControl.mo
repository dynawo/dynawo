within Dynawo.Electrical.Controls.WECC;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PlantControl "WECC PV Plant Control REPC"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.Controls.WECC.BaseControls;
  import Dynawo.Electrical.SystemBase;

  extends Parameters.Params_PlantControl;

  Modelica.Blocks.Interfaces.RealInput PRefPu_PC(start = PGen0Pu) "Active power setpoint at regulated bus in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu_PC(start = QGen0Pu) "Reactive power setpoint at regulated bus in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-309, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -59}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaRefPu(start = SystemBase.omega0Pu) "Frequency setpoint" annotation(
    Placement(visible = true, transformation(origin = {-310, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRegPu(start = PGen0Pu) "Active power at regulated bus in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {79, 111}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QGen0Pu) "Reactive power at regulated bus in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {31, 111}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at regulated bus in p.u" annotation(
    Placement(visible = true, transformation(origin = {-310, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-31, 111}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = iInj0Pu.re), im(start = iInj0Pu.im)) "Complex current at regulated bus in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-79, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput OmegaPu(start = SystemBase.omega0Pu) "Frequency at regulated bus in p.u (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 79}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu, fixed = true) "Active power setpoint at inverter terminal in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu, fixed = true) "Reactive power setpoint at inverter terminal in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput freeze annotation(
    Placement(visible = true, transformation(origin = {-190, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch FreqFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant FreqFlag_const(k = FreqFlag) annotation(
    Placement(visible = true, transformation(origin = {51, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder Pref_lag(T = Tlag, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-69, -91}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter Pref_Lim(limitsAtInit = true, uMax = feMax, uMin = feMin) annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID PID_P(Ti = Kpg / Kig, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.InitPID.SteadyState, k = Kpg, limitsAtInit = true, xi_start = PInj0Pu / Kpg, yMax = PMax, yMin = PMin, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 PCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder Pbranch_Filt(T = Tp, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270,-50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter QVErr_Lim(limitsAtInit = true, uMax = eMax, uMin = eMin) annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction QVext_LeadLag(a = {Tfv, 1}, b = {Tft, 1}, initType = Modelica.Blocks.Types.Init.NoInit, y_start = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {150, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant RefFlag_const(k = RefFlag) annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch RefFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {9, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone QVext_dbd(uMax = dbd, uMin = -dbd) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder Qbranch_Filt(T = Tfltr, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add QCtrlErr(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-29, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder Ubranch_Filt(T = Tfltr, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = if VcompFlag == true then URefPu else UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.LineDropCompensation lineDropCompensation1(Rc = Rc, Xc = Xc) annotation(
    Placement(visible = true, transformation(origin = {-270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch VCompFlagSwitch annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant VCompFlag_const(k = VcompFlag) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add QVCtrlErr annotation(
    Placement(visible = true, transformation(origin = {-230, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainKc(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-270, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add wCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-270, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone Frq_dbd(deadZoneAtInit = true, uMax = fdbd2, uMin = -fdbd1) annotation(
    Placement(visible = true, transformation(origin = {-230, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add dPfreq annotation(
    Placement(visible = true, transformation(origin = {-110, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain dPfreq_down(k = Ddn) annotation(
    Placement(visible = true, transformation(origin = {-190, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain dPfreq_up(k = Dup) annotation(
    Placement(visible = true, transformation(origin = {-190, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter dPfreq_down_lim(limitsAtInit = true, uMax = 0, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter dPfreq_up_lim(limitsAtInit = true, uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-149, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze PID_Q(Td = 0, Ti = Kp / Ki, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.InitPID.InitialState, k = Kp, limitsAtInit = true, xi_start = QInj0Pu / Kp, yMax = QMax, yMin = QMin, y_start = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltage_check1(UMinPu = Vfrz, UMaxPu = 999) annotation(
    Placement(visible = true, transformation(origin = {-230, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant uRefPu(k = URefPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression freeze1(y = freeze)  annotation(
    Placement(visible = true, transformation(origin = {100, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.PerUnit PGen0Pu "Start value of active power at regulated bus in p.u (generator convention) (base SNom)";
  parameter Types.PerUnit QGen0Pu "Start value of reactive power at regulated bus in p.u (generator convention) (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in p.u";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at regulated bus in p.u";
  parameter Types.PerUnit UInj0Pu "Start value of voltage magnitude at injector terminal in p.u";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at regulated bus in p.u (generator convention) (base SNom)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in p.u (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in p.u (injector convention) (base SNom)";
  final parameter Types.PerUnit URefPu = if VcompFlag == true then UInj0Pu else (U0Pu + Kc * QGen0Pu) "Voltage setpoint for plant level control, calculated depending on VcompFlag";

equation
  connect(lineDropCompensation1.U2Pu, voltage_check1.UPu) annotation(
    Line(points = {{-259, 94}, {-241, 94}}, color = {0, 0, 127}));
  connect(PID_Q.y, QVext_LeadLag.u) annotation(
    Line(points = {{141, 50}, {158, 50}}, color = {0, 0, 127}));
  connect(PRegPu, Pbranch_Filt.u) annotation(
    Line(points = {{-310, -50}, {-282, -50}}, color = {0, 0, 127}));
  connect(GainKc.u, QRegPu) annotation(
    Line(points = {{-282, 50}, {-310, 50}}, color = {0, 0, 127}));
  connect(OmegaPu, wCtrlErr.u2) annotation(
    Line(points = {{-310, -140}, {-290, -140}, {-290, -136}, {-282, -136}}, color = {0, 0, 127}));
  connect(FreqFlagSwitch.y, PInjRefPu) annotation(
    Line(points = {{101, -80}, {210, -80}}, color = {0, 0, 127}));
  connect(QVext_LeadLag.y, QInjRefPu) annotation(
    Line(points = {{181, 50}, {210, 50}}, color = {0, 0, 127}));
  connect(wCtrlErr.y, Frq_dbd.u) annotation(
    Line(points = {{-259, -130}, {-242, -130}}, color = {0, 0, 127}));
  connect(Frq_dbd.y, dPfreq_up.u) annotation(
    Line(points = {{-219, -130}, {-202, -130}}, color = {0, 0, 127}));
  connect(dPfreq_up.y, dPfreq_up_lim.u) annotation(
    Line(points = {{-179, -130}, {-161, -130}}, color = {0, 0, 127}));
  connect(PID_P.y, Pref_lag.u) annotation(
    Line(points = {{21, -50}, {38, -50}}, color = {0, 0, 127}));
  connect(Zero.y, PID_P.u_m) annotation(
    Line(points = {{-58, -91}, {10, -91}, {10, -62}}, color = {0, 0, 127}));
  connect(Pref_Lim.y, PID_P.u_s) annotation(
    Line(points = {{-19, -50}, {-2, -50}}, color = {0, 0, 127}));
  connect(PCtrlErr.y, Pref_Lim.u) annotation(
    Line(points = {{-59, -50}, {-42, -50}}, color = {0, 0, 127}));
  connect(Pbranch_Filt.y, PCtrlErr.u2) annotation(
    Line(points = {{-259, -50}, {-82, -50}}, color = {0, 0, 127}));
  connect(QVext_dbd.y, QVErr_Lim.u) annotation(
    Line(points = {{61, 50}, {78, 50}}, color = {0, 0, 127}));
  connect(RefFlag_const.y, RefFlagSwitch.u2) annotation(
    Line(points = {{-19, 50}, {-3, 50}}, color = {255, 0, 255}));
  connect(RefFlagSwitch.y, QVext_dbd.u) annotation(
    Line(points = {{20, 50}, {38, 50}}, color = {0, 0, 127}));
  connect(Qbranch_Filt.y, QCtrlErr.u1) annotation(
    Line(points = {{-219, 20}, {-41, 20}}, color = {0, 0, 127}));
  connect(Ubranch_Filt.y, UCtrlErr.u2) annotation(
    Line(points = {{-59, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(dPfreq_down.y, dPfreq_down_lim.u) annotation(
    Line(points = {{-179, -90}, {-162, -90}}, color = {0, 0, 127}));
  connect(VCompFlagSwitch.y, Ubranch_Filt.u) annotation(
    Line(points = {{-99, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(VCompFlag_const.y, VCompFlagSwitch.u2) annotation(
    Line(points = {{-139, 80}, {-122, 80}}, color = {255, 0, 255}));
  connect(GainKc.y, QVCtrlErr.u2) annotation(
    Line(points = {{-259, 50}, {-242, 50}}, color = {0, 0, 127}));
  connect(uPu, lineDropCompensation1.u2Pu) annotation(
    Line(points = {{-310, 80}, {-290, 80}, {-290, 94}, {-281, 94}, {-281, 94}}, color = {85, 170, 255}));
  connect(iPu, lineDropCompensation1.iPu) annotation(
    Line(points = {{-310, 120}, {-290, 120}, {-290, 106}, {-281, 106}, {-281, 106}}, color = {85, 170, 255}));
  connect(QRegPu, Qbranch_Filt.u) annotation(
    Line(points = {{-310, 50}, {-290, 50}, {-290, 20}, {-242, 20}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, QVCtrlErr.u1) annotation(
    Line(points = {{-259, 94}, {-250, 94}, {-250, 62}, {-242, 62}, {-242, 62}}, color = {0, 0, 127}));
  connect(freeze1.y, PID_Q.freeze) annotation(
    Line(points = {{111, 90}, {123, 90}, {123, 62}}, color = {255, 0, 255}));
  connect(voltage_check1.freeze, freeze) annotation(
    Line(points = {{-219, 94}, {-197, 94}, {-197, 94}, {-190, 94}}, color = {255, 0, 255}));
  connect(QRefPu_PC, QCtrlErr.u2) annotation(
    Line(points = {{-309, 0}, {-60, 0}, {-60, 8}, {-41, 8}}, color = {0, 0, 127}));
  connect(QVErr_Lim.y, PID_Q.u_s) annotation(
    Line(points = {{101, 50}, {118, 50}}, color = {0, 0, 127}));
  connect(Zero1.y, PID_Q.u_m) annotation(
    Line(points = {{139, 90}, {130, 90}, {130, 62}}, color = {0, 0, 127}));
  connect(OmegaRefPu, wCtrlErr.u1) annotation(
    Line(points = {{-310, -120}, {-290, -120}, {-290, -124}, {-282, -124}, {-282, -124}}, color = {0, 0, 127}));
  connect(Frq_dbd.y, dPfreq_down.u) annotation(
    Line(points = {{-219, -130}, {-210, -130}, {-210, -90}, {-202, -90}, {-202, -90}}, color = {0, 0, 127}));
  connect(dPfreq.y, PCtrlErr.u3) annotation(
    Line(points = {{-99, -110}, {-90, -110}, {-90, -58}, {-82, -58}}, color = {0, 0, 127}));
  connect(PRefPu_PC, PCtrlErr.u1) annotation(
    Line(points = {{-310, -30}, {-90, -30}, {-90, -42}, {-82, -42}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, RefFlagSwitch.u1) annotation(
    Line(points = {{-19, 86}, {-10, 86}, {-10, 58}, {-3, 58}}, color = {0, 0, 127}));
  connect(QCtrlErr.y, RefFlagSwitch.u3) annotation(
    Line(points = {{-18, 14}, {-10, 14}, {-10, 42}, {-3, 42}}, color = {0, 0, 127}));
  connect(uRefPu.y, UCtrlErr.u1) annotation(
    Line(points = {{-59, 120}, {-50, 120}, {-50, 92}, {-42, 92}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, VCompFlagSwitch.u1) annotation(
    Line(points = {{-259, 106}, {-130, 106}, {-130, 88}, {-122, 88}, {-122, 88}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, VCompFlagSwitch.u3) annotation(
    Line(points = {{-219, 56}, {-130, 56}, {-130, 72}, {-122, 72}, {-122, 72}}, color = {0, 0, 127}));
  connect(FreqFlag_const.y, FreqFlagSwitch.u2) annotation(
    Line(points = {{62, -80}, {78, -80}}, color = {255, 0, 255}));
  connect(Pref_lag.y, FreqFlagSwitch.u1) annotation(
    Line(points = {{61, -50}, {70, -50}, {70, -72}, {78, -72}, {78, -72}}, color = {0, 0, 127}));
  connect(const.y, FreqFlagSwitch.u3) annotation(
    Line(points = {{61, -110}, {70, -110}, {70, -88}, {78, -88}, {78, -88}}, color = {0, 0, 127}));
  connect(dPfreq_down_lim.y, dPfreq.u1) annotation(
    Line(points = {{-139, -90}, {-130, -90}, {-130, -104}, {-122, -104}, {-122, -104}}, color = {0, 0, 127}));
  connect(dPfreq_up_lim.y, dPfreq.u2) annotation(
    Line(points = {{-138, -130}, {-130, -130}, {-130, -116}, {-122, -116}, {-122, -116}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled when VcompFlag == true. Therefore, Rc and Xc shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, Vcomp should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu). </p>
</html>"),
    Diagram(coordinateSystem(extent = {{-300, -150}, {200, 150}}, grid = {1, 1})),
    version = "",
    uses(Modelica(version = "3.2.3")),
    __OpenModelica_commandLineOptions = "",
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "Plant Control"), Text(origin = {137, 74}, extent = {{-23, 10}, {41, -12}}, textString = "PInjRefPu"), Text(origin = {59, 110}, extent = {{-15, 12}, {11, -12}}, textString = "QPu"), Text(origin = {103, 110}, extent = {{-15, 12}, {11, -12}}, textString = "PPu"), Text(origin = {-53, 110}, extent = {{-15, 12}, {11, -12}}, textString = "iPu"), Text(origin = {-7, 110}, extent = {{-15, 12}, {11, -12}}, textString = "uPu"), Text(origin = {-149, -10}, extent = {{-23, 10}, {21, -10}}, textString = "PRefPu"), Text(origin = {-149, -52}, extent = {{-23, 10}, {21, -10}}, textString = "QRefPu"), Text(origin = {-149, 34}, extent = {{-55, 40}, {21, -10}}, textString = "OmegaRefPu"), Text(origin = {-151, 78}, extent = {{-31, 32}, {21, -10}}, textString = "OmegaPu"),  Text(origin = {139, -46}, extent = {{-23, 10}, {41, -12}}, textString = "QInjRefPu"), Text(origin = {137, 12}, extent = {{-23, 10}, {27, -8}}, textString = "freeze")}, coordinateSystem(initialScale = 0.1)));
end PlantControl;
