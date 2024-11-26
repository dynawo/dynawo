within Dynawo.Electrical.Controls.WECC.REGC;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
*/

model REGCa "WECC Generator Converter REGC type A"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREGC;

  // REGC-A parameters
  parameter Boolean Lvplsw(start=false) "Low voltage power logic switch: 1-enabled/0-disabled" annotation(
  Dialog(tab="Generator Converter"));
  parameter Types.PerUnit zerox(start=0.0) "LVPL zero crossing in pu" annotation(
    Dialog(tab="Generator Converter"));
  parameter Types.PerUnit brkpt(start=1.0) "LVPL breakpoint in pu" annotation(
    Dialog(tab="Generator Converter"));
  parameter Types.PerUnit lvpl1(start=1.0) "LVPL gain breakpoint in pu" annotation(
  Dialog(tab="Generator Converter"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput idCmdPu(start = Id0Pu) "idCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qgen0(start = UInj0Pu) "Reactive power setpoint in pu (base Inverter)" annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 109}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Inverter terminal voltage magnitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) "idRefPu setpoint to injector in pu (generator convention) (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "iqRefPu setpoint to injector in pu (generator convention) (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {160, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold annotation(
    Placement(visible = true, transformation(origin = {-160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant4(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(T = tG, UseRateLim = true, Y0 = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant5(k = IqrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant6(k = IqrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {10, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-39.5, -150.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-80.5, -79.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Lvplsw) annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrNeg0(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = tG, UseRateLim = true, Y0 = Id0Pu*UInj0Pu, k = 1) annotation(
    Placement(visible = true, transformation(origin = {-60, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrPos0(k = RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilterGC, k = 1, y(start = UInj0Pu), y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.LowVoltagePowerLogic lowVoltagePowerLogic(brkpt = brkpt, lvpl1 = lvpl1, zerox = zerox) annotation(
    Placement(visible = true, transformation(origin = {-80, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Dynawo.Types.VoltageModulePu UInj0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Dynawo.Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Dynawo.Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in pu (generator convention) (base SNom, UNom)";

equation
  connect(switch3.y, rateLimFirstOrderFreeze2.dyMin) annotation(
    Line(points = {{-29, 20}, {-20, 20}, {-20, 54}, {-2, 54}}, color = {0, 0, 127}));
  connect(constant6.y, switch3.u1) annotation(
    Line(points = {{-69, 40}, {-60.5, 40}, {-60.5, 28}, {-52, 28}, {-52, 28}}, color = {0, 0, 127}));
  connect(constant5.y, switch4.u1) annotation(
    Line(points = {{-69, 120}, {-59.5, 120}, {-59.5, 108}, {-52, 108}}, color = {0, 0, 127}));
  connect(constant4.y, switch4.u3) annotation(
    Line(points = {{-69, 80}, {-60, 80}, {-60, 92}, {-52, 92}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.y, gain1.u) annotation(
    Line(points = {{21, 60}, {38, 60}}, color = {0, 0, 127}));
  connect(constant3.y, switch3.u3) annotation(
    Line(points = {{-69, 0}, {-60, 0}, {-60, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(switch4.y, rateLimFirstOrderFreeze2.dyMax) annotation(
    Line(points = {{-29, 100}, {-20, 100}, {-20, 67}, {-2, 67}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, switch4.u2) annotation(
    Line(points = {{-149, 100}, {-52, 100}}, color = {255, 0, 255}));
  connect(not1.y, switch3.u2) annotation(
    Line(points = {{-99, 20}, {-52, 20}}, color = {255, 0, 255}));
  connect(greaterThreshold.y, not1.u) annotation(
    Line(points = {{-149, 100}, {-149, 99.9688}, {-140, 99.9688}, {-140, 19.75}, {-121, 19.75}, {-121, 19.5}, {-122, 19.5}, {-122, 20}}, color = {255, 0, 255}));
  connect(iqCmdPu, rateLimFirstOrderFreeze2.u) annotation(
    Line(points = {{-190, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(constant1.y, variableLimiter.limit2) annotation(
    Line(points = {{-27.95, -150.5}, {-27.95, -150.25}, {-19.95, -150.25}, {-19.95, -127.625}, {-2.95, -127.625}, {-2.95, -127.328}, {-1.95, -127.328}, {-1.95, -128}}, color = {0, 0, 127}));
  connect(Qgen0, greaterThreshold.u) annotation(
    Line(points = {{-190, 100}, {-172, 100}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{-99, -60}, {-52, -60}}, color = {255, 0, 255}));
  connect(RrpwrPos0.y, rateLimFirstOrderFreeze1.dyMax) annotation(
    Line(points = {{-99, -100}, {-79.5, -100}, {-79.5, -113}, {-72, -113}}, color = {0, 0, 127}));
  connect(RrpwrNeg0.y, rateLimFirstOrderFreeze1.dyMin) annotation(
    Line(points = {{-99, -140}, {-79.5, -140}, {-79.5, -126}, {-72, -126}}, color = {0, 0, 127}));
  connect(idCmdPu, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-190, -120}, {-72, -120}}, color = {0, 0, 127}));
  connect(switch1.y, variableLimiter.limit1) annotation(
    Line(points = {{-29, -60}, {-19.5, -60}, {-19.5, -112}, {-2, -112}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u3) annotation(
    Line(points = {{-69, -79.5}, {-60.125, -79.5}, {-60.125, -68.5}, {-52.25, -68.5}}, color = {0, 0, 127}));
  connect(firstOrder.u, UPu) annotation(
    Line(points = {{-162, -30}, {-190, -30}}, color = {0, 0, 127}));
  connect(firstOrder.y, lowVoltagePowerLogic.UPu) annotation(
    Line(points = {{-139, -30}, {-92, -30}}, color = {0, 0, 127}));
  connect(lowVoltagePowerLogic.LVPL, switch1.u1) annotation(
    Line(points = {{-68, -30}, {-60.3, -30}, {-60.3, -52}, {-52.2, -52}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, variableLimiter.u) annotation(
    Line(points = {{-49, -120}, {-2, -120}}, color = {0, 0, 127}));
  connect(gain1.y, iqRefPu) annotation(
    Line(points = {{61, 60}, {160, 60}}, color = {0, 0, 127}));
  connect(variableLimiter.y, idRefPu) annotation(
    Line(points = {{21, -120}, {160, -120}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>

<p> The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current (or active power if RampFlag is true).


</ul> </p></html>"),
    Diagram(coordinateSystem(initialScale = 0.2, extent = {{-180, -180}, {150, 150}}, grid = {1, 1}),graphics = {Rectangle(origin = {100, 60}, extent = {{-30, 40}, {30, -40}}), Text(origin = {100, 57}, extent = {{-28, 27}, {28, -26}}, textString = "high voltage
reactive current
management"), Rectangle(origin = {100, -120}, extent = {{-30, 40}, {30, -40}}), Text(origin = {99, -124.5}, extent = {{-25, 23}, {25, -22}}, textString = "low voltage
active current
management")}),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-25, 20}, extent = {{-53, 60}, {107, -100}}, textString = "REGC A"), Text(origin = {134, -42}, extent = {{-22, 16}, {36, -28}}, textString = "idRefPu"), Text(origin = {134, 62}, extent = {{-22, 16}, {36, -32}}, textString = "iqRefPu"), Text(origin = {-138, 82}, extent = {{-22, 16}, {36, -28}}, textString = "idCmdPu"), Text(origin = {-138, -38}, extent = {{-22, 16}, {36, -28}}, textString = "iqCmdPu"), Text(origin = {-33, -108}, extent = {{25, 10}, {-25, -10}}, textString = "UPu"), Text(origin = {-5, 123}, extent = {{43, -9}, {-43, 9}}, textString = "Qgen0")}));
end REGCa;
