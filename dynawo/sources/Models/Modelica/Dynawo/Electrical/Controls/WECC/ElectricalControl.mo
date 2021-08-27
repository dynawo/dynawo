within Dynawo.Electrical.Controls.WECC;

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

model ElectricalControl "WECC PV Electrical Control REEC"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
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
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Voltage magnitude at injector terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput idCmdPu(start = Id0Pu) "idCmdPu setpoint for generator control in p.u (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {510, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint for generator control in p.u (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {510, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UFilteredPu(start = UInj0Pu) "Filtered voltage module at injector terminal in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput frtOn(start = false) "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise " annotation(
    Placement(visible = true, transformation(origin = {-200, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.BooleanConstant QFlag0(k = QFlag) annotation(
    Placement(visible = true, transformation(origin = {220, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant VFlag0(k = VFlag) annotation(
    Placement(visible = true, transformation(origin = {-40, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PfFlag0(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = VMaxPu, uMin = VMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
<<<<<<< HEAD
  Modelica.Blocks.Math.Division division annotation(
=======
  Modelica.Blocks.Math.Division IqCmd annotation(
>>>>>>> #672 Coding style
    Placement(visible = true, transformation(origin = {90, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tRv, k = 1, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vref(k = if VRef0Pu < 0.5 then UInj0Pu else VRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = Dbd2, uMin = Dbd1) annotation(
    Placement(visible = true, transformation(origin = {180, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {220, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(visible = true, transformation(origin = {280, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
<<<<<<< HEAD
  Modelica.Blocks.Math.Add add1(k1 = +1, k2 = +1) annotation(
=======
  Modelica.Blocks.Math.Add IqCmd_sum(k1 = +1, k2 = +1) annotation(
>>>>>>> #672 Coding style
    Placement(visible = true, transformation(origin = {330, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {10, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tP, y_start = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PfaRef(k = tan(acos(PF0))) annotation(
    Placement(visible = true, transformation(origin = {-230, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(uMax = QMaxPu, uMin = QMinPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {280, -27}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {90, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(Ti = Kqp / Kqi, K = Kqp, Xi0 = UInj0Pu / Kvp, YMax = VMaxPu, YMin = VMinPu, Y0 = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageCheck voltageCheck(UMinPu = UMinPu, UMaxPu = UMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimPIDFreeze varLimPIDFreeze(Ti = Kvp / Kvi, K = Kvp, Xi0 = QInj0Pu / UInj0Pu / Kqp, Y0 = QInj0Pu / UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {180, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
<<<<<<< HEAD
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculation currentLimitsCalculation1(IMaxPu = IMaxPu, PPriority = PPriority) annotation(
    Placement(visible = true, transformation(origin = {410, 29}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
=======
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculation currentLimitsCalculation1(IMax = IMax, PPriority = PPriority) annotation(
    Placement(visible = true, transformation(origin = {410, 29}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter IqCmd_lim annotation(
>>>>>>> #672 Coding style
    Placement(visible = true, transformation(origin = {410, -21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {410, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tPord, k = 1, UseFreeze = true, UseRateLim = true, Y0 = PInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant DPMax0(k = DPMax) annotation(
    Placement(visible = true, transformation(origin = {-40, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant DPMin0(k = DPMin) annotation(
    Placement(visible = true, transformation(origin = {-40, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 0.01, k = 1, y_start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {450, 9}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 0.01, k = 1, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {450, 49}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
<<<<<<< HEAD
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = Tiq, k = 1, UseFreeze = true, UseRateLim = false, Y0 = QInj0Pu / UInj0Pu) annotation(
=======
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze IqCmd_Filt(T = Tiq, k = 1, use_freeze = true, use_rateLim = false, y_start = QInj0Pu / UInj0Pu) annotation(
>>>>>>> #672 Coding style
    Placement(visible = true, transformation(origin = {130, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn(y = frtOn)  annotation(
    Placement(visible = true, transformation(origin = {124, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn1(y = frtOn)  annotation(
    Placement(visible = true, transformation(origin = {163, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn2(y = frtOn)  annotation(
    Placement(visible = true, transformation(origin = {4, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.BooleanExpression FRTOn3(y = frtOn)  annotation(
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
<<<<<<< HEAD
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculation1.iqMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {130, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculation1.iqMinPu)  annotation(
=======
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculation1.IqMax)  annotation(
    Placement(visible = true, transformation(origin = {130, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculation1.IqMin)  annotation(
>>>>>>> #672 Coding style
    Placement(visible = true, transformation(origin = {130, -33}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu1(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {-20, 67}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu2(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {-20, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu3(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {190, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.RealExpression UFilteredPu4(y = UFilteredPu)  annotation(
    Placement(visible = true, transformation(origin = {50, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {50, 73}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.0001)  annotation(
    Placement(visible = true, transformation(origin = {-20, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0.0001) annotation(
    Placement(visible = true, transformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in p.u (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in p.u (generator convention) (base SNom)";
  parameter Types.PerUnit UInj0Pu "Start value of voltage magnitude at injector terminal in p.u (base UNom)";
  parameter Types.PerUnit PF0 "Start value of powerfactor";
  parameter Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in p.u (generator convention) (base SNom, UNom)";
  parameter Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in p.u (generator convention) (base SNom, UNom)";

equation
<<<<<<< HEAD
  connect(variableLimiter.y, iqCmdPu) annotation(
=======
  connect(IqCmd_lim.y, iqCmdPu) annotation(
>>>>>>> #672 Coding style
    Line(points = {{421, -21}, {510, -21}}, color = {0, 0, 127}));
  connect(varLimPIDFreeze.y, switch2.u1) annotation(
    Line(points = {{191, -19}, {268, -19}}, color = {0, 0, 127}));
  connect(limiter.y, varLimPIDFreeze.u_s) annotation(
    Line(points = {{101, -19}, {168, -19}}, color = {0, 0, 127}));
  connect(limiter2.y, limPIDFreeze.u_s) annotation(
    Line(points = {{-69, 20}, {-52, 20}}, color = {0, 0, 127}));
  connect(QInjPu, limPIDFreeze.u_m) annotation(
    Line(points = {{-270, 110}, {-40, 110}, {-40, 32}}, color = {0, 0, 127}));
  connect(switch.y, limiter.u) annotation(
    Line(points = {{21, -19}, {78, -19}}, color = {0, 0, 127}));
  connect(VFlag0.y, switch.u2) annotation(
    Line(points = {{-29, -19}, {-2, -19}}, color = {255, 0, 255}));
  connect(PInjPu, firstOrder1.u) annotation(
    Line(points = {{-270, 80}, {-242, 80}}, color = {0, 0, 127}));
  connect(switch1.y, limiter2.u) annotation(
    Line(points = {{-109, 20}, {-92, 20}}, color = {0, 0, 127}));
  connect(PfFlag0.y, switch1.u2) annotation(
    Line(points = {{-179, 20}, {-132, 20}}, color = {255, 0, 255}));
<<<<<<< HEAD
  connect(rateLimFirstOrderFreeze1.y, switch2.u3) annotation(
    Line(points = {{141, -76}, {260, -76}, {260, -35}, {268, -35}}, color = {0, 0, 127}));
  connect(division.y, rateLimFirstOrderFreeze1.u) annotation(
=======
  connect(IqCmd_Filt.y, Qflagswitch.u3) annotation(
    Line(points = {{141, -76}, {260, -76}, {260, -35}, {268, -35}}, color = {0, 0, 127}));
  connect(IqCmd.y, IqCmd_Filt.u) annotation(
>>>>>>> #672 Coding style
    Line(points = {{101, -76}, {118, -76}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, idCmdPu) annotation(
    Line(points = {{421, 79}, {510, 79}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{101, 79}, {398, 79}}, color = {0, 0, 127}));
<<<<<<< HEAD
  connect(add1.y, variableLimiter.u) annotation(
    Line(points = {{341, -21}, {398, -21}}, color = {0, 0, 127}));
  connect(switch2.y, add1.u2) annotation(
    Line(points = {{291, -27}, {318, -27}}, color = {0, 0, 127}));
  connect(limiter1.y, add1.u1) annotation(
=======
  connect(IqCmd_sum.y, IqCmd_lim.u) annotation(
    Line(points = {{341, -21}, {398, -21}}, color = {0, 0, 127}));
  connect(Qflagswitch.y, IqCmd_sum.u2) annotation(
    Line(points = {{291, -27}, {318, -27}}, color = {0, 0, 127}));
  connect(Iq_FRT_lim.y, IqCmd_sum.u1) annotation(
>>>>>>> #672 Coding style
    Line(points = {{291, 30}, {300, 30}, {300, -15}, {318, -15}}, color = {0, 0, 127}));
  connect(PInjRefPu, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-270, 190}, {-2, 190}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, limiter3.u) annotation(
    Line(points = {{21, 190}, {38, 190}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{231, 30}, {268, 30}}, color = {0, 0, 127}));
  connect(deadZone.y, gain.u) annotation(
    Line(points = {{191, 30}, {208, 30}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{141, 30}, {168, 30}}, color = {0, 0, 127}));
  connect(UPu, firstOrder.u) annotation(
    Line(points = {{-270, -70}, {-242, -70}}, color = {0, 0, 127}));
  connect(Vref.y, add.u1) annotation(
    Line(points = {{21, 36}, {118, 36}}, color = {0, 0, 127}));
<<<<<<< HEAD
  connect(currentLimitsCalculation1.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{399, 31}, {360, 31}, {360, 87}, {398, 87}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{399, 27}, {360, 27}, {360, -29}, {398, -29}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{399, 23}, {380, 23}, {380, -13}, {398, -13}}, color = {0, 0, 127}));
  connect(firstOrder3.y, currentLimitsCalculation1.ipCmdPu) annotation(
    Line(points = {{439, 49}, {430, 49}, {430, 33}, {421, 33}}, color = {0, 0, 127}));
  connect(firstOrder2.y, currentLimitsCalculation1.iqCmdPu) annotation(
    Line(points = {{439, 9}, {430, 9}, {430, 25}, {421, 25}}, color = {0, 0, 127}));
  connect(variableLimiter.y, firstOrder2.u) annotation(
    Line(points = {{421, -21}, {480, -21}, {480, 9}, {462, 9}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, variableLimiter1.limit2) annotation(
=======
  connect(currentLimitsCalculation1.IpMax, Idcmd_lim.limit1) annotation(
    Line(points = {{399, 31}, {360, 31}, {360, 87}, {398, 87}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.IqMin, IqCmd_lim.limit2) annotation(
    Line(points = {{399, 27}, {360, 27}, {360, -29}, {398, -29}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.IqMax, IqCmd_lim.limit1) annotation(
    Line(points = {{399, 23}, {380, 23}, {380, -13}, {398, -13}}, color = {0, 0, 127}));
  connect(Id_delay.y, currentLimitsCalculation1.IpCmd) annotation(
    Line(points = {{439, 49}, {430, 49}, {430, 33}, {421, 33}}, color = {0, 0, 127}));
  connect(Iq_delay.y, currentLimitsCalculation1.IqCmd) annotation(
    Line(points = {{439, 9}, {430, 9}, {430, 25}, {421, 25}}, color = {0, 0, 127}));
  connect(IqCmd_lim.y, Iq_delay.u) annotation(
    Line(points = {{421, -21}, {480, -21}, {480, 9}, {462, 9}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.IpMin, Idcmd_lim.limit2) annotation(
>>>>>>> #672 Coding style
    Line(points = {{399, 35}, {380, 35}, {380, 71}, {398, 71}}, color = {0, 0, 127}));
  connect(QFlag0.y, switch2.u2) annotation(
    Line(points = {{231, -40}, {240, -40}, {240, -27}, {268, -27}, {268, -27}}, color = {255, 0, 255}));
<<<<<<< HEAD
  connect(FRTOn.y, rateLimFirstOrderFreeze1.freeze) annotation(
=======
  connect(FRTOn.y, IqCmd_Filt.freeze) annotation(
>>>>>>> #672 Coding style
    Line(points = {{124, -95}, {124, -88}}, color = {255, 0, 255}));
  connect(FRTOn2.y, rateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{4, 171}, {4, 178}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, frtOn) annotation(
    Line(points = {{-219, -40}, {-200, -40}}, color = {255, 0, 255}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{141, -6}, {150, -6}, {150, -13}, {168, -13}, {168, -13}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{141, -33}, {150, -33}, {150, -25}, {168, -25}}, color = {0, 0, 127}));
  connect(UFilteredPu3.y, varLimPIDFreeze.u_m) annotation(
    Line(points = {{190, -49}, {190, -49}, {190, -40}, {180, -40}, {180, -31}, {180, -31}}, color = {0, 0, 127}));
  connect(FRTOn1.y, varLimPIDFreeze.freeze) annotation(
    Line(points = {{163, -49}, {163, -40}, {173, -40}, {173, -31}}, color = {255, 0, 255}));
  connect(UFilteredPu4.y, add.u2) annotation(
    Line(points = {{61, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(firstOrder.y, UFilteredPu) annotation(
    Line(points = {{-219, -70}, {-200, -70}}, color = {0, 0, 127}));
  connect(FRTOn3.y, limPIDFreeze.freeze) annotation(
    Line(points = {{-69, 50}, {-47, 50}, {-47, 32}}, color = {255, 0, 255}));
  connect(variableLimiter1.y, firstOrder3.u) annotation(
    Line(points = {{421, 79}, {480, 79}, {480, 49}, {462, 49}, {462, 49}}, color = {0, 0, 127}));
  connect(limPIDFreeze.y, switch.u1) annotation(
    Line(points = {{-29, 20}, {-20, 20}, {-20, -11}, {-2, -11}, {-2, -11}}, color = {0, 0, 127}));
  connect(switch1.y, switch.u3) annotation(
    Line(points = {{-109, 20}, {-100, 20}, {-100, -40}, {-20, -40}, {-20, -27}, {-2, -27}, {-2, -27}}, color = {0, 0, 127}));
<<<<<<< HEAD
  connect(switch1.y, division.u1) annotation(
=======
  connect(Pfflagswitch.y, IqCmd.u1) annotation(
>>>>>>> #672 Coding style
    Line(points = {{-109, 20}, {-100, 20}, {-100, -70}, {78, -70}, {78, -70}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-179, 60}, {-170, 60}, {-170, 28}, {-132, 28}, {-132, 28}}, color = {0, 0, 127}));
  connect(QInjRefPu, switch1.u3) annotation(
    Line(points = {{-270, -20}, {-170, -20}, {-170, 12}, {-132, 12}}, color = {0, 0, 127}));
  connect(firstOrder1.y, product.u1) annotation(
    Line(points = {{-219, 80}, {-210, 80}, {-210, 66}, {-202, 66}, {-202, 66}}, color = {0, 0, 127}));
  connect(PfaRef.y, product.u2) annotation(
    Line(points = {{-219, 30}, {-210, 30}, {-210, 54}, {-202, 54}, {-202, 54}}, color = {0, 0, 127}));
  connect(limiter3.y, division1.u1) annotation(
    Line(points = {{61, 190}, {70, 190}, {70, 85}, {78, 85}, {78, 85}}, color = {0, 0, 127}));
  connect(DPMin0.y, rateLimFirstOrderFreeze.dyMin) annotation(
    Line(points = {{-29, 160}, {-20, 160}, {-20, 184}, {-1, 184}}, color = {0, 0, 127}));
  connect(DPMax0.y, rateLimFirstOrderFreeze.dyMax) annotation(
    Line(points = {{-29, 220}, {-20, 220}, {-20, 197}, {-1, 197}, {-1, 197}}, color = {0, 0, 127}));
  connect(UPu, voltageCheck.UPu) annotation(
    Line(points = {{-270, -70}, {-250, -70}, {-250, -40}, {-241, -40}, {-241, -40}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{61, 73}, {78, 73}}, color = {0, 0, 127}));
  connect(UFilteredPu1.y, max.u2) annotation(
    Line(points = {{-9, 67}, {38, 67}}, color = {0, 0, 127}));
  connect(constant1.y, max.u1) annotation(
    Line(points = {{-9, 100}, {20, 100}, {20, 79}, {38, 79}}, color = {0, 0, 127}));
<<<<<<< HEAD
  connect(max1.y, division.u2) annotation(
=======
  connect(max1.y, IqCmd.u2) annotation(
>>>>>>> #672 Coding style
    Line(points = {{61, -90}, {70, -90}, {70, -82}, {78, -82}}, color = {0, 0, 127}));
  connect(UFilteredPu2.y, max1.u1) annotation(
    Line(points = {{-9, -84}, {38, -84}}, color = {0, 0, 127}));
  connect(constant2.y, max1.u2) annotation(
    Line(points = {{-9, -110}, {20, -110}, {20, -96}, {38, -96}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the electrical inverter control of the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p> Following control modes can be activated:
<li> local coordinated V/Q control: QFlag = true, VFlag = true </li>
<li> only plant level control active: QFlag = false, VFlag = false</li>
<li> if plant level control not connected: local powerfactor control: PfFlag = true, otherwise PfFlag = false.</li>
<<<<<<< HEAD
<p> The block calculates the idCmdPu and iqCmdPu setpoint values for the generator control based on the selected control algorithm.
=======
<p> The block calculates the Id and Iq setpoint values for the generator control based on the selected control algorithm.


>>>>>>> #672 Coding style
</ul> </p></html>"),
    Diagram(coordinateSystem(extent = {{-260, -130}, {500, 250}}, grid = {1, 1})),
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 22}, extent = {{-57, 58}, {103, -102}}, textString = "Electrical Control"), Text(origin = {137, 79}, extent = {{-23, 13}, {35, -21}}, textString = "idCmdPu"), Text(origin = {139, -41}, extent = {{-23, 13}, {35, -21}}, textString = "iqCmdPu"), Text(origin = {141, 13}, extent = {{-23, 13}, {17, -11}}, textString = "frtOn"), Text(origin = {89, -113}, extent = {{-23, 13}, {9, -3}}, textString = "UPu"), Text(origin = {-19, -117}, extent = {{-33, 21}, {9, -3}}, textString = "QInjPu"), Text(origin = {41, -117}, extent = {{-33, 21}, {9, -3}}, textString = "PInjPu"), Text(origin = {-135, 79}, extent = {{-23, 13}, {35, -21}}, textString = "PInjRefPu"), Text(origin = {-135, -41}, extent = {{-23, 13}, {35, -21}}, textString = "QInjRefPu"), Text(origin = {-135, 21}, extent = {{-23, 13}, {35, -21}}, textString = "UFilteredPu")}, coordinateSystem(initialScale = 0.1)));
end ElectricalControl;
