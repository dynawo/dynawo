within Dynawo.Electrical.Controls.WECC.REEC.BaseClasses;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
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

partial model ElectricalControlCommon "WECC Electrical Control REEC common"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsElectricalControl;

  // Inputs
  Modelica.Blocks.Interfaces.RealInput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PInjRefPu(start = PInj0Pu) "Active power setpoint at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QInjPu(start = QInj0Pu) "Reactive power at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PInjPu(start = PInj0Pu) "Active power at injector terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Voltage magnitude at injector terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idCmdPu(start = Id0Pu) "idCmdPu setpoint for generator control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {550, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint for generator control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {550, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UFilteredPu(start = UInj0Pu) "Filtered voltage module at injector terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput frtOn(start = false) "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise " annotation(
    Placement(visible = true, transformation(origin = {-200, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.BooleanConstant QFlag0(k = QFlag) annotation(
    Placement(visible = true, transformation(origin = {220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant VFlag0(k = VFlag) annotation(
    Placement(visible = true, transformation(origin = {-40, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PfFlag0(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VMaxPu, uMin = VMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {90, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tRv, k = 1, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = 1, k2 = 1) annotation(
    Placement(visible = true, transformation(origin = {330, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {10, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tP, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PfaRef(k = tan(acos(PF0))) annotation(
    Placement(visible = true, transformation(origin = {-230, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = QMaxPu, uMin = QMinPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {280, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {180, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(Ti = Kqp / Kqi, K = Kqp, Xi0 = UInj0Pu / Kqp, YMax = VMaxPu, YMin = VMinPu, Y0 = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMinPu = UMinPu, UMaxPu = UMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimPIDFreeze varLimPIDFreeze(Ti = Kvp / Kvi, K = Kvp, Xi0 = QInj0Pu / UInj0Pu / Kqp, Y0 = QInj0Pu / UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {180, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {457, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {457, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = Tiq, k = 1, UseFreeze = true, UseRateLim = false, Y0 = QInj0Pu / UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {124, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn1(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {163, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn3(y = frtOn) annotation(
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu1(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {50, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu2(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {-20, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu3(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {190, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {130, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.0001) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0.0001) annotation(
    Placement(visible = true, transformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant VRefConst(k = if VRef0Pu < 0.5 then UInj0Pu else VRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu4(y = UFilteredPu) annotation(
    Placement(visible = true, transformation(origin = {50, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = 1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = Dbd2, uMin = Dbd1) annotation(
    Placement(visible = true, transformation(origin = {180, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(visible = true, transformation(origin = {280, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {220, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(variableLimiter.y, iqCmdPu) annotation(
    Line(points = {{468, -20}, {550, -20}}, color = {0, 0, 127}));
  connect(varLimPIDFreeze.y, switch2.u1) annotation(
    Line(points = {{191, -18}, {268, -18}}, color = {0, 0, 127}));
  connect(limiter.y, varLimPIDFreeze.u_s) annotation(
    Line(points = {{101, -18}, {168, -18}}, color = {0, 0, 127}));
  connect(limiter2.y, limPIDFreeze.u_s) annotation(
    Line(points = {{-69, 20}, {-52, 20}}, color = {0, 0, 127}));
  connect(QInjPu, limPIDFreeze.u_m) annotation(
    Line(points = {{-270, 110}, {-40, 110}, {-40, 32}}, color = {0, 0, 127}));
  connect(switch.y, limiter.u) annotation(
    Line(points = {{21, -18}, {78, -18}}, color = {0, 0, 127}));
  connect(VFlag0.y, switch.u2) annotation(
    Line(points = {{-29, -18}, {-2, -18}}, color = {255, 0, 255}));
  connect(PInjPu, firstOrder1.u) annotation(
    Line(points = {{-270, 80}, {-242, 80}}, color = {0, 0, 127}));
  connect(switch1.y, limiter2.u) annotation(
    Line(points = {{-109, 20}, {-92, 20}}, color = {0, 0, 127}));
  connect(PfFlag0.y, switch1.u2) annotation(
    Line(points = {{-179, 20}, {-132, 20}}, color = {255, 0, 255}));
  connect(rateLimFirstOrderFreeze1.y, switch2.u3) annotation(
    Line(points = {{141, -76}, {260, -76}, {260, -34}, {268, -34}}, color = {0, 0, 127}));
  connect(division.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{101, -76}, {118, -76}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, idCmdPu) annotation(
    Line(points = {{468, 80}, {550, 80}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{191, 80}, {445, 80}}, color = {0, 0, 127}));
  connect(add1.y, variableLimiter.u) annotation(
    Line(points = {{341, -20}, {445, -20}}, color = {0, 0, 127}));
  connect(switch2.y, add1.u2) annotation(
    Line(points = {{291, -26}, {318, -26}}, color = {0, 0, 127}));
  connect(UPu, firstOrder.u) annotation(
    Line(points = {{-270, -70}, {-242, -70}}, color = {0, 0, 127}));
  connect(QFlag0.y, switch2.u2) annotation(
    Line(points = {{231, -40}, {240, -40}, {240, -26}, {268, -26}}, color = {255, 0, 255}));
  connect(FRTOn.y, rateLimFirstOrderFreeze1.freeze) annotation(
    Line(points = {{124, -99}, {124, -88}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, frtOn) annotation(
    Line(points = {{-219, -40}, {-200, -40}}, color = {255, 0, 255}));
  connect(UFilteredPu3.y, varLimPIDFreeze.u_m) annotation(
    Line(points = {{190, -49}, {190, -40}, {180, -40}, {180, -30}}, color = {0, 0, 127}));
  connect(FRTOn1.y, varLimPIDFreeze.freeze) annotation(
    Line(points = {{163, -49}, {163, -40}, {173, -40}, {173, -30}}, color = {255, 0, 255}));
  connect(firstOrder.y, UFilteredPu) annotation(
    Line(points = {{-219, -70}, {-200, -70}}, color = {0, 0, 127}));
  connect(FRTOn3.y, limPIDFreeze.freeze) annotation(
    Line(points = {{-69, 50}, {-47, 50}, {-47, 32}}, color = {255, 0, 255}));
  connect(limPIDFreeze.y, switch.u1) annotation(
    Line(points = {{-29, 20}, {-20, 20}, {-20, -10}, {-2, -10}}, color = {0, 0, 127}));
  connect(switch1.y, division.u1) annotation(
    Line(points = {{-109, 20}, {-100, 20}, {-100, -70}, {78, -70}, {78, -70}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-179, 60}, {-170, 60}, {-170, 28}, {-132, 28}, {-132, 28}}, color = {0, 0, 127}));
  connect(QInjRefPu, switch1.u3) annotation(
    Line(points = {{-270, -20}, {-170, -20}, {-170, 12}, {-132, 12}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u1) annotation(
    Line(points = {{-219, 80}, {-210, 80}, {-210, 66}, {-202, 66}, {-202, 66}}, color = {0, 0, 127}));
  connect(PfaRef.y, product.u2) annotation(
    Line(points = {{-219, 40}, {-210, 40}, {-210, 54}, {-202, 54}}, color = {0, 0, 127}));
  connect(UPu, voltageCheck.UPu) annotation(
    Line(points = {{-270, -70}, {-250, -70}, {-250, -40}, {-241, -40}, {-241, -40}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{141, 74}, {168, 74}}, color = {0, 0, 127}));
  connect(UFilteredPu1.y, max.u2) annotation(
    Line(points = {{61, 68}, {118, 68}}, color = {0, 0, 127}));
  connect(constant1.y, max.u1) annotation(
    Line(points = {{21, 80}, {118, 80}}, color = {0, 0, 127}));
  connect(max1.y, division.u2) annotation(
    Line(points = {{61, -90}, {70, -90}, {70, -82}, {78, -82}}, color = {0, 0, 127}));
  connect(UFilteredPu2.y, max1.u1) annotation(
    Line(points = {{-9, -84}, {38, -84}}, color = {0, 0, 127}));
  connect(constant2.y, max1.u2) annotation(
    Line(points = {{-9, -110}, {20, -110}, {20, -96}, {38, -96}}, color = {0, 0, 127}));
  connect(VRefConst.y, add.u1) annotation(
    Line(points = {{21, 36}, {118, 36}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{141, 30}, {168, 30}}, color = {0, 0, 127}));
  connect(UFilteredPu4.y, add.u2) annotation(
    Line(points = {{61, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{231, 30}, {268, 30}}, color = {0, 0, 127}));
  connect(deadZone.y, gain.u) annotation(
    Line(points = {{191, 30}, {208, 30}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the electrical common part of the inverter control for the generic WECC model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> this model is used in the following models:
<li> Electrical Control PV </li>
<li> Electrical Control WP </li>
 </p></html>"),
    Diagram(coordinateSystem(extent = {{-260, -130}, {540, 250}}, grid = {1, 1})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 22}, extent = {{-57, 58}, {103, -102}}, textString = "Electrical Control"), Text(origin = {137, 79}, extent = {{-23, 13}, {35, -21}}, textString = "idCmdPu"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "frtOn"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {-111, -116}, extent = {{-33, 21}, {9, -3}}, textString = "QInjPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu")}, coordinateSystem(extent = {{-100, -100}, {100, 100}}, grid = {1, 1}, initialScale = 0.1)));
end ElectricalControlCommon;
