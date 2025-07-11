within Dynawo.Electrical.Controls.WECC.REGC;

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

model REGCbCS "WECC Generator/Converter type B with current source interface"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idCmdPu(start = Id0Pu) "idCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) "Inverter terminal voltage magnitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput frtOn(start = false) "Boolean signal for iq ramp after fault: true if FRT detected, false otherwise" annotation(
    Placement(visible = true, transformation(origin = {-160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) "idRefPu setpoint to injector in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {160, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "iqRefPu setpoint to injector in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {160, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.BooleanConstant RateFlag0(k = RateFlag) annotation(
    Placement(visible = true, transformation(origin = {-40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilterGC, y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UNomFix(k = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {40, -26}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {120, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-80, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tG, UseRateLim = true, Y0 = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IqrMaxPu0(k = IqrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IqrMinPu0(k = IqrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = tG, UseRateLim = true, Y0 = Id0Pu * UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrPos0(k = RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {40, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrNeg0(k = -RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {40, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.MathBoolean.OffDelay offDelay(tDelay = max(abs(1 / IqrMaxPu), abs(1 / IqrMinPu))) annotation(
    Placement(visible = true, transformation(origin = {-120, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in pu (generator convention) (base SNom, UNom)";

equation
  connect(frtOn, offDelay.u) annotation(
    Line(points = {{-160, 100}, {-134, 100}}, color = {255, 0, 255}));
  connect(UPu, firstOrder.u) annotation(
    Line(points = {{-160, -70}, {-132, -70}}, color = {0, 0, 127}));
  connect(iqCmdPu, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-160, 60}, {-12, 60}}, color = {0, 0, 127}));
  connect(switch2.y, rateLimFirstOrderFreeze.dyMin) annotation(
    Line(points = {{-29, 20}, {-26, 20}, {-26, 54}, {-11, 54}}, color = {0, 0, 127}));
  connect(switch1.y, rateLimFirstOrderFreeze.dyMax) annotation(
    Line(points = {{-29, 100}, {-26, 100}, {-26, 67}, {-11, 67}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, gain.u) annotation(
    Line(points = {{11, 60}, {28, 60}}, color = {0, 0, 127}));
  connect(gain.y, iqRefPu) annotation(
    Line(points = {{51, 60}, {160, 60}}, color = {0, 0, 127}));
  connect(product.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{51, -26}, {68, -26}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, division.u1) annotation(
    Line(points = {{91, -26}, {100, -26}, {100, -66}, {108, -66}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{11, -78}, {108, -78}}, color = {0, 0, 127}));
  connect(division.y, idRefPu) annotation(
    Line(points = {{131, -72}, {160, -72}}, color = {0, 0, 127}));
  connect(UNomFix.y, switch.u3) annotation(
    Line(points = {{-29, -120}, {-16.5, -120}, {-16.5, -86}, {-12, -86}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{-69, -70}, {-12, -70}}, color = {0, 0, 127}));
  connect(firstOrder.y, limiter.u) annotation(
    Line(points = {{-109, -70}, {-92, -70}}, color = {0, 0, 127}));
  connect(RateFlag0.y, switch.u2) annotation(
    Line(points = {{-29, -90}, {-20, -90}, {-20, -78}, {-12, -78}}, color = {255, 0, 255}));
  connect(idCmdPu, product.u2) annotation(
    Line(points = {{-160, -20}, {28, -20}}, color = {0, 0, 127}));
  connect(switch.y, product.u1) annotation(
    Line(points = {{11, -78}, {20, -78}, {20, -32}, {28, -32}}, color = {0, 0, 127}));
  connect(RrpwrNeg0.y, rateLimFirstOrderFreeze1.dyMin) annotation(
    Line(points = {{51, -56}, {60, -56}, {60, -32}, {69, -32}}, color = {0, 0, 127}));
  connect(RrpwrPos0.y, rateLimFirstOrderFreeze1.dyMax) annotation(
    Line(points = {{51, 4}, {60, 4}, {60, -19}, {69, -19}}, color = {0, 0, 127}));
  connect(offDelay.y, switch1.u2) annotation(
    Line(points = {{-108, 100}, {-52, 100}}, color = {255, 0, 255}));
  connect(offDelay.y, switch2.u2) annotation(
    Line(points = {{-108, 100}, {-100, 100}, {-100, 20}, {-52, 20}}, color = {255, 0, 255}));
  connect(IqrMinPu0.y, switch2.u1) annotation(
    Line(points = {{-69, 40}, {-60, 40}, {-60, 28}, {-52, 28}}, color = {0, 0, 127}));
  connect(constant2.y, switch2.u3) annotation(
    Line(points = {{-69, 0}, {-60, 0}, {-60, 12}, {-52, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(constant1.y, switch1.u3) annotation(
    Line(points = {{-69, 80}, {-60, 80}, {-60, 92}, {-52, 92}}, color = {0, 0, 127}));
  connect(IqrMaxPu0.y, switch1.u1) annotation(
    Line(points = {{-69, 120}, {-60, 120}, {-60, 108}, {-52, 108}, {-52, 108}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><p> The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current (or active power if RampFlag is true).</ul> </p></html>"),
    Diagram(coordinateSystem(initialScale = 0.2, extent = {{-150, -130}, {150, 150}}, grid = {1, 1}), graphics = {Text(origin = {52, 36}, extent = {{-22, 8}, {38, -32}}, textString = "Reactive power convention:
    negative reactive current refers to
    reactive power injection (positive)")}),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-27, 20}, extent = {{-53, 60}, {107, -100}}, textString = "REGC B"), Text(origin = {134, -42}, extent = {{-22, 16}, {36, -28}}, textString = "idRefPu"), Text(origin = {134, 62}, extent = {{-22, 16}, {36, -32}}, textString = "iqRefPu"), Text(origin = {-28, -117}, extent = {{-18, 15}, {6, -1}}, textString = "UPu"), Text(origin = {-138, 82}, extent = {{-22, 16}, {36, -28}}, textString = "idCmdPu"), Text(origin = {-138, -38}, extent = {{-22, 16}, {36, -28}}, textString = "iqCmdPu"), Text(origin = {-138, 28}, extent = {{-8, 6}, {36, -28}}, textString = "frtOn")}, coordinateSystem(initialScale = 0.1)));
end REGCbCS;
