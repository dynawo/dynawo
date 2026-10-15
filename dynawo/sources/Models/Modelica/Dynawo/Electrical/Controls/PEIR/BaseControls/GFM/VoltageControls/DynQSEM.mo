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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DynQSEM "Quasi-Static Electrical Model"

  parameter Types.PerUnit RFilterPu "Resistance between the filter capacitor and the PCC in pu (base UNom, SNom) (transformer resistance in the GFM controls using this block)";
  parameter Types.PerUnit LFilterPu "Inductance between the filter capacitor and the PCC in pu (base UNom, SNom) (transformer inductance in the GFM controls using this block)";
  parameter Types.PerUnit XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";

  Modelica.Blocks.Interfaces.RealInput udFilteredPCCPu(start = UdPcc0Pu) "Filtered d-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30.5, -109.5}, extent = {{-9.5, -9.5}, {9.5, 9.5}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterRefPu(start = UdFilter0Pu) "d-axis voltage reference after the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-109, 41}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterRefPu(start = UqFilter0Pu) "q-axis voltage reference after the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilteredPCCPu(start = UqPcc0Pu) "Filtered q-axis voltage at PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {29, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.AngularVelocityPu Omega0Pu = SystemBase.omega0Pu "Start value of converter's frequency in pu (base omegaNom)";

equation

  [idConvRefPu; iqConvRefPu] = 1/(RFilterPu^2 + (LFilterPu*omegaPu + XVIPu)^2)*[RFilterPu, LFilterPu*omegaPu + XVIPu; -(LFilterPu*omegaPu + XVIPu), RFilterPu] * [udFilterRefPu-udFilteredPCCPu; uqFilterRefPu-uqFilteredPCCPu];

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1})),
    Documentation(info = "<html><head></head><body>
<p>This model is a Quasi-Static Electrical Model (QSEM) used in grid-forming controls to compute the converter current references from a voltage reference, giving its name to Current-Controlled GFMs. Instead of regulating the filter capacitor voltage with a voltage loop, it emulates a <b>voltage source behind an impedance</b>: the voltage reference (udFilterRefPu, uqFilterRefPu), provided by the voltage reference control, is considered as an internal electromotive force E, connected to the measured PCC voltage V (udFilteredPCCPu, uqFilteredPCCPu) through an impedance Z. The current flowing through this impedance is used as the reference of the inner current loop:</p>
<p><b>I</b><sub>ConvRef</sub> = (<b>E</b> &minus; <b>V</b>) / Z, with Z = R + jX and X = L &middot; &omega; + X<sub>VI</sub></p>
<p>where R = RFilterPu, L = LFilterPu, X<sub>VI</sub> = XVIPu and &omega; = omegaPu is the converter frequency (provided by the power-angle control, e.g. VSM). In the dq frame (generator convention):</p>
<p>i<sub>dConvRef</sub> = [R &middot; (u<sub>dFilterRef</sub> &minus; u<sub>dPcc</sub>) + X &middot; (u<sub>qFilterRef</sub> &minus; u<sub>qPcc</sub>)] / (R<sup>2</sup> + X<sup>2</sup>)</p>
<p>i<sub>qConvRef</sub> = [R &middot; (u<sub>qFilterRef</sub> &minus; u<sub>qPcc</sub>) &minus; X &middot; (u<sub>dFilterRef</sub> &minus; u<sub>dPcc</sub>)] / (R<sup>2</sup> + X<sup>2</sup>)</p>

<h4>Quasi-static assumption</h4>
<p>The impedance is represented by its steady-state (phasor) relation: the dynamic term L &middot; di/dt is neglected and only the frequency-dependent reactance L &middot; &omega; is kept. The model is therefore purely algebraic :
the current references react instantaneously to any change of the PCC voltage (voltage dip, phase jump), which provides the inherent grid-forming behaviour of a voltage source behind an impedance.

<h4>Impedance</h4>
<ul>
<li>In the grid-forming controls using this block, RFilterPu and LFilterPu are set to the <b>transformer</b> resistance and inductance (RTransformerPu, LTransformerPu): the voltage reference is the voltage at the filter capacitor and Z is the physical impedance between this capacitor and the PCC. The role of the QSEM is thus to compensate for the voltage drop inherent to the transformer.</li>
<li>XVIPu is a <b>permanent virtual reactance</b> added to the physical one. It increases the equivalent impedance seen by the grid, which reduces the current variations caused by grid disturbances and decouples the converter from the grid. The  numerical value is usually adjusted to be compliant with grid code requirements.</li>
</ul>

<h4>Initialization</h4>
<p>The start values of the voltage reference (UdFilter0Pu, UqFilter0Pu) must be consistent with the QSEM equation, i.e. E<sub>0</sub> = V<sub>0</sub> + Z<sub>0</sub> &middot; I<sub>Conv0</sub> with Z<sub>0</sub> = R + j(L &middot; &Omega;<sub>0</sub> + X<sub>VI</sub>). This is done in the parent controls (UdFilterRef0Pu, UqFilterRef0Pu).</p>
</body></html>"));
end DynQSEM;
