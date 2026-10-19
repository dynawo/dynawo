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

model VirtualImpedance2 "Virtual impedance model for the current limitation of grid forming converters"

  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVIPu "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu EpsVIUpPu "Upper half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold";
  parameter Types.CurrentModulePu EpsVIDownPu "Lower half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold";

  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput DeltaVVIdPu(start = DeltaVVId0Pu) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIqPu(start = DeltaVVIq0Pu) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.CurrentModulePu IConvPu(start = IConv0Pu) "Current module in the converter in pu (base UNom, SNom)";
  Types.CurrentModulePu DeltaIConvPu(start = DeltaIConv0Pu) "Extra current module in the converter in pu (base UNom, SNom)";
  Types.PerUnit RVIPu(start = RVI0Pu) "Virtual resistance in pu (base UNom, SNom)";
  Types.PerUnit XVIPu(start = XVI0Pu) "Virtual reactance in pu (base UNom, SNom)";

  Boolean virtualImpedanceActive(start = VIActive0) "True while the virtual impedance correction is active (above IMaxVI+HysteresisPu)";
  Modelica.Blocks.Interfaces.BooleanOutput BlocVirtualImpedance_Enable(start = VIActive0) "True while the virtual impedance correction is active (above IMaxVI+HysteresisPu)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";

  final parameter Types.CurrentModulePu IConv0Pu = sqrt(IdConv0Pu ^ 2 + IqConv0Pu ^ 2)  "Start value of current module in the converter in pu (base UNom, SNom)";
  final parameter Boolean VIActive0 = IConv0Pu >= IMaxVIPu "Initial state of the virtual impedance: active if the initial converter current module is above IMaxVI";
  final parameter Types.CurrentModulePu DeltaIConv0Pu = if VIActive0 then max((IConv0Pu - IMaxVIPu), 0) else 0 "Start value of extra current module in the converter in pu (base UNom, SNom)";
  final parameter Types.PerUnit RVI0Pu = if VIActive0 then KpVI * DeltaIConv0Pu else 0 "Start value of virtual resistance in pu (base UNom, SNom)";
  final parameter Types.PerUnit XVI0Pu = if VIActive0 then RVI0Pu * XRratio else 0 "Start value of virtual reactance in pu (base UNom, SNom)";
  final parameter Types.PerUnit DeltaVVId0Pu = IdConv0Pu * RVI0Pu - IqConv0Pu * XVI0Pu "Start value of d-axis virtual impedance output in pu (base UNom)";
  final parameter Types.PerUnit DeltaVVIq0Pu = IqConv0Pu * RVI0Pu + IdConv0Pu * XVI0Pu "Start value of q-axis virtual impedance output in pu (base UNom)";

