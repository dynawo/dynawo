within Dynawo.Electrical.Controls.WECC.REEC.BaseClasses;

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

partial model BaseREEC "WECC Electrical Control REEC common"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-270, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {9, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PInjPu(start = PInj0Pu) "Active power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-270, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-269, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjPu(start = QInj0Pu) "Reactive power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-270, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-270, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Voltage magnitude at injector terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 270}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.BooleanOutput frtOn(start = false) "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise " annotation(
    Placement(transformation(origin = {194, 270}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput idCmdPu(start = Id0Pu) "idCmdPu setpoint for generator control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {550, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint for generator control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {550, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IMaxPu) "p-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = 0) "p-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IMaxPu) "q-axis maximum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = - IMaxPu) "q-axis minimum current in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {550, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UFilteredPu(start = UInj0Pu) "Filtered voltage module at injector terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {109, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.RealExpression MaxPID(y = VMaxPu) annotation(
    Placement(transformation(origin = {-50, 138}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression MinPID(y = VMinPu) annotation(
    Placement(transformation(origin = {-50, 160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant VFlag0(k = VFlag) annotation(
    Placement(visible = true, transformation(origin = {-20, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PfFlag0(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-190, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VMaxPu, uMin = VMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {90, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tRv, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 240}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {330, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {27, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tP, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-190, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-120, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = QMaxPu, uMin = QMinPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {181, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimPIDFreeze limPIDFreeze(Ti = Kqp/Kqi, K = Kqp, Strict = true, Xi0 = UInj0Pu/Kqp, Y0 = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-20, 150}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMinPu = VDipPu, UMaxPu = VUpPu) annotation(
    Placement(visible = true, transformation(origin = {140, 270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimPIDFreeze varLimPIDFreeze(Ti = Kvp/Kvi, K = Kvp, Xi0 = QInj0Pu/UInj0Pu/Kqp, Y0 = QInj0Pu/UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {180, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {510, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {510, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = tIq, UseFreeze = true, UseRateLim = false, Y0 = QInj0Pu/UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {124, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn2(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {59, -105}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn1(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {163, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn3(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {-80, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu2(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {-20, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.Max2 max1 annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant VRefConst(k = if VRef0Pu < 0.5 then UInj0Pu else VRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = Dbd2Pu, uMin = Dbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {164, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kqv) annotation(
    Placement(transformation(origin = {204, 220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Tan tan annotation(
    Placement(visible = true, transformation(origin = {-230, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Falling = DPMinPu, Rising = DPMaxPu, initType = Modelica.Blocks.Types.Init.InitialState, y_start = PInj0Pu, y(start = PInj0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tPord, UseFreeze = true, UseRateLim = false, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {65, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {130, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {125, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 2,DynamicSelection=false,fp=QFlag) annotation(
    Placement(transformation(origin = {273, 105}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(variableLimiter.y, iqCmdPu) annotation(
    Line(points = {{521, 110}, {550, 110}}, color = {0, 0, 127}));
  connect(limiter.y, varLimPIDFreeze.u_s) annotation(
    Line(points = {{101, 112}, {168, 112}}, color = {0, 0, 127}));
  connect(QInjPu, limPIDFreeze.u_m) annotation(
    Line(points = {{-270, 240}, {-20, 240}, {-20, 162}}, color = {0, 0, 127}));
  connect(switch.y, limiter.u) annotation(
    Line(points = {{38, 112}, {78, 112}}, color = {0, 0, 127}));
  connect(VFlag0.y, switch.u2) annotation(
    Line(points = {{-9, 112}, {15, 112}}, color = {255, 0, 255}));
  connect(switch1.y, limiter2.u) annotation(
    Line(points = {{-109, 150}, {-92, 150}}, color = {0, 0, 127}));
  connect(PfFlag0.y, switch1.u2) annotation(
    Line(points = {{-179, 150}, {-132, 150}}, color = {255, 0, 255}));
  connect(division.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{101, 54}, {118, 54}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, idCmdPu) annotation(
    Line(points = {{521, -120}, {550, -120}}, color = {0, 0, 127}));
  connect(UPu, firstOrder.u) annotation(
    Line(points = {{-270, 270}, {19.5, 270}, {19.5, 240}, {38, 240}}, color = {0, 0, 127}));
  connect(FRTOn.y, rateLimFirstOrderFreeze1.freeze) annotation(
    Line(points = {{124, 31}, {124, 42}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, frtOn) annotation(
    Line(points = {{151, 270}, {194, 270}}, color = {255, 0, 255}));
  connect(FRTOn1.y, varLimPIDFreeze.freeze) annotation(
    Line(points = {{163, 81}, {163, 90}, {173, 90}, {173, 100}}, color = {255, 0, 255}));
  connect(firstOrder.y, UFilteredPu) annotation(
    Line(points = {{61, 240}, {109, 240}}, color = {0, 0, 127}));
  connect(FRTOn3.y, limPIDFreeze.freeze) annotation(
    Line(points = {{-69, 180}, {-27, 180}, {-27, 162}}, color = {255, 0, 255}));
  connect(limPIDFreeze.y, switch.u1) annotation(
    Line(points = {{-9, 150}, {0, 150}, {0, 120}, {15, 120}}, color = {0, 0, 127}));
  connect(switch1.y, division.u1) annotation(
    Line(points = {{-109, 150}, {-100, 150}, {-100, 60}, {78, 60}, {78, 60}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-179, 190}, {-170, 190}, {-170, 158}, {-132, 158}, {-132, 158}}, color = {0, 0, 127}));
  connect(QInjRefPu, switch1.u3) annotation(
    Line(points = {{-270, 110}, {-170, 110}, {-170, 142}, {-132, 142}}, color = {0, 0, 127}));
  connect(max1.y, division.u2) annotation(
    Line(points = {{61, 40}, {70, 40}, {70, 48}, {78, 48}}, color = {0, 0, 127}));
  connect(UFilteredPu2.y, max1.u1) annotation(
    Line(points = {{-9, 46}, {38, 46}}, color = {0, 0, 127}));
  connect(constant2.y, max1.u2) annotation(
    Line(points = {{-9, 20}, {20, 20}, {20, 34}, {38, 34}}, color = {0, 0, 127}));
  connect(deadZone.y, gain.u) annotation(
    Line(points = {{175, 220}, {192, 220}}, color = {0, 0, 127}));
  connect(PInjPu, firstOrder1.u) annotation(
    Line(points = {{-270, 170}, {-242, 170}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u2) annotation(
    Line(points = {{-219, 170}, {-210, 170}, {-210, 184}, {-202, 184}}, color = {0, 0, 127}));
  connect(tan.y, product.u1) annotation(
    Line(points = {{-219, 210}, {-210, 210}, {-210, 196}, {-202, 196}}, color = {0, 0, 127}));
  connect(PFaRef, tan.u) annotation(
    Line(points = {{-270, 210}, {-242, 210}}, color = {0, 0, 127}));
  connect(PInjRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-269, -40}, {-242, -40}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, limiter3.u) annotation(
    Line(points = {{76, -70}, {118, -70}}, color = {0, 0, 127}));
  connect(FRTOn2.y, rateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{59, -94}, {59, -82}}, color = {255, 0, 255}));
  connect(limiter2.y, limPIDFreeze.u_s) annotation(
    Line(points = {{-69, 150}, {-32, 150}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{136, 220}, {152, 220}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u1) annotation(
    Line(points = {{61, 240}, {80, 240}, {80, 226}, {113, 226}}, color = {0, 0, 127}));
  connect(VRefConst.y, add.u2) annotation(
    Line(points = {{61, 200}, {80, 200}, {80, 214}, {113, 214}}, color = {0, 0, 127}));
  connect(max1.y, division1.u2) annotation(
    Line(points = {{61, 40}, {99, 40}, {99, -126}, {169, -126}}, color = {0, 0, 127}));
  connect(multiSwitch.y, add1.u2) annotation(
    Line(points = {{284, 105}, {300.5, 105}, {300.5, 104}, {318, 104}}, color = {0, 0, 127}));
  connect(MaxPID.y, limPIDFreeze.yMax) annotation(
    Line(points = {{-41, 139}, {-32, 139}, {-32, 144}}, color = {0, 0, 127}));
  connect(MinPID.y, limPIDFreeze.yMin) annotation(
    Line(points = {{-42, 161}, {-32, 161}, {-32, 156}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the electrical common part of the inverter control for the generic WECC model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> this model is used in the following models:
<li> Electrical Control PV </li>
<li> Electrical Control WP </li>
 </p></html>"),
    Diagram(coordinateSystem(extent = {{-260, -280}, {540, 280}}, grid = {1, 1})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {137, 79}, extent = {{-23, 13}, {35, -21}}, textString = "idCmdPu"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "frtOn"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {-111, -116}, extent = {{-33, 21}, {9, -3}}, textString = "QInjPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu"), Text(origin = {7, 130.5}, extent = {{-16, 7}, {24, -10}}, textString = "PFaRef")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1}, initialScale = 0.1)));
end BaseREEC;
