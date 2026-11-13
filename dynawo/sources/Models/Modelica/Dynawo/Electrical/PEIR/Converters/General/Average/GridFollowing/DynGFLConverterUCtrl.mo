within Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing;

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

model DynGFLConverterUCtrl "Grid-following average converter model without plant control (P/U outer loop, references at LV bus)"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  // Nominal parameters
  parameter Types.AngularVelocity omegaNom = Electrical.SystemBase.omegaNom "Nominal angular frequency in rad/s";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Measurement parameters
  parameter Types.PerUnit KFilter "Measurement low-pass filter gain";
  parameter Types.Time tFilter "Measurement low-pass filter time constant in s";

  // PLL parameters
  parameter Types.PerUnit KpPLL "PLL proportional gain in pu/pu (frequency pu per voltage pu)";
  parameter Types.PerUnit KiPLL "PLL integral gain in pu/(pu.s)";
  parameter Types.AngularVelocityPu OmegaMaxPu "Upper frequency limit in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Lower frequency limit in pu (base omegaNom)";

  // Outer loop parameters
  parameter Types.PerUnit DidMax "Maximum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit DidMin "Minimum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMaxPu "Maximum reactive current boost in pu (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMinPu "Minimum reactive current boost in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum converter current magnitude in pu (base UNom, SNom)";
  parameter Types.PerUnit KidOuter "Active power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit KpdOuter "Active power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit KiqOuter "Voltage PI integral gain in pu/(pu.s) (current base UNom, SNom / voltage base UNom)";
  parameter Types.PerUnit KpqOuter "Voltage PI proportional gain in pu/pu (current base UNom, SNom / voltage base UNom)";
  parameter Types.PerUnit Kqv "Reactive current boost gain in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Current priority: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: direct control idConvRefPu = PRefPu/ULVPu | false: PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.Time tBoost "Time constant of the first-order filter on the reactive current boost in s, 0 to disable";
  parameter Types.Time tSid "Sample time of the idConvRefPu ramp limiter in s";

  // Current loop parameters
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";

  // VSC parameter
  parameter Types.Time tVSC "VSC response time constant in s";

  // RLC filter parameters
  parameter Types.PerUnit RFilterPu "Filter series resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilterPu "Filter series inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CFilterPu "Filter shunt capacitance in pu (base UNom, SNom)";

  // Transformer parameters (LV and HV stages)
  parameter Types.PerUnit RTransformerHVPu "Transformer series resistance, HV stage, in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerHVPu "Transformer series inductance, HV stage, in pu (base UNom, SNom)";
  parameter Types.PerUnit RTransformerLVPu "Transformer series resistance, LV stage, in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformerLVPu "Transformer series inductance, LV stage, in pu (base UNom, SNom)";

  // Equivalent impedances
  final parameter Types.PerUnit LgPu = LFilterPu + LTransformerLVPu "Inductance used for dq decoupling in the current loop (filter + LV transformer) in pu (base UNom, SNom)";
  final parameter Types.ComplexPerUnit ZfPu = Complex(RTransformerHVPu + RTransformerLVPu, Omega0Pu*(LTransformerHVPu + LTransformerLVPu)) "Impedance of the transformer (LV + HV stages) in pu (base UNom, SNom)";
  final parameter Complex ZFiltPu = Complex(RFilterPu, Omega0Pu*LFilterPu) "Impedance of the filter series branch in pu (base UNom, SNom)";
  final parameter Types.ComplexPerUnit ZHVPu = Complex(RTransformerHVPu, Omega0Pu*LTransformerHVPu) "Impedance of the HV transformer stage (between LV bus and PCC) in pu (base UNom, SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Reference frequency of the system in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 74}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = ULV0Pu) "Voltage reference at LV bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Terminal connector
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Converter AC terminal (PCC), receptor convention, base SnRef" annotation(
    Placement(transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.Converters.Average.DynGridFollowingControlU gFLControl(Omega0Pu = Omega0Pu, PInj0Pu = PInj0Pu, IdRef0Pu = IdConv0Pu, IdConv0Pu = IdConv0Pu, IqRef0Pu = IqConv0Pu, IqConv0Pu = IqConv0Pu, DidMax = DidMax, DidMin = DidMin, tSid = tSid, Kpc = Kpc, Kic = Kic, LgPu = LgPu, UdLV0Pu = UdLV0Pu, UqLV0Pu = UqLV0Pu, UdConv0Pu = Ud0Pu, UqConv0Pu = Uq0Pu, KpdOuter = KpdOuter, KidOuter = KidOuter, KpqOuter = KpqOuter, KiqOuter = KiqOuter, IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, KpPLL = KpPLL, KiPLL = KiPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, uConvRef0Pu = uConv0Pu, ULV0Pu = ULV0Pu, UqFilter0Pu = UqFilter0Pu, Kfd = Kfd, Kfq = Kfq, tBoost = tBoost, PControlFlag = PControlFlag) annotation(
    Placement(transformation(origin = {0, 40}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.MeasurementsGFL measurementBlock(UrePcc0Pu = UrePcc0Pu, UimPcc0Pu = UimPcc0Pu, IrePcc0Pu = IrePcc0Pu, IimPcc0Pu = IiPcc0Pu, Theta0 = Theta0, UPcc0Pu = U0Pu, KFilter = KFilter, tFilter = tFilter, PPcc0Pu = PPcc0Pu, QPcc0Pu = QPcc0Pu, UqFilter0Pu = UqFilter0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, IreConv0Pu = IrConv0Pu, IimConv0Pu = IiConv0Pu, UreLV0Pu = uLV0Pu.re, UimLV0Pu = uLV0Pu.im, PLV0Pu = PInj0Pu, QLV0Pu = QInj0Pu, UdLV0Pu = UdLV0Pu, UqLV0Pu = UqLV0Pu, UreFilter0Pu = uFilter0Pu.re, UimFilter0Pu = uFilter0Pu.im) annotation(
    Placement(transformation(origin = {0, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Dynawo.Electrical.Sources.PEIR.Converters.Average.DynConverter1 dynConverter1(tVSC = tVSC, UrConv0Pu = uConv0Pu.re, UiConv0Pu = uConv0Pu.im, IrPcc0Pu = IrePcc0Pu*SNom/SystemBase.SnRef, IiPcc0Pu = IiPcc0Pu*SNom/SystemBase.SnRef, IrConv0Pu = IrConv0Pu, IiConv0Pu = IiConv0Pu, UrFilter0Pu = uFilter0Pu.re, UiFilter0Pu = uFilter0Pu.im, RfPu = RFilterPu, LfPu = LFilterPu, CfPu = CFilterPu, omegaNom = omegaNom, SNom = SNom, RPu = (RTransformerLVPu + RTransformerHVPu)*SystemBase.SnRef/SNom, LPu = (LTransformerLVPu + LTransformerHVPu)*SystemBase.SnRef/SNom, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {60, 40}, extent = {{-20, -20}, {20, 20}})));

  // Initial parameters
  parameter Types.AngularVelocityPu Omega0Pu = Electrical.SystemBase.omega0Pu "Start value of frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at PCC in rad";

  // PCC
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of complex voltage at PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of complex current at PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ActivePowerPu PPcc0Pu = -P0Pu*SystemBase.SnRef/SNom "Start value of active power at PCC in pu (base SNom) (generator convention)";
  final parameter Types.ReactivePowerPu QPcc0Pu = -Q0Pu*SystemBase.SnRef/SNom "Start value of reactive power at PCC in pu (base SNom) (generator convention)";
  final parameter Types.PerUnit UrePcc0Pu = u0Pu.re "Start value of real-axis voltage at PCC in pu (base UNom)";
  final parameter Types.PerUnit UimPcc0Pu = u0Pu.im "Start value of imag-axis voltage at PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iPcc0Pu = -i0Pu*SystemBase.SnRef/SNom "Start value of complex current at PCC in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IrePcc0Pu = iPcc0Pu.re "Start value of real-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IiPcc0Pu = iPcc0Pu.im "Start value of imag-axis current at PCC in pu (base UNom, SNom) (generator convention)";

  // Filter capacitor and PLL
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu + iPcc0Pu*ZfPu "Start value of complex filter capacitor voltage in pu (base UNom): PCC voltage plus drop across the transformer";
  final parameter Types.Angle Theta0 = Modelica.Math.atan2(uFilter0Pu.im, uFilter0Pu.re) "Start value of the PLL angle relative to the network RI frame in rad";
  final parameter Types.PerUnit UqFilter0Pu = -uFilter0Pu.re*sin(Theta0) + uFilter0Pu.im*cos(Theta0) "Start value of q-axis filter voltage in the PLL frame in pu (base UNom), 0 at lock";

  // Converter current and voltage
  final parameter Types.PerUnit IrConv0Pu = IrePcc0Pu - Omega0Pu*CFilterPu*uFilter0Pu.im "Start value of real-axis current from converter into filter in pu (base UNom, SNom)";
  final parameter Types.PerUnit IiConv0Pu = IiPcc0Pu + Omega0Pu*CFilterPu*uFilter0Pu.re "Start value of imag-axis current from converter into filter in pu (base UNom, SNom)";
  final parameter Types.PerUnit IdConv0Pu = IrConv0Pu*cos(Theta0) + IiConv0Pu*sin(Theta0) "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IqConv0Pu = -IrConv0Pu*sin(Theta0) + IiConv0Pu*cos(Theta0) "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  final parameter Complex iConv0Pu = Complex(IrConv0Pu, IiConv0Pu) "Start value of complex current from converter into filter in pu (base UNom, SNom)";
  final parameter Complex uConv0Pu = uFilter0Pu + iConv0Pu*ZFiltPu "Start value of complex converter voltage in pu (base UNom)";
  final parameter Types.PerUnit Ud0Pu = uConv0Pu.re*cos(Theta0) + uConv0Pu.im*sin(Theta0) "Start value of d-axis modulation voltage in pu (base UNom)";
  final parameter Types.PerUnit Uq0Pu = -uConv0Pu.re*sin(Theta0) + uConv0Pu.im*cos(Theta0) "Start value of q-axis modulation voltage in pu (base UNom)";

  // LV bus (junction between LV and HV transformer stages)
  final parameter Types.ActivePowerPu PInj0Pu = PPcc0Pu + RTransformerHVPu*(IrePcc0Pu^2 + IiPcc0Pu^2) "Start value of active power at LV bus in pu (base SNom) (generator convention): PCC power plus HV stage active losses";
  final parameter Types.ReactivePowerPu QInj0Pu = QPcc0Pu + Omega0Pu*LTransformerHVPu*(IrePcc0Pu^2 + IiPcc0Pu^2) "Start value of reactive power at LV bus in pu (base SNom) (generator convention): PCC power plus HV stage reactive losses";
  final parameter Types.ComplexVoltagePu uLV0Pu = u0Pu + iPcc0Pu*ZHVPu "Start value of complex voltage at LV bus in pu (base UNom)";
  final parameter Types.PerUnit UdLV0Pu = uLV0Pu.re*cos(Theta0) + uLV0Pu.im*sin(Theta0) "Start value of d-axis voltage at LV bus in the PLL frame in pu (base UNom)";
  final parameter Types.PerUnit UqLV0Pu = -uLV0Pu.re*sin(Theta0) + uLV0Pu.im*cos(Theta0) "Start value of q-axis voltage at LV bus in the PLL frame in pu (base UNom)";
  final parameter Types.VoltageModulePu ULV0Pu = Modelica.ComplexMath.'abs'(uLV0Pu) "Start value of voltage magnitude at LV bus in pu (base UNom)";

equation
  // LV bus voltage reconstructed from the PCC voltage and the drop across the HV stage (steady-state impedance)
  measurementBlock.uLVPu.re = terminal.V.re + dynConverter1.Trafo.irPccPu*SystemBase.SnRef/SNom*RTransformerHVPu - dynConverter1.Trafo.iiPccPu*SystemBase.SnRef/SNom*dynConverter1.Trafo.omegaPu*LTransformerHVPu;
  measurementBlock.uLVPu.im = terminal.V.im + dynConverter1.Trafo.irPccPu*SystemBase.SnRef/SNom*dynConverter1.Trafo.omegaPu*LTransformerHVPu + dynConverter1.Trafo.iiPccPu*SystemBase.SnRef/SNom*RTransformerHVPu;
  // PCC quantities: terminal current in receptor convention (base SnRef) -> generator convention (base SNom)
  measurementBlock.iPccPu = -terminal.i*SystemBase.SnRef/SNom;
  measurementBlock.uPccPu = terminal.V;

  connect(omegaRefPu, gFLControl.omegaRefPu) annotation(
    Line(points = {{-110, 74}, {-110, 75.5}, {14, 75.5}, {14, 62}}, color = {0, 0, 127}));
  connect(measurementBlock.thetaPLL, gFLControl.thetaPLL) annotation(
    Line(points = {{14, -18}, {14, -1}, {26.1818, -1}, {26.1818, 19.5}, {22.1818, 19.5}, {22.1818, 20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(measurementBlock.uqFilterPu, gFLControl.uqFilterPu) annotation(
    Line(points = {{-22, -24}, {-22, -20.6}, {-25.8182, -20.6}, {-25.8182, 29.9}, {-23.8182, 29.9}, {-23.8182, 28.15}, {-21.8182, 28.15}, {-21.8182, 30.4}}, color = {192, 28, 40}));
  connect(measurementBlock.ULVPu, gFLControl.ULVPu) annotation(
    Line(points = {{-22, -50}, {-31.8182, -50}, {-31.8182, 24}, {-21.8182, 24}}, color = {85, 170, 0}));
  connect(dynConverter1.terminal, terminal) annotation(
    Line(points = {{80.4, 40}, {100.4, 40}}, color = {0, 0, 255}));
  connect(gFLControl.omegaPLLPu, dynConverter1.omegaPu) annotation(
    Line(points = {{22, 28}, {38, 28}}, color = {0, 0, 127}));
  connect(dynConverter1.iConvPu, measurementBlock.iConvPu) annotation(
    Line(points = {{60, 18}, {60, -80}, {9, -80}, {9, -64}}, color = {245, 121, 0}));
  connect(dynConverter1.uFiltPu, measurementBlock.uFiltPu) annotation(
    Line(points = {{52, 18}, {52, -72}, {19, -72}, {19, -64}, {16, -64}}, color = {192, 28, 40}));
  connect(gFLControl.urConvRefPu, dynConverter1.urConvRefPu) annotation(
    Line(points = {{22, 52}, {38, 52}}, color = {245, 121, 0}));
  connect(gFLControl.uiConvRefPu, dynConverter1.uiConvRefPu) annotation(
    Line(points = {{22, 40}, {38, 40}}, color = {245, 121, 0}));
  connect(gFLControl.uqLVPu, measurementBlock.uqLVPu) annotation(
    Line(points = {{14, 18}, {14, 0}, {9, 0}, {9, -18}}, color = {85, 170, 0}));
  connect(measurementBlock.udLVPu, gFLControl.udLVPu) annotation(
    Line(points = {{4, -18}, {4, 2}, {10, 2}, {10, 18}}, color = {85, 170, 0}));
  connect(measurementBlock.idConvPu, gFLControl.idConvPu) annotation(
    Line(points = {{-1, -18}, {2, -18}, {2, 18}, {4, 18}}, color = {245, 121, 0}));
  connect(measurementBlock.iqConvPu, gFLControl.iqConvPu) annotation(
    Line(points = {{-6, -18}, {-4, -18}, {-4, 18}, {-2, 18}}, color = {245, 121, 0}));
  connect(gFLControl.PLVFilteredPu, measurementBlock.PLVFilteredPu) annotation(
    Line(points = {{-16, 18}, {-15, 18}, {-15, 16}, {-16, 16}, {-16, -1}, {-14, -1}, {-14, -18}, {-16, -18}}, color = {85, 170, 0}));
  connect(PRefPu, gFLControl.PRefPu) annotation(
    Line(points = {{-110, 54}, {-22, 54}}, color = {0, 0, 127}));
  connect(URefPu, gFLControl.URefPu) annotation(
    Line(points = {{-110, 20}, {-40, 20}, {-40, 42}, {-22, 42}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-8, 4}, extent = {{-80, 20}, {80, -20}}, textString = "DynGFL U")}),
    Diagram(graphics = {Ellipse(extent = {{-100, 52}, {-100, 52}})}),
    Documentation(info = "<html>
<h4>Grid-following average converter without plant control (P/U outer loop)</h4>

<p>Average-value model of a grid-following (GFL) converter. A voltage-source converter (VSC) is connected to the PCC
through an RLC filter and a two-stage RL transformer (LV + HV). The model includes:</p>
<ol>
  <li><code>gFLControl</code> (<code>DynGridFollowingControlU</code>): PLL, P/U outer loop with current limitation and
      reactive current boost, inner current loop and dq/RI transformation;</li>
  <li><code>dynConverter1</code> (<code>DynConverter1</code>): VSC with first-order lag, dynamic RLC filter and dynamic RL
      transformer (LV + HV stages lumped);</li>
  <li><code>measurementBlock</code> (<code>MeasurementBlock</code>): measurements at the LV bus and dq quantities in the PLL
      frame. The active power at the LV bus is filtered (<code>KFilter</code>, <code>tFilter</code>); the dq currents and
      voltages, the LV-bus voltage magnitude and <code>uqFilterPu</code> are not.</li>
</ol>

<h4>Difference with DynGFLConverterQCtrl</h4>
<ul>
  <li>The outer loop controls the active power and the <b>voltage magnitude</b> at the LV bus, instead of the active and
      reactive power: the input <code>QRefPu</code> is replaced by <code>URefPu</code>, and the reactive power measured at the
      LV bus is not used.</li>
  <li><code>KpqOuter</code>, <code>KiqOuter</code> are the gains of the voltage PI (current per voltage).</li>
  <li>The voltage axis has no direct mode (no <code>QControlFlag</code>), and there is no delay <code>tPlant</code> on the references.</li>
  <li>The electrical part, the measurement block, the PLL, the current loop and the initialization are the same.</li>
</ul>

<h4>Electrical circuit</h4>
<pre>
  VSC ---- RFilterPu + j*X ----+---- RTransformerLVPu + j*X ---- (LV bus) ---- RTransformerHVPu + j*X ---- PCC
                               |
                          CFilterPu
                               |
</pre>
<p>The LV and HV stages carry the same current; they are lumped into a single dynamic RL element (<code>Trafo</code>), and
the LV-bus voltage is reconstructed algebraically:</p>
<pre>
  uLVPu = terminal.V + (RTransformerHVPu + j*omegaPLLPu*LTransformerHVPu) * iPccPu
</pre>
<p>The <code>LTransformerHVPu/omegaNom*di/dt</code> term is neglected: exact at steady state, approximate during fast transients.</p>

<h4>Control points</h4>
<ul>
  <li>The PLL is synchronized on the filter capacitor voltage.</li>
  <li>The outer loop acts on the LV-bus active power and voltage magnitude.</li>
  <li>The current loop uses the LV-bus voltage as feedforward and <code>LgPu = LFilterPu + LTransformerLVPu</code> as
      decoupling inductance.</li>
</ul>

<h4>Sign conventions</h4>
<ul>
  <li><code>terminal</code>: Dynawo receptor convention (current positive into the converter), base SnRef.</li>
  <li>Inside the model: generator convention (positive = injected into the grid), base SNom:
      <code>iPccPu = -terminal.i*SnRef/SNom</code>.</li>
  <li>The input parameters <code>P0Pu</code>, <code>Q0Pu</code> are given in receptor convention, base SnRef (load flow).</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>Parameters and internal quantities in pu on the machine base (UNom, SNom).</li>
  <li>The transformer impedance is converted to the system base for <code>Trafo</code>: <code>Z(SnRef) = Z(SNom)*SnRef/SNom</code>.</li>
  <li>Frequencies in pu (base omegaNom), angles in rad.</li>
</ul>

<h4>Initialization</h4>
<p>All start values are computed from the load flow (<code>U0Pu</code>, <code>UPhase0</code>, <code>P0Pu</code>,
<code>Q0Pu</code>) and passed down to the sub-models, as in <code>DynGFLConverterQCtrl</code>:</p>
<ol>
  <li>PCC current: <code>iPcc0Pu = -conj((P0Pu + j*Q0Pu)/u0Pu)*SnRef/SNom</code> (generator convention, base SNom);</li>
  <li>filter voltage: <code>uFilter0Pu = u0Pu + ZfPu*iPcc0Pu</code>, and PLL angle <code>Theta0</code> = angle of
      <code>uFilter0Pu</code>, so that <code>UqFilter0Pu = 0</code>;</li>
  <li>converter current: <code>iConv0Pu = iPcc0Pu + j*Omega0Pu*CFilterPu*uFilter0Pu</code>;</li>
  <li>converter voltage: <code>uConv0Pu = uFilter0Pu + ZFiltPu*iConv0Pu</code>;</li>
  <li>LV bus: <code>uLV0Pu = u0Pu + ZHVPu*iPcc0Pu</code>, <code>ULV0Pu = |uLV0Pu|</code>, and <code>PInj0Pu</code>,
      <code>QInj0Pu</code> = PCC powers plus the HV stage losses.</li>
</ol>
<p>For a steady-state start, the references must start at the LV-bus values: <code>PRefPu = PInj0Pu</code> and
<code>URefPu = ULV0Pu</code> (not the load-flow PCC values).</p>
</html>"));
end DynGFLConverterUCtrl;