equation
  IConvPu = sqrt(idConvPu ^ 2 + iqConvPu ^ 2);

  when IConvPu >= IMaxVIPu + EpsVIUpPu then
    virtualImpedanceActive = true;
  elsewhen IConvPu <= IMaxVIPu - EpsVIDownPu then
    virtualImpedanceActive = false;
  end when;

  if virtualImpedanceActive then
    DeltaIConvPu = max((IConvPu - IMaxVIPu), 0);
    RVIPu = KpVI * DeltaIConvPu;
    XVIPu = RVIPu * XRratio;
  else
    DeltaIConvPu = 0;
    RVIPu = 0;
    XVIPu = 0;
  end if;

  BlocVirtualImpedance_Enable = virtualImpedanceActive;

  DeltaVVIdPu = idConvPu * RVIPu - iqConvPu * XVIPu;
  DeltaVVIqPu = iqConvPu * RVIPu + idConvPu * XVIPu;

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1})),
    Documentation(info = "<html><head></head><body>
<p>This model computes a <b>virtual impedance</b> used to limit the current of a grid-forming converter during overcurrents (faults, heavy load connections, line trippings).</p>
<p>As a grid-forming converter behaves as a voltage source, its current increases up to unacceptable values when the grid voltage drops. Since adding a physical impedance is not possible, a virtual impedance is emulated by the control: its voltage drop (DeltaVVIdPu, DeltaVVIqPu) is subtracted from the voltage reference (cf. VoltageReferenceControl or DroopControl), which reduces the internal voltage of the converter, hence its current.</p>

<h4>Equations</h4>
<p>The virtual impedance Z<sub>VI</sub> = R<sub>VI</sub> + jX<sub>VI</sub> is only activated when the converter current module exceeds the threshold I<sub>MaxVI</sub> (IMaxVIPu), and increases proportionally to the overcurrent:</p>
<p>I<sub>Conv</sub> = &radic;(i<sub>dConv</sub><sup>2</sup> + i<sub>qConv</sub><sup>2</sup>)</p>
<p>&Delta;I<sub>Conv</sub> = max(I<sub>Conv</sub> &minus; I<sub>MaxVI</sub>, 0)</p>
<p>R<sub>VI</sub> = K<sub>pVI</sub> &middot; &Delta;I<sub>Conv</sub>, X<sub>VI</sub> = &sigma;<sub>X/R</sub> &middot; R<sub>VI</sub></p>
<p>where K<sub>pVI</sub> (KpVI) is the proportional gain of the virtual impedance and &sigma;<sub>X/R</sub> (XRratio) its constant X/R ratio. The output is the voltage drop &Delta;<b>V</b><sub>VI</sub> = Z<sub>VI</sub> &middot; <b>I</b><sub>Conv</sub> in the dq frame:</p>
<p>&Delta;V<sub>VId</sub> = R<sub>VI</sub> &middot; i<sub>dConv</sub> &minus; X<sub>VI</sub> &middot; i<sub>qConv</sub></p>
<p>&Delta;V<sub>VIq</sub> = R<sub>VI</sub> &middot; i<sub>qConv</sub> + X<sub>VI</sub> &middot; i<sub>dConv</sub></p>
<p>Below the threshold, Z<sub>VI</sub> = 0 and the block has no effect on the control.</p>

<h4>Current limitation and tuning</h4>
<p>As R<sub>VI</sub> depends on the overcurrent itself, the current is not strictly limited to I<sub>MaxVI</sub>: I<sub>MaxVI</sub> is the activation threshold, and the current settles to a value I<sub>Lim</sub> &gt; I<sub>MaxVI</sub> determined by K<sub>pVI</sub>. For a bolted fault close to the converter (grid voltage close to zero), neglecting resistances and assuming fast inner loops, the internal voltage E is entirely consumed by the physical reactance X (between the converter and the fault) and the virtual impedance, so that approximately:</p>
<p>E &asymp; (X + K<sub>pVI</sub> &middot; (I<sub>Lim</sub> &minus; I<sub>MaxVI</sub>) &middot; &radic;(1 + &sigma;<sub>X/R</sub><sup>2</sup>)) &middot; I<sub>Lim</sub></p>
<p>which gives K<sub>pVI</sub> for a desired current limit I<sub>Lim</sub>. For example, with the parameters of the MIGRATE report (E = 1 pu, X = 0.15 pu, I<sub>MaxVI</sub> = 1 pu, K<sub>pVI</sub> = 0.67 pu, &sigma;<sub>X/R</sub> = 5), I<sub>Lim</sub> &asymp; 1.2 pu.</p>
<p>A high X/R ratio keeps a mainly inductive output impedance, consistent with the decoupling between active power / angle and reactive power / voltage on which the outer controls (VSM, droop) rely.</p>

<h4>Limitations</h4>
<ul>
<li>The model is purely algebraic: the virtual impedance acts instantaneously on the voltage reference, but the actual current limitation depends on the dynamics of the downstream voltage/current control. In the MIGRATE report, the virtual impedance alone is too slow to limit the first current peak, which is why it is combined with a current saturation (hybrid current limitation control, section III.3).</li>
<li>There is no hysteresis around the threshold and no bound on the virtual impedance: see VirtualImpedance2CC for a variant with a capped overcurrent (DeltaIConvMaxPu) and a hysteresis band, used with the current saturation in DynGridFormingControlCCVSM.</li>
</ul>
<p>This block is used in DynGridFormingControlVSM and DynGridFormingControlDroop. Its initial state is computed from the initial converter current (IdConv0Pu, IqConv0Pu): the virtual impedance is active at t = 0 (VIActive0 = true) if the initial current module is above IMaxVIPu, and inactive otherwise. The start values of the virtual impedance (DeltaIConv0Pu, RVI0Pu, XVI0Pu) and of its output (DeltaVVId0Pu, DeltaVVIq0Pu) are then derived from this initial state, which is also the start value of virtualImpedanceActive and of BlocVirtualImpedance_Enable.</p>
</body></html>"));
end VirtualImpedance2;
