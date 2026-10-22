within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls;

model VoltageReferenceControl "Voltage reference control block"
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
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the high-pass filter of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdRef0Pu) "d-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = UqRef0Pu) "q-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 1/Omegaff, y_start = -Kff*IqPcc0Pu) annotation(
    Placement(transformation(origin = {-4, -36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {82, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {22, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = -Kff) annotation(
    Placement(visible = true, transformation(origin = {-48, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1/Omegaf, y_start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Mq) annotation(
    Placement(visible = true, transformation(origin = {-26, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 1/Omegaff, y_start = Kff*IdPcc0Pu) annotation(
    Placement(transformation(origin = {0, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-58, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kff) annotation(
    Placement(transformation(origin = {-48, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {52, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {82, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage module reference in pu (base UNom)";
  parameter Types.ReactivePowerPu QFilterRef0Pu = QFilter0Pu "Start value of reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  final parameter Types.PerUnit UdRef0Pu = URef0Pu + Mq*(QFilterRef0Pu - QFilter0Pu) - DeltaVVId0 "Start value of d-axis voltage reference in pu (base UNom)";
  final parameter Types.PerUnit UqRef0Pu = -DeltaVVIq0 "Start value of q-axis voltage reference in pu (base UNom)";
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {34, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(origin = {38, -36}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(feedback5.y, udFilterRefPu) annotation(
    Line(points = {{91, 78}, {110, 78}}, color = {0, 0, 127}));
  connect(gain1.u, idPccPu) annotation(
    Line(points = {{-60, 4}, {-110, 4}}, color = {0, 0, 127}));
  connect(QFilterPu, firstOrder1.u) annotation(
    Line(points = {{-110, 54}, {-88, 54}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{-49, 84}, {-38, 84}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{-37, 4}, {-12, 4}}, color = {0, 0, 127}));
  connect(gain2.u, iqPccPu) annotation(
    Line(points = {{-60, -36}, {-110, -36}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{-65, 54}, {-58, 54}, {-58, 76}}, color = {0, 0, 127}));
  connect(DeltaVVId, feedback5.u2) annotation(
    Line(points = {{-110, -16}, {82, -16}, {82, 70}}, color = {0, 0, 127}));
  connect(gain2.y, firstOrder3.u) annotation(
    Line(points = {{-37, -36}, {-16, -36}}, color = {0, 0, 127}));
  connect(URefPu, add2.u2) annotation(
    Line(points = {{-110, 24}, {2, 24}, {2, 72}, {10, 72}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-15, 84}, {10, 84}}, color = {0, 0, 127}));
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{61, 78}, {74, 78}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{33, 78}, {44, 78}}, color = {0, 0, 127}));
  connect(feedback7.y, uqFilterRefPu) annotation(
    Line(points = {{91, -36}, {110, -36}}, color = {0, 0, 127}));
  connect(DeltaVVIq, feedback7.u2) annotation(
    Line(points = {{-110, -56}, {82, -56}, {82, -44}}, color = {0, 0, 127}));
  connect(QFilterRefPu, feedback3.u1) annotation(
    Line(points = {{-110, 84}, {-66, 84}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u1) annotation(
    Line(points = {{12, 4}, {26, 4}}, color = {0, 0, 127}));
  connect(feedback.y, feedback4.u2) annotation(
    Line(points = {{44, 4}, {52, 4}, {52, 70}}, color = {0, 0, 127}));
  connect(gain1.y, feedback.u2) annotation(
    Line(points = {{-36, 4}, {-26, 4}, {-26, -14}, {34, -14}, {34, -4}}, color = {0, 0, 127}));
  connect(gain2.y, feedback1.u2) annotation(
    Line(points = {{-36, -36}, {-24, -36}, {-24, -54}, {38, -54}, {38, -44}}, color = {0, 0, 127}));
  connect(firstOrder3.y, feedback1.u1) annotation(
    Line(points = {{8, -36}, {30, -36}}, color = {0, 0, 127}));
  connect(feedback1.y, feedback7.u1) annotation(
    Line(points = {{48, -36}, {74, -36}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(initialScale = 0.2)),
    Icon(coordinateSystem(initialScale = 0.2)),
    Documentation(info = "<html><head></head><body>
<p>This model computes the dq voltage reference at the filter capacitor (udFilterRefPu, uqFilterRefPu) of a grid-forming converter, i.e. the internal electromotive force E used afterwards by the QSEM block to compute the current references. It is expressed in the converter rotating frame given by the power-angle control (e.g. VSM), in which the voltage reference is aligned on the d-axis. It combines three contributions:</p>
<p>u<sub>dFilterRef</sub> = U<sub>Ref</sub> + M<sub>q</sub> &middot; (Q<sub>FilterRef</sub> &minus; Q<sub>Filter</sub> / (1 + s / &omega;<sub>f</sub>)) + K<sub>ff</sub> &middot; (s / &omega;<sub>ff</sub>) / (1 + s / &omega;<sub>ff</sub>) &middot; i<sub>dPcc</sub> &minus; &Delta;V<sub>VId</sub></p>
<p>u<sub>qFilterRef</sub> = K<sub>ff</sub> &middot; (s / &omega;<sub>ff</sub>) / (1 + s / &omega;<sub>ff</sub>) &middot; i<sub>qPcc</sub> &minus; &Delta;V<sub>VIq</sub></p>

<h4>Reactive power / voltage droop</h4>
<p>The voltage magnitude reference URefPu is corrected proportionally to the reactive power error, with the droop coefficient M<sub>q</sub> (Mq, in pu voltage per pu reactive power). The measured reactive power at the filter capacitor is first filtered by a first order low-pass filter of cutoff pulsation &omega;<sub>f</sub> (Omegaf, in rad/s). In steady state:</p>
<p>U = U<sub>Ref</sub> + M<sub>q</sub> &middot; (Q<sub>FilterRef</sub> &minus; Q<sub>Filter</sub>)</p>
<p>so that the internal voltage decreases when the converter produces more reactive power than requested (stable droop characteristic).</p>
<p><b>Small-signal analysis.</b> Assuming fast QSEM and current loops, no virtual impedance, a stiff grid and neglecting the active damping (K<sub>ff</sub> = 0, or &omega;<sub>ff</sub> well above the bandwidth of the reactive power loop, so that its high-pass filter is transparent at these frequencies), the reactive power sensitivity to the internal voltage can be written &Delta;Q<sub>Filter</sub> = K<sub>Q</sub> &middot; &Delta;E with, neglecting resistances, Q<sub>Filter</sub> = E &middot; (E &minus; V &middot; cos(&delta;)) / X, hence K<sub>Q</sub> = (2E &minus; V &middot; cos(&delta;<sub>0</sub>)) / X &asymp; 1 / X (E &asymp; V &asymp; 1 pu, small &delta;<sub>0</sub>), X being the total reactance between the capacitor and the grid voltage (cf. QSEM). The closed loop is then of first order:</p>
<ul>
<li>time constant: &tau;<sub>Q</sub> = 1 / (&omega;<sub>f</sub> &middot; (1 + M<sub>q</sub> &middot; K<sub>Q</sub>));</li>
<li>a reactive power step &Delta;Q<sub>FilterRef</sub> leads to &Delta;Q<sub>Filter</sub> = M<sub>q</sub> &middot; K<sub>Q</sub> / (1 + M<sub>q</sub> &middot; K<sub>Q</sub>) &middot; &Delta;Q<sub>FilterRef</sub> in steady state (static error due to the proportional droop). As the active damping vanishes in steady state, this static result does not depend on K<sub>ff</sub>.</li>
</ul>

<h4>Active damping</h4>
<p>The grid current (idPccPu, iqPccPu) multiplied by K<sub>ff</sub> (Kff, in pu) and filtered by a first order high-pass filter of cutoff pulsation &omega;<sub>ff</sub> (Omegaff, in rad/s) is added to the voltage reference on both axes:</p>
<p>&Delta;<b>u</b><sub>FilterRef</sub> = K<sub>ff</sub> &middot; (s / &omega;<sub>ff</sub>) / (1 + s / &omega;<sub>ff</sub>) &middot; <b>i</b><sub>Pcc</sub></p>
<p>The high-pass filter is implemented as a first order low-pass filter with a direct connection, using (s / &omega;<sub>ff</sub>) / (1 + s / &omega;<sub>ff</sub>) = 1 &minus; 1 / (1 + s / &omega;<sub>ff</sub>). Note the sign: the output of the low-pass filter minus its input gives the opposite of the high-pass output, LPF(K<sub>ff</sub> &middot; i) &minus; K<sub>ff</sub> &middot; i = &minus; HPF(K<sub>ff</sub> &middot; i). On the d-axis, this difference is subtracted from the voltage reference; on the q-axis, the input current is first multiplied by &minus; K<sub>ff</sub>, so that both axes finally get + K<sub>ff</sub> &middot; HPF(i).</p>
<p>The active damping is therefore a <b>transient virtual impedance</b> of value &minus; K<sub>ff</sub> &middot; (s / &omega;<sub>ff</sub>) / (1 + s / &omega;<sub>ff</sub>) in series with the converter (generator convention), i.e. a virtual resistance &minus; K<sub>ff</sub> above &omega;<sub>ff</sub>, acting on the oscillations between the converter and the grid:</p>
<ul>
<li>it is zero in steady state: it introduces no permanent voltage drop and does not modify the operating point nor the static gain of the reactive power / voltage droop;</li>
<li>below &omega;<sub>ff</sub>, its gain decreases proportionally to the frequency: &omega;<sub>ff</sub> sets the frequency below which the active damping fades out;</li>
<li>at high frequencies, its gain tends to K<sub>ff</sub>: the grid current is directly fed through to the voltage reference, without attenuation of the fast dynamics.</li>
</ul>

<h4>Virtual impedance</h4>
<p>The voltage drop of the virtual impedance (DeltaVVId, DeltaVVIq), computed by a dedicated block (e.g. VirtualImpedance2CC), is directly subtracted from the voltage reference. This virtual impedance is typically activated only above a current threshold, to limit the converter current during faults.</p>

<h4>Initialization</h4>
<p>The start values of the outputs are consistent with the equations above in steady state, where the output of the high-pass filter of the active damping is zero:</p>
<p>U<sub>dRef0</sub> = U<sub>Ref0</sub> + M<sub>q</sub> &middot; (Q<sub>FilterRef0</sub> &minus; Q<sub>Filter0</sub>) &minus; &Delta;V<sub>VId0</sub></p>
<p>U<sub>qRef0</sub> = &minus; &Delta;V<sub>VIq0</sub></p>
<p>The internal low-pass filters of the active damping start at their steady-state input values, K<sub>ff</sub> &middot; I<sub>dPcc0</sub> and &minus; K<sub>ff</sub> &middot; I<sub>qPcc0</sub>.</p>
</body></html>"));
end VoltageReferenceControl;
