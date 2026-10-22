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
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC;

  Modelica.Blocks.Continuous.FirstOrder firstOrder3(
    T = tFilterPC,
    y_start = URef0Pu) annotation(
    Placement(transformation(origin = {-170, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(transformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConst(k = false) annotation(
    Placement(transformation(origin = {150, -100}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(lineDropCompensation1.U2Pu, voltageCheck.UPu) annotation(
    Line(points = {{-538, 94}, {-500, 94}, {-500, 280}, {100, 280}}, color = {0, 0, 127}));
  connect(omegaPu, wCtrlErr.u2) annotation(
    Line(points = {{-610, -220}, {-380, -220}, {-380, -186}, {-362, -186}}, color = {0, 0, 127}));
  connect(limPID.y, firstOrder.u) annotation(
    Line(points = {{212, -60}, {340, -60}, {340, -40}, {498, -40}}, color = {0, 0, 127}));
  connect(add3.y, PRefLim.u) annotation(
    Line(points = {{2, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add3.u2) annotation(
    Line(points = {{-398, -80}, {-240, -80}, {-240, -60}, {-22, -60}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UCtrlErr.u2) annotation(
    Line(points = {{-158, 140}, {-62, 140}}, color = {0, 0, 127}));
  connect(switch2.y, firstOrder3.u) annotation(
    Line(points = {{-198, 140}, {-182, 140}}, color = {0, 0, 127}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-378, 80}, {-300, 80}, {-300, 94}, {-282, 94}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, QVCtrlErr.u1) annotation(
    Line(points = {{-538, 94}, {-420, 94}, {-420, 106}, {-282, 106}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, limPIDFreeze.freeze) annotation(
    Line(points = {{122, 280}, {320, 280}, {320, 80}, {334, 80}, {334, 72}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, freeze) annotation(
    Line(points = {{122, 280}, {610, 280}}, color = {255, 0, 255}));
  connect(QRefPu, QCtrlErr.u2) annotation(
    Line(points = {{-608, 0}, {-320, 0}, {-320, -6}, {-282, -6}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain1.u) annotation(
    Line(points = {{-298, -180}, {-200, -180}, {-200, -140}, {-182, -140}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain2.u) annotation(
    Line(points = {{-298, -180}, {-200, -180}, {-200, -220}, {-184, -220}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u1) annotation(
    Line(points = {{-610, -40}, {-40, -40}, {-40, -52}, {-22, -52}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, switch2.u1) annotation(
    Line(points = {{-538, 106}, {-520, 106}, {-520, 240}, {-240, 240}, {-240, 148}, {-222, 148}}, color = {0, 0, 127}));
  connect(leadLag.y, QConvRefPu) annotation(
    Line(points = {{402, 60}, {610, 60}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-610, 260}, {-80, 260}, {-80, 148}, {-62, 148}}, color = {0, 0, 127}));
  connect(const1.y, UCtrlErr.u3) annotation(
    Line(points = {{-99, 100}, {-80, 100}, {-80, 132}, {-62, 132}}, color = {0, 0, 127}));
  connect(booleanConst.y, limPID.freeze) annotation(
    Line(points = {{162, -100}, {194, -100}, {194, -72}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to Model User Guide for Generic Renewable Energy System Models: EPRI, Palo Alto, CA:
2023. 3002027129. </p>
<p>Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled if VCompFlag is true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu). </p>
</html>"),
    Diagram(coordinateSystem(extent = {{-600, -300}, {600, 300}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC A"), Text(origin = {137, 74}, extent = {{-23, 10}, {41, -12}}, textString = "PConvRefPu"), Text(origin = {59, 110}, extent = {{-15, 12}, {11, -12}}, textString = "QPu"), Text(origin = {103, 110}, extent = {{-15, 12}, {11, -12}}, textString = "PPu"), Text(origin = {-53, 110}, extent = {{-15, 12}, {11, -12}}, textString = "iPu"), Text(origin = {-7, 110}, extent = {{-15, 12}, {11, -12}}, textString = "uPu"), Text(origin = {-149, -10}, extent = {{-23, 10}, {21, -10}}, textString = "PRefPu"), Text(origin = {-149, -52}, extent = {{-23, 10}, {21, -10}}, textString = "QRefPu"), Text(origin = {-149, 34}, extent = {{-55, 40}, {21, -10}}, textString = "omegaRefPu"), Text(origin = {-151, 78}, extent = {{-31, 32}, {21, -10}}, textString = "omegaPu"), Text(origin = {139, -46}, extent = {{-23, 10}, {41, -12}}, textString = "QConvRefPu"), Text(origin = {137, 12}, extent = {{-23, 10}, {27, -8}}, textString = "freeze"), Text(origin = {1, -132}, extent = {{-23, 10}, {21, -10}}, textString = "URefPu")}, coordinateSystem(initialScale = 0.1)));
end REPCa;
