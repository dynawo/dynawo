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


model REEC_ElectricalControl "WECC PV Electrical Control REEC"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.Controls.WECC.BaseControls;
  import Dynawo.Electrical.Controls.WECC.Parameters;

  extends Parameters.Params_ElectricalControl;

  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjPu(start = QInj0Pu) "Reactive power at injector terminal in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PInjPu(start = PInj0Pu) "Active power at injector terminal in p.u (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Voltage magnitude at injector terminal in p.u" annotation(
    Placement(visible = true, transformation(origin = {-270, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput idCmdPu(start = Id0Pu) "Id setpoint for generator control in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {510, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Iq0Pu) "Iq setpoint for generator control in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {510, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UFilteredPu(start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-200, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput FRTon "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise " annotation(
    Placement(visible = true, transformation(origin = {-200, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.BooleanConstant Qflag_const(k = QFlag) annotation(
    Placement(visible = true, transformation(origin = {220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant Vflag_const(k = VFlag) annotation(
    Placement(visible = true, transformation(origin = {-40, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant Pfflag_const(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter Vcmd_lim(limitsAtInit = true, uMax = Vmax, uMin = Vmin) annotation(
    Placement(visible = true, transformation(origin = {90, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division Iqcmd annotation(
    Placement(visible = true, transformation(origin = {90, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UPu_filt(T = Trv, initType = Modelica.Blocks.Types.Init.InitialState, k = 1, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vref(k = if Vref0 < 0.5 then UInj0Pu else Vref0) annotation(
    Placement(visible = true, transformation(origin = {10, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Verr_FRT(k1 = +1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone Verr_dbd(deadZoneAtInit = true, uMax = dbd2, uMin = dbd1) annotation(
    Placement(visible = true, transformation(origin = {180, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Iq_FRT(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {220, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter Iq_FRT_lim(limitsAtInit = true, uMax = Iqh1, uMin = Iql1) annotation(
    Placement(visible = true, transformation(origin = {280, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add Iqcmd_sum(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {330, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch Vflagswitch annotation(
    Placement(visible = true, transformation(origin = {10, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder PextPu_Filt(T = Tp, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Pfaref(k = tan(acos(PF0))) annotation(
    Placement(visible = true, transformation(origin = {-230, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product Pext_x_Pf annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch Pfflagswitch annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter Q_lim(limitsAtInit = true, uMax = Qmax, uMin = Qmin) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch Qflagswitch annotation(
    Placement(visible = true, transformation(origin = {280, -27}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division Idcmd annotation(
    Placement(visible = true, transformation(origin = {90, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze PID_V(Ti = Kqp / Kqi, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.InitPID.InitialState, k = Kqp, limitsAtInit = true, xi_start = UInj0Pu / Kvp, yMax = Vmax, yMin = Vmin, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltage_Dip(Vdip = Vdip, Vup = Vup) annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimPIDFreeze PID_VQ(Ti = Kvp / Kvi, controllerType = Modelica.Blocks.Types.SimpleController.PI, initType = Modelica.Blocks.Types.InitPID.InitialState, k = Kvp, limitsAtInit = true, xi_start = QInj0Pu / UInj0Pu / Kqp, y_start = QInj0Pu / UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {180, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitLogic currentLimitLogic1(Imax = Imax, Pqflag = PqFlag) annotation(
    Placement(visible = true, transformation(origin = {410, 29}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter Iqcmd_lim(limitsAtInit = true) annotation(
    Placement(visible = true, transformation(origin = {410, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter Idcmd_lim annotation(
    Placement(visible = true, transformation(origin = {410, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze Pcmd_filt(T = Tpord, initType = Modelica.Blocks.Types.Init.SteadyState, k = 1, use_freeze = true, use_rateLim = true, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter Pcmd_lim(limitsAtInit = true, uMax = Pmax, uMin = Pmin) annotation(
    Placement(visible = true, transformation(origin = {50, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant dPmax_const(k = dPmax) annotation(
    Placement(visible = true, transformation(origin = {-40, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant dPmin_const(k = dPmin) annotation(
    Placement(visible = true, transformation(origin = {-40, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder Iq_delay(T = 0.01, initType = Modelica.Blocks.Types.Init.SteadyState, k = 1, y_start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {450, 9}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder Id_delay(T = 0.01, initType = Modelica.Blocks.Types.Init.SteadyState, k = 1, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {450, 49}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze Iqcmd_Filt(T = Tiq, initType = Modelica.Blocks.Types.Init.SteadyState, k = 1, use_freeze = true, use_rateLim = false, y_start = QInj0Pu / UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn(y = FRTon)  annotation(
    Placement(visible = true, transformation(origin = {124, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn1(y = FRTon)  annotation(
    Placement(visible = true, transformation(origin = {163, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn2(y = FRTon)  annotation(
    Placement(visible = true, transformation(origin = {4, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn3(y = FRTon)  annotation(
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitLogic1.Iqmax)  annotation(
    Placement(visible = true, transformation(origin = {130, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitLogic1.Iqmin)  annotation(
    Placement(visible = true, transformation(origin = {130, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu1(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {50, 73}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu2(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {50, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu3(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {190, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu4(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {50, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in p.u (injector convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in p.u (injector convention) (base SNom)";
  parameter Types.PerUnit UInj0Pu "Start value of voltage magnitude at injector terminal in p.u";
  parameter Types.PerUnit PF0 "Start value of powerfactor";
  parameter Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in p.u (injector convention) (base SNom)";
  parameter Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in p.u (injector convention) (base SNom)";

equation
  connect(Iqcmd_lim.y, iqCmdPu) annotation(
    Line(points = {{421, -21}, {510, -21}}, color = {0, 0, 127}));
  connect(PID_VQ.y, Qflagswitch.u1) annotation(
    Line(points = {{191, -19}, {268, -19}}, color = {0, 0, 127}));
  connect(Vcmd_lim.y, PID_VQ.u_s) annotation(
    Line(points = {{101, -19}, {168, -19}}, color = {0, 0, 127}));
  connect(Q_lim.y, PID_V.u_s) annotation(
    Line(points = {{-69, 20}, {-52, 20}}, color = {0, 0, 127}));
  connect(QInjPu, PID_V.u_m) annotation(
    Line(points = {{-270, 110}, {-40, 110}, {-40, 32}}, color = {0, 0, 127}));
  connect(Vflagswitch.y, Vcmd_lim.u) annotation(
    Line(points = {{21, -19}, {78, -19}}, color = {0, 0, 127}));
  connect(Vflag_const.y, Vflagswitch.u2) annotation(
    Line(points = {{-29, -19}, {-2, -19}}, color = {255, 0, 255}));
  connect(PInjPu, PextPu_Filt.u) annotation(
    Line(points = {{-270, 80}, {-242, 80}}, color = {0, 0, 127}));
  connect(Pfflagswitch.y, Q_lim.u) annotation(
    Line(points = {{-109, 20}, {-92, 20}}, color = {0, 0, 127}));
  connect(Pfflag_const.y, Pfflagswitch.u2) annotation(
    Line(points = {{-179, 20}, {-132, 20}}, color = {255, 0, 255}));
  connect(Iqcmd_Filt.y, Qflagswitch.u3) annotation(
    Line(points = {{141, -76}, {260, -76}, {260, -35}, {268, -35}}, color = {0, 0, 127}));
  connect(Iqcmd.y, Iqcmd_Filt.u) annotation(
    Line(points = {{101, -76}, {118, -76}}, color = {0, 0, 127}));
  connect(Idcmd_lim.y, idCmdPu) annotation(
    Line(points = {{421, 79}, {510, 79}}, color = {0, 0, 127}));
  connect(Idcmd.y, Idcmd_lim.u) annotation(
    Line(points = {{101, 79}, {398, 79}}, color = {0, 0, 127}));
  connect(Iqcmd_sum.y, Iqcmd_lim.u) annotation(
    Line(points = {{341, -21}, {398, -21}}, color = {0, 0, 127}));
  connect(Qflagswitch.y, Iqcmd_sum.u2) annotation(
    Line(points = {{291, -27}, {318, -27}}, color = {0, 0, 127}));
  connect(Iq_FRT_lim.y, Iqcmd_sum.u1) annotation(
    Line(points = {{291, 30}, {300, 30}, {300, -15}, {318, -15}}, color = {0, 0, 127}));
  connect(PInjRefPu, Pcmd_filt.u) annotation(
    Line(points = {{-270, 190}, {-2, 190}}, color = {0, 0, 127}));
  connect(Pcmd_filt.y, Pcmd_lim.u) annotation(
    Line(points = {{21, 190}, {38, 190}}, color = {0, 0, 127}));
  connect(Iq_FRT.y, Iq_FRT_lim.u) annotation(
    Line(points = {{231, 30}, {268, 30}}, color = {0, 0, 127}));
  connect(Verr_dbd.y, Iq_FRT.u) annotation(
    Line(points = {{191, 30}, {208, 30}}, color = {0, 0, 127}));
  connect(Verr_FRT.y, Verr_dbd.u) annotation(
    Line(points = {{141, 30}, {168, 30}}, color = {0, 0, 127}));
  connect(UPu, UPu_filt.u) annotation(
    Line(points = {{-270, -70}, {-242, -70}}, color = {0, 0, 127}));
  connect(Vref.y, Verr_FRT.u1) annotation(
    Line(points = {{21, 36}, {118, 36}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Ipmax, Idcmd_lim.limit1) annotation(
    Line(points = {{399, 31}, {360, 31}, {360, 87}, {398, 87}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Iqmin, Iqcmd_lim.limit2) annotation(
    Line(points = {{399, 27}, {360, 27}, {360, -29}, {398, -29}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Iqmax, Iqcmd_lim.limit1) annotation(
    Line(points = {{399, 23}, {380, 23}, {380, -13}, {398, -13}}, color = {0, 0, 127}));
  connect(Id_delay.y, currentLimitLogic1.Ipcmd) annotation(
    Line(points = {{439, 49}, {430, 49}, {430, 33}, {421, 33}}, color = {0, 0, 127}));
  connect(Iq_delay.y, currentLimitLogic1.Iqcmd) annotation(
    Line(points = {{439, 9}, {430, 9}, {430, 25}, {421, 25}}, color = {0, 0, 127}));
  connect(Iqcmd_lim.y, Iq_delay.u) annotation(
    Line(points = {{421, -21}, {480, -21}, {480, 9}, {462, 9}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Ipmin, Idcmd_lim.limit2) annotation(
    Line(points = {{399, 35}, {380, 35}, {380, 71}, {398, 71}}, color = {0, 0, 127}));
  connect(Qflag_const.y, Qflagswitch.u2) annotation(
    Line(points = {{231, -40}, {240, -40}, {240, -27}, {268, -27}, {268, -27}}, color = {255, 0, 255}));
  connect(FRTOn.y, Iqcmd_Filt.freeze) annotation(
    Line(points = {{124, -95}, {124, -88}}, color = {255, 0, 255}));
  connect(FRTOn2.y, Pcmd_filt.freeze) annotation(
    Line(points = {{4, 171}, {4, 178}}, color = {255, 0, 255}));
  connect(voltage_Dip.freeze, FRTon) annotation(
    Line(points = {{-219, -40}, {-200, -40}}, color = {255, 0, 255}));
  connect(IqMax.y, PID_VQ.yMax) annotation(
    Line(points = {{141, -6}, {150, -6}, {150, -13}, {168, -13}, {168, -13}}, color = {0, 0, 127}));
  connect(IqMin.y, PID_VQ.yMin) annotation(
    Line(points = {{141, -33}, {150, -33}, {150, -25}, {168, -25}}, color = {0, 0, 127}));
  connect(UFilteredPu1.y, Idcmd.u2) annotation(
    Line(points = {{61, 73}, {78, 73}}, color = {0, 0, 127}));
  connect(UFilteredPu2.y, Iqcmd.u2) annotation(
    Line(points = {{61, -82}, {78, -82}}, color = {0, 0, 127}));
  connect(UFilteredPu3.y, PID_VQ.u_m) annotation(
    Line(points = {{190, -49}, {190, -49}, {190, -40}, {180, -40}, {180, -31}, {180, -31}}, color = {0, 0, 127}));
  connect(FRTOn1.y, PID_VQ.freeze) annotation(
    Line(points = {{163, -49}, {163, -40}, {173, -40}, {173, -31}}, color = {255, 0, 255}));
  connect(UFilteredPu4.y, Verr_FRT.u2) annotation(
    Line(points = {{61, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(UPu_filt.y, UFilteredPu) annotation(
    Line(points = {{-219, -70}, {-200, -70}}, color = {0, 0, 127}));
  connect(FRTOn3.y, PID_V.freeze) annotation(
    Line(points = {{-69, 50}, {-47, 50}, {-47, 32}}, color = {255, 0, 255}));
  connect(Idcmd_lim.y, Id_delay.u) annotation(
    Line(points = {{421, 79}, {480, 79}, {480, 49}, {462, 49}, {462, 49}}, color = {0, 0, 127}));
  connect(PID_V.y, Vflagswitch.u1) annotation(
    Line(points = {{-29, 20}, {-20, 20}, {-20, -11}, {-2, -11}, {-2, -11}}, color = {0, 0, 127}));
  connect(Pfflagswitch.y, Vflagswitch.u3) annotation(
    Line(points = {{-109, 20}, {-100, 20}, {-100, -40}, {-20, -40}, {-20, -27}, {-2, -27}, {-2, -27}}, color = {0, 0, 127}));
  connect(Pfflagswitch.y, Iqcmd.u1) annotation(
    Line(points = {{-109, 20}, {-100, 20}, {-100, -70}, {78, -70}, {78, -70}}, color = {0, 0, 127}));
  connect(Pext_x_Pf.y, Pfflagswitch.u1) annotation(
    Line(points = {{-179, 60}, {-170, 60}, {-170, 28}, {-132, 28}, {-132, 28}}, color = {0, 0, 127}));
  connect(QInjRefPu, Pfflagswitch.u3) annotation(
    Line(points = {{-270, -20}, {-170, -20}, {-170, 12}, {-132, 12}}, color = {0, 0, 127}));
  connect(PextPu_Filt.y, Pext_x_Pf.u1) annotation(
    Line(points = {{-219, 80}, {-210, 80}, {-210, 66}, {-202, 66}, {-202, 66}}, color = {0, 0, 127}));
  connect(Pfaref.y, Pext_x_Pf.u2) annotation(
    Line(points = {{-219, 30}, {-210, 30}, {-210, 54}, {-202, 54}, {-202, 54}}, color = {0, 0, 127}));
  connect(Pcmd_lim.y, Idcmd.u1) annotation(
    Line(points = {{61, 190}, {70, 190}, {70, 85}, {78, 85}, {78, 85}}, color = {0, 0, 127}));
  connect(dPmin_const.y, Pcmd_filt.dy_min) annotation(
    Line(points = {{-29, 160}, {-20, 160}, {-20, 184}, {-1, 184}}, color = {0, 0, 127}));
  connect(dPmax_const.y, Pcmd_filt.dy_max) annotation(
    Line(points = {{-29, 220}, {-20, 220}, {-20, 197}, {-1, 197}, {-1, 197}}, color = {0, 0, 127}));
  connect(UPu, voltage_Dip.Vt) annotation(
    Line(points = {{-270, -70}, {-250, -70}, {-250, -40}, {-241, -40}, {-241, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the electrical inverter control of the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> Following control modes can be activated:
<li> local coordinated V/Q control: QFlag = true, VFlag = true </li>
<li> only plant level control active: QFlag = false, VFlag = false</li>
<li> if plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false./Q</li>
<p> The block calculates the Id and Iq setpoint values for the generator control based on the selected control algorithm.


</ul> </p></html>"),
    Diagram(coordinateSystem(extent = {{-260, -130}, {500, 250}}, grid = {1, 1})),
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 22}, extent = {{-57, 58}, {103, -102}}, textString = "Electrical Control"), Text(origin = {137, 79}, extent = {{-23, 13}, {35, -21}}, textString = "idCmdPu"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "FRTon"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {-19, -117}, extent = {{-33, 21}, {9, -3}}, textString = "QInjPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu")}, coordinateSystem(initialScale = 0.1)));
end REEC_ElectricalControl;
