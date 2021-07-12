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

model GeneratorControl "WECC PV Generator Control REGC"
  import Modelica;
  import Dynawo;

  extends Parameters.Params_GeneratorControl;

  Modelica.Blocks.Interfaces.RealInput idCmdPu(start = Id0Pu) "Id setpoint from electrical control in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "Iq setpoint from electrical control in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Inverter terminal voltage magnitude in pu" annotation(
    Placement(visible = true, transformation(origin = {-160, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) "Id setpoint to injector in p.u (injector convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "Iq setpoint to injector in p.u (injector convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {160, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput FRTon "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise " annotation(
    Placement(visible = true, transformation(origin = {-160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 1.77636e-15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Sources.BooleanConstant RateFlag_const(k = RateFlag)  annotation(
    Placement(visible = true, transformation(origin = {-40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UPu_filt(T = Tfltr, k = 1, y(fixed = true, start = UInj0Pu), y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch VDependencySwitch annotation(
    Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Unom_fix1(k = UInj0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-40, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product Pcmd annotation(
    Placement(visible = true, transformation(origin = {40, -26}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division IdrefPu annotation(
    Placement(visible = true, transformation(origin = {120, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain IqrefPu(k = -1) annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter UPu_NonZero(limitsAtInit = true, uMax = 999, uMin = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-80, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze Iqcmd_Filt(T = Tg, initType = Modelica.Blocks.Types.Init.SteadyState, use_rateLim = true, y_start = Iq0Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Iqrmax_const(k = Iqrmax) annotation(
    Placement(visible = true, transformation(origin = {-80, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Iqrmin_const(k = Iqrmin) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze Pcmd_Filt(T = Tg, k = 1, use_rateLim = true, y_start = Id0Pu*UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant rrpwr_pos_const(k = rrpwr) annotation(
    Placement(visible = true, transformation(origin = {40, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant rrpwr_neg_const(k = -rrpwr) annotation(
    Placement(visible = true, transformation(origin = {40, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchIqmax annotation(
    Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchIqmin annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constMaxFix(k = 9999)  annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constMinFix(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay fallingEdge(delayTime = max(abs(1/Iqrmax),abs(1/Iqrmin)))  annotation(
    Placement(visible = true, transformation(origin = {-120, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage amplitude at injector terminal in p.u";
  parameter Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in p.u (injector convention) (base SNom)";
  parameter Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in p.u (injector convention) (base SNom)";

equation
  connect(FRTon, fallingEdge.u) annotation(
    Line(points = {{-160, 100}, {-134, 100}}, color = {255, 0, 255}));
  connect(UPu, UPu_filt.u) annotation(
    Line(points = {{-160, -70}, {-132, -70}}, color = {0, 0, 127}));
  connect(iqCmdPu, Iqcmd_Filt.u) annotation(
    Line(points = {{-160, 60}, {-12, 60}}, color = {0, 0, 127}));
  connect(switchIqmin.y, Iqcmd_Filt.dy_min) annotation(
    Line(points = {{-29, 20}, {-26, 20}, {-26, 54}, {-11, 54}}, color = {0, 0, 127}));
  connect(switchIqmax.y, Iqcmd_Filt.dy_max) annotation(
    Line(points = {{-29, 100}, {-26, 100}, {-26, 67}, {-11, 67}}, color = {0, 0, 127}));
  connect(Iqcmd_Filt.y, IqrefPu.u) annotation(
    Line(points = {{11, 60}, {28, 60}}, color = {0, 0, 127}));
  connect(IqrefPu.y, iqRefPu) annotation(
    Line(points = {{51, 60}, {160, 60}}, color = {0, 0, 127}));
  connect(Pcmd.y, Pcmd_Filt.u) annotation(
    Line(points = {{51, -26}, {68, -26}}, color = {0, 0, 127}));
  connect(Pcmd_Filt.y, IdrefPu.u1) annotation(
    Line(points = {{91, -26}, {100, -26}, {100, -66}, {108, -66}}, color = {0, 0, 127}));
  connect(VDependencySwitch.y, IdrefPu.u2) annotation(
    Line(points = {{11, -78}, {108, -78}}, color = {0, 0, 127}));
  connect(IdrefPu.y, idRefPu) annotation(
    Line(points = {{131, -72}, {160, -72}}, color = {0, 0, 127}));
  connect(Unom_fix1.y, VDependencySwitch.u3) annotation(
    Line(points = {{-29, -120}, {-16.5, -120}, {-16.5, -86}, {-12, -86}}, color = {0, 0, 127}));
  connect(UPu_NonZero.y, VDependencySwitch.u1) annotation(
    Line(points = {{-69, -70}, {-12, -70}}, color = {0, 0, 127}));
  connect(UPu_filt.y, UPu_NonZero.u) annotation(
    Line(points = {{-109, -70}, {-92, -70}}, color = {0, 0, 127}));
  connect(RateFlag_const.y, VDependencySwitch.u2) annotation(
    Line(points = {{-29, -90}, {-20, -90}, {-20, -78}, {-12, -78}}, color = {255, 0, 255}));
  connect(idCmdPu, Pcmd.u2) annotation(
    Line(points = {{-160, -20}, {28, -20}}, color = {0, 0, 127}));
  connect(VDependencySwitch.y, Pcmd.u1) annotation(
    Line(points = {{11, -78}, {20, -78}, {20, -32}, {28, -32}}, color = {0, 0, 127}));
  connect(rrpwr_neg_const.y, Pcmd_Filt.dy_min) annotation(
    Line(points = {{51, -56}, {60, -56}, {60, -32}, {69, -32}}, color = {0, 0, 127}));
  connect(rrpwr_pos_const.y, Pcmd_Filt.dy_max) annotation(
    Line(points = {{51, 4}, {60, 4}, {60, -19}, {69, -19}}, color = {0, 0, 127}));
  connect(fallingEdge.y, switchIqmax.u2) annotation(
    Line(points = {{-108, 100}, {-52, 100}}, color = {255, 0, 255}));
  connect(fallingEdge.y, switchIqmin.u2) annotation(
    Line(points = {{-108, 100}, {-100, 100}, {-100, 20}, {-52, 20}}, color = {255, 0, 255}));
  connect(Iqrmin_const.y, switchIqmin.u1) annotation(
    Line(points = {{-69, 40}, {-60, 40}, {-60, 28}, {-52, 28}}, color = {0, 0, 127}));
  connect(constMinFix.y, switchIqmin.u3) annotation(
    Line(points = {{-69, 0}, {-60, 0}, {-60, 12}, {-52, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(constMaxFix.y, switchIqmax.u3) annotation(
    Line(points = {{-69, 80}, {-60, 80}, {-60, 92}, {-52, 92}}, color = {0, 0, 127}));
  connect(Iqrmax_const.y, switchIqmax.u1) annotation(
    Line(points = {{-69, 120}, {-60, 120}, {-60, 108}, {-52, 108}, {-52, 108}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
Documentation(info="<html>

<p> The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current (or active power if RampFlag is true).


</ul> </p></html>"),
    Diagram(coordinateSystem(initialScale = 0.2, extent = {{-150, -130}, {150, 150}}, grid = {1, 1}), graphics = {Text(origin = {52, 36}, extent = {{-22, 8}, {38, -32}}, textString = "Reactive power convention:
 negative reactive current refers to
  reactive power injection (posititve)")}),
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-27, 20}, extent = {{-53, 60}, {107, -100}}, textString = "Generator Control"), Text(origin = {134, -42}, extent = {{-22, 16}, {36, -28}}, textString = "idRefPu"), Text(origin = {134, 62}, extent = {{-22, 16}, {36, -32}}, textString = "iqRefPu"), Text(origin = {-28, -117}, extent = {{-18, 15}, {6, -1}}, textString = "UPu"), Text(origin = {-138, 82}, extent = {{-22, 16}, {36, -28}}, textString = "idCmdPu"), Text(origin = {-138, -38}, extent = {{-22, 16}, {36, -28}}, textString = "iqCmdPu"), Text(origin = {-138, 28}, extent = {{-8, 6}, {36, -28}}, textString = "FRTon")}, coordinateSystem(initialScale = 0.1)));

end GeneratorControl;
