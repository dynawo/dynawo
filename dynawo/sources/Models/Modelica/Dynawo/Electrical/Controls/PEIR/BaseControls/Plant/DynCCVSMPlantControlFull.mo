within Dynawo.Electrical.Controls.PEIR.BaseControls.Plant;

model DynCCVSMPlantControlFull "Current-saturated GFM with VSM control, generic Plant Controller, line and Transformer"
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

  parameter Types.Time tUFiltGFM = 0.01 "Filter time constant for voltage measurement in s";
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain" annotation(
    Dialog(tab = "VSM"));
  parameter Types.Time H "Inertia constant in s" annotation(
    Dialog(tab = "VSM"));
  parameter Types.PerUnit KDampingAngle "Proportional gain of the PI action on theta (angle-damping term) in s" annotation(
    Dialog(tab = "VSM"));
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu IMaxVIPu "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu DeltaIConvMaxPu "Maximum extra current module used to compute RVI/XVI, in pu (base UNom, SNom): bounds the virtual impedance correction regardless of how large the measured current becomes" annotation(
    Dialog(tab = "VI"));
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // QSEM parameter
  parameter Types.PerUnit XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Current loop parameters
  parameter Types.PerUnit Omegac "Current Loop bandwidth (in rad/s)" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
  // Current saturation parameters
  parameter Types.CurrentModulePu ImaxPu "Current max threshold to limit a current's module" annotation(
    Dialog(tab = "Current Saturation"));
  parameter Types.CurrentModulePu IminPu "Current min threshold to limit a current's module" annotation(
    Dialog(tab = "Current Saturation"));
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit CFilterPu "Filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s" annotation(
    Dialog(tab = "VSC"));
  parameter Types.CurrentModulePu EpsVIUpPu "Upper half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu EpsVIDownPu "Lower half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu EpsUpPu "Upper half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold" annotation(
    Dialog(tab = "Current Saturation"));
  parameter Types.CurrentModulePu EpsDownPu "Lower half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold" annotation(
    Dialog(tab = "Current Saturation"));
  parameter Types.Time tSat "Time constant of the first-order filter on the dq reference currents (in s)" annotation(
    Dialog(tab = "Current Saturation"));
  parameter Types.AngularVelocityPu Omega0Pu = SystemBase.omegaRef0Pu "Start value of the physical frequency of the grid and converter in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaRef0Pu = SystemBase.omegaRef0Pu "Start value of the rotation speed of the RI reference frame (omegaRefPu input) in pu (base omegaNom)";

  // PlantControl parameters
  //Parameters -- gains
  parameter Types.PerUnit Lambd "Gain for voltage/reactive power regulation" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kdroop "Gain for frequency/active power regulation" annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- time constants
  parameter Real tQFilt "Time constant for the reactive power filter (in s)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Real tPFilt "Time constant for the active power filter (in s)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Real tUFilt "Time constant for the voltage filter (in s)" annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- PI gains
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop" annotation(
    Dialog(tab = "Plant Control"));
  parameter Real Kiq(unit = "1/s") "PI integral gain - voltage/Q loop" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop" annotation(
    Dialog(tab = "Plant Control"));
  parameter Real Kip(unit = "1/s") "PI integral gain - active power loop" annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- output limits (base SNref, receptor convention, i.e. same base as PI internal signals before final conversion)
  parameter Types.PerUnit QMaxPu "Maximum reactive power reference before base/sign conversion (pu, base SNref)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit QMinPu "Minimum reactive power reference before base/sign conversion (pu, base SNref)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PMaxPu "Maximum active power reference before base/sign conversion (pu, base SNref)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PMinPu "Minimum active power reference before base/sign conversion (pu, base SNref)" annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- deadbands and frequency droop limiter
  parameter Types.PerUnit FEMaxPu "Maximum frequency error after droop limiter (pu)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit FEMinPu "Minimum frequency error after droop limiter (pu)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit FDbd1Pu "Frequency deadband lower threshold (pu, positive value)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit FDbd2Pu "Frequency deadband upper threshold (pu, positive value)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DbdPu "Voltage error deadband half-width (pu)" annotation(
    Dialog(tab = "Plant Control"));
  // PLL parameters
  parameter Types.PerUnit OmegaPLL "PLL bandwidth (in rad/s)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KsiPLL "PLL damping ratio (dimensionless)" annotation(
    Dialog(tab = "PLL"));
  //Line parameters
  parameter Types.PerUnit RPu "Resistance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit XPu "Reactance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit BPu "Half-susceptance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  // Plant transformer parameters
  parameter Types.PerUnit RTfoPu "Plant transformer resistance in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit XTfoPu "Plant transformer reactance in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit GTfoPu "Plant transformer conductance in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit BTfoPu "Plant transformer susceptance in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit rTfoPu "Plant transformer ratio in pu: U2/U1 in no load conditions" annotation(
    Dialog(tab = "Plant transformer"));

  // Operating point at the PCC (plant terminal)
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.VoltageModulePu UPcc0Pu "Start value of voltage amplitude at the PCC in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.Angle UPccPhase0 "Start value of voltage angle at the PCC in rad" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ActivePowerPu PPcc0Pu "Start value of active power at the PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ReactivePowerPu QPcc0Pu "Start value of reactive power at the PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Initialization"));

  final parameter Types.ComplexVoltagePu uPcc0Pu = Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0) "Start value of the complex voltage at the PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iPcc0Pu = Modelica.ComplexMath.conj(Complex(PPcc0Pu, QPcc0Pu) / uPcc0Pu) "Start value of the complex current at the PCC in pu (base UNom, SnRef) (receptor convention)";

  // Operating point at the transformer terminal 1
  final parameter Types.ComplexImpedancePu ZTfoPu = Complex(RTfoPu, XTfoPu) "Plant transformer impedance in pu (base U2Nom, SnRef)";
  final parameter Types.ComplexAdmittancePu YTfoPu = Complex(GTfoPu, BTfoPu) "Plant transformer admittance in pu (base U2Nom, SnRef)";
  final parameter Types.ComplexCurrentPu iTfo10Pu = rTfoPu * (YTfoPu * uPcc0Pu - iPcc0Pu) "Start value of the complex current at transformer terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uTfo10Pu = (rTfoPu * uPcc0Pu + ZTfoPu * iTfo10Pu) / (rTfoPu * rTfoPu) "Start value of the complex voltage at transformer terminal 1 in pu (base U1Nom)";

  // Operating point at the GFM terminal
  final parameter Types.ComplexImpedancePu ZLinePu = Complex(RPu, XPu) "Line impedance in pu (base SnRef)";
  final parameter Types.ComplexAdmittancePu YLinePu = Complex(GPu, BPu) "Line half-admittance in pu (base SnRef)";
  final parameter Types.ComplexCurrentPu iLine20Pu = - iTfo10Pu "Start value of the complex current at line terminal 2 in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uGfm0Pu = uTfo10Pu - ZLinePu * (iLine20Pu - YLinePu * uTfo10Pu) "Start value of the complex voltage at the GFM terminal in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iLine10Pu = (uGfm0Pu - uTfo10Pu) / ZLinePu + YLinePu * uGfm0Pu "Start value of the complex current at line terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iGfm0Pu = - iLine10Pu "Start value of the complex current at the GFM terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.VoltageModulePu UGfm0Pu = Modelica.ComplexMath.'abs'(uGfm0Pu) "Start value of voltage amplitude at the GFM terminal in pu (base UNom)";
  final parameter Types.Angle UPhaseGfm0 = Modelica.ComplexMath.arg(uGfm0Pu) "Start value of voltage angle at the GFM terminal in rad";
  final parameter Types.ActivePowerPu PGfm0Pu = Modelica.ComplexMath.real(uGfm0Pu * Modelica.ComplexMath.conj(iGfm0Pu)) "Start value of active power at the GFM terminal in pu (base SnRef) (receptor convention)";
  final parameter Types.ReactivePowerPu QGfm0Pu = Modelica.ComplexMath.imag(uGfm0Pu * Modelica.ComplexMath.conj(iGfm0Pu)) "Start value of reactive power at the GFM terminal in pu (base SnRef) (receptor convention)";


  Dynawo.Electrical.Controls.PEIR.BaseControls.Plant.DynCCVSMPlantControl dynCCVSMPlantControl(EpsVIUpPu = EpsVIUpPu, EpsVIDownPu = EpsVIDownPu, EpsUpPu = EpsUpPu, EpsDownPu = EpsDownPu, tSat = tSat, Omega0Pu = Omega0Pu, OmegaRef0Pu = OmegaRef0Pu, tUFiltGFM = tUFiltGFM, CFilterPu = CFilterPu, DbdPu = DbdPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, H = H, KDampingAngle = KDampingAngle, DeltaIConvMaxPu = DeltaIConvMaxPu, ImaxPu = ImaxPu, IminPu = IminPu, IMaxVIPu = IMaxVIPu, Kdroop = Kdroop, Kfd = Kfd, Kff = Kff, Kfq = Kfq, Kip = Kip, Kiq = Kiq, KpVI = KpVI, Kpp = Kpp, Kpq = Kpq, KsiPLL = KsiPLL, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Lambd = Lambd, Mq = Mq, OmegaPLL = OmegaPLL, Omegac = Omegac, Omegaf = Omegaf, Omegaff = Omegaff, P0Pu = PGfm0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PPcc0Pu = PPcc0Pu, Q0Pu = QGfm0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, QPcc0Pu = QPcc0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, U0Pu = UGfm0Pu, UPcc0Pu = UPcc0Pu, UPccPhase0 = UPccPhase0, UPhase0 = UPhaseGfm0, XRratio = XRratio, XVIPu = XVIPu, kVSM = kVSM, tPFilt = tPFilt, tQFilt = tQFilt, tUFilt = tUFilt, tVSC = tVSC) annotation(
    Placement(transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line(BPu = BPu, GPu = GPu, RPu = RPu, XPu = XPu,
    terminal1(V(re(start = uGfm0Pu.re), im(start = uGfm0Pu.im)), i(re(start = iLine10Pu.re), im(start = iLine10Pu.im))),
    terminal2(V(re(start = uTfo10Pu.re), im(start = uTfo10Pu.im)), i(re(start = iLine20Pu.re), im(start = iLine20Pu.im)))) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(RPu = RTfoPu, XPu = XTfoPu, GPu = GTfoPu, BPu = BTfoPu, rTfoPu = rTfoPu,
    terminal1(V(re(start = uTfo10Pu.re), im(start = uTfo10Pu.im)), i(re(start = iTfo10Pu.re), im(start = iTfo10Pu.im))),
    terminal2(V(re(start = uPcc0Pu.re), im(start = uPcc0Pu.im)), i(re(start = iPcc0Pu.re), im(start = iPcc0Pu.im)))) annotation(
    Placement(transformation(origin = {52, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Connectors.ACPower terminal(V(re(start = uPcc0Pu.re), im(start = uPcc0Pu.im)), i(re(start = iPcc0Pu.re), im(start = iPcc0Pu.im))) "Connector used to connect the plant to the grid (PCC)" annotation(
    Placement(transformation(origin = {94, 0}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PPcc0Pu) annotation(
    Placement(transformation(origin = {-114, 60}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 61}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = UPcc0Pu + Lambd*QPcc0Pu) annotation(
    Placement(transformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -61}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = dynCCVSMPlantControl.DynGFMCCVSM.ControlCC.URef0Pu) annotation(
    Placement(transformation(origin = {-114, -60}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {1, -111}, extent = {{-11, -11}, {11, 11}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) annotation(
    Placement(transformation(origin = {0, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;

  connect(Transformer.terminal2, terminal) annotation(
    Line(points = {{62, 0}, {94, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, Transformer.terminal1) annotation(
    Line(points = {{20, 0}, {42, 0}}, color = {0, 0, 255}));
  connect(dynCCVSMPlantControl.terminal, line.terminal1) annotation(
    Line(points = {{-22, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(Transformer.P2Pu, dynCCVSMPlantControl.PPccPu) annotation(
    Line(points = {{52, -10}, {52, -60}, {-60, -60}, {-60, 8}, {-44, 8}}, color = {0, 0, 127}));
  connect(Transformer.Q2Pu, dynCCVSMPlantControl.QPccPu) annotation(
    Line(points = {{42, -10}, {42, -40}, {-48, -40}, {-48, -6}, {-44, -6}}, color = {0, 0, 127}));
  connect(Transformer.U2Pu, dynCCVSMPlantControl.UPccPu) annotation(
    Line(points = {{62, -10}, {62, -20}, {-44, -20}, {-44, -8}}, color = {0, 0, 127}));
  connect(UFilterRefPu, dynCCVSMPlantControl.UFilterRefPu) annotation(
    Line(points = {{-114, -60}, {-32, -60}, {-32, -12}}, color = {230, 97, 0}, pattern = LinePattern.Dot));
  connect(URefPu, dynCCVSMPlantControl.URefPu) annotation(
    Line(points = {{-114, 0}, {-44, 0}, {-44, -2}}, color = {230, 97, 0}, pattern = LinePattern.Dot));
  connect(PRefPu, dynCCVSMPlantControl.PRefPu) annotation(
    Line(points = {{-114, 60}, {-60, 60}, {-60, 4}, {-44, 4}}, color = {230, 97, 0}, pattern = LinePattern.Dot));
  connect(omegaRefPu, dynCCVSMPlantControl.omegaRefPu) annotation(
    Line(points = {{0, 114}, {0, 20}, {-32, 20}, {-32, 12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram");
end DynCCVSMPlantControlFull;
