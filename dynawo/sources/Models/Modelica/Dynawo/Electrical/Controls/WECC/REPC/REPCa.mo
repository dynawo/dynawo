within Dynawo.Electrical.Controls.WECC.REPC;

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

model REPCa "WECC Plant Control type A"
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC;

  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFilterPC, y_start = if VCompFlag == true then UInj0Pu else U0Pu + Kc * QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(visible = true, transformation(origin = {170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(lineDropCompensation1.U2Pu, voltageCheck.UPu) annotation(
    Line(points = {{-538, 94}, {-360, 94}, {-360, 280}, {100, 280}}, color = {0, 0, 127}));
  connect(switch2.y, firstOrder3.u) annotation(
    Line(points = {{-198, 140}, {-122, 140}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UCtrlErr.u2) annotation(
    Line(points = {{-99, 140}, {-62, 140}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-610, 260}, {-80, 260}, {-80, 148}, {-62, 148}}, color = {0, 0, 127}));
  connect(Zero2.y, UCtrlErr.u3) annotation(
    Line(points = {{-98, 100}, {-80, 100}, {-80, 132}, {-62, 132}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add3.u2) annotation(
    Line(points = {{-558, -80}, {-280, -80}, {-280, -60}, {-22, -60}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u1) annotation(
    Line(points = {{-610, -40}, {-120, -40}, {-120, -52}, {-22, -52}}, color = {0, 0, 127}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-398, 40}, {-380, 40}, {-380, 60}, {-320, 60}, {-320, 94}, {-282, 94}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, QVCtrlErr.u1) annotation(
    Line(points = {{-538, 94}, {-360, 94}, {-360, 106}, {-282, 106}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, switch2.u1) annotation(
    Line(points = {{-538, 106}, {-380, 106}, {-380, 180}, {-240, 180}, {-240, 148}, {-222, 148}}, color = {0, 0, 127}));
  connect(add3.y, PRefLim.u) annotation(
    Line(points = {{2, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(booleanConstant.y, limPID.freeze) annotation(
    Line(points = {{182, -140}, {194, -140}, {194, -72}}, color = {255, 0, 255}));
  connect(limPID.y, firstOrder.u) annotation(
    Line(points = {{212, -60}, {400, -60}, {400, -40}, {498, -40}}, color = {0, 0, 127}));
  connect(firstOrder.y, switch.u1) annotation(
    Line(points = {{522, -40}, {540, -40}, {540, -72}, {558, -72}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain2.u) annotation(
    Line(points = {{-298, -180}, {-200, -180}, {-200, -220}, {-182, -220}}, color = {0, 0, 127}));
  connect(omegaPu, wCtrlErr.u2) annotation(
    Line(points = {{-610, -220}, {-380, -220}, {-380, -186}, {-362, -186}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain1.u) annotation(
    Line(points = {{-298, -180}, {-200, -180}, {-200, -140}, {-182, -140}}, color = {0, 0, 127}));
  connect(QRefPu, QCtrlErr.u2) annotation(
    Line(points = {{-608, 0}, {-320, 0}, {-320, -6}, {-282, -6}}, color = {0, 0, 127}));
  connect(leadLag.y, QInjRefPu) annotation(
    Line(points = {{402, 60}, {610, 60}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, limPIDFreeze.freeze) annotation(
    Line(points = {{322, 280}, {334, 280}, {334, 72}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, freeze) annotation(
    Line(points = {{122, 280}, {610, 280}}, color = {255, 0, 255}));
  connect(QCtrlErr.y, multiSwitch.u[1]) annotation(
    Line(points = {{-258, 0}, {160, 0}, {160, 60}, {190, 60}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, multiSwitch.u[2]) annotation(
    Line(points = {{-38, 140}, {160, 140}, {160, 60}, {190, 60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC A")}),
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled when VcompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu). </p>
</html>"));
end REPCa;
