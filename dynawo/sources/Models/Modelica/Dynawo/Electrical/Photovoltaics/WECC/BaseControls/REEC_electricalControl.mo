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


model REEC_electricalControl
  import Modelica.Blocks;
  import Modelica.Blocks.Types.Init;
  import Modelica.Blocks.Types.InitPID;
  import Modelica.Blocks.Interfaces;
  import Modelica.ComplexMath;
  import Modelica.Math;
  import Modelica.SIunits;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Photovoltaics.WECC.Utilities;

  parameter Boolean QFlag "Q control flag: const. pf or Q ctrl (0) or voltage/Q (1)";
  parameter Boolean VFlag "Voltage control flag: voltage control (0) or Q ctrl (1)";
  parameter Boolean PfFlag "Power factor flag: Q control (0) or pf control(1)";
  parameter Boolean PqFlag "Q/P priority: Q priority (0) or P priority (1)";
  parameter SIunits.Time Trv "Filter time constant terminal voltage (typical: 0.01..0.02, chosen: 0.02)";
  parameter SIunits.PerUnit Vdip "Low voltage condition trigger voltage for FRT (typical: 0..0.9, chosen: 0.9)";
  parameter SIunits.PerUnit Vup "High voltage condition trigger voltage for FRT (typical: 1.1..1.3, chosen: 1.1)";
  parameter SIunits.PerUnit Vref0 "Reference voltage for reactive current injection (typical: 0.95..1.05, chosen: 1)";
  parameter SIunits.PerUnit dbd1 "Overvoltage deadband for reactive current injection (typical: -0.1..0, chosen: -0.1)";
  parameter SIunits.PerUnit dbd2 "Undervoltage deadband for reactive current injection (typical: 0..0.1, chosen: 0.1)";
  parameter SIunits.PerUnit Kqv "K-Factor, reactive current injection gain (typical: 0..10, chosen: 2)";
  parameter SIunits.PerUnit Iqh1 "Maximum reactive current injection (typical: 1..1.1, chosen: 2)";
  parameter SIunits.PerUnit Iql1 "Minimum reactive current injection (typical: -1.1..-1, chosen: -2)";
  parameter SIunits.Time Tp "Filter time constant active power (typical: 0.1..0.2, chosen: 0.04)";
  parameter SIunits.PerUnit Qmax "Reactive power upper limit, when vFlag == 1 (typical: -, chosen: 0.4)";
  parameter SIunits.PerUnit Qmin "Reactive power lower limit, when vFlag == 1 (typical: -, chosen: -0.4)";
  parameter SIunits.PerUnit Kqp "Proportional gain local reactive power PI controller (typical: -, chosen: 1)";
  parameter SIunits.PerUnit Kqi "Integrator gain local reactive power PI controller (typical: -, chosen: 0.5)";
  parameter SIunits.PerUnit Vmax "Maximum voltage at inverter terminal (typical: 1.05..1.15, chosen: 1.1)";
  parameter SIunits.PerUnit Vmin "Minimum voltage at inverter terminal (typical: 0.85..0.95, chosen: 0.9)";
  parameter SIunits.PerUnit Kvp "Proportional gain local Voltage PI controller (typical: -, chosen: 1)";
  parameter SIunits.PerUnit Kvi "Integrator gain local Voltage PI controller (typical: -, chosen: 1)";
  parameter SIunits.Time Tiq "Filter time constant reactive current (typical: 0.01..0.02, chosen: 0.02)";
  parameter SIunits.Time Tpord "Filter time constant inverter active power (typical: -, chosen: 0.02)";
  parameter SIunits.PerUnit Pmax "Active power upper limit (typical: 1, chosen: 1)";
  parameter SIunits.PerUnit Pmin "Active power lower limit (typical: 0, chosen: 0)";
  parameter SIunits.PerUnit dPmax "Active power upper rate limit (typical: -, chosen: 1)";
  parameter SIunits.PerUnit dPmin "Active power lower rate limit (typical: -, chosen: -1)";
  parameter SIunits.PerUnit Imax "Maximal apparent current magnitude (typical: 1..1.3, chosen: 1.05)";

  // Inputs:
  Blocks.Interfaces.RealInput UPu(start = U0Pu) "Inverter terminal voltage magnitude in pu" annotation(
    Placement(visible = true, transformation(origin = {-506, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-504, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput Q_VRefPu_EC(start = Q0Pu) "Setpoint reactive power from plant level control, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-506, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-504, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput PRefPu_EC(start = P0Pu) "Setpoint active power from plant level control, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-506, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-504, -114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput QInjPu(start = Q0Pu) "Measured reactive power injection at inverter terminal, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-506, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-504, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput PInjPu(start = P0Pu) "Measured active power injection at inverter terminal, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-506, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-504, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Outputs:
  Blocks.Interfaces.BooleanOutput FRTon "Boolean signal, if FRT detected then true else false, for current ramp in generator control on iq after fault"  annotation(
    Placement(visible = true, transformation(origin = {158, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {152, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput idCmdPu "Setpoint id in pu, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {158, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {152, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput iqCmdPu "Setpoint id in pu, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {160, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {152, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Sources:
  Blocks.Sources.BooleanConstant Qflag_const(k = QFlag) annotation(
    Placement(visible = true, transformation(origin = {-68, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.BooleanConstant Vflag_const(k = VFlag) annotation(
    Placement(visible = true, transformation(origin = {-256, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.BooleanConstant Pfflag_const(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-430, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Blocks:
  Blocks.Nonlinear.Limiter Vcmd_lim(limitsAtInit = true, uMax = Vmax, uMin = Vmin) annotation(
    Placement(visible = true, transformation(origin = {-184, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Division Iqcmd annotation(
    Placement(visible = true, transformation(origin = {-138, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder UPu_filt(T = Trv, initType = Modelica.Blocks.Types.Init.InitialState, k = 1, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-446, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Vref(k = if Vref0 < 0.5 then U0Pu else Vref0) annotation(
    Placement(visible = true, transformation(origin = {-470, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add Verr_FRT(k1 = +1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-294, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.DeadZone Verr_dbd(deadZoneAtInit = true, uMax = dbd2, uMin = dbd1) annotation(
    Placement(visible = true, transformation(origin = {-254, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain Iq_FRT(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {-216, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter Iq_FRT_lim(limitsAtInit = true, uMax = Iqh1, uMin = Iql1) annotation(
    Placement(visible = true, transformation(origin = {-180, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add Iqcmd_sum(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {0, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch Vflagswitch annotation(
    Placement(visible = true, transformation(origin = {-216, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder PextPu_Filt(T = Tp, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-470, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Pfaref(k = tan(acos(PFref))) annotation(
    Placement(visible = true, transformation(origin = {-470, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Product Pext_x_Pf annotation(
    Placement(visible = true, transformation(origin = {-430, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch Pfflagswitch annotation(
    Placement(visible = true, transformation(origin = {-390, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter Q_lim(limitsAtInit = true, uMax = Qmax, uMin = Qmin) annotation(
    Placement(visible = true, transformation(origin = {-350, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch Qflagswitch annotation(
    Placement(visible = true, transformation(origin = {-32, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Division Idcmd annotation(
    Placement(visible = true, transformation(origin = {-98, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.LimPID_freeze PID_V(Ti = Kqp / Kqi, controllerType = Blocks.Types.SimpleController.PI, initType = InitPID.InitialState, k = Kqp, limitsAtInit = true, xi_start = U0Pu / Kvp, yMax = Vmax, yMin = Vmin, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-276, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.Voltage_check voltage_Dip(Vdip = Vdip, Vup = Vup) annotation(
    Placement(visible = true, transformation(origin = {-446, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.VarLimPID_freeze PID_VQ(Ti = Kvp / Kvi, controllerType = Blocks.Types.SimpleController.PI, initType = InitPID.InitialState, k = Kvp, limitsAtInit = true, xi_start = Q0Pu / U0Pu / Kqp, y_start = Q0Pu / U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-92, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.CurrentLimitLogic currentLimitLogic1(Imax = Imax, Pqflag = PqFlag) annotation(
    Placement(visible = true, transformation(origin = {58, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.VariableLimiter Iqcmd_lim(limitsAtInit = true) annotation(
    Placement(visible = true, transformation(origin = {58, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.VariableLimiter Idcmd_lim annotation(
    Placement(visible = true, transformation(origin = {58, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.RateLimFirstOrder_freeze Pcmd_filt(T = Tpord, initType = Init.SteadyState, k = 1, use_freeze = true, use_rateLim = true, y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-304, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter Pcmd_lim(limitsAtInit = true, uMax = Pmax, uMin = Pmin) annotation(
    Placement(visible = true, transformation(origin = {-250, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant dPmax_const(k = dPmax) annotation(
    Placement(visible = true, transformation(origin = {-342, -86}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Sources.Constant dPmin_const(k = dPmin) annotation(
    Placement(visible = true, transformation(origin = {-342, -120}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Iq_delay(T = 0.01, initType = Init.SteadyState, k = 1) annotation(
    Placement(visible = true, transformation(origin = {58, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder Id_delay(T = 0.01, initType = Init.SteadyState, k = 1) annotation(
    Placement(visible = true, transformation(origin = {58, -136}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Utilities.RateLimFirstOrder_freeze Iqcmd_Filt(T = Tiq, initType = Init.SteadyState, k = 1, use_freeze = true, use_rateLim = false, y_start = Q0Pu / U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-98, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter SIunits.PerUnit P0Pu "Initial value terminal active power, injector convention, base SNom";
  parameter SIunits.PerUnit Q0Pu "Initial value terminal reactive power, injector convention, base SNom";
  parameter SIunits.PerUnit U0Pu "Initial value terminal voltage";
  parameter SIunits.PerUnit PFref "Powerfactor reference value from load flow solution";

equation

  connect(Pfflagswitch.y, Vflagswitch.u3) annotation(
    Line(points = {{-378, -8}, {-376, -8}, {-376, -70}, {-238, -70}, {-238, -24}, {-228, -24}, {-228, -24}}, color = {0, 0, 127}));
  connect(Pfflagswitch.y, Iqcmd.u1) annotation(
    Line(points = {{-378, -8}, {-376, -8}, {-376, -70}, {-150, -70}, {-150, -70}}, color = {0, 0, 127}));
  connect(UPu_filt.y, PID_VQ.u_m) annotation(
    Line(points = {{-434, 48}, {-166, 48}, {-166, -40}, {-92, -40}, {-92, -28}, {-92, -28}}, color = {0, 0, 127}));
  connect(UPu_filt.y, Iqcmd.u2) annotation(
    Line(points = {{-434, 48}, {-170, 48}, {-170, 48}, {-168, 48}, {-168, -82}, {-150, -82}, {-150, -82}}, color = {0, 0, 127}));
  connect(UPu_filt.y, Idcmd.u2) annotation(
    Line(points = {{-434, 48}, {-170, 48}, {-170, -114}, {-110, -114}, {-110, -116}}, color = {0, 0, 127}));
  connect(UPu_filt.y, Verr_FRT.u2) annotation(
    Line(points = {{-434, 48}, {-334, 48}, {-334, 94}, {-306, 94}, {-306, 94}}, color = {0, 0, 127}));
  connect(voltage_Dip.freeze, FRTon) annotation(
    Line(points = {{-435, 80}, {158, 80}}, color = {255, 0, 255}));
  connect(UPu, voltage_Dip.Vt) annotation(
    Line(points = {{-506, 48}, {-482, 48}, {-482, 80}, {-457, 80}}, color = {0, 0, 127}));
  connect(voltage_Dip.freeze, Pcmd_filt.freeze) annotation(
    Line(points = {{-435, 80}, {-370, 80}, {-370, -136}, {-309, -136}, {-309, -116}, {-310, -116}}, color = {255, 0, 255}));
  connect(voltage_Dip.freeze, Iqcmd_Filt.freeze) annotation(
    Line(points = {{-435, 80}, {-116, 80}, {-116, -94}, {-104, -94}, {-104, -88}}, color = {255, 0, 255}));
  connect(voltage_Dip.freeze, PID_V.freeze) annotation(
    Line(points = {{-435, 80}, {-296, 80}, {-296, -20}, {-283, -20}}, color = {255, 0, 255}));
  connect(voltage_Dip.freeze, PID_VQ.freeze) annotation(
    Line(points = {{-435, 80}, {-114, 80}, {-114, -28}, {-99, -28}}, color = {255, 0, 255}));
  connect(Iqcmd_lim.y, iqCmdPu) annotation(
    Line(points = {{70, -18}, {160, -18}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Iqmax, PID_VQ.yMax) annotation(
    Line(points = {{68, -60}, {86, -60}, {86, -34}, {20, -34}, {20, 20}, {-110, 20}, {-110, -10}, {-104, -10}, {-104, -10}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Iqmin, PID_VQ.yMin) annotation(
    Line(points = {{68, -56}, {80, -56}, {80, -40}, {18, -40}, {18, 24}, {-112, 24}, {-112, -22}, {-104, -22}, {-104, -22}}, color = {0, 0, 127}));
  connect(PID_VQ.y, Qflagswitch.u1) annotation(
    Line(points = {{-81, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(Vcmd_lim.y, PID_VQ.u_s) annotation(
    Line(points = {{-173, -16}, {-104, -16}}, color = {0, 0, 127}));
  connect(Q_lim.y, PID_V.u_s) annotation(
    Line(points = {{-339, -8}, {-288, -8}}, color = {0, 0, 127}));
  connect(QInjPu, PID_V.u_m) annotation(
    Line(points = {{-506, 26}, {-308, 26}, {-308, -34}, {-276, -34}, {-276, -20}}, color = {0, 0, 127}));
  connect(PID_V.y, Vflagswitch.u1) annotation(
    Line(points = {{-265, -8}, {-228, -8}}, color = {0, 0, 127}));
  connect(Vflagswitch.y, Vcmd_lim.u) annotation(
    Line(points = {{-205, -16}, {-197, -16}}, color = {0, 0, 127}));
  connect(Vflag_const.y, Vflagswitch.u2) annotation(
    Line(points = {{-245, -46}, {-241, -46}, {-241, -16}, {-228, -16}}, color = {255, 0, 255}));
  connect(PInjPu, PextPu_Filt.u) annotation(
    Line(points = {{-506, 6}, {-484, 6}, {-484, 6}, {-482, 6}}, color = {0, 0, 127}));
  connect(PextPu_Filt.y, Pext_x_Pf.u1) annotation(
    Line(points = {{-459, 6}, {-442, 6}}, color = {0, 0, 127}));
  connect(Pfaref.y, Pext_x_Pf.u2) annotation(
    Line(points = {{-459, -24}, {-453, -24}, {-453, -6}, {-443, -6}}, color = {0, 0, 127}));
  connect(Pext_x_Pf.y, Pfflagswitch.u1) annotation(
    Line(points = {{-419, 0}, {-403, 0}}, color = {0, 0, 127}));
  connect(Pfflagswitch.y, Q_lim.u) annotation(
    Line(points = {{-379, -8}, {-363, -8}}, color = {0, 0, 127}));
  connect(Pfflag_const.y, Pfflagswitch.u2) annotation(
    Line(points = {{-419, -28}, {-413, -28}, {-413, -8}, {-403, -8}}, color = {255, 0, 255}));
  connect(Q_VRefPu_EC, Pfflagswitch.u3) annotation(
    Line(points = {{-506, -70}, {-408, -70}, {-408, -16}, {-402, -16}}, color = {0, 0, 127}));
  connect(Iqcmd_Filt.y, Qflagswitch.u3) annotation(
    Line(points = {{-87, -76}, {-51, -76}, {-51, -32}, {-45, -32}}, color = {0, 0, 127}));
  connect(Iqcmd.y, Iqcmd_Filt.u) annotation(
    Line(points = {{-127, -76}, {-111, -76}, {-111, -76}, {-111, -76}}, color = {0, 0, 127}));
  connect(Idcmd_lim.y, idCmdPu) annotation(
    Line(points = {{70, -110}, {152, -110}, {152, -110}, {158, -110}}, color = {0, 0, 127}));
  connect(Id_delay.y, currentLimitLogic1.Ipcmd) annotation(
    Line(points = {{48, -136}, {16, -136}, {16, -66}, {48, -66}, {48, -66}}, color = {0, 0, 127}));
  connect(Id_delay.u, Idcmd_lim.y) annotation(
    Line(points = {{70, -136}, {86, -136}, {86, -110}, {70, -110}, {70, -110}}, color = {0, 0, 127}));
  connect(Iq_delay.y, currentLimitLogic1.Iqcmd) annotation(
    Line(points = {{48, 12}, {16, 12}, {16, -60}, {48, -60}, {48, -60}}, color = {0, 0, 127}));
  connect(Iqcmd_lim.y, Iq_delay.u) annotation(
    Line(points = {{70, -18}, {86, -18}, {86, 12}, {70, 12}, {70, 12}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Iqmax, Iqcmd_lim.limit1) annotation(
    Line(points = {{68, -59}, {86.2, -59}, {86.2, -33.4}, {26.2, -33.4}, {26.2, -9.4}, {46.2, -9.4}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Iqmin, Iqcmd_lim.limit2) annotation(
    Line(points = {{68, -56}, {80.2, -56}, {80.2, -39.6}, {36.2, -39.6}, {36.2, -25.6}, {46.2, -25.6}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Ipmin, Idcmd_lim.limit2) annotation(
    Line(points = {{68, -64}, {86.2, -64}, {86.2, -91.8}, {28.2, -91.8}, {28.2, -115.8}, {46, -115.8}, {46, -118}}, color = {0, 0, 127}));
  connect(currentLimitLogic1.Ipmax, Idcmd_lim.limit1) annotation(
    Line(points = {{68, -67}, {80.2, -67}, {80.2, -87.2}, {38.2, -87.2}, {38.2, -102}, {46, -102}}, color = {0, 0, 127}));
  connect(Idcmd.y, Idcmd_lim.u) annotation(
    Line(points = {{-87, -110}, {46, -110}}, color = {0, 0, 127}));
  connect(Iqcmd_sum.y, Iqcmd_lim.u) annotation(
    Line(points = {{11, -18}, {45, -18}}, color = {0, 0, 127}));
  connect(Qflagswitch.y, Iqcmd_sum.u2) annotation(
    Line(points = {{-21, -24}, {-12, -24}}, color = {0, 0, 127}));
  connect(Iq_FRT_lim.y, Iqcmd_sum.u1) annotation(
    Line(points = {{-169, 100}, {-20, 100}, {-20, -12}, {-12, -12}}, color = {0, 0, 127}));
  connect(dPmin_const.y, Pcmd_filt.dy_min) annotation(
    Line(points = {{-334, -120}, {-326, -120}, {-326, -110}, {-316, -110}, {-316, -110}}, color = {0, 0, 127}));
  connect(dPmax_const.y, Pcmd_filt.dy_max) annotation(
    Line(points = {{-333, -86}, {-326, -86}, {-326, -96}, {-316, -96}, {-316, -98}}, color = {0, 0, 127}));
  connect(PRefPu_EC, Pcmd_filt.u) annotation(
    Line(points = {{-506, -104}, {-316, -104}}, color = {0, 0, 127}));
  connect(Qflag_const.y, Qflagswitch.u2) annotation(
    Line(points = {{-57, -46}, {-54, -46}, {-54, -24}, {-44, -24}}, color = {255, 0, 255}));
  connect(Pcmd_lim.y, Idcmd.u1) annotation(
    Line(points = {{-239, -104}, {-111, -104}, {-111, -104}, {-111, -104}}, color = {0, 0, 127}));
  connect(Pcmd_filt.y, Pcmd_lim.u) annotation(
    Line(points = {{-293, -104}, {-263, -104}}, color = {0, 0, 127}));
  connect(Iq_FRT.y, Iq_FRT_lim.u) annotation(
    Line(points = {{-205, 100}, {-195, 100}, {-195, 100}, {-193, 100}}, color = {0, 0, 127}));
  connect(Verr_dbd.y, Iq_FRT.u) annotation(
    Line(points = {{-243, 100}, {-229, 100}, {-229, 100}, {-229, 100}}, color = {0, 0, 127}));
  connect(Verr_FRT.y, Verr_dbd.u) annotation(
    Line(points = {{-283, 100}, {-269, 100}, {-269, 100}, {-267, 100}}, color = {0, 0, 127}));
  connect(UPu, UPu_filt.u) annotation(
    Line(points = {{-506, 48}, {-458, 48}, {-458, 48}, {-458, 48}}, color = {0, 0, 127}));
  connect(Vref.y, Verr_FRT.u1) annotation(
    Line(points = {{-459, 106}, {-307, 106}}, color = {0, 0, 127}));

  annotation(
    Documentation(info = "<html>
    <p> This block contains the electrical inverter control of the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> Following control modes can be activated:
<li> local coordinated V/Q control: QFlag = true, VFlag = true </li>
<li> only plant level control active: QFlag = false, VFlag = false</li>
<li> if plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false./Q</li>
<p> The block calculates the Id and Iq setpoint values for the generator control based on the selected control algorithm.


</ul> </p></html>"),
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-500, -150}, {150, 150}}, initialScale = 0.1), graphics = {Text(origin = {92, 26}, extent = {{-16, 8}, {16, -8}}, textString = "lastvalue")}),
    Icon(coordinateSystem(extent = {{-500, -150}, {150, 150}}, initialScale = 0.1), graphics = {Rectangle(origin = {-248, 0}, extent = {{-252, 150}, {398, -150}}), Text(origin = {-278, 80}, extent = {{326, -186}, {-170, 22}}, textString = "Elec
 Ctrl")}),
    version = "",
    __OpenModelica_commandLineOptions = "");

end REEC_electricalControl;
