within Dynawo.Electrical.Controls.WECC.REGC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model REGCa "WECC Renewable Energy Generator Converter model a"
  extends Dynawo.Electrical.Controls.WECC.REGC.BaseClasses.BaseREGC(booleanConstant.k = LvplSw, const6.k = 9999, rateLimFirstOrderFreeze1.Y0 = Ip0Pu, rateLimFirstOrderFreeze.T = tG, rateLimFirstOrderFreeze.UseRateLim = true, rateLimFirstOrderFreeze.Y0 = -Iq0Pu, rateLimFirstOrderFreeze.k = -1, rateLimFirstOrderFreeze1.T = tG, rateLimFirstOrderFreeze1.UseRateLim = true);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.REGCaParameters;

  //Input variable
  Modelica.Blocks.Interfaces.RealInput UPhaseInj(start = UPhaseInj0) "Rotor angle: angle between machine rotor frame and port phasor frame in rad" annotation(
    Placement(visible = true, transformation(origin = {200, -220}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = [0, 0; Zerox, 0; Brkpt, Lvpl1; 1, Lvpl1]) annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {50, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const7(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-10, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ injectorIDQ(Id0Pu = Ip0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu * SNom / SystemBase.SnRef, Q0Pu = -QInj0Pu * SNom / SystemBase.SnRef, SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {200, 0}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at injector in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhaseInj0 "Start value of rotor angle in rad" annotation(
    Dialog(group = "Initialization"));

equation
  connect(ipCmdPu, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-320, -120}, {-22, -120}}, color = {0, 0, 127}));
  connect(firstOrder.y, combiTable1Ds.u) annotation(
    Line(points = {{-238, 0}, {-202, 0}}, color = {0, 0, 127}));
  connect(switch2.y, variableLimiter.limit1) annotation(
    Line(points = {{-118, -40}, {20, -40}, {20, -112}, {38, -112}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, variableLimiter.u) annotation(
    Line(points = {{2, -120}, {38, -120}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y[1], switch2.u1) annotation(
    Line(points = {{-178, 0}, {-160, 0}, {-160, -32}, {-142, -32}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{-178, -40}, {-142, -40}}, color = {255, 0, 255}));
  connect(const6.y, switch2.u3) annotation(
    Line(points = {{-178, -80}, {-160, -80}, {-160, -48}, {-142, -48}}, color = {0, 0, 127}));
  connect(const7.y, variableLimiter.limit2) annotation(
    Line(points = {{2, -160}, {20, -160}, {20, -128}, {38, -128}}, color = {0, 0, 127}));
  connect(variableLimiter.y, injectorIDQ.idPu) annotation(
    Line(points = {{62, -120}, {140, -120}, {140, -12}, {178, -12}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, injectorIDQ.iqPu) annotation(
    Line(points = {{2, 120}, {140, 120}, {140, 8}, {178, 8}}, color = {0, 0, 127}));
  connect(UPhaseInj, injectorIDQ.UPhase) annotation(
    Line(points = {{200, -220}, {200, -22}}, color = {0, 0, 127}));
  connect(injectorIDQ.terminal, terminal) annotation(
    Line(points = {{224, 16}, {310, 16}, {310, 0}}, color = {0, 0, 255}));
  connect(injectorIDQ.uPu, uInjPu) annotation(
    Line(points = {{224, 6}, {240, 6}, {240, -120}, {310, -120}}, color = {85, 170, 255}));
  connect(injectorIDQ.QInjPuSn, QInjPu) annotation(
    Line(points = {{224, 0}, {280, 0}, {280, 60}, {310, 60}}, color = {0, 0, 127}));
  connect(injectorIDQ.PInjPuSn, PInjPu) annotation(
    Line(points = {{224, -8}, {260, -8}, {260, 120}, {310, 120}}, color = {0, 0, 127}));
  connect(injectorIDQ.UPu, UInjPu) annotation(
    Line(points = {{224, -16}, {260, -16}, {260, -60}, {310, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC generator converter model type A according to the EPRI document Model User Guide for Generic Renewable Energy System Models (page 66), available for download at : <a href='https://www.epri.com/research/products/3002014083'>https://www.epri.com/research/products/3002014083 </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REGCa.png\" alt=\"Renewable energy generator/converter model A (regc_a)\">
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "A"), Text(origin = {46, 112}, extent = {{-32, 12}, {4, -4}}, textString = "UPhaseInj"), Text(origin = {146, -98}, extent = {{-32, 12}, {4, -4}}, textString = "uInjPu"), Text(origin = {148, 94}, extent = {{-32, 12}, {24, -8}}, textString = "PInjPu"), Text(origin = {148, 28}, extent = {{-32, 12}, {24, -20}}, textString = "QInjPu"), Text(origin = {144, -28}, extent = {{-32, 12}, {4, -4}}, textString = "UInjPu")}));
end REGCa;
