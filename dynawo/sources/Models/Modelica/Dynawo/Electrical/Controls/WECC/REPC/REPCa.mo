within Dynawo.Electrical.Controls.WECC.REPC;

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

model REPCa "WECC Renewable Energy Plant Controller REPC model a"
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC(add3.k1 = -1, pid.YMax = PMaxPu, pid.YMin = PMinPu, pid1.YMax = QMaxPu, pid1.YMin = QMinPu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.REPCaParameters;

  Modelica.Blocks.Math.Gain gain2(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-350, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tFilterPC, y_start = URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 210}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant3(k = false) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = RefFlag == 1) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(omegaPu, feedback.u2) annotation(
    Line(points = {{-360, -220}, {-360, -148}}, color = {0, 0, 127}));
  connect(deadZone.y, gain.u) annotation(
    Line(points = {{-298, -140}, {-240, -140}, {-240, -160}, {-222, -160}}, color = {0, 0, 127}));
  connect(deadZone.y, gain1.u) annotation(
    Line(points = {{-298, -140}, {-240, -140}, {-240, -120}, {-222, -120}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u2) annotation(
    Line(points = {{-420, -80}, {-62, -80}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u1) annotation(
    Line(points = {{-298, -40}, {-80, -40}, {-80, -72}, {-62, -72}}, color = {0, 0, 127}));
  connect(add3.y, limiter2.u) annotation(
    Line(points = {{-38, -80}, {38, -80}}, color = {0, 0, 127}));
  connect(pid.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{102, -80}, {218, -80}}, color = {0, 0, 127}));
  connect(gain2.y, add1.u2) annotation(
    Line(points = {{-338, 100}, {-220, 100}, {-220, 94}, {-202, 94}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U2Pu, voltageCheck.UPu) annotation(
    Line(points = {{-298, 148}, {-280, 148}, {-280, 140}, {-200, 140}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U2Pu, add1.u1) annotation(
    Line(points = {{-298, 148}, {-280, 148}, {-280, 140}, {-220, 140}, {-220, 106}, {-202, 106}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add4.u3) annotation(
    Line(points = {{2, 120}, {20, 120}, {20, 132}, {38, 132}}, color = {0, 0, 127}));
  connect(switch11.y, firstOrder2.u) annotation(
    Line(points = {{-58, 120}, {-22, 120}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U1Pu, switch11.u1) annotation(
    Line(points = {{-298, 172}, {-100, 172}, {-100, 128}, {-82, 128}}, color = {0, 0, 127}));
  connect(URefPu, add4.u2) annotation(
    Line(points = {{-60, 220}, {-60, 140}, {38, 140}}, color = {0, 0, 127}));
  connect(const3.y, add4.u1) annotation(
    Line(points = {{0, 200}, {0, 148}, {38, 148}}, color = {0, 0, 127}));
  connect(QRegPu, gain2.u) annotation(
    Line(points = {{-420, 80}, {-380, 80}, {-380, 100}, {-362, 100}}, color = {0, 0, 127}));
  connect(booleanConstant3.y, pid.freeze) annotation(
    Line(points = {{62, -40}, {84, -40}, {84, -68}}, color = {255, 0, 255}));
  connect(QRefPu, feedback1.u1) annotation(
    Line(points = {{-420, 40}, {-8, 40}}, color = {0, 0, 127}));
  connect(booleanConstant1.y, switch.u2) annotation(
    Line(points = {{62, 80}, {98, 80}}, color = {255, 0, 255}));
  connect(add4.y, switch.u1) annotation(
    Line(points = {{62, 140}, {80, 140}, {80, 88}, {98, 88}}, color = {0, 0, 127}));
  connect(feedback1.y, switch.u3) annotation(
    Line(points = {{10, 40}, {80, 40}, {80, 72}, {98, 72}}, color = {0, 0, 127}));
  connect(switch.y, deadZone1.u) annotation(
    Line(points = {{122, 80}, {158, 80}}, color = {0, 0, 127}));
  connect(pid1.y, transferFunction.u) annotation(
    Line(points = {{302, 80}, {358, 80}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the WECC plant level control model type A according to the WECC document Second Generation Wind Turbine Models (page 25) : <a href='https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf/'>https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf </a> </p>
    <img src=\"modelica://Dynawo/Electrical/Controls/WECC/Images/REPCa.png\" alt=\"Renewable energy plant controller model A (repc_a)\">
    <p> Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled when VcompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu). </p>
    </html>"),
    Icon(graphics = {Text(origin = {0, -27}, extent = {{22, 19}, {-22, -19}}, textString = "A")}));
end REPCa;
