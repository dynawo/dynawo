within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls;

model VoltageReferenceControlCC "Voltage reference control block, with measurement filters frozen during current saturation episodes"
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
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  parameter Types.PerUnit WVIFreeze "Bandwidth of the DeltaVVId/DeltaVVIq near-passthrough tracking (should be fast compared to Wf/Wff so it behaves like a direct feedthrough in normal operation, e.g. a few hundred rad/s)";
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
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-110, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput BlocCurrentSaturation_Enable "True when CurrentSaturation is clamping the current reference: freezes the measurement filters below" annotation(
    Placement(visible = true, transformation(origin = {-110, 108}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdRef0Pu) "d-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = UqRef0Pu) "q-axis voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback5 annotation(
    Placement(visible = true, transformation(origin = {82, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {22, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Mq) annotation(
    Placement(visible = true, transformation(origin = {-26, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-58, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {52, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback7 annotation(
    Placement(visible = true, transformation(origin = {82, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdRef0Pu "Start value of d-axis voltage reference in pu (base UNom)";
  parameter Types.PerUnit UqRef0Pu "Start value of q-axis voltage reference in pu (base UNom)";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu URef0Pu "Start value of voltage module reference in pu (base UNom)";
  final parameter Types.ReactivePowerPu QFilterRef0Pu = QFilter0Pu + (Kff*IdPcc0Pu + DeltaVVId0)/Mq "Start value of reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  // Measurement filters rewritten as explicit states, frozen (der = 0) while BlocCurrentSaturation_Enable is true.
  // Rationale: idPccPu/iqPccPu/QFilterPu remain physically correct measurements during saturation, but they no
  // longer reflect what this control's own model assumes ("commanded = actually delivered"). Letting the droop
  // and active-damping paths keep reacting to them during saturation was found to drive udFilterRefPu/QSEM's
  // high algebraic gain into a runaway (IConvRefFilterModulePu diverging to thousands of pu). Freezing the
  // filters preserves continuity (no jump) while cutting the feedback path that was causing the divergence.
  Types.PerUnit QFilterFiltPu(start = QFilter0Pu) "Filtered QFilterPu, frozen during saturation";
  Types.PerUnit KffIdPccFiltPu(start = Kff*IdPcc0Pu) "Filtered Kff*idPccPu, frozen during saturation";
  Types.PerUnit KffIqPccFiltPu(start = -Kff*IqPcc0Pu) "Filtered -Kff*iqPccPu, frozen during saturation";
  // CHANGE vs the previous VoltageReferenceControlCC: DeltaVVId/DeltaVVIq used to be fed straight through
  // (connect(DeltaVVId, feedback5.u2) / connect(DeltaVVIq, feedback7.u2)), bypassing the freeze mechanism
  // entirely. Since idConvPu/iqConvPu (which drive VirtualImpedance2's output) are themselves real measurements
  // that become misleading during a saturation episode (same reasoning as QFilterPu above), leaving this path
  // unprotected let udFilterRefPu/uqFilterRefPu keep diverging even with the Q-loop frozen, confirmed empirically
  // (BlocCurrentSaturation_Enable=1 while udFilterRefPu/uqFilterRefPu kept climbing). These two states track
  // DeltaVVId/DeltaVVIq almost instantaneously in normal operation (WVIFreeze should be fast, e.g. a few hundred
  // rad/s) and are frozen (der=0) during saturation, exactly like the other three filters above.
  Types.PerUnit DeltaVVIdFrozenPu(start = DeltaVVId0) "Near-passthrough tracking of DeltaVVId, frozen during saturation";
  Types.PerUnit DeltaVVIqFrozenPu(start = DeltaVVIq0) "Near-passthrough tracking of DeltaVVIq, frozen during saturation";
equation
  der(QFilterFiltPu) = if BlocCurrentSaturation_Enable then 0 else Wf * (QFilterPu - QFilterFiltPu);
  der(KffIdPccFiltPu) = if BlocCurrentSaturation_Enable then 0 else Wff * (Kff * idPccPu - KffIdPccFiltPu);
  der(KffIqPccFiltPu) = if BlocCurrentSaturation_Enable then 0 else Wff * (-Kff * iqPccPu - KffIqPccFiltPu);
  der(DeltaVVIdFrozenPu) = if BlocCurrentSaturation_Enable then 0 else WVIFreeze * (DeltaVVId - DeltaVVIdFrozenPu);
  der(DeltaVVIqFrozenPu) = if BlocCurrentSaturation_Enable then 0 else WVIFreeze * (DeltaVVIq - DeltaVVIqFrozenPu);

  connect(feedback5.y, udFilterRefPu) annotation(
    Line(points = {{91, 78}, {110, 78}}, color = {0, 0, 127}));
  connect(feedback3.y, gain3.u) annotation(
    Line(points = {{-49, 84}, {-38, 84}}, color = {0, 0, 127}));
  feedback3.u2 = QFilterFiltPu;
  feedback5.u2 = DeltaVVIdFrozenPu;
  connect(URefPu, add2.u2) annotation(
    Line(points = {{-110, 24}, {2, 24}, {2, 72}, {10, 72}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-15, 84}, {10, 84}}, color = {0, 0, 127}));
  feedback4.u2 = KffIdPccFiltPu;
  connect(feedback4.y, feedback5.u1) annotation(
    Line(points = {{61, 78}, {74, 78}}, color = {0, 0, 127}));
  connect(add2.y, feedback4.u1) annotation(
    Line(points = {{33, 78}, {44, 78}}, color = {0, 0, 127}));
  feedback7.u1 = KffIqPccFiltPu;
  connect(feedback7.y, uqFilterRefPu) annotation(
    Line(points = {{91, -36}, {110, -36}}, color = {0, 0, 127}));
  feedback7.u2 = DeltaVVIqFrozenPu;
  connect(QFilterRefPu, feedback3.u1) annotation(
    Line(points = {{-110, 84}, {-66, 84}}, color = {0, 0, 127}));  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><body>
    <p>Same voltage droop / active damping structure as <code>VoltageReferenceControl</code>, but five
    signals derived from real (post-saturation-episode) measurements are written as explicit states whose
    derivative is forced to zero while <code>BlocCurrentSaturation_Enable</code> is true (wired from
    <code>CurrentSaturation.BlocCurrentSaturation_Enable</code>): the reactive power Q filter, the d/q-axis
    active-damping paths (Kff*idPccPu, -Kff*iqPccPu), and DeltaVVId/DeltaVVIq (fed by VirtualImpedance2CC).</p>
    <p>Motivation: idPccPu/iqPccPu/QFilterPu/idConvPu/iqConvPu stay physically correct during a saturation
    episode, but this control's droop and virtual-impedance paths implicitly assume the commanded current is
    actually delivered. When CurrentSaturation clamps the real current, that assumption breaks, and letting
    these paths keep reacting to the (now misleading) measurements was observed to drive QSEM's algebraic gain
    into a runaway divergence of the unsaturated current reference -- confirmed empirically to persist even
    after freezing the Q-droop path alone, because DeltaVVId/DeltaVVIq were still feeding through unprotected.
    Freezing all five paths removes the spurious feedback while remaining continuous (no value jump) at both
    freeze and unfreeze instants.</p>
    </body></html>"),
    Diagram(coordinateSystem(initialScale = 0.2)),
    Icon(coordinateSystem(initialScale = 0.2)));
end VoltageReferenceControlCC;
