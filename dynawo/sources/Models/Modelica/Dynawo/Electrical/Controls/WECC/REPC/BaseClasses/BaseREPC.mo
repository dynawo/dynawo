within Dynawo.Electrical.Controls.WECC.REPC.BaseClasses;

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

model BaseREPC "WECC Plant Control REPC common"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;

  parameter Types.PerUnit RcPu "Line drop compensation resistance when VCompFlag = true in pu (base SnRef, UNom)";
  parameter Types.PerUnit XcPu "Line drop compensation reactance when VCompFlag = true in pu (base SnRef, UNom)";

  // Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = i0Pu.re), im(start = i0Pu.im)) "Complex current at regulated bus in pu (base SnRef, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-610, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-79, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Frequency at regulated bus in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-610, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 79}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omega0Pu) "Frequency setpoint in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-610, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Active power setpoint at regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-610, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRegPu(start = PGen0Pu) "Active power at regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-610, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {79, 111}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QGen0Pu) "Reactive power setpoint at regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-609, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -59}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QGen0Pu) "Reactive power at regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-610, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {31, 111}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at regulated bus in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-610, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-31, 111}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-610, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variables
  Modelica.Blocks.Interfaces.BooleanOutput freeze(start = false) "Boolean to freeze the regulation" annotation(
    Placement(visible = true,transformation(origin = {610, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu) "Active power setpoint at inverter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {610, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at inverter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {610, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {570, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant FreqFlag0(k = FreqFlag) annotation(
    Placement(visible = true, transformation(origin = {510, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze firstOrder(T = tLag, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {510, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {230, -100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter PRefLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = FEMaxPu, uMin = FEMinPu) annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPID(Ti = Kpg / Kig, K = Kpg, Xi0 = PInj0Pu / Kpg, YMax = PMaxPu, YMin = PMinPu, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {200, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tP, y_start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-410, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter QVErrLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(visible = true, transformation(origin = {290, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {390, 120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(visible = true, transformation(origin = {250, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tFilterPC, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-350, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add QCtrlErr(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 UCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.LineDropCompensation lineDropCompensation1(RcPu = RcPu, XcPu = XcPu) annotation(
    Placement(visible = true, transformation(origin = {-550, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-210, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant VCompFlag0(k = VCompFlag) annotation(
    Placement(visible = true, transformation(origin = {-270, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add QVCtrlErr annotation(
    Placement(visible = true, transformation(origin = {-270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-410, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add wCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-350, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(uMax = FDbd2Pu, uMin = -FDbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add dPfreq annotation(
    Placement(visible = true, transformation(origin = {-70, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = DDn) annotation(
    Placement(visible = true, transformation(origin = {-170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = DUp) annotation(
    Placement(visible = true, transformation(origin = {-172, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 0, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-130, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {510, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(Ti = Kp / Ki, K = Kp, Xi0 = QInj0Pu / Kp, YMax = QMaxPu, YMin = QMinPu, Y0 = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {340, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMinPu = VFrz, UMaxPu = 999) annotation(
    Placement(visible = true, transformation(origin = {110, 280}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction leadLag(a = {tFv, 1}, b = {tFt, 1}, x_start = {QInj0Pu}, y_start = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {390, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {200, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant RefFlag0(k = RefFlag) annotation(
    Placement(visible = true, transformation(origin = {250, 120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at regulated bus in pu (base SnRef, UNom) (generator convention)";
  parameter Types.ActivePowerPu PGen0Pu "Start value of active power at regulated bus in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QGen0Pu "Start value of reactive power at regulated bus in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at regulated bus in pu (base UNom)";
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage magnitude at injector terminal in pu (base UNom)";

  final parameter Types.VoltageModulePu URef0Pu = if VCompFlag == true then UInj0Pu else U0Pu + Kc*QGen0Pu "Start value of voltage setpoint for plant level control, calculated depending on VCompFlag, in pu (base UNom)";

equation
  connect(PRegPu, firstOrder1.u) annotation(
    Line(points = {{-610, -80}, {-422, -80}}, color = {0, 0, 127}));
  connect(gain.u, QRegPu) annotation(
    Line(points = {{-422, 40}, {-610, 40}}, color = {0, 0, 127}));
  connect(switch.y, PInjRefPu) annotation(
    Line(points = {{581, -80}, {610, -80}}, color = {0, 0, 127}));
  connect(wCtrlErr.y, deadZone1.u) annotation(
    Line(points = {{-339, -180}, {-322, -180}}, color = {0, 0, 127}));
  connect(gain2.y, limiter1.u) annotation(
    Line(points = {{-161, -220}, {-142, -220}}, color = {0, 0, 127}));
  connect(Zero.y, limPID.u_m) annotation(
    Line(points = {{219, -100}, {200, -100}, {200, -72}}, color = {0, 0, 127}));
  connect(PRefLim.y, limPID.u_s) annotation(
    Line(points = {{161, -60}, {188, -60}}, color = {0, 0, 127}));
  connect(deadZone.y, QVErrLim.u) annotation(
    Line(points = {{261, 60}, {278, 60}}, color = {0, 0, 127}));
  connect(firstOrder2.y, QCtrlErr.u1) annotation(
    Line(points = {{-339, 40}, {-320, 40}, {-320, 6}, {-282, 6}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{-159, -140}, {-142, -140}}, color = {0, 0, 127}));
  connect(VCompFlag0.y, switch2.u2) annotation(
    Line(points = {{-259, 140}, {-222, 140}}, color = {255, 0, 255}));
  connect(uPu, lineDropCompensation1.u2Pu) annotation(
    Line(points = {{-610, 80}, {-580, 80}, {-580, 94}, {-561, 94}}, color = {85, 170, 255}));
  connect(iPu, lineDropCompensation1.iPu) annotation(
    Line(points = {{-610, 120}, {-580, 120}, {-580, 106}, {-561, 106}}, color = {85, 170, 255}));
  connect(QRegPu, firstOrder2.u) annotation(
    Line(points = {{-610, 40}, {-362, 40}}, color = {0, 0, 127}));
  connect(QVErrLim.y, limPIDFreeze.u_s) annotation(
    Line(points = {{301, 60}, {328, 60}}, color = {0, 0, 127}));
  connect(Zero1.y, limPIDFreeze.u_m) annotation(
    Line(points = {{379, 120}, {340, 120}, {340, 72}}, color = {0, 0, 127}));
  connect(omegaRefPu, wCtrlErr.u1) annotation(
    Line(points = {{-610, -140}, {-380, -140}, {-380, -174}, {-362, -174}}, color = {0, 0, 127}));
  connect(dPfreq.y, add3.u3) annotation(
    Line(points = {{-59, -180}, {-40, -180}, {-40, -68}, {-22, -68}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, switch2.u3) annotation(
    Line(points = {{-259, 100}, {-240, 100}, {-240, 132}, {-222, 132}}, color = {0, 0, 127}));
  connect(FreqFlag0.y, switch.u2) annotation(
    Line(points = {{521, -80}, {559, -80}}, color = {255, 0, 255}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{521, -120}, {540, -120}, {540, -88}, {558, -88}}, color = {0, 0, 127}));
  connect(limiter.y, dPfreq.u1) annotation(
    Line(points = {{-119, -140}, {-100, -140}, {-100, -174}, {-82, -174}}, color = {0, 0, 127}));
  connect(limiter1.y, dPfreq.u2) annotation(
    Line(points = {{-119, -220}, {-100, -220}, {-100, -186}, {-82, -186}}, color = {0, 0, 127}));
  connect(limPIDFreeze.y, leadLag.u) annotation(
    Line(points = {{351, 60}, {378, 60}}, color = {0, 0, 127}));
  connect(RefFlag0.y, multiSwitch.f) annotation(
    Line(points = {{239, 120}, {200, 120}, {200, 72}}, color = {255, 127, 0}));
  connect(multiSwitch.y, deadZone.u) annotation(
    Line(points = {{211, 60}, {238, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model's common parts according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>this model is used in the following models:
<li> Plant Control PV </li>
<li> Plant Control WP </li> </p>
</html>"),
    Diagram(coordinateSystem(extent = {{-600, -300}, {600, 300}})),
    version = "",
    uses(Modelica(version = "3.2.3")),
    __OpenModelica_commandLineOptions = "",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {137, 74}, extent = {{-23, 10}, {41, -12}}, textString = "PInjRefPu"), Text(origin = {59, 110}, extent = {{-15, 12}, {11, -12}}, textString = "QPu"), Text(origin = {103, 110}, extent = {{-15, 12}, {11, -12}}, textString = "PPu"), Text(origin = {-53, 110}, extent = {{-15, 12}, {11, -12}}, textString = "iPu"), Text(origin = {-7, 110}, extent = {{-15, 12}, {11, -12}}, textString = "uPu"), Text(origin = {-149, -10}, extent = {{-23, 10}, {21, -10}}, textString = "PRefPu"), Text(origin = {-149, -52}, extent = {{-23, 10}, {21, -10}}, textString = "QRefPu"), Text(origin = {-149, 34}, extent = {{-55, 40}, {21, -10}}, textString = "omegaRefPu"), Text(origin = {-151, 78}, extent = {{-31, 32}, {21, -10}}, textString = "omegaPu"), Text(origin = {139, -46}, extent = {{-23, 10}, {41, -12}}, textString = "QInjRefPu"), Text(origin = {137, 12}, extent = {{-23, 10}, {27, -8}}, textString = "freeze"), Text(origin = {1, -132}, extent = {{-23, 10}, {21, -10}}, textString = "URefPu")}, coordinateSystem(initialScale = 0.1)));
end BaseREPC;
