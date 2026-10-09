within Dynawo.Electrical.Controls.Converters.BaseControls;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DroopControl "Droop control for grid forming converters"

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Omegaff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";

  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UFilterRef0Pu) "Voltage module reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {130,40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {130, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdFilter0Pu) "d-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = UqFilter0Pu) "q-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -99}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain (k = Mp)annotation(
    Placement(visible = true, transformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1 / Omegaf, y_start = Mp * (PRef0Pu - PFilter0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-20, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {20, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {70, 94}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {100, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 1 / Omegaf, y_start = QFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kff) annotation(
    Placement(visible = true, transformation(origin = {-50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = -Kff) annotation(
    Placement(visible = true, transformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 1 / Omegaff, y_start = Kff * IdPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 1 / Omegaff, y_start = -Kff * IqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Mq) annotation(
    Placement(visible = true, transformation(origin = {-50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {20, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {50, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {80, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {80, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaSetPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu PRef0Pu "Start value of the active power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";
  parameter Types.VoltageModulePu UFilterRef0Pu "Start value of voltage module reference at the converter's capacitor in pu (base UNom)";

equation
  connect(feedback1.u1, PRefPu) annotation(
    Line(points = {{-88, 100}, {-130, 100}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-71, 100}, {-62, 100}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{-39, 100}, {-32, 100}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{31, 94}, {40, 94}, {40, 40}, {130, 40}}, color = {0, 0, 127}));
  connect(add1.y, feedback2.u1) annotation(
    Line(points = {{31, 94}, {62, 94}}, color = {0, 0, 127}));
  connect(integrator.u, feedback2.y) annotation(
    Line(points = {{88, 94}, {79, 94}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{111, 94}, {130, 94}}, color = {0, 0, 127}));
  connect(gain1.u, idPccPu) annotation(
    Line(points = {{-62, -70}, {-130, -70}}, color = {0, 0, 127}));
  connect(gain2.u, iqPccPu) annotation(
    Line(points = {{-62, -110}, {-130, -110}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{-39, -70}, {-32, -70}}, color = {0, 0, 127}));
  connect(gain2.y, firstOrder3.u) annotation(
    Line(points = {{-39, -110}, {-32, -110}}, color = {0, 0, 127}));
  connect(feedback3.u1, QRefPu) annotation(
    Line(points = {{-88, 10}, {-130, 10}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{-71, 10}, {-62, 10}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{31, 4}, {42, 4}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback4.u2) annotation(
    Line(points = {{-9, -70}, {50, -70}, {50, -4}}, color = {0, 0, 127}));
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{59, 4}, {72, 4}}, color = {0, 0, 127}));
  connect(feedback5.y, udFilterRefPu) annotation(
    Line(points = {{89, 4}, {130, 4}}, color = {0, 0, 127}));
  connect(DeltaVVIq, feedback7.u2) annotation(
    Line(points = {{-130, -130}, {80, -130}, {80, -118}}, color = {0, 0, 127}));
  connect(feedback7.y, uqFilterRefPu) annotation(
    Line(points = {{89, -110}, {130, -110}}, color = {0, 0, 127}));
  connect(PFilterPu, feedback1.u2) annotation(
    Line(points = {{-130, 70}, {-80, 70}, {-80, 92}}, color = {0, 0, 127}));
  connect(QFilterPu, firstOrder1.u) annotation(
    Line(points = {{-130, -20}, {-112, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-9, 100}, {8, 100}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback3.u2) annotation(
    Line(points = {{-89, -20}, {-80, -20}, {-80, 2}}, color = {0, 0, 127}));
  connect(omegaSetPu.y, add1.u2) annotation(
    Line(points = {{-119, 40}, {0, 40}, {0, 88}, {8, 88}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-39, 10}, {8, 10}}, color = {0, 0, 127}));
  connect(UFilterRefPu, add2.u2) annotation(
    Line(points = {{-130, -50}, {0, -50}, {0, -2}, {8, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-130, 120}, {70, 120}, {70, 102}}, color = {0, 0, 127}));
  connect(firstOrder3.y, feedback7.u1) annotation(
    Line(points = {{-9, -110}, {72, -110}}, color = {0, 0, 127}));
  connect(DeltaVVId, feedback5.u2) annotation(
    Line(points = {{-130, -90}, {80, -90}, {80, -4}}, color = {0, 0, 127}));

  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -140}, {120, 140}})),
    Documentation(info = "<html><head></head><body>
<p>This model is the outer (synchronization) control of a grid-forming converter based on droop control. It computes the converter frequency and angle (omegaPu, theta) from the active power, and the dq voltage reference at the filter capacitor (udFilterRefPu, uqFilterRefPu) from the reactive power, following the principles described in the MIGRATE project, Deliverable 3.2 (T. Qoria et al., 2018), sections I.1 and I.2.</p>

<h4>Active power / frequency droop</h4>
<p>The frequency of the converter is deduced from the active power error (\"inverse\" droop), filtered by a first order low-pass filter of cutoff pulsation &omega;<sub>f</sub> (Omegaf, in rad/s):</p>
<p>&omega; = &omega;<sub>Set</sub> + M<sub>p</sub> &middot; (P<sub>Ref</sub> &minus; P<sub>Filter</sub>) / (1 + s / &omega;<sub>f</sub>)</p>
<p>d&theta;/dt = &omega;<sub>Nom</sub> &middot; (&omega; &minus; &omega;<sub>Ref</sub>)</p>
<p>where &omega;<sub>Set</sub> is a constant frequency set point equal to SystemBase.omegaRef0Pu (1 pu), M<sub>p</sub> (Mp) is the active power droop coefficient (in pu frequency per pu active power) and &omega;<sub>Ref</sub> (omegaRefPu) is the frequency of the reference rotating frame in which the angle &theta; is expressed. The low-pass filter avoids fast frequency variations, filters the power measurement noise and sets the active power response time.</p>
<p>In steady state, &omega; is equal to the grid frequency &omega;<sub>g</sub> and:</p>
<p>P<sub>Filter</sub> = P<sub>Ref</sub> &minus; (&omega;<sub>g</sub> &minus; &omega;<sub>Set</sub>) / M<sub>p</sub></p>
<p>i.e. the converter participates in the primary frequency control with a permanent droop M<sub>p</sub> (typically a few %), similarly to a synchronous machine.</p>

<h4>Equivalence with a Virtual Synchronous Machine</h4>
<p>In the time domain, the droop equation reads (MIGRATE D3.2, eq. 33):</p>
<p>1 / (&omega;<sub>f</sub> &middot; M<sub>p</sub>) &middot; d&omega;/dt = P<sub>Ref</sub> &minus; P<sub>Filter</sub> &minus; (1 / M<sub>p</sub>) &middot; (&omega; &minus; &omega;<sub>Set</sub>) + 1 / (&omega;<sub>f</sub> &middot; M<sub>p</sub>) &middot; d&omega;<sub>Set</sub>/dt</p>
<p>The last term comes from the fact that &omega;<sub>Set</sub> is added after the low-pass filter. As stated in the report (section I.2.1, eq. 34), the droop control is equivalent to a VSM only for a constant &omega;<sub>Set</sub>, which is the case in this model (&omega;<sub>Set</sub> = SystemBase.omegaRef0Pu). The last term then vanishes and the equation is exactly the swing equation of a VSM, 2H &middot; d&omega;/dt = P<sub>Ref</sub> &minus; P<sub>Filter</sub> &minus; k<sub>VSM</sub> &middot; (&omega; &minus; &omega;<sub>Set</sub>), with:</p>
<p>H = 1 / (2 &middot; &omega;<sub>f</sub> &middot; M<sub>p</sub>) and k<sub>VSM</sub> = 1 / M<sub>p</sub></p>
<p>For example, M<sub>p</sub> = 5 % and &omega;<sub>f</sub> = 31.4 rad/s lead to H &asymp; 0.32 s and k<sub>VSM</sub> = 20: a usual droop tuning provides a low inertia, whereas a usual VSM tuning (e.g. H = 5 s, k<sub>VSM</sub> = 300) corresponds to a very low droop (M<sub>p</sub> &asymp; 0.3 %), i.e. poor load sharing capability.</p>
<p><b>Note:</b> the VSM controls of the PEIR library (e.g. DynGridFormingControlVSM) are not equivalent to this droop control, because their &omega;<sub>Set</sub> is not a constant set point but the grid frequency measured by a PLL. This differs from the assumption of the report, where &omega;<sub>Set</sub> is a fixed set point for both controls, and has two consequences:</p>
<ul>
<li>in transient, &omega;<sub>Set</sub> varies, so that the equivalence above no longer holds;</li>
<li>in steady state, &omega; tends to &omega;<sub>Set</sub> = &omega;<sub>PLL</sub> = &omega;<sub>g</sub> and P<sub>Filter</sub> = P<sub>Ref</sub>: the damping term only acts on the deviation between the converter and the grid frequencies, and the PEIR VSM provides inertia without permanent droop, whereas this droop control keeps a permanent droop 1 / M<sub>p</sub>.</li>
</ul>

<h4>Small-signal analysis</h4>
<p>Assuming a stiff grid (&omega;<sub>g</sub> = &omega;<sub>Ref</sub> = &omega;<sub>Set</sub>), fast inner loops, neglected resistances and small variations around an operating point, &Delta;P<sub>Filter</sub> = K<sub>S</sub> &middot; &Delta;&theta; with K<sub>S</sub> = E &middot; V &middot; cos(&theta;<sub>0</sub>) / X the synchronizing power coefficient (cf. documentation of the VSM block in Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls). The closed-loop active power response is then of second order:</p>
<p>d<sup>2</sup>&Delta;P/dt<sup>2</sup> + &omega;<sub>f</sub> &middot; d&Delta;P/dt + &omega;<sub>f</sub> &middot; M<sub>p</sub> &middot; K<sub>S</sub> &middot; &omega;<sub>Nom</sub> &middot; &Delta;P = &omega;<sub>f</sub> &middot; M<sub>p</sub> &middot; K<sub>S</sub> &middot; &omega;<sub>Nom</sub> &middot; &Delta;P<sub>Ref</sub></p>
<ul>
<li>natural angular frequency (in rad/s): &omega;<sub>n</sub> = &radic;(&omega;<sub>f</sub> &middot; M<sub>p</sub> &middot; K<sub>S</sub> &middot; &omega;<sub>Nom</sub>)</li>
<li>damping ratio: &zeta; = &omega;<sub>f</sub> / (2 &omega;<sub>n</sub>) = (1/2) &middot; &radic;(&omega;<sub>f</sub> / (M<sub>p</sub> &middot; K<sub>S</sub> &middot; &omega;<sub>Nom</sub>))</li>
</ul>
<p>These expressions are identical to the ones of the VSM block with the above equivalence. Decreasing &omega;<sub>f</sub> increases the equivalent inertia but decreases the damping of the active power response. Without filter (&omega;<sub>f</sub> &rarr; &infin;), the response is of first order with a time constant 1 / (M<sub>p</sub> &middot; K<sub>S</sub> &middot; &omega;<sub>Nom</sub>).</p>

<h4>Voltage reference</h4>
<p>The dq voltage reference is computed as in the VoltageReferenceControl block (Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls), see its documentation for details:</p>
<p>u<sub>dFilterRef</sub> = U<sub>FilterRef</sub> + M<sub>q</sub> &middot; (Q<sub>Ref</sub> &minus; Q<sub>Filter</sub> / (1 + s / &omega;<sub>f</sub>)) &minus; K<sub>ff</sub> &middot; i<sub>dPcc</sub> / (1 + s / &omega;<sub>ff</sub>) &minus; &Delta;V<sub>VId</sub></p>
<p>u<sub>qFilterRef</sub> = &minus; K<sub>ff</sub> &middot; i<sub>qPcc</sub> / (1 + s / &omega;<sub>ff</sub>) &minus; &Delta;V<sub>VIq</sub></p>
<ul>
<li>reactive power / voltage droop of coefficient M<sub>q</sub> (Mq), the reactive power being filtered with the same cutoff pulsation &omega;<sub>f</sub> as the active power;</li>
<li>active damping of gain K<sub>ff</sub> (Kff) and cutoff pulsation &omega;<sub>ff</sub> (Omegaff, in rad/s), equivalent to a virtual resistance;</li>
<li>voltage drop of the virtual impedance (DeltaVVId, DeltaVVIq), used for current limitation.</li>
</ul>
<p><b>Note:</b> in the MIGRATE report, the active damping is a <i>transient</i> virtual resistance, i.e. a high-pass filtered term &minus; K<sub>ff</sub> &middot; i &middot; (s / &omega;<sub>ff</sub>) / (1 + s / &omega;<sub>ff</sub>) which vanishes in steady state. Here, the current is low-pass filtered, so that the virtual resistance remains active in steady state and introduces a small permanent voltage drop K<sub>ff</sub> &middot; i<sub>Pcc</sub>.</p>
</body></html>"));
end DroopControl;
