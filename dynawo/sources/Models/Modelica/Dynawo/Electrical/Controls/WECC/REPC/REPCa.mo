within Dynawo.Electrical.Controls.WECC.REPC;

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

model REPCa "WECC Plant Control type A"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREPC;

  parameter Types.PerUnit RcPu "Line drop compensation resistance when VcompFlag = 1 in pu (base SnRef, UNom)";
  parameter Types.PerUnit XcPu "Line drop compensation reactance when VcompFlag = 1 in pu (base SnRef, UNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Active power setpoint at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QGen0Pu) "Reactive power setpoint at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-309, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -59}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omega0Pu) "Frequency setpoint" annotation(
    Placement(visible = true, transformation(origin = {-310, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRegPu(start = PGen0Pu) "Active power at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {79, 111}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QGen0Pu) "Reactive power at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {31, 111}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-50, 160}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at regulated bus in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-31, 111}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = iInj0Pu.re), im(start = iInj0Pu.im)) "Complex current at regulated bus in pu (generator convention) (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-79, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Frequency at regulated bus in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, 79}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu) "Active power setpoint at inverter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at inverter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput freeze(start = false) "Boolean to freeze the regulation" annotation(
    Placement(visible = true, transformation(origin = {-190, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant FreqFlag0(k = FreqFlag) annotation(
    Placement(visible = true, transformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tLag, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter PRefLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = FEMaxPu, uMin = FEMinPu) annotation(
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID limPID(Ti = Kpg / Kig, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = Kpg, xi_start = PInj0Pu / Kpg, yMax = PMaxPu, yMin = PMinPu, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tP, y_start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter QVErrLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {150, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant RefFlag0(k = RefFlag) annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tFilterPC, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add QCtrlErr(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFilterPC, y_start = if VCompFlag == true then UInj0Pu else U0Pu + Kc * QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.LineDropCompensation lineDropCompensation1(RcPu = RcPu, XcPu = XcPu) annotation(
    Placement(visible = true, transformation(origin = {-270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant VCompFlag0(k = VCompFlag) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add QVCtrlErr annotation(
    Placement(visible = true, transformation(origin = {-230, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-270, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add wCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-270, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(uMax = FDbd2Pu, uMin = -FDbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add dPfreq annotation(
    Placement(visible = true, transformation(origin = {-110, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = DDn) annotation(
    Placement(visible = true, transformation(origin = {-190, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = DUp) annotation(
    Placement(visible = true, transformation(origin = {-190, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 0, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-150, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(Ti = Kp / Ki, K = Kp, Xi0 = QInj0Pu / Kp, YMax = QMaxPu, YMin = QMinPu, Y0 = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMinPu = VFrz, UMaxPu = 999) annotation(
    Placement(visible = true, transformation(origin = {-230, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction leadLag(a = {tFv, 1}, b = {tFt, 1}, x_start = {QInj0Pu}, y_start = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit PGen0Pu "Start value of active power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QGen0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at regulated bus in pu (base UNom)";
  parameter Types.PerUnit UInj0Pu "Start value of voltage magnitude at injector terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at regulated bus in pu (generator convention) (base SNom, UNom)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";

  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else U0Pu + Kc * QGen0Pu "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(lineDropCompensation1.U2Pu, voltageCheck.UPu) annotation(
    Line(points = {{-259, 94}, {-241, 94}}, color = {0, 0, 127}));
  connect(PRegPu, firstOrder1.u) annotation(
    Line(points = {{-310, -50}, {-282, -50}}, color = {0, 0, 127}));
  connect(gain.u, QRegPu) annotation(
    Line(points = {{-282, 50}, {-310, 50}}, color = {0, 0, 127}));
  connect(omegaPu, wCtrlErr.u2) annotation(
    Line(points = {{-310, -140}, {-290, -140}, {-290, -136}, {-282, -136}}, color = {0, 0, 127}));
  connect(switch.y, PInjRefPu) annotation(
    Line(points = {{121, -90}, {160, -90}, {160, -80}, {210, -80}}, color = {0, 0, 127}));
  connect(wCtrlErr.y, deadZone1.u) annotation(
    Line(points = {{-259, -130}, {-242, -130}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain2.u) annotation(
    Line(points = {{-219, -130}, {-202, -130}}, color = {0, 0, 127}));
  connect(gain2.y, limiter1.u) annotation(
    Line(points = {{-179, -130}, {-161, -130}}, color = {0, 0, 127}));
  connect(limPID.y, firstOrder.u) annotation(
    Line(points = {{21, -50}, {38, -50}}, color = {0, 0, 127}));
  connect(Zero.y, limPID.u_m) annotation(
    Line(points = {{-19, -90}, {10, -90}, {10, -62}}, color = {0, 0, 127}));
  connect(PRefLim.y, limPID.u_s) annotation(
    Line(points = {{-19, -50}, {-2, -50}}, color = {0, 0, 127}));
  connect(add3.y, PRefLim.u) annotation(
    Line(points = {{-59, -50}, {-42, -50}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add3.u2) annotation(
    Line(points = {{-259, -50}, {-82, -50}}, color = {0, 0, 127}));
  connect(deadZone.y, QVErrLim.u) annotation(
    Line(points = {{61, 50}, {78, 50}}, color = {0, 0, 127}));
  connect(RefFlag0.y, switch1.u2) annotation(
    Line(points = {{-19, 50}, {-2, 50}}, color = {255, 0, 255}));
  connect(switch1.y, deadZone.u) annotation(
    Line(points = {{21, 50}, {38, 50}}, color = {0, 0, 127}));
  connect(firstOrder2.y, QCtrlErr.u1) annotation(
    Line(points = {{-219, 20}, {-42, 20}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UCtrlErr.u2) annotation(
    Line(points = {{-59, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{-179, -90}, {-162, -90}}, color = {0, 0, 127}));
  connect(switch2.y, firstOrder3.u) annotation(
    Line(points = {{-99, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(VCompFlag0.y, switch2.u2) annotation(
    Line(points = {{-139, 80}, {-122, 80}}, color = {255, 0, 255}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-259, 50}, {-242, 50}}, color = {0, 0, 127}));
  connect(uPu, lineDropCompensation1.u2Pu) annotation(
    Line(points = {{-310, 80}, {-290, 80}, {-290, 94}, {-281, 94}, {-281, 94}}, color = {85, 170, 255}));
  connect(iPu, lineDropCompensation1.iPu) annotation(
    Line(points = {{-310, 120}, {-290, 120}, {-290, 106}, {-281, 106}, {-281, 106}}, color = {85, 170, 255}));
  connect(QRegPu, firstOrder2.u) annotation(
    Line(points = {{-310, 50}, {-290, 50}, {-290, 20}, {-242, 20}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, QVCtrlErr.u1) annotation(
    Line(points = {{-259, 94}, {-250, 94}, {-250, 62}, {-242, 62}, {-242, 62}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, limPIDFreeze.freeze) annotation(
    Line(points = {{-218, 94}, {-210, 94}, {-210, 120}, {124, 120}, {124, 62}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, freeze) annotation(
    Line(points = {{-219, 94}, {-197, 94}, {-197, 94}, {-190, 94}}, color = {255, 0, 255}));
  connect(QRefPu, QCtrlErr.u2) annotation(
    Line(points = {{-309, 0}, {-60, 0}, {-60, 8}, {-42, 8}}, color = {0, 0, 127}));
  connect(QVErrLim.y, limPIDFreeze.u_s) annotation(
    Line(points = {{101, 50}, {118, 50}}, color = {0, 0, 127}));
  connect(Zero1.y, limPIDFreeze.u_m) annotation(
    Line(points = {{139, 90}, {130, 90}, {130, 62}}, color = {0, 0, 127}));
  connect(omegaRefPu, wCtrlErr.u1) annotation(
    Line(points = {{-310, -120}, {-290, -120}, {-290, -124}, {-282, -124}, {-282, -124}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain1.u) annotation(
    Line(points = {{-219, -130}, {-210, -130}, {-210, -90}, {-202, -90}, {-202, -90}}, color = {0, 0, 127}));
  connect(dPfreq.y, add3.u3) annotation(
    Line(points = {{-99, -110}, {-90, -110}, {-90, -58}, {-82, -58}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u1) annotation(
    Line(points = {{-310, -30}, {-90, -30}, {-90, -42}, {-82, -42}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, switch1.u1) annotation(
    Line(points = {{-19, 86}, {-10, 86}, {-10, 58}, {-2, 58}}, color = {0, 0, 127}));
  connect(QCtrlErr.y, switch1.u3) annotation(
    Line(points = {{-19, 14}, {-10, 14}, {-10, 42}, {-2, 42}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, switch2.u1) annotation(
    Line(points = {{-259, 106}, {-130, 106}, {-130, 88}, {-122, 88}, {-122, 88}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, switch2.u3) annotation(
    Line(points = {{-219, 56}, {-130, 56}, {-130, 72}, {-122, 72}, {-122, 72}}, color = {0, 0, 127}));
  connect(FreqFlag0.y, switch.u2) annotation(
    Line(points = {{60, -90}, {98, -90}}, color = {255, 0, 255}));
  connect(firstOrder.y, switch.u1) annotation(
    Line(points = {{61, -50}, {80, -50}, {80, -82}, {98, -82}}, color = {0, 0, 127}));
  connect(const.y, switch.u3) annotation(
    Line(points = {{61, -130}, {80, -130}, {80, -98}, {98, -98}}, color = {0, 0, 127}));
  connect(limiter.y, dPfreq.u1) annotation(
    Line(points = {{-139, -90}, {-130, -90}, {-130, -104}, {-122, -104}, {-122, -104}}, color = {0, 0, 127}));
  connect(limiter1.y, dPfreq.u2) annotation(
    Line(points = {{-139, -130}, {-130, -130}, {-130, -116}, {-122, -116}, {-122, -116}}, color = {0, 0, 127}));
  connect(limPIDFreeze.y, leadLag.u) annotation(
    Line(points = {{141, 50}, {158, 50}}, color = {0, 0, 127}));
  connect(leadLag.y, QInjRefPu) annotation(
    Line(points = {{181, 50}, {210, 50}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-50, 160}, {-50, 92}, {-42, 92}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled when VcompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu). </p>
</html>"),
    Diagram(coordinateSystem(extent = {{-300, -150}, {200, 150}})),
    version = "",
    __OpenModelica_commandLineOptions = "",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC A"), Text(origin = {137, 74}, extent = {{-23, 10}, {41, -12}}, textString = "PInjRefPu"), Text(origin = {59, 110}, extent = {{-15, 12}, {11, -12}}, textString = "QPu"), Text(origin = {103, 110}, extent = {{-15, 12}, {11, -12}}, textString = "PPu"), Text(origin = {-53, 110}, extent = {{-15, 12}, {11, -12}}, textString = "iPu"), Text(origin = {-7, 110}, extent = {{-15, 12}, {11, -12}}, textString = "uPu"), Text(origin = {-149, -10}, extent = {{-23, 10}, {21, -10}}, textString = "PRefPu"), Text(origin = {-149, -52}, extent = {{-23, 10}, {21, -10}}, textString = "QRefPu"), Text(origin = {-149, 34}, extent = {{-55, 40}, {21, -10}}, textString = "omegaRefPu"), Text(origin = {-151, 78}, extent = {{-31, 32}, {21, -10}}, textString = "omegaPu"), Text(origin = {139, -46}, extent = {{-23, 10}, {41, -12}}, textString = "QInjRefPu"), Text(origin = {137, 12}, extent = {{-23, 10}, {27, -8}}, textString = "freeze"), Text(origin = {1, -132}, extent = {{-23, 10}, {21, -10}}, textString = "URefPu")}, coordinateSystem(initialScale = 0.1)));
end REPCa;
