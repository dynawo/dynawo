within Dynawo.Electrical.Controls.PEIR.BaseControls;

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

model VirtualImpedance2CC "Virtual impedance model for the current limitation of grid forming converters, with a bounded correction to avoid loop-gain runaway"

  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVIPu "Current threshold above which the virtual impedance activates in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvMaxPu "Maximum extra current module used to compute RVI/XVI, in pu (base UNom, SNom): bounds the virtual impedance correction regardless of how large the measured current becomes";

  parameter Types.CurrentModulePu HysteresisPu = 0.02 "Half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold";

  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Boolean virtualImpedanceActive(start = IConv0Pu >= IMaxVIPu) "True while the virtual impedance correction is active (above IMaxVI+HysteresisPu)";
  Modelica.Blocks.Interfaces.BooleanOutput BlocVirtualImpedance_Enable(start = false) "True while the virtual impedance correction is active (above IMaxVI+HysteresisPu)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Types.CurrentModulePu IConvPu(start = IConv0Pu) "Current module in the converter in pu (base UNom, SNom)";
  Types.CurrentModulePu DeltaIConvPu(start = DeltaIConv0Pu) "Extra current module in the converter in pu (base UNom, SNom), bounded by DeltaIConvMaxPu";
  Types.PerUnit RVI(start = RVI0) "Virtual resistance in pu (base UNom, SNom)";
  Types.PerUnit XVI(start = XVI0) "Virtual reactance in pu (base UNom, SNom)";

  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";

  final parameter Types.CurrentModulePu IConv0Pu = sqrt(IdConv0Pu ^ 2 + IqConv0Pu ^ 2)  "Start value of current module in the converter in pu (base UNom, SNom)";
  final parameter Types.CurrentModulePu DeltaIConv0Pu = min(max((IConv0Pu - IMaxVIPu), 0), DeltaIConvMaxPu) "Start value of extra current module in the converter in pu (base UNom, SNom)";
  final parameter Types.PerUnit RVI0 = KpVI * DeltaIConv0Pu "Start value of virtual resistance in pu (base UNom, SNom)";
  final parameter Types.PerUnit XVI0 = RVI0 * XRratio "Start value of virtual reactance in pu (base UNom, SNom)";
  final parameter Types.PerUnit DeltaVVId0 = IdConv0Pu * RVI0 - IqConv0Pu * XVI0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  final parameter Types.PerUnit DeltaVVIq0 = IqConv0Pu * RVI0 + IdConv0Pu * XVI0 "Start value of q-axis virtual impedance output in pu (base UNom)";

equation
  IConvPu = sqrt(idConvPu ^ 2 + iqConvPu ^ 2);

  when IConvPu >= IMaxVIPu + HysteresisPu then
    virtualImpedanceActive = true;
  elsewhen IConvPu <= IMaxVIPu - HysteresisPu then
    virtualImpedanceActive = false;
  end when;

  if virtualImpedanceActive then
    DeltaIConvPu = min(max((IConvPu - IMaxVIPu), 0), DeltaIConvMaxPu);
    RVI = KpVI * DeltaIConvPu;
    XVI = RVI * XRratio;
  else
    DeltaIConvPu = 0;
    RVI = 0;
    XVI = 0;
  end if;

  BlocVirtualImpedance_Enable = virtualImpedanceActive;

  DeltaVVId = idConvPu * RVI - iqConvPu * XVI;
  DeltaVVIq = iqConvPu * RVI + idConvPu * XVI;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>
<p>This model computes a virtual impedance for the current limitation of grid-forming converters, with the same principle as the VirtualImpedance2 block (cf. its documentation for the principle, the equations and the tuning of KpVI): when the converter current module exceeds I<sub>MaxVI</sub> (IMaxVIPu), a virtual impedance Z<sub>VI</sub> = R<sub>VI</sub> + jX<sub>VI</sub>, proportional to the overcurrent, is activated and its voltage drop (DeltaVVId, DeltaVVIq) is subtracted from the voltage reference:</p>
<p>&Delta;V<sub>VId</sub> = R<sub>VI</sub> &middot; i<sub>dConv</sub> &minus; X<sub>VI</sub> &middot; i<sub>qConv</sub>, &Delta;V<sub>VIq</sub> = R<sub>VI</sub> &middot; i<sub>qConv</sub> + X<sub>VI</sub> &middot; i<sub>dConv</sub></p>
<p>It differs from VirtualImpedance2 by two features, intended for its use together with a current saturation (CurrentSaturation block) in DynGridFormingControlCCVSM.</p>

<h4>Bounded virtual impedance</h4>
<p>The overcurrent used to compute the virtual impedance is capped at &Delta;I<sub>ConvMax</sub> (DeltaIConvMaxPu):</p>
<p>&Delta;I<sub>Conv</sub> = min(max(I<sub>Conv</sub> &minus; I<sub>MaxVI</sub>, 0), &Delta;I<sub>ConvMax</sub>)</p>
<p>R<sub>VI</sub> = K<sub>pVI</sub> &middot; &Delta;I<sub>Conv</sub>, X<sub>VI</sub> = &sigma;<sub>X/R</sub> &middot; R<sub>VI</sub></p>
<p>so that the virtual impedance module is bounded by |Z<sub>VI</sub>|<sub>max</sub> = K<sub>pVI</sub> &middot; &Delta;I<sub>ConvMax</sub> &middot; &radic;(1 + &sigma;<sub>X/R</sub><sup>2</sup>) (e.g. 0.6 &middot; 0.15 &middot; &radic;101 &asymp; 0.9 pu with K<sub>pVI</sub> = 0.6, &Delta;I<sub>ConvMax</sub> = 0.15 pu and &sigma;<sub>X/R</sub> = 10). This avoids a runaway of the loop gain (the virtual impedance would otherwise grow with the current, which itself depends on the virtual impedance) for very large overcurrents. Beyond I<sub>MaxVI</sub> + &Delta;I<sub>ConvMax</sub>, the virtual impedance no longer increases and the current is limited by the current saturation.</p>

<h4>Activation with hysteresis</h4>
<p>The virtual impedance is activated and deactivated with a hysteresis of half-width HysteresisPu around I<sub>MaxVI</sub>, to avoid chattering when the current module oscillates around the threshold:</p>
<ul>
<li>activation when I<sub>Conv</sub> &ge; I<sub>MaxVI</sub> + HysteresisPu;</li>
<li>deactivation when I<sub>Conv</sub> &le; I<sub>MaxVI</sub> &minus; HysteresisPu;</li>
<li>between these two thresholds, the previous state (active or inactive) is kept.</li>
</ul>
<p>The hysteresis only acts on the activation state: while active, R<sub>VI</sub> and X<sub>VI</sub> continuously follow the overcurrent (and are equal to zero when I<sub>Conv</sub> &lt; I<sub>MaxVI</sub>); while inactive, they are equal to zero. Consequently, the virtual impedance is continuous at deactivation, but steps from zero to K<sub>pVI</sub> &middot; HysteresisPu &middot; (1 + j&sigma;<sub>X/R</sub>) at activation (e.g. 0.6 &middot; 0.02 = 0.012 pu for R<sub>VI</sub>).</p>
<p>The activation state is provided on the BlocVirtualImpedance_Enable output, for information only.</p>
</body></html>"),
    Icon(coordinateSystem(grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1})));
end VirtualImpedance2CC;
