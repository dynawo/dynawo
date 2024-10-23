within Dynawo.Electrical.Controls.WECC.REGC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model REGCa "WECC Generator Converter REGC type A"
  extends Dynawo.Electrical.Controls.WECC.REGC.BaseClasses.BaseREGC(rateLimFirstOrderFreeze2.T = tG, rateLimFirstOrderFreeze2.UseRateLim = true, rateLimFirstOrderFreeze2.Y0 = Iq0Pu, rateLimFirstOrderFreeze1.T = tG, rateLimFirstOrderFreeze1.UseRateLim = true, rateLimFirstOrderFreeze1.Y0 = Id0Pu);

  // REGC-A parameters
  parameter Boolean Lvplsw(start = false) "Low voltage power logic switch: 1-enabled/0-disabled" annotation(
    Dialog(tab = "Generator Converter"));
  parameter Types.PerUnit zerox(start = 0.0) "LVPL zero crossing in pu (base UNom)" annotation(
    Dialog(tab = "Generator Converter"));
  parameter Types.PerUnit brkpt(start = 1.0) "LVPL breakpoint in pu (base UNom)" annotation(
    Dialog(tab = "Generator Converter"));
  parameter Types.PerUnit lvpl1(start = 1.0) "LVPL gain breakpoint in pu" annotation(
    Dialog(tab = "Generator Converter"));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) "idRefPu setpoint to injector in pu (generator convention) (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {230, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "iqRefPu setpoint to injector in pu (generator convention) (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {230, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, 43}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {120, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {69.5, -160.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-80.5, -89.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Lvplsw) annotation(
    Placement(visible = true, transformation(origin = {-109, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.LowVoltagePowerLogic lowVoltagePowerLogic(brkpt = brkpt, lvpl1 = lvpl1, zerox = zerox) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{-98, -60}, {-2, -60}}, color = {255, 0, 255}));
  connect(switch1.y, variableLimiter.limit1) annotation(
    Line(points = {{21, -60}, {100.5, -60}, {100.5, -112}, {108, -112}}, color = {0, 0, 127}));
  connect(constant2.y, switch1.u3) annotation(
    Line(points = {{-68.95, -89.5}, {-60.075, -89.5}, {-60.075, -68}, {-1.95, -68}}, color = {0, 0, 127}));
  connect(lowVoltagePowerLogic.LVPL, switch1.u1) annotation(
    Line(points = {{-68, -40}, {-60.3, -40}, {-60.3, -52}, {-2, -52}}, color = {0, 0, 127}));
  connect(variableLimiter.y, idRefPu) annotation(
    Line(points = {{131, -120}, {230, -120}}, color = {0, 0, 127}));
  connect(constant1.y, variableLimiter.limit2) annotation(
    Line(points = {{81, -160}, {100, -160}, {100, -128}, {108, -128}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, variableLimiter.u) annotation(
    Line(points = {{71, -120}, {108, -120}}, color = {0, 0, 127}));
  connect(firstOrder.y, lowVoltagePowerLogic.UPu) annotation(
    Line(points = {{-139, -40}, {-92, -40}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.y, gain1.u) annotation(
    Line(points = {{21, 100}, {38, 100}}, color = {0, 0, 127}));
  connect(gain1.y, iqRefPu) annotation(
    Line(points = {{61, 100}, {230, 100}}, color = {0, 0, 127}));
  connect(idCmdPu, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-210, -120}, {48, -120}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current.


 </p></body></html>"),
    Diagram(graphics = {Rectangle(origin = {170, 100}, extent = {{-30, 40}, {30, -40}}), Text(origin = {169, 96}, extent = {{-28, 27}, {28, -26}}, textString = "high voltage
reactive current
management"), Rectangle(origin = {170, -120}, extent = {{-30, 40}, {30, -40}}), Text(origin = {171, -122.5}, extent = {{-25, 23}, {25, -22}}, textString = "low voltage
active current
management")}, coordinateSystem( extent = {{-200, -180}, {220, 180}}, grid = {1, 1}, initialScale = 0.2)),
    Icon(graphics = {Text(origin = {-25, 20}, extent = {{-53, 60}, {107, -100}}, textString = "REGC A"), Text(origin = {142, -52}, extent = {{-22, 16}, {36, -28}}, textString = "idRefPu"), Text(origin = {145, 52}, extent = {{-22, 16}, {36, -32}}, textString = "iqRefPu")}));
end REGCa;
