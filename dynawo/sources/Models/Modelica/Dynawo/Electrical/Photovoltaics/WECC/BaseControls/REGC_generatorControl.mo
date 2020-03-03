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


model REGC_generatorControl

  import Modelica.Blocks;
  import Modelica.ComplexMath;
  import Modelica.SIunits;
  import Dynawo.Connectors;
  import Dynawo.Types;
  import Dynawo.Electrical.Photovoltaics.WECC.Utilities;

  parameter SIunits.Time Tg "Emulated delay in converter controls (Cannot be zero, typical: 0.02..0.05, chosen: 0.02)";
  parameter SIunits.Time Tfltr "Filter time constant of terminal voltage(Cannot be set to zero, typical: 0.02..0.05, chosen: 0.02)";
  parameter SIunits.PerUnit Iqrmin "Minimum rate-of-change of reactive current after fault (typical: -999..-1, chosen: -20)";
  parameter SIunits.PerUnit Iqrmax "Maximum rate-of-change of reactive current after fault (typical: 1..999, chosen: 20)";
  parameter SIunits.PerUnit rrpwr "Active power recovery time [pu/s] (typical: 1..20, chosen: 10)";
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false, chosen: false)";

  //Inputs:
  Blocks.Interfaces.RealInput idCmdPu(start = Id0Pu) "Setpoint id in pu from electrical control, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-168, -74}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-162, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "Setpoint iq in pu from electrical control, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {-168, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-162, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput UPu(start = U0Pu) "Inverter terminal voltage magnitude in pu" annotation(
    Placement(visible = true, transformation(origin = {-168, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-162, 136}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Outputs:
  Blocks.Interfaces.RealOutput iqRef(start = -Iq0Pu) "Setpoint iq in pu to injector, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {158, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {168, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealOutput idRef(start = Id0Pu) "Setpoint id in pu to injector, injector convention, pu base SNom" annotation(
    Placement(visible = true, transformation(origin = {158, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {167, -69}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Blocks.Interfaces.BooleanInput FRTon "Boolean signal, if FRT detected then true else false, for current ramp on iq after fault" annotation(
    Placement(visible = true, transformation(origin = {-168, 126}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-162, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Blocks
  Blocks.Sources.BooleanConstant RateFlag_const(k = RateFlag)  annotation(
    Placement(visible = true, transformation(origin = {-36, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.FirstOrder UPu_filt(T = Tfltr, initType = Modelica.Blocks.Types.Init.NoInit, k = 1, y(fixed = true, start = U0Pu), y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-102, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch VDependencySwitch annotation(
    Placement(visible = true, transformation(origin = {4, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Unom_fix1(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-36, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Product Pcmd annotation(
    Placement(visible = true, transformation(origin = {-102, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Division IdrefPu annotation(
    Placement(visible = true, transformation(origin = {114, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain IqrefPu(k = -1) annotation(
    Placement(visible = true, transformation(origin = {62, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter UPu_NonZero(limitsAtInit = true, uMax = 999, uMin = 0.01)  annotation(
    Placement(visible = true, transformation(origin = {-66, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.RateLimFirstOrder_freeze Iqcmd_Filt(T = Tg, initType = Modelica.Blocks.Types.Init.SteadyState, use_rateLim = true)  annotation(
    Placement(visible = true, transformation(origin = {4, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Iqrmax_const(k = Iqrmax) annotation(
    Placement(visible = true, transformation(origin = {-116, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant Iqrmin_const(k = Iqrmin) annotation(
    Placement(visible = true, transformation(origin = {-116, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Utilities.RateLimFirstOrder_freeze Pcmd_Filt(T = Tg, initType = Modelica.Blocks.Types.Init.NoInit, k = 1, use_rateLim = true, y(start = P0Pu), y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {74, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant rrpwr_pos_const(k = rrpwr) annotation(
    Placement(visible = true, transformation(origin = {44, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Sources.Constant rrpwr_neg_const(k = -rrpwr) annotation(
    Placement(visible = true, transformation(origin = {44, -92}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Logical.Switch switchIqmax annotation(
    Placement(visible = true, transformation(origin = {-48, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Logical.Switch switchIqmin annotation(
    Placement(visible = true, transformation(origin = {-48, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Sources.Constant constMaxFix(k = 9999)  annotation(
    Placement(visible = true, transformation(origin = {-90, 68}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Blocks.Sources.Constant constMinFix(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-90, 18}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Utilities.FallingEdge_delay fallingEdge(delayTime = max(abs(1/Iqrmax),abs(1/Iqrmin)))  annotation(
    Placement(visible = true, transformation(origin = {-98, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu U0Pu "Initial value of measured voltage amplitude at injector terminal in p.u";
  parameter Types.CurrentModulePu Id0Pu "Initial value of d-component current at injector terminal in p.u, injector convention, base SNom";
  parameter Types.CurrentModulePu Iq0Pu "Initial value of q-component current at injector terminal in p.u, injector convention, base SNom";
  parameter SIunits.PerUnit P0Pu "Initial value terminal active power, injector convention, base SNom";

equation

  connect(fallingEdge.y, switchIqmin.u2) annotation(
    Line(points = {{-86, 126}, {-74, 126}, {-74, 26}, {-60, 26}, {-60, 26}}, color = {255, 0, 255}));
  connect(fallingEdge.y, switchIqmax.u2) annotation(
    Line(points = {{-86, 126}, {-74, 126}, {-74, 76}, {-60, 76}, {-60, 76}}, color = {255, 0, 255}));
  connect(FRTon, fallingEdge.u) annotation(
    Line(points = {{-168, 126}, {-114, 126}, {-114, 126}, {-112, 126}}, color = {255, 0, 255}));
  connect(idCmdPu, Pcmd.u1) annotation(
    Line(points = {{-168, -74}, {-114, -74}}, color = {0, 0, 127}));
  connect(UPu, UPu_filt.u) annotation(
    Line(points = {{-168, -30}, {-114, -30}}, color = {0, 0, 127}));
  connect(iqCmdPu, Iqcmd_Filt.u) annotation(
    Line(points = {{-168, 50}, {-8, 50}}, color = {0, 0, 127}));
  connect(constMinFix.y, switchIqmin.u3) annotation(
    Line(points = {{-83, 18}, {-60, 18}}, color = {0, 0, 127}));
  connect(constMaxFix.y, switchIqmax.u3) annotation(
    Line(points = {{-83, 68}, {-60, 68}}, color = {0, 0, 127}));
  connect(switchIqmin.y, Iqcmd_Filt.dy_min) annotation(
    Line(points = {{-36, 26}, {-26, 26}, {-26, 44}, {-8, 44}, {-8, 44}}, color = {0, 0, 127}));
  connect(Iqrmin_const.y, switchIqmin.u1) annotation(
    Line(points = {{-105, 34}, {-60, 34}}, color = {0, 0, 127}));
  connect(Iqrmax_const.y, switchIqmax.u1) annotation(
    Line(points = {{-105, 84}, {-60, 84}}, color = {0, 0, 127}));
  connect(switchIqmax.y, Iqcmd_Filt.dy_max) annotation(
    Line(points = {{-36, 76}, {-26, 76}, {-26, 58}, {-8, 58}, {-8, 56}}, color = {0, 0, 127}));
  connect(Iqcmd_Filt.y, IqrefPu.u) annotation(
    Line(points = {{15, 50}, {49, 50}}, color = {0, 0, 127}));
  connect(IqrefPu.y, iqRef) annotation(
    Line(points = {{73, 50}, {158, 50}}, color = {0, 0, 127}));
  connect(rrpwr_neg_const.y, Pcmd_Filt.dy_min) annotation(
    Line(points = {{53, -92}, {56, -92}, {56, -86}, {62, -86}}, color = {0, 0, 127}));
  connect(rrpwr_pos_const.y, Pcmd_Filt.dy_max) annotation(
    Line(points = {{52, -64}, {56, -64}, {56, -74}, {62, -74}, {62, -74}}, color = {0, 0, 127}));
  connect(Pcmd.y, Pcmd_Filt.u) annotation(
    Line(points = {{-90, -80}, {62, -80}}, color = {0, 0, 127}));
  connect(Pcmd_Filt.y, IdrefPu.u1) annotation(
    Line(points = {{85, -80}, {102, -80}}, color = {0, 0, 127}));
  connect(RateFlag_const.y, VDependencySwitch.u2) annotation(
    Line(points = {{-25, -14}, {-20, -14}, {-20, -38}, {-8, -38}}, color = {255, 0, 255}));
  connect(VDependencySwitch.y, IdrefPu.u2) annotation(
    Line(points = {{15, -38}, {26, -38}, {26, -106}, {88, -106}, {88, -92}, {102, -92}}, color = {0, 0, 127}));
  connect(IdrefPu.y, idRef) annotation(
    Line(points = {{125, -86}, {158, -86}}, color = {0, 0, 127}));
  connect(VDependencySwitch.y, Pcmd.u2) annotation(
    Line(points = {{15, -38}, {24, -38}, {24, -106}, {-122, -106}, {-122, -87}, {-114, -87}, {-114, -86}}, color = {0, 0, 127}));
  connect(Unom_fix1.y, VDependencySwitch.u3) annotation(
    Line(points = {{-25, -46}, {-8, -46}}, color = {0, 0, 127}));
  connect(UPu_NonZero.y, VDependencySwitch.u1) annotation(
    Line(points = {{-54, -30}, {-8, -30}}, color = {0, 0, 127}));
  connect(UPu_filt.y, UPu_NonZero.u) annotation(
    Line(points = {{-90, -30}, {-78, -30}, {-78, -30}, {-78, -30}}, color = {0, 0, 127}));

  annotation(
Documentation(info="<html>

<p> The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current (or active power if RampFlag is true).


</ul> </p></html>"),
    Icon(coordinateSystem(initialScale = 0.2, extent = {{-150, -130}, {150, 180}}), graphics = {Rectangle(origin = {0, 25}, extent = {{-150, 155}, {150, -155}}), Text(origin = {14, 14}, extent = {{-122, 96}, {88, -70}}, textString = "Gen \n Ctrl")}),
    Diagram(coordinateSystem(initialScale = 0.2, extent = {{-150, -130}, {150, 180}}), graphics = {Text(origin = {52, 36}, extent = {{-22, 8}, {38, -32}}, textString = "Reactive power convention:
 negative reactive current refers to
  reactive power injection (posititve)")}),
    __OpenModelica_commandLineOptions = "");

end REGC_generatorControl;
