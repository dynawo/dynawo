within Dynawo.Electrical.Controls.WECC.REPC;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model REPCd "WECC Plant Control type D"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPCd;
  extends Dynawo.Electrical.Controls.WECC.REPC.REPCc(voltageCheck.UMaxPu = VFrzHighPu);

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput[NbConv] PConvVectRefPu(start = PConvVect0) "Active power setpoint at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {910, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput[NbConv] QConvVectRefPu(start = QConvVect0) "Reactive power setpoint at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {910, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add add(k1 = -1)  annotation(
    Placement(transformation(origin = {690, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(transformation(origin = {690, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const4(k = PConvAverage0Pu) annotation(
    Placement(transformation(origin = {630, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const5(k = QConvAverage0Pu) annotation(
    Placement(transformation(origin = {630, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain[NbConv] gain4(k = Kz) annotation(
    Placement(transformation(origin = {730, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain[NbConv] gain3(k = Kw) annotation(
    Placement(transformation(origin = {730, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant[NbConv] const2(k = PConvVect0) annotation(
    Placement(transformation(origin = {730, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant[NbConv] const3(k = QConvVect0) annotation(
    Placement(transformation(origin = {730, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add[NbConv] add8 annotation(
    Placement(transformation(origin = {790, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add[NbConv] add7 annotation(
    Placement(transformation(origin = {790, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder[NbConv] firstOrder8(T = tZ) annotation(
    Placement(transformation(origin = {830, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder[NbConv] firstOrder7(T = tW) annotation(
    Placement(transformation(origin = {830, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter[NbConv] limiter8(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(transformation(origin = {870, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter[NbConv] limiter9(uMax = QMaxPu, uMin = QMinPu) annotation(
    Placement(transformation(origin = {870, -40}, extent = {{-10, -10}, {10, 10}})));

  //Initial parameters
  parameter Types.ActivePowerPu[NbConv] PConvVect0 "Start value of active power at converter terminal in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu[NbConv] QConvVect0 "Start value of reactive power at converter terminal in pu (generator convention) (base SNom)";

  final parameter Types.ActivePowerPu PConvAverage0Pu = sum(PConvVect0 .* SNomConv) / sum(SNomConv) "Start value of active power at converter terminal in pu (base SNom) (generator convention)";
  final parameter Types.ReactivePowerPu QConvAverage0Pu = sum(QConvVect0 .* SNomConv) / sum(SNomConv) "Start value of reactive power at converter terminal in pu (generator convention) (base SNom)";

equation
  for k in 1:NbConv loop
    connect(add.y, gain4[k].u) annotation(
      Line(points = {{701, 60}, {717, 60}}, color = {0, 0, 127}));
    connect(add1.y, gain3[k].u) annotation(
      Line(points = {{701, -60}, {717, -60}}, color = {0, 0, 127}));
    connect(gain4[k].y, add8[k].u1) annotation(
      Line(points = {{741, 60}, {760, 60}, {760, 46}, {777, 46}}, color = {0, 0, 127}, thickness = 0.5));
    connect(gain3[k].y, add7[k].u2) annotation(
      Line(points = {{741, -60}, {760, -60}, {760, -46}, {777, -46}}, color = {0, 0, 127}, thickness = 0.5));
    connect(const2[k].y, add8[k].u2) annotation(
      Line(points = {{741, 20}, {760, 20}, {760, 34}, {777, 34}}, color = {0, 0, 127}, thickness = 0.5));
    connect(const3[k].y, add7[k].u1) annotation(
      Line(points = {{741, -20}, {760, -20}, {760, -34}, {777, -34}}, color = {0, 0, 127}, thickness = 0.5));
    connect(add8[k].y, firstOrder8[k].u) annotation(
      Line(points = {{801, 40}, {817, 40}}, color = {0, 0, 127}, thickness = 0.5));
    connect(add7[k].y, firstOrder7[k].u) annotation(
      Line(points = {{801, -40}, {817, -40}}, color = {0, 0, 127}, thickness = 0.5));
    connect(firstOrder8[k].y, limiter8[k].u) annotation(
      Line(points = {{841, 40}, {857, 40}}, color = {0, 0, 127}, thickness = 0.5));
    connect(firstOrder7[k].y, limiter9[k].u) annotation(
      Line(points = {{841, -40}, {857, -40}}, color = {0, 0, 127}, thickness = 0.5));
    connect(limiter8[k].y, PConvVectRefPu[k]) annotation(
      Line(points = {{881, 40}, {909, 40}}, color = {0, 0, 127}, thickness = 0.5));
    connect(limiter9[k].y, QConvVectRefPu[k]) annotation(
      Line(points = {{881, -40}, {909, -40}}, color = {0, 0, 127}, thickness = 0.5));
  end for;

  connect(const4.y, add.u1) annotation(
    Line(points = {{641, 100}, {660, 100}, {660, 66}, {677, 66}}, color = {0, 0, 127}));
  connect(const5.y, add1.u2) annotation(
    Line(points = {{641, -100}, {660, -100}, {660, -66}, {677, -66}}, color = {0, 0, 127}));
  connect(switch5.y, add1.u1) annotation(
    Line(points = {{582, 60}, {590, 60}, {590, 40}, {660, 40}, {660, -54}, {678, -54}}, color = {0, 0, 127}));
  connect(switch.y, add.u2) annotation(
    Line(points = {{582, -80}, {590, -80}, {590, -60}, {640, -60}, {640, 54}, {678, 54}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-600, -300}, {900, 300}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC D")}),
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to Model User Guide for Generic Renewable Energy System Models: EPRI, Palo Alto, CA:
2023. 3002027129. </p>
<p>Plant level active and reactive power/voltage control. Reactive power(0), voltage control(1) or power factor(2) dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = 1), voltage at remote bus can be controlled when VCompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu).PefdFlag allows to ignore the electrical power feedback. FfwrdFlag creates a feedforward path for the active current.  </p>
</html>"));
end REPCd;
