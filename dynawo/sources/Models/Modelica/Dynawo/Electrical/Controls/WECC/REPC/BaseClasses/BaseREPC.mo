within Dynawo.Electrical.Controls.WECC.REPC.BaseClasses;

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

partial model BaseREPC "WECC Renewable Energy Plant Controller base model"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.BaseREPCParameters;

  //Line drop parameters
  parameter Types.PerUnit RcPu "Line drop compensation resistance when UCompFlag = 1 in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Line drop"));
  parameter Types.PerUnit XcPu "Line drop compensation reactance when UCompFlag = 1 in pu (base SnRef, UNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Line drop"));

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = iInj0Pu.re), im(start = iInj0Pu.im)) "Complex current at terminal in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-360, 220}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Freq: Frequency at terminal in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-360, -220}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omega0Pu) "Freq_ref: Frequency setpoint in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRegPu(start = PGen0Pu) "Pbranch: Active power at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Plant_pref: Active power setpoint at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QGen0Pu) "Qref: Reactive power setpoint at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QGen0Pu) "Qbranch: Reactive power at terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Vreg : Complex voltage at terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Vref: Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-60, 220}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu) "Pref: Active power setpoint at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {410, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInjRef0Pu) "Qext or Vext : Reactive power or voltage setpoint at injector in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {410, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-360, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = FDbd2Pu, uMin = FDbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = DUpPu) annotation(
    Placement(visible = true, transformation(origin = {-210, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = DDnPu) annotation(
    Placement(visible = true, transformation(origin = {-210, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-170, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 0, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-170, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(visible = true, transformation(origin = {-50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = FEMaxPu, uMin = FEMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {350, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = FreqFlag) annotation(
    Placement(visible = true, transformation(origin = {290, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze pid(K = Kpg, Ti = Kpg / Kig, Xi0 = PInj0Pu / Kpg, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tLag, UseRateLim = false, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {230, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tP, y_start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {290, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(visible = true, transformation(origin = {170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(visible = true, transformation(origin = {230, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze pid1(K = Kp, Ti = Kp / Ki, Xi0 = QInjRef0Pu / Kp, Y0 = QInjRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {290, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tFv, 1}, b = {tFt, 1}, x_scaled(start = {QInjRef0Pu}), x_start = {QInjRef0Pu}, y_start = QInjRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {370, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = voltageCheck.freeze) annotation(
    Placement(visible = true, transformation(origin = {280, 170}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.WECC.BaseControls.LineDropCompensation lineDropCompensation(RcPu = RcPu, XcPu = XcPu) annotation(
    Placement(visible = true, transformation(origin = {-320, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {-70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add4(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k = UCompFlag) annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tFilterPC, y_start = QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMaxPu = 999, UMinPu = UFrzPu) annotation(
    Placement(visible = true, transformation(origin = {-190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {310, 140}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at terminal in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector  in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Start value of voltage module at terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage magnitude at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

  final parameter Types.PerUnit QInjRef0Pu = if RefFlag == 1 then UInj0Pu else QInj0Pu "Start value of reactive power or voltage setpoint at injector in pu (base SNom or UNom) (generator convention)";
  final parameter Types.VoltageModulePu URef0Pu = if UCompFlag then UInj0Pu else (U0Pu + Kc * QGen0Pu) "Start value of voltage setpoint for plant level control, calculated depending on UCompFlag, in pu (base UNom)";

equation
  connect(add.y, add3.u3) annotation(
    Line(points = {{-98, -140}, {-80, -140}, {-80, -88}, {-62, -88}}, color = {0, 0, 127}));
  connect(gain1.y, limiter1.u) annotation(
    Line(points = {{-198, -120}, {-182, -120}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-198, -160}, {-182, -160}}, color = {0, 0, 127}));
  connect(limiter1.y, add.u1) annotation(
    Line(points = {{-158, -120}, {-140, -120}, {-140, -134}, {-122, -134}}, color = {0, 0, 127}));
  connect(limiter.y, add.u2) annotation(
    Line(points = {{-158, -160}, {-140, -160}, {-140, -146}, {-122, -146}}, color = {0, 0, 127}));
  connect(feedback.y, deadZone.u) annotation(
    Line(points = {{-350, -140}, {-322, -140}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback.u1) annotation(
    Line(points = {{-420, -140}, {-368, -140}}, color = {0, 0, 127}));
  connect(PRegPu, firstOrder.u) annotation(
    Line(points = {{-420, -40}, {-322, -40}}, color = {0, 0, 127}));
  connect(limiter2.y, pid.u_s) annotation(
    Line(points = {{61, -80}, {77, -80}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, switch1.u1) annotation(
    Line(points = {{241, -80}, {260, -80}, {260, -60}, {320, -60}, {320, -72}, {338, -72}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{302, -80}, {338, -80}}, color = {255, 0, 255}));
  connect(const.y, switch1.u3) annotation(
    Line(points = {{302, -120}, {320, -120}, {320, -88}, {338, -88}}, color = {0, 0, 127}));
  connect(switch1.y, PInjRefPu) annotation(
    Line(points = {{362, -80}, {410, -80}}, color = {0, 0, 127}));
  connect(transferFunction.y, QInjRefPu) annotation(
    Line(points = {{381, 80}, {410, 80}}, color = {0, 0, 127}));
  connect(deadZone1.y, limiter3.u) annotation(
    Line(points = {{182, 80}, {218, 80}}, color = {0, 0, 127}));
  connect(limiter3.y, pid1.u_s) annotation(
    Line(points = {{242, 80}, {278, 80}}, color = {0, 0, 127}));
  connect(booleanExpression.y, pid1.freeze) annotation(
    Line(points = {{280, 160}, {280, 120}, {284, 120}, {284, 92}}, color = {255, 0, 255}));
  connect(iPu, lineDropCompensation.iPu) annotation(
    Line(points = {{-360, 220}, {-360, 172}, {-342, 172}}, color = {85, 170, 255}));
  connect(booleanConstant2.y, switch11.u2) annotation(
    Line(points = {{-118, 120}, {-82, 120}}, color = {255, 0, 255}));
  connect(add1.y, switch11.u3) annotation(
    Line(points = {{-179, 100}, {-100, 100}, {-100, 112}, {-82, 112}}, color = {0, 0, 127}));
  connect(uPu, lineDropCompensation.u2Pu) annotation(
    Line(points = {{-420, 140}, {-360, 140}, {-360, 148}, {-342, 148}}, color = {85, 170, 255}));
  connect(QRegPu, firstOrder1.u) annotation(
    Line(points = {{-420, 80}, {-322, 80}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback1.u2) annotation(
    Line(points = {{-298, 80}, {0, 80}, {0, 48}}, color = {0, 0, 127}));
  connect(const1.y, pid.u_m) annotation(
    Line(points = {{99, -40}, {90, -40}, {90, -68}}, color = {0, 0, 127}));
  connect(const2.y, pid1.u_m) annotation(
    Line(points = {{299, 140}, {290, 140}, {290, 92}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 39}, extent = {{-41, 19}, {97, -41}}, textString = "Plant Controller"), Text(origin = {137, 76}, extent = {{-23, 10}, {41, -12}}, textString = "PInjRefPu"), Text(origin = {-103, 116}, extent = {{-15, 12}, {11, -12}}, textString = "iPu"), Text(origin = {-15, 116}, extent = {{-15, 12}, {11, -12}}, textString = "uPu"), Text(origin = {-149, 10}, extent = {{-23, 10}, {21, -10}}, textString = "PRefPu"), Text(origin = {-149, -52}, extent = {{-23, 10}, {21, -10}}, textString = "QRefPu"), Text(origin = {-149, 34}, extent = {{-55, 40}, {21, -10}}, textString = "omegaRefPu"), Text(origin = {-151, 78}, extent = {{-31, 32}, {21, -10}}, textString = "omegaPu"), Text(origin = {137, -74}, extent = {{-23, 10}, {41, -12}}, textString = "QInjRefPu"), Text(origin = {41, -116}, extent = {{-23, 10}, {21, -10}}, textString = "URefPu"), Text(origin = {113, 106}, extent = {{-23, 10}, {21, -10}}, textString = "PRegPu"), Text(origin = {15, 106}, extent = {{-21, 8}, {19, -8}}, textString = "QRegPu")}, coordinateSystem(initialScale = 0.1)));
end BaseREPC;
