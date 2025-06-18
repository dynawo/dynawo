within Dynawo.Electrical.Controls.WECC.REPC;

model REPCa "WECC Plant Control type A"
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
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREPC;
  extends Dynawo.Electrical.Controls.WECC.REPC.BaseClasses.BaseREPC;
  
  // REPC-A parameter
  parameter Boolean RefFlag ;
  
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFilterPC, y_start = if VCompFlag == true then UInj0Pu else U0Pu + Kc*QGen0Pu) annotation(
    Placement(transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = false) annotation(
    Placement(transformation(origin = {-26, -116}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant RefFlag0(k = RefFlag) annotation(
    Placement(transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {12, 50}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(switch2.y, firstOrder3.u) annotation(
    Line(points = {{-98, 80}, {-88, 80}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UCtrlErr.u2) annotation(
    Line(points = {{-64, 80}, {-58, 80}, {-58, 90}, {-50, 90}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-50, 160}, {-50, 98}}, color = {0, 0, 127}));
  connect(Zero1.y, UCtrlErr.u3) annotation(
    Line(points = {{110, 96}, {-22, 96}, {-22, 72}, {-50, 72}, {-50, 82}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add3.u2) annotation(
    Line(points = {{-258, -50}, {-82, -50}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u1) annotation(
    Line(points = {{-310, -30}, {-82, -30}, {-82, -42}}, color = {0, 0, 127}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-258, 50}, {-194, 50}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U2Pu, QVCtrlErr.u1) annotation(
    Line(points = {{-258, 94}, {-246, 94}, {-246, 62}, {-194, 62}}, color = {0, 0, 127}));
  connect(lineDropCompensation1.U1Pu, switch2.u1) annotation(
    Line(points = {{-258, 106}, {-122, 106}, {-122, 88}}, color = {0, 0, 127}));
  connect(add3.y, PRefLim.u) annotation(
    Line(points = {{-68, -50}, {-36, -50}}, color = {0, 0, 127}));
  connect(booleanExpression.y, limPID.freeze) annotation(
    Line(points = {{-14, -116}, {4, -116}, {4, -62}}, color = {255, 0, 255}));
  connect(limPID.y, firstOrder.u) annotation(
    Line(points = {{22, -50}, {98, -50}}, color = {0, 0, 127}));
  connect(firstOrder.y, switch.u1) annotation(
    Line(points = {{122, -50}, {136, -50}, {136, -66}, {84, -66}, {84, -82}, {98, -82}}, color = {0, 0, 127}));
  connect(RefFlag0.y, switch1.u2) annotation(
    Line(points = {{-19, 50}, {0, 50}}, color = {255, 0, 255}));
  connect(UCtrlErr.y, switch1.u1) annotation(
    Line(points = {{-26, 90}, {0, 90}, {0, 58}}, color = {0, 0, 127}));
  connect(QCtrlErr.y, switch1.u3) annotation(
    Line(points = {{-20, 4}, {0, 4}, {0, 42}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain2.u) annotation(
    Line(points = {{-206, -130}, {-166, -130}}, color = {0, 0, 127}));
  connect(omegaPu, wCtrlErr.u2) annotation(
    Line(points = {{-310, -140}, {-272, -140}, {-272, -136}, {-258, -136}}, color = {0, 0, 127}));
  connect(deadZone1.y, gain1.u) annotation(
    Line(points = {{-206, -130}, {-194, -130}, {-194, -90}, {-168, -90}}, color = {0, 0, 127}));
  connect(QRefPu, QCtrlErr.u2) annotation(
    Line(points = {{-308, 0}, {-254, 0}, {-254, -2}, {-44, -2}}, color = {0, 0, 127}));
  connect(switch1.y, deadZone.u) annotation(
    Line(points = {{24, 50}, {28, 50}}, color = {0, 0, 127}));
  connect(leadLag.y, QInjRefPu) annotation(
    Line(points = {{146, 50}, {210, 50}}, color = {0, 0, 127}));
  connect(voltageCheck.freeze, limPIDFreeze.freeze) annotation(
    Line(points = {{-218, 94}, {-208, 94}, {-208, 118}, {90, 118}, {90, 62}}, color = {255, 0, 255}));
  connect(voltageCheck.freeze, freeze) annotation(
    Line(points = {{-218, 94}, {-174, 94}, {-174, 102}, {-102, 102}}, color = {255, 0, 255}));

annotation(
    Icon(graphics = {Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC A")}));
end REPCa;
