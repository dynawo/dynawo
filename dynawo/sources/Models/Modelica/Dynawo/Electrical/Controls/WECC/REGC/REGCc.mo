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

model REGCc "WECC Renewable Energy Generator Converter model c"
  extends Dynawo.Electrical.Controls.WECC.REGC.BaseClasses.BaseREGC(booleanConstant.k = RateFlag, const6.k = 1, rateLimFirstOrderFreeze.T = 1e-5, rateLimFirstOrderFreeze.UseRateLim = true, rateLimFirstOrderFreeze.Y0 = Iq0Pu, rateLimFirstOrderFreeze.k = 1, rateLimFirstOrderFreeze1.Y0 = if RateFlag then Ip0Pu * UInj0Pu else Ip0Pu, rateLimFirstOrderFreeze1.T = 1e-5, rateLimFirstOrderFreeze1.UseRateLim = true);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.REGCcParameters;

  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-70, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {50, -120}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VoltageSource voltageSource(Id0Pu = Ip0Pu, Iq0Pu = -Iq0Pu, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, RSourcePu = RSourcePu, SNom = SNom, UInj0Pu = UInj0Pu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, i0Pu = i0Pu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze pid(K = Kip, Ti = Kii, Y0 = -Iq0Pu, YMax = IMaxGCPu) annotation(
    Placement(visible = true, transformation(origin = {110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze pid1(K = Kip, Ti = Kii, Y0 = Ip0Pu, YMax = IMaxGCPu) annotation(
    Placement(visible = true, transformation(origin = {110, -120}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression It(y = terminal.i) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPll, Kp = KpPll, OmegaMaxPu = OmegaMax / SystemBase.omegaNom, OmegaMinPu = OmegaMin / SystemBase.omegaNom, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {200, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));

equation
  pid.freeze = false;
  pid1.freeze = false;
  pll.omegaRefPu = 1;

  connect(firstOrder.y, limiter.u) annotation(
    Line(points = {{-238, 0}, {-202, 0}}, color = {0, 0, 127}));
  connect(limiter.y, switch2.u1) annotation(
    Line(points = {{-178, 0}, {-160, 0}, {-160, -32}, {-142, -32}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{-178, -40}, {-142, -40}}, color = {255, 0, 255}));
  connect(const6.y, switch2.u3) annotation(
    Line(points = {{-178, -80}, {-160, -80}, {-160, -48}, {-142, -48}}, color = {0, 0, 127}));
  connect(switch2.y, product.u1) annotation(
    Line(points = {{-118, -40}, {-100, -40}, {-100, -114}, {-82, -114}}, color = {0, 0, 127}));
  connect(switch2.y, division.u2) annotation(
    Line(points = {{-118, -40}, {20, -40}, {20, -114}, {38, -114}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, division.u1) annotation(
    Line(points = {{2, -120}, {20, -120}, {20, -126}, {38, -126}}, color = {0, 0, 127}));
  connect(product.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-58, -120}, {-22, -120}}, color = {0, 0, 127}));
  connect(ipCmdPu, product.u2) annotation(
    Line(points = {{-320, -120}, {-100, -120}, {-100, -126}, {-82, -126}}, color = {0, 0, 127}));
  connect(voltageSource.terminal, terminal) annotation(
    Line(points = {{222, 0}, {310, 0}}, color = {0, 0, 255}));
  connect(voltageSource.PInjPu, PInjPu) annotation(
    Line(points = {{222, 16}, {260, 16}, {260, 120}, {310, 120}}, color = {0, 0, 127}));
  connect(voltageSource.QInjPu, QInjPu) annotation(
    Line(points = {{222, 8}, {280, 8}, {280, 60}, {310, 60}}, color = {0, 0, 127}));
  connect(voltageSource.UInjPu, UInjPu) annotation(
    Line(points = {{222, -8}, {280, -8}, {280, -60}, {310, -60}}, color = {0, 0, 127}));
  connect(voltageSource.uInjPu, uInjPu) annotation(
    Line(points = {{222, -16}, {260, -16}, {260, -120}, {310, -120}}, color = {85, 170, 255}));
  connect(pid.y, voltageSource.iqPu) annotation(
    Line(points = {{121, 120}, {140, 120}, {140, 12}, {178, 12}}, color = {0, 0, 127}));
  connect(It.y, transformRItoDQ.xPu) annotation(
    Line(points = {{-59, 0}, {-1, 0}}, color = {85, 170, 255}));
  connect(pid1.y, voltageSource.idPu) annotation(
    Line(points = {{121, -120}, {140, -120}, {140, -12}, {178, -12}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, pid.u_s) annotation(
    Line(points = {{2, 120}, {98, 120}}, color = {0, 0, 127}));
  connect(transformRItoDQ.xqPu, pid.u_m) annotation(
    Line(points = {{22, 6}, {110, 6}, {110, 108}}, color = {0, 0, 127}));
  connect(transformRItoDQ.xdPu, pid1.u_m) annotation(
    Line(points = {{22, -6}, {110, -6}, {110, -108}}, color = {0, 0, 127}));
  connect(division.y, pid1.u_s) annotation(
    Line(points = {{62, -120}, {98, -120}}, color = {0, 0, 127}));
  connect(pll.phi, transformRItoDQ.phi) annotation(
    Line(points = {{178, -68}, {120, -68}, {120, 40}, {10, 40}, {10, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(voltageSource.uInjPu, pll.uPu) annotation(
    Line(points = {{222, -16}, {260, -16}, {260, -68}, {222, -68}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC generator converter model type C according to the WECC document Modeling Updates 021623 Rev27 (page 5) : <a href='https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf'>https://www.wecc.org/_layouts/15/WopiFrame.aspx?sourcedoc=/Reliability/Memo_RES_Modeling_Updates_021623_Rev27_Clean.pdf </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REGCc.png\" alt=\"Renewable energy generator/converter model C (regc_c)\">
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "B"), Text(origin = {148, 28}, extent = {{-32, 12}, {24, -20}}, textString = "QInjPu"), Text(origin = {144, -28}, extent = {{-32, 12}, {4, -4}}, textString = "UInjPu"), Text(origin = {146, -98}, extent = {{-32, 12}, {4, -4}}, textString = "uInjPu"), Text(origin = {148, 94}, extent = {{-32, 12}, {24, -8}}, textString = "PInjPu")}));
end REGCc;
