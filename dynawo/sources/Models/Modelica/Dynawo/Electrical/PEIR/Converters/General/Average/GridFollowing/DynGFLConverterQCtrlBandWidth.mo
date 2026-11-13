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

model DynGFLConverterQCtrlBandWidth "Grid-following average converter model without plant control (P/Q outer loop, references at LV bus), controller gains derived from target bandwidths"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  // Nominal parameters
  parameter Types.AngularVelocity omegaNom = Electrical.SystemBase.omegaNom "Nominal angular frequency in rad/s";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Measurement parameters
  parameter Types.PerUnit KFilter "Measurement low-pass filter gain";
  parameter Types.AngularVelocity OmegaLPF "Measurement low-pass filter cutoff frequency in rad/s";
  final parameter Types.Time tFilter = 1.0/OmegaLPF "Measurement low-pass filter time constant in s, tFilter = 1/OmegaLPF";

  // PLL parameters
  parameter Types.PerUnit KsiPLL "PLL damping ratio";
  parameter Types.AngularVelocity OmegaPLL "PLL bandwidth (natural frequency) in rad/s";
  parameter Types.AngularVelocityPu OmegaMaxPu "Upper frequency limit in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Lower frequency limit in pu (base omegaNom)";
  final parameter Types.PerUnit KpPLL = 2.0*KsiPLL*OmegaPLL/omegaNom "PLL proportional gain in pu/pu (frequency pu per voltage pu), KpPLL = 2*KsiPLL*OmegaPLL/omegaNom";
  final parameter Types.PerUnit KiPLL = OmegaPLL*OmegaPLL/omegaNom "PLL integral gain in pu/(pu.s), KiPLL = OmegaPLL^2/omegaNom";

  // Outer loop parameters
  parameter Types.PerUnit DidMax "Maximum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit DidMin "Minimum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMaxPu "Maximum reactive current boost in pu (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMinPu "Minimum reactive current boost in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum converter current magnitude in pu (base UNom, SNom)";
  parameter Types.PerUnit Kqv "Reactive current boost gain in pu/pu, 0 to disable";
  parameter Types.AngularVelocity OmegaOuter "Outer loop (P/Q) bandwidth in rad/s";
  parameter Boolean PQFlag "Current priority: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: direct control idConvRefPu = PRefFiltPu/ULVPu | false: PI regulator (default)";
  parameter Boolean QControlFlag "true: direct control iqConvRefPu = QRefFiltPu/ULVPu | false: PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.Time tBoost "Time constant of the first-order filter on the reactive current boost in s, 0 to disable";
  parameter Types.Time tPlant "Time constant of the delay on the P/Q references before the outer loop in s";
  parameter Types.Time tSid "Sample time of the idConvRefPu ramp limiter in s";
  final parameter Types.PerUnit KidOuter = OmegaOuter "Active power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom), KidOuter = OmegaOuter";
  final parameter Types.PerUnit KpdOuter = OmegaOuter/OmegaLPF "Active power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom), KpdOuter = OmegaOuter/OmegaLPF";
  final parameter Types.PerUnit KiqOuter = OmegaOuter "Reactive power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom), KiqOuter = OmegaOuter";
  final parameter Types.PerUnit KpqOuter = OmegaOuter/OmegaLPF "Reactive power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom), KpqOuter = OmegaOuter/OmegaLPF";

  // Current loop parameters
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  parameter Types.AngularVelocity OmegaCC "Inner current loop bandwidth in rad/s";
  final parameter Types.PerUnit Kic = RgPu*OmegaCC "Integral gain of the current loop, Kic = RgPu*OmegaCC";
  final parameter Types.PerUnit Kpc = LgPu*OmegaCC/omegaNom "Proportional gain of the current loop, Kpc = LgPu*OmegaCC/omegaNom";

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
  final parameter Types.PerUnit LgPu = LFilterPu + LTransformerLVPu "Inductance used for dq decoupling and tuning of the current loop (filter + LV transformer) in pu (base UNom, SNom)";
  final parameter Types.PerUnit RgPu = RFilterPu + RTransformerLVPu "Resistance used for tuning of the current loop (filter + LV transformer) in pu (base UNom, SNom)";
  final parameter Types.ComplexPerUnit ZfPu = Complex(RTransformerHVPu + RTransformerLVPu, Omega0Pu*(LTransformerHVPu + LTransformerLVPu)) "Impedance of the transformer (LV + HV stages) in pu (base UNom, SNom)";
  final parameter Complex ZFiltPu = Complex(RFilterPu, Omega0Pu*LFilterPu) "Impedance of the filter series branch in pu (base UNom, SNom)";
  final parameter Types.ComplexPerUnit ZHVPu = Complex(RTransformerHVPu, Omega0Pu*LTransformerHVPu) "Impedance of the HV transformer stage (between LV bus and PCC) in pu (base UNom, SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Reference frequency of the system in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 74}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) "Reactive power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Terminal connector
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Converter AC terminal (PCC), receptor convention, base SnRef" annotation(
    Placement(transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.Converters.Average.DynGridFollowingControlQ gFLControl(Omega0Pu = Omega0Pu, QInj0Pu = QInj0Pu, PInj0Pu = PInj0Pu, IdRef0Pu = IdConv0Pu, IdConv0Pu = IdConv0Pu, IqRef0Pu = IqConv0Pu, IqConv0Pu = IqConv0Pu, DidMax = DidMax, DidMin = DidMin, tSid = tSid, tPlant = tPlant, Kpc = Kpc, Kic = Kic, LgPu = LgPu, UdLV0Pu = UdLV0Pu, UqLV0Pu = UqLV0Pu, UdConv0Pu = Ud0Pu, UqConv0Pu = Uq0Pu, KpdOuter = KpdOuter, KidOuter = KidOuter, KpqOuter = KpqOuter, KiqOuter = KiqOuter, IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, KpPLL = KpPLL, KiPLL = KiPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, uConvRef0Pu = uConv0Pu, ULV0Pu = ULV0Pu, UqFilter0Pu = UqFilter0Pu, Kfd = Kfd, Kfq = Kfq, tBoost = tBoost, PControlFlag = PControlFlag, QControlFlag = QControlFlag) annotation(
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
  connect(gFLControl.QLVFilteredPu, measurementBlock.QLVFilteredPu) annotation(
    Line(points = {{-10, 18}, {-8, 18}, {-8, -18}, {-11, -18}}, color = {85, 170, 0}));
  connect(gFLControl.PLVFilteredPu, measurementBlock.PLVFilteredPu) annotation(
    Line(points = {{-16, 18}, {-15, 18}, {-15, 16}, {-16, 16}, {-16, -1}, {-14, -1}, {-14, -18}, {-16, -18}}, color = {85, 170, 0}));
  connect(PRefPu, gFLControl.PRefPu) annotation(
    Line(points = {{-110, 54}, {-22, 54}}, color = {0, 0, 127}));
  connect(QRefPu, gFLControl.QRefPu) annotation(
    Line(points = {{-110, 20}, {-40, 20}, {-40, 42}, {-22, 42}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-8, 4}, extent = {{-80, 20}, {80, -20}}, textString = "DynGFL")}),
    Diagram(graphics = {Ellipse(extent = {{-100, 52}, {-100, 52}})}),
    Documentation(info = "<html>
<h4>Grid-following average converter without plant control (P/Q outer loop), bandwidth-based tuning</h4>

<p>Same model as <code>DynGFLConverterQCtrl</code>: average-value grid-following (GFL) converter, with a VSC connected to
the PCC through an RLC filter and a two-stage RL transformer (LV + HV), a GFL control (PLL, P/Q outer loop with current
limitation, inner current loop) and a measurement block. There is no plant controller: <code>PRefPu</code> and
<code>QRefPu</code> are the power references at the LV bus, sent directly to the outer loop.</p>

<h4>Difference with DynGFLConverterQCtrl</h4>
<p>The controller gains are not given directly. The user sets target bandwidths, and the PI gains, the PLL gains and the
measurement filter time constant are derived internally as final parameters:</p>
<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">
  <tr><th>DynGFLConverterQCtrl parameter</th><th>Replaced by</th><th>Derived as</th></tr>
  <tr><td><code>tFilter</code></td><td><code>OmegaLPF</code></td><td><code>tFilter = 1/OmegaLPF</code></td></tr>
  <tr><td><code>KpPLL</code>, <code>KiPLL</code></td><td><code>OmegaPLL</code>, <code>KsiPLL</code></td>
      <td><code>KpPLL = 2*KsiPLL*OmegaPLL/omegaNom</code>, <code>KiPLL = OmegaPLL^2/omegaNom</code></td></tr>
  <tr><td><code>Kpc</code>, <code>Kic</code></td><td><code>OmegaCC</code></td>
      <td><code>Kpc = LgPu*OmegaCC/omegaNom</code>, <code>Kic = RgPu*OmegaCC</code></td></tr>
  <tr><td><code>KpdOuter</code>, <code>KidOuter</code>, <code>KpqOuter</code>, <code>KiqOuter</code></td><td><code>OmegaOuter</code></td>
      <td><code>Kp = OmegaOuter/OmegaLPF</code>, <code>Ki = OmegaOuter</code> (both axes)</td></tr>
</table>
<p>All bandwidths are in rad/s. The structure, equations, conventions and initialization are identical to
<code>DynGFLConverterQCtrl</code>. Compared with <code>DynGFLPlantQCtrlBandWidth</code>, the plant controller and its
bandwidth <code>OmegaPlant</code> are removed.</p>

<h4>Tuning rules</h4>
<ul>
  <li><b>PLL</b>: second-order PLL, <code>der(theta) = omegaNom*(KpPLL*uq + KiPLL*integral(uq))</code> with
      <code>uq = U*sin(delta)</code>; the closed loop has natural frequency <code>OmegaPLL</code> and damping <code>KsiPLL</code>
      for <code>U = 1 pu</code>.</li>
  <li><b>Current loop</b>: the PI zero cancels the pole of the plant <code>1/(RgPu + s*LgPu/omegaNom)</code>
      (filter + LV transformer, as seen by the current loop); the closed loop is first-order with bandwidth <code>OmegaCC</code>.</li>
  <li><b>Outer loop</b>: with the current loop much faster, <code>P = U*id</code> and <code>Q = U*(-iq)</code> filtered by
      <code>1/(1 + s/OmegaLPF)</code>; the PI zero cancels the filter pole, and the closed loop has bandwidth <code>OmegaOuter</code>
      for <code>U = 1 pu</code> and <code>KFilter = 1</code>.</li>
</ul>

<h4>Assumptions and limits</h4>
<ul>
  <li>The bandwidths must be separated, typically by a decade: <code>OmegaCC &gt; OmegaOuter</code>, with <code>OmegaLPF</code>
      and <code>OmegaPLL</code> placed consistently. This is not checked in the model.</li>
  <li>The rules assume <code>U = 1 pu</code> and <code>KFilter = 1</code>; the actual bandwidths scale with the voltage magnitude.</li>
  <li>The delay <code>tPlant</code> acts on the references, outside the loops, and does not change the tuning.</li>
</ul>

<h4>Sign conventions, units and initialization</h4>
<p>As in <code>DynGFLConverterQCtrl</code>: <code>terminal</code> in Dynawo receptor convention (base SnRef); internal
quantities in generator convention, pu on the machine base (UNom, SNom); start values computed from the load flow
(<code>U0Pu</code>, <code>UPhase0</code>, <code>P0Pu</code>, <code>Q0Pu</code>) and passed down to the sub-models. For a
steady-state start, the references must start at the LV-bus values: <code>PRefPu = PInj0Pu</code>,
<code>QRefPu = QInj0Pu</code>.</p>
</html>"));
end DynGFLConverterQCtrlBandWidth;
