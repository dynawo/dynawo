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
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VirtualImpedance2CC "Virtual impedance model for the current limitation of grid forming converters, with a bounded correction to avoid loop-gain runaway"

  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu DeltaIConvMaxPu "Maximum extra current module used to compute RVI/XVI, in pu (base UNom, SNom): bounds the virtual impedance correction regardless of how large the measured current becomes";

  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.CurrentModulePu IConvPu(start = IConv0Pu) "Current module in the converter in pu (base UNom, SNom)";
  Types.CurrentModulePu DeltaIConvPu(start = DeltaIConv0Pu) "Extra current module in the converter in pu (base UNom, SNom), bounded by DeltaIConvMaxPu";
  Types.PerUnit RVI(start = RVI0) "Virtual resistance in pu (base UNom, SNom)";
  Types.PerUnit XVI(start = XVI0) "Virtual reactance in pu (base UNom, SNom)";

  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  final parameter Types.CurrentModulePu IConv0Pu = sqrt(IdConv0Pu ^ 2 + IqConv0Pu ^ 2)  "Start value of current module in the converter in pu (base UNom, SNom)";
  final parameter Types.CurrentModulePu DeltaIConv0Pu = min(max((IConv0Pu - IMaxVI), 0), DeltaIConvMaxPu) "Start value of extra current module in the converter in pu (base UNom, SNom)";
  final parameter Types.PerUnit RVI0 = KpVI * DeltaIConv0Pu "Start value of virtual resistance in pu (base UNom, SNom)";
  final parameter Types.PerUnit XVI0 = RVI0 * XRratio "Start value of virtual reactance in pu (base UNom, SNom)";
  final parameter Types.PerUnit DeltaVVId0 = IdConv0Pu * RVI0 - IqConv0Pu * XVI0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  final parameter Types.PerUnit DeltaVVIq0 = IqConv0Pu * RVI0 + IdConv0Pu * XVI0 "Start value of q-axis virtual impedance output in pu (base UNom)";

equation
  IConvPu = sqrt(idConvPu ^ 2 + iqConvPu ^ 2);
  // CHANGE vs VirtualImpedance2: DeltaIConvPu is now capped at DeltaIConvMaxPu.
  // Rationale: RVI/XVI scale linearly with DeltaIConvPu, and DeltaVVId/DeltaVVIq scale as (current)*(RVI/XVI),
  // i.e. quadratically in the current itself once IConvPu is large. Composed with QSEM's algebraic gain
  // (~1/sqrt(R^2+X^2), typically well above 1 for a small transformer/filter impedance), the effective loop
  // gain d(DeltaVV)/dI grows with I itself: for any KpVI>0 there exists a current I* above which the loop
  // gain exceeds 1 and the correction becomes self-reinforcing instead of corrective (observed empirically:
  // reducing KpVI by ~12x barely changed the runaway amplitude). Capping DeltaIConvPu bounds RVI/XVI/DeltaVV
  // to a fixed maximum regardless of how large the measured current becomes, removing that runaway mechanism.
  DeltaIConvPu = min(max((IConvPu - IMaxVI), 0), DeltaIConvMaxPu);
  RVI = KpVI * DeltaIConvPu;
  XVI = RVI * XRratio;
  DeltaVVId = idConvPu * RVI - iqConvPu * XVI;
  DeltaVVIq = iqConvPu * RVI + idConvPu * XVI;

  annotation(preferredView = "text",
    Documentation(info = "<html><body>
    <p>Same virtual-impedance current-limitation principle as <code>VirtualImpedance2</code>, with one change:
    the extra current module <code>DeltaIConvPu</code> feeding RVI/XVI is capped at <code>DeltaIConvMaxPu</code>.</p>
    </body></html>"),
    Icon(coordinateSystem(grid = {1, 1})),
    Diagram(coordinateSystem(grid = {1, 1})));
end VirtualImpedance2CC;
