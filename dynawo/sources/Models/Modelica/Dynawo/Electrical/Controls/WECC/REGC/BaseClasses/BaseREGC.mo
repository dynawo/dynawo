within Dynawo.Electrical.Controls.WECC.REGC.BaseClasses;

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

partial model BaseREGC "Base class for WECC Generator Converter REGC"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREGC;

  // Input variables
  Modelica.Blocks.Interfaces.BooleanInput frtOn(start = false) "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise" annotation(
    Placement(visible = true, transformation(origin = {-211, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -10}, {-100, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idCmdPu(start = Id0Pu) "idCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Inverter terminal voltage magnitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -111}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));

  Modelica.Blocks.Sources.Constant constant3(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant4(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-79, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(UseRateLim = true) annotation(
    Placement(visible = true, transformation(origin = {10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant5(k = IqrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant6(k = IqrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-79, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {-41, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrNeg0(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(UseRateLim = true) annotation(
    Placement(visible = true, transformation(origin = {60, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilterGC, k = 1, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrPos0(k = RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {10, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay offDelay(tDelay = max(abs(1 / IqrMaxPu), abs(1 / IqrMinPu))) annotation(
    Placement(visible = true, transformation(origin = {-180, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.And and1(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant QInj0PuPos(k = QInj0Pu > 0)  annotation(
    Placement(visible = true, transformation(origin = {-180, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.And and2(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant Qinj0PuNeg(k = QInj0Pu < 0)  annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Dynawo.Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Dynawo.Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Dynawo.Types.VoltageModulePu UInj0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";

equation
  connect(switch3.y, rateLimFirstOrderFreeze2.dyMin) annotation(
    Line(points = {{-29, 60}, {-20, 60}, {-20, 94}, {-2, 94}}, color = {0, 0, 127}));
  connect(constant6.y, switch3.u1) annotation(
    Line(points = {{-68, 80}, {-60.5, 80}, {-60.5, 68}, {-52, 68}}, color = {0, 0, 127}));
  connect(constant5.y, switch4.u1) annotation(
    Line(points = {{-69, 160}, {-60.5, 160}, {-60.5, 148}, {-53, 148}}, color = {0, 0, 127}));
  connect(constant4.y, switch4.u3) annotation(
    Line(points = {{-68, 120}, {-60, 120}, {-60, 132}, {-53, 132}}, color = {0, 0, 127}));
  connect(constant3.y, switch3.u3) annotation(
    Line(points = {{-69, 40}, {-60, 40}, {-60, 52}, {-52, 52}}, color = {0, 0, 127}));
  connect(switch4.y, rateLimFirstOrderFreeze2.dyMax) annotation(
    Line(points = {{-30, 140}, {-20, 140}, {-20, 107}, {-2, 107}}, color = {0, 0, 127}));
  connect(iqCmdPu, rateLimFirstOrderFreeze2.u) annotation(
    Line(points = {{-210, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(RrpwrNeg0.y, rateLimFirstOrderFreeze1.dyMin) annotation(
    Line(points = {{21, -140}, {40.5, -140}, {40.5, -126}, {48, -126}}, color = {0, 0, 127}));
  connect(firstOrder.u, UPu) annotation(
    Line(points = {{-162, -40}, {-210, -40}}, color = {0, 0, 127}));
  connect(RrpwrPos0.y, rateLimFirstOrderFreeze1.dyMax) annotation(
    Line(points = {{21, -100}, {40.5, -100}, {40.5, -113}, {48, -113}}, color = {0, 0, 127}));
  connect(frtOn, offDelay.u) annotation(
    Line(points = {{-211, 80}, {-194, 80}}, color = {255, 0, 255}));
  connect(and1.y, switch4.u2) annotation(
    Line(points = {{-98.5, 140}, {-53, 140}}, color = {255, 0, 255}));
  connect(and2.y, switch3.u2) annotation(
    Line(points = {{-98.5, 60}, {-52, 60}}, color = {255, 0, 255}));
  connect(QInj0PuPos.y, and1.u[1]) annotation(
    Line(points = {{-169, 160}, {-140, 160}, {-140, 140}, {-120, 140}}, color = {255, 0, 255}));
  connect(offDelay.y, and2.u[1]) annotation(
    Line(points = {{-168, 80}, {-140, 80}, {-140, 60}, {-120, 60}}, color = {255, 0, 255}));
  connect(Qinj0PuNeg.y, and2.u[2]) annotation(
    Line(points = {{-169, 40}, {-140, 40}, {-140, 60}, {-120, 60}}, color = {255, 0, 255}));
  connect(offDelay.y, and1.u[2]) annotation(
    Line(points = {{-168, 80}, {-140, 80}, {-140, 140}, {-120, 140}}, color = {255, 0, 255}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>

<p> The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current (or active power if RampFlag is true).


</ul> </p></html>"),
    Diagram(coordinateSystem(initialScale = 0.2, extent = {{-200, -180}, {220, 180}}, grid = {1, 1})),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-162, 66}, extent = {{-22, 16}, {36, -28}}, textString = "idCmdPu"), Text(origin = {-164, -50}, extent = {{-22, 16}, {36, -28}}, textString = "iqCmdPu"), Text(origin = {-93, -116}, extent = {{25, 10}, {-25, -10}}, textString = "UPu"), Text(origin = {-166, 7}, extent = {{-22, 16}, {36, -28}}, textString = "frtOn")}));
end BaseREGC;
