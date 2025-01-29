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

model REGCb "WECC Generator Converter REGC type B"
  extends Dynawo.Electrical.Controls.WECC.REGC.BaseClasses.BaseREGC(rateLimFirstOrderFreeze1.T = tG, rateLimFirstOrderFreeze1.UseRateLim = true, rateLimFirstOrderFreeze1.Y0 = Id0Pu * UInj0Pu, rateLimFirstOrderFreeze2.T = tG, rateLimFirstOrderFreeze2.UseRateLim = true, rateLimFirstOrderFreeze2.Y0 = Iq0Pu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.ParamsREGCb;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsVSourceRef;

  // Input variable
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(im(start = uInj0Pu.im), re(start = uInj0Pu.re)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {175, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput phi(start = Modelica.ComplexMath.arg(uInj0Pu)) "Voltage phase at injector in rad" annotation(
    Placement(visible = true, transformation(origin = {-210.5, -0.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput urSource(start = uSource0Pu.re) "Real voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {230, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uiSource(start = uSource0Pu.im) "Imaginary voltage at source in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {229, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {109, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-60, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UNomFix(k = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -99}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-19, -120}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant RateFlag0(k = RateFlag) annotation(
    Placement(visible = true, transformation(origin = {-150, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, limitsAtInit = true, uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-99, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {120, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef vSourceRef(Id0Pu = Id0Pu, Iq0Pu = -Iq0Pu, RSourcePu = RSourcePu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {175.5, 0.5}, extent = {{-25.5, -25.5}, {25.5, 25.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {60, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  connect(RateFlag0.y, switch.u2) annotation(
    Line(points = {{-139, -70}, {-90, -70}, {-90, -80}, {-72, -80}}, color = {255, 0, 255}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-49, -80}, {30.5, -80}, {30.5, -96}, {108, -96}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{-88, -40}, {-80, -40}, {-80, -72}, {-72, -72}}, color = {0, 0, 127}));
  connect(UNomFix.y, switch.u3) annotation(
    Line(points = {{-109, -99}, {-101, -99}, {-101, -88}, {-72, -88}}, color = {0, 0, 127}));
  connect(switch.y, product.u2) annotation(
    Line(points = {{-49, -80}, {-40, -80}, {-40, -114}, {-31, -114}}, color = {0, 0, 127}));
  connect(product.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-8, -120}, {48, -120}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, division.u1) annotation(
    Line(points = {{71, -120}, {92, -120}, {92, -84}, {108, -84}}, color = {0, 0, 127}));
  connect(firstOrder.y, limiter.u) annotation(
    Line(points = {{-139, -40}, {-111, -40}}, color = {0, 0, 127}));
  connect(division.y, vSourceRef.idPu) annotation(
    Line(points = {{131, -90}, {140, -90}, {140, -15}, {147, -15}}, color = {0, 0, 127}));
  connect(vSourceRef.uiSourcePu, uiSource) annotation(
    Line(points = {{204, -9}, {210, -9}, {210, -50}, {229, -50}}, color = {0, 0, 127}));
  connect(vSourceRef.urSourcePu, urSource) annotation(
    Line(points = {{204, 11}, {210, 11}, {210, 50}, {230, 50}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.y, gain1.u) annotation(
    Line(points = {{21, 100}, {48, 100}}, color = {0, 0, 127}));
  connect(idCmdPu, product.u1) annotation(
    Line(points = {{-210, -120}, {-40, -120}, {-40, -126}, {-31, -126}}, color = {0, 0, 127}));
  connect(gain1.y, vSourceRef.iqPu) annotation(
    Line(points = {{71, 100}, {140, 100}, {140, 16}, {147, 16}}, color = {0, 0, 127}));
  connect(vSourceRef.uInjPu, uInjPu) annotation(
    Line(points = {{175.5, -28}, {175.5, -111.5}, {175, -111.5}, {175, -190}}, color = {85, 170, 255}));
  connect(phi, vSourceRef.phi) annotation(
    Line(points = {{-210, 0}, {147, 0}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-200, -180}, {220, 180}}, initialScale = 0.2, grid = {1, 1})),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-25, 20}, extent = {{-53, 60}, {107, -100}}, textString = "REGC B"), Text(origin = {141, 49}, extent = {{-22, 16}, {36, -28}}, textString = "urSourcePu"), Text(origin = {145, -34}, extent = {{-22, 16}, {36, -28}}, textString = "uiSourcePu"), Text(origin = {-6, -112}, extent = {{-19, 14}, {30, -24}}, textString = "uInjPu"), Text(origin = {-144, 95}, extent = {{-10, 11}, {16, -19}}, textString = "phi")}),
  Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The block calculates the final setpoints for Iq and Id while considering ramp rates for reactive current and active current (or active power if RampFlag is true).</span><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">It is&nbsp;</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">connected to the grid with a voltage source interface through urSource and uiSource.</span></div></body></html>"));
end REGCb;
