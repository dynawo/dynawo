within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model VoltageReferenceControl "Voltage reference control block"

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the high-pass filter of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";

  //Inputs
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference at the filter in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIdPu(start = DeltaVVId0Pu) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIqPu(start = DeltaVVIq0Pu) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdRef0Pu) "d-axis voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = UqRef0Pu) "q-axis voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 1/Omegaff, y_start = -Kff*IqPcc0Pu) annotation(
    Placement(transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(origin = {20, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(transformation(origin = {80, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain2(k = -Kff) annotation(
    Placement(transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1/Omegaf, y_start = QFilter0Pu) annotation(
    Placement(transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain3(k = Mq) annotation(
    Placement(transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 1/Omegaff, y_start = Kff*IdPcc0Pu) annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(transformation(origin = {-60, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = Kff) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(transformation(origin = {40, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit DeltaVVId0Pu "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0Pu "Start value of q-axis virtual impedance output in pu (base UNom)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage module reference in pu (base UNom)";
  parameter Types.ReactivePowerPu QFilterRef0Pu = QFilter0Pu "Start value of reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";

  final parameter Types.PerUnit UdRef0Pu = URef0Pu + Mq*(QFilterRef0Pu - QFilter0Pu) - DeltaVVId0Pu "Start value of d-axis voltage reference in pu (base UNom)";
  final parameter Types.PerUnit UqRef0Pu = -DeltaVVIq0Pu "Start value of q-axis voltage reference in pu (base UNom)";

equation
  connect(feedback5.y, udFilterRefPu) annotation(
    Line(points = {{89, 80}, {110, 80}}, color = {0, 0, 127}));
  connect(gain1.u, idPccPu) annotation(
    Line(points = {{-62, 0}, {-110, 0}}, color = {0, 0, 127}));
  connect(QFilterPu, firstOrder1.u) annotation(
    Line(points = {{-110, 40}, {-92, 40}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{-51, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{-39, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(gain2.u, iqPccPu) annotation(
    Line(points = {{-62, -40}, {-110, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{-69, 40}, {-60, 40}, {-60, 72}}, color = {0, 0, 127}));
  connect(DeltaVVIdPu, feedback5.u2) annotation(
    Line(points = {{-110, -20}, {80, -20}, {80, 72}}, color = {0, 0, 127}));
  connect(gain2.y, firstOrder3.u) annotation(
    Line(points = {{-39, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(URefPu, add2.u2) annotation(
    Line(points = {{-110, 20}, {-10, 20}, {-10, 74}, {-2, 74}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-19, 80}, {-10.5, 80}, {-10.5, 86}, {-2, 86}}, color = {0, 0, 127}));
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{49, 80}, {72, 80}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{21, 80}, {32, 80}}, color = {0, 0, 127}));
  connect(feedback7.y, uqFilterRefPu) annotation(
    Line(points = {{89, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(DeltaVVIqPu, feedback7.u2) annotation(
    Line(points = {{-110, -60}, {80, -60}, {80, -48}}, color = {0, 0, 127}));
  connect(QFilterRefPu, feedback3.u1) annotation(
    Line(points = {{-110, 80}, {-68, 80}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u1) annotation(
    Line(points = {{1, 0}, {12, 0}}, color = {0, 0, 127}));
  connect(feedback.y, feedback4.u2) annotation(
    Line(points = {{29, 0}, {40, 0}, {40, 72}}, color = {0, 0, 127}));
  connect(gain1.y, feedback.u2) annotation(
    Line(points = {{-39, 0}, {-29, 0}, {-29, -18}, {20, -18}, {20, -8}}, color = {0, 0, 127}));
  connect(gain2.y, feedback1.u2) annotation(
    Line(points = {{-39, -40}, {-29, -40}, {-29, -58}, {20, -58}, {20, -48}}, color = {0, 0, 127}));
  connect(firstOrder3.y, feedback1.u1) annotation(
    Line(points = {{1, -40}, {12, -40}}, color = {0, 0, 127}));
  connect(feedback1.y, feedback7.u1) annotation(
    Line(points = {{29, -40}, {72, -40}}, color = {0, 0, 127}));

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
<p>The voltage drop of the virtual impedance (DeltaVVIdPu, DeltaVVIqPu), computed by a dedicated block (e.g. VirtualImpedance2CC), is directly subtracted from the voltage reference. This virtual impedance is typically activated only above a current threshold, to limit the converter current during faults.</p>

<h4>Initialization</h4>
<p>The start values of the outputs are consistent with the equations above in steady state, where the output of the high-pass filter of the active damping is zero:</p>
<p>U<sub>dRef0</sub> = U<sub>Ref0</sub> + M<sub>q</sub> &middot; (Q<sub>FilterRef0</sub> &minus; Q<sub>Filter0</sub>) &minus; &Delta;V<sub>VId0</sub></p>
<p>U<sub>qRef0</sub> = &minus; &Delta;V<sub>VIq0</sub></p>
<p>The internal low-pass filters of the active damping start at their steady-state input values, K<sub>ff</sub> &middot; I<sub>dPcc0</sub> and &minus; K<sub>ff</sub> &middot; I<sub>qPcc0</sub>.</p>
</body></html>"));
end VoltageReferenceControl;
