within Dynawo.Electrical.Controls.WECC.REEC.BaseClasses;

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

partial model BaseREEC "WECC Renewable Energy Electrical Control base model"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.BaseREECParameters;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-500, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PInjPu(start = PInj0Pu) "Pe: Active power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-500, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "PRef: Active power setpoint at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-220, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjPu(start = QInj0Pu) "QGen: Reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-140, -20}, extent = {{-20, 20}, {20, -20}}, rotation = 90), iconTransformation(origin = {-80, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInjRef0Pu) "QExt or VExt: Reactive power or voltage setpoint at injector in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-500, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UInjPu(start = UInj0Pu) "Vt: Voltage module at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.BooleanOutput frtOn(start = false) "Ongoing voltage dip" annotation(
    Placement(visible = true, transformation(origin = {-50, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = Ip0Pu) "Active current setpoint for generator converter in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {490, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Iq0Pu) "Reactive current setpoint for generator converter in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {490, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tP, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-430, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-370, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch pfflagswitch annotation(
    Placement(visible = true, transformation(origin = {-270, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-350, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2 annotation(
    Placement(visible = true, transformation(origin = {-210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Tan tan annotation(
    Placement(visible = true, transformation(origin = {-430, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Falling = DPMinPu, Rising = DPMaxPu, initType = Modelica.Blocks.Types.Init.InitialState, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tPOrd, UseFreeze = true, UseRateLim = false, Y0 = PInj0Pu, k = 1) annotation(
    Placement(visible = true, transformation(origin = {130, -160}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {170, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {290, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {410, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMaxPu = UMaxPu, UMinPu = UMinPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRT3(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {124, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIFreeze(K = Kqp, Ti = Kqp / Kqi, Xi0 = UInj0Pu / Kqp, Y0 = UInj0Pu, YMax = UMaxPu, YMin = UMinPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRT1(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {-160, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.Switch uflagswitch annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = UFlag) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tRv, k = 1, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {30, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefConst(k = if VRef0Pu < 0.5 then UInj0Pu else VRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-90, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = Dbd2Pu, uMin = Dbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {-30, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {290, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {410, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilt2(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = variableLimiter.limit2) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch qflagswitch annotation(
    Placement(visible = true, transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMax(y = variableLimiter.limit1) annotation(
    Placement(visible = true, transformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k = QFlag) annotation(
    Placement(visible = true, transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimPIDFreeze varLimPIFreeze(K = Kvp, Ti = Kvp / Kvi, Xi0 = QInj0Pu / UInj0Pu / Kvp, Y0 = QInj0Pu / UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = UMaxPu, uMin = UMinPu) annotation(
    Placement(visible = true, transformation(origin = {10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = tIq, UseFreeze = true, UseRateLim = false, Y0 = QInj0Pu / UInj0Pu, k = 1) annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilt1(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {100, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UFilteredPu annotation(
    Placement(visible = false, transformation(origin = {-90, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRT2(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {80, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-30, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit Ip0Pu "Start value of active current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit Iq0Pu "Start value of reactive current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Real PF0 "Start value of cosinus of power factor angle" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

  final parameter Types.PerUnit QInjRef0Pu = if not PfFlag and not UFlag and QFlag then UInj0Pu else QInj0Pu "Start value of reactive power or voltage setpoint at injector in pu (base SNom or UNom) (generator convention)";

equation
  connect(PFaRef, tan.u) annotation(
    Line(points = {{-500, 40}, {-442, 40}}, color = {0, 0, 127}));
  connect(tan.y, product.u1) annotation(
    Line(points = {{-419, 40}, {-400, 40}, {-400, 26}, {-382, 26}}, color = {0, 0, 127}));
  connect(PInjPu, firstOrder1.u) annotation(
    Line(points = {{-500, 0}, {-442, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u2) annotation(
    Line(points = {{-419, 0}, {-400, 0}, {-400, 14}, {-382, 14}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, ipCmdPu) annotation(
    Line(points = {{421, -80}, {490, -80}}, color = {0, 0, 127}));
  connect(PInjRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-220, -160}, {-162, -160}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, frtOn) annotation(
    Line(points = {{-79, 220}, {-51, 220}}, color = {255, 0, 255}));
  connect(rateLimFirstOrderFreeze.y, limiter3.u) annotation(
    Line(points = {{141, -160}, {158, -160}}, color = {0, 0, 127}));
  connect(pfflagswitch.y, limiter2.u) annotation(
    Line(points = {{-259, 40}, {-222, 40}}, color = {0, 0, 127}));
  connect(booleanConstant1.y, uflagswitch.u2) annotation(
    Line(points = {{-79, 40}, {-42, 40}}, color = {255, 0, 255}));
  connect(UInjPu, firstOrder.u) annotation(
    Line(points = {{-220, 200}, {-180, 200}, {-180, 180}, {-162, 180}}, color = {0, 0, 127}));
  connect(URefConst.y, add.u2) annotation(
    Line(points = {{-139, 140}, {-120, 140}, {-120, 154}, {-103, 154}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u1) annotation(
    Line(points = {{-139, 180}, {-120, 180}, {-120, 166}, {-103, 166}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{-79, 160}, {-43, 160}}, color = {0, 0, 127}));
  connect(deadZone.y, gain.u) annotation(
    Line(points = {{-19, 160}, {17, 160}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{41, 160}, {77, 160}}, color = {0, 0, 127}));
  connect(variableLimiter.y, iqCmdPu) annotation(
    Line(points = {{421, 80}, {490, 80}}, color = {0, 0, 127}));
  connect(limiter2.y, limPIFreeze.u_s) annotation(
    Line(points = {{-199, 40}, {-162, 40}}, color = {0, 0, 127}));
  connect(limPIFreeze.y, uflagswitch.u1) annotation(
    Line(points = {{-139, 40}, {-120, 40}, {-120, 60}, {-60, 60}, {-60, 48}, {-42, 48}}, color = {0, 0, 127}));
  connect(booleanConstant2.y, qflagswitch.u2) annotation(
    Line(points = {{161, 40}, {198, 40}}, color = {255, 0, 255}));
  connect(qflagswitch.y, add1.u2) annotation(
    Line(points = {{221, 40}, {240, 40}, {240, 74}, {278, 74}}, color = {0, 0, 127}));
  connect(uflagswitch.y, limiter.u) annotation(
    Line(points = {{-19, 40}, {-2, 40}}, color = {0, 0, 127}));
  connect(varLimPIFreeze.y, qflagswitch.u1) annotation(
    Line(points = {{101, 40}, {120, 40}, {120, 60}, {180, 60}, {180, 48}, {198, 48}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIFreeze.yMin) annotation(
    Line(points = {{42, 0}, {60, 0}, {60, 34}, {78, 34}}, color = {0, 0, 127}));
  connect(IqMax.y, varLimPIFreeze.yMax) annotation(
    Line(points = {{42, 80}, {60, 80}, {60, 46}, {78, 46}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, qflagswitch.u3) annotation(
    Line(points = {{101, -60}, {180, -60}, {180, 32}, {198, 32}}, color = {0, 0, 127}));
  connect(division.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{41, -60}, {78, -60}}, color = {0, 0, 127}));
  connect(UFilt1.y, varLimPIFreeze.u_m) annotation(
    Line(points = {{100, 1}, {100, 20}, {90, 20}, {90, 28}}, color = {0, 0, 127}));
  connect(FRT3.y, rateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{124, -141}, {124, -148}}, color = {255, 0, 255}));
  connect(firstOrder.y, UFilteredPu);
  connect(FRT2.y, varLimPIFreeze.freeze) annotation(
    Line(points = {{80, 1}, {80, 20}, {83, 20}, {83, 28}}, color = {255, 0, 255}));
  connect(add1.y, variableLimiter.u) annotation(
    Line(points = {{301, 80}, {398, 80}}, color = {0, 0, 127}));
  connect(product.y, pfflagswitch.u1) annotation(
    Line(points = {{-358, 20}, {-340, 20}, {-340, 48}, {-282, 48}}, color = {0, 0, 127}));
  connect(booleanConstant.y, pfflagswitch.u2) annotation(
    Line(points = {{-339, -20}, {-320, -20}, {-320, 40}, {-282, 40}}, color = {255, 0, 255}));
  connect(QInjRefPu, pfflagswitch.u3) annotation(
    Line(points = {{-500, -40}, {-300, -40}, {-300, 32}, {-282, 32}}, color = {0, 0, 127}));
  connect(FRT1.y, limPIFreeze.freeze) annotation(
    Line(points = {{-160, 2}, {-160, 20}, {-156, 20}, {-156, 28}}, color = {255, 0, 255}));
  connect(QInjPu, limPIFreeze.u_m) annotation(
    Line(points = {{-140, -20}, {-140, 20}, {-150, 20}, {-150, 28}}, color = {0, 0, 127}));
  connect(FRT2.y, rateLimFirstOrderFreeze1.freeze) annotation(
    Line(points = {{80, 2}, {80, -40}, {84, -40}, {84, -48}}, color = {255, 0, 255}));
  connect(UFilt2.y, limiter4.u) annotation(
    Line(points = {{-78, -100}, {-42, -100}}, color = {0, 0, 127}));
  connect(limiter4.y, division.u2) annotation(
    Line(points = {{-18, -100}, {0, -100}, {0, -66}, {18, -66}}, color = {0, 0, 127}));
  connect(limiter4.y, division1.u2) annotation(
    Line(points = {{-18, -100}, {240, -100}, {240, -74}, {278, -74}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-480, -240}, {480, 240}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 52}, extent = {{-57, 58}, {103, -102}}, textString = "Electrical Control"), Text(origin = {140, -64}, extent = {{-22, 16}, {36, -28}}, textString = "ipCmdPu"), Text(origin = {140, 80}, extent = {{-22, 16}, {36, -28}}, textString = "iqCmdPu"), Text(origin = {140, 18}, extent = {{-22, 16}, {36, -28}}, textString = "frtOn"), Text(origin = {-36, 132}, extent = {{-22, 16}, {36, -28}}, textString = "PFaRef"), Text(origin = {-156, 80}, extent = {{-22, 16}, {36, -28}}, textString = "PInjRefPu"), Text(origin = {-156, -68}, extent = {{-22, 16}, {36, -28}}, textString = "QInjRefPu"), Text(origin = {-128, -124}, extent = {{-22, 16}, {36, -28}}, textString = "QInjPu"), Text(origin = {-4, -126}, extent = {{-22, 16}, {36, -28}}, textString = "PInjPu"), Text(origin = {92, -126}, extent = {{-22, 16}, {36, -28}}, textString = "UInjPu")}));
end BaseREEC;
