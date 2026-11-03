within Dynawo.Electrical.PEIR.Plants.General.Average;

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

model DynDroopPlantControlFull "GFM with droop control, generic Plant Controller, line and Transformer"
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";
  parameter Types.Time tUFiltGFM = 0.01 "Filter time constant for voltage measurement in the converter in s";
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu IMaxVIPu "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu EpsVIUpPu "Upper half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold, in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu EpsVIDownPu "Lower half-width of the dead band around IMaxVI, to avoid chattering at the activation threshold, in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  // Droop & voltage reference control parameters
  parameter Types.PerUnit Mp "Active power droop control coefficient" annotation(
    Dialog(tab = "Droop & Voltage Reference"));
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Droop & Voltage Reference"));
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters in rad/s" annotation(
    Dialog(tab = "Droop & Voltage Reference"));
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the active damping in rad/s" annotation(
    Dialog(tab = "Droop & Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Droop & Voltage Reference"));
  // QSEM parameter
  parameter Types.PerUnit XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Current loop parameters
  parameter Types.AngularVelocity Omegac "Current loop bandwidth in rad/s" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
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
  // PLL parameters
  parameter Types.AngularVelocity OmegaPLL "PLL bandwidth in rad/s" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KsiPLL "PLL damping ratio (dimensionless)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu OmegaMaxPLLPu "Upper frequency limit of the PLL in pu (base omegaNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu OmegaMinPLLPu "Lower frequency limit of the PLL in pu (base omegaNom)" annotation(
    Dialog(tab = "PLL"));
  // Plant control parameters -- gains
  parameter Types.PerUnit LambdaPu "Reactive power compensation gain, URegPu + LambdaPu*QReg is controlled (in pu (base UNom) per pu (base SNom), generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kdroop "Frequency droop gain (in pu (base SNom) per pu (base omegaNom), generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  // Plant control parameters -- time constants
  parameter Types.Time tQFilt "Time constant for the reactive power filter in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tPFilt "Time constant for the active power filter in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tUFilt "Time constant for the voltage filter in s" annotation(
    Dialog(tab = "Plant Control"));
  // Plant control parameters -- PI gains
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop" annotation(
    Dialog(tab = "Plant Control"));
  parameter Real Kiq(unit = "1/s") "PI integral gain - voltage/Q loop" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop" annotation(
    Dialog(tab = "Plant Control"));
  parameter Real Kip(unit = "1/s") "PI integral gain - active power loop" annotation(
    Dialog(tab = "Plant Control"));
  // Plant control parameters -- output limits
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power reference sent to the converter in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power reference sent to the converter in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu PMaxPu "Maximum active power reference sent to the converter in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu PMinPu "Minimum active power reference sent to the converter in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  // Plant control parameters -- deadbands and frequency droop limiter
  parameter Types.ActivePowerPu FEMaxPu "Maximum active power contribution of the frequency droop in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu FEMinPu "Minimum active power contribution of the frequency droop in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit FDbd1Pu "Frequency deadband on the over-frequency side in pu (base omegaNom) (positive value)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit FDbd2Pu "Frequency deadband on the under-frequency side in pu (base omegaNom) (positive value)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DbdPu "Voltage error deadband half-width in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));
  // Line parameters
  parameter Types.PerUnit RPu "Line resistance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit XPu "Line reactance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit GPu "Line half-conductance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  parameter Types.PerUnit BPu "Line half-susceptance in pu (base SnRef)" annotation(
    Dialog(tab = "Line"));
  // Plant transformer parameters
  parameter Types.PerUnit RTfoPu "Plant transformer resistance on the converter side (terminal 2) in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit XTfoPu "Plant transformer reactance on the converter side (terminal 2) in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit GTfoPu "Plant transformer conductance on the converter side (terminal 2) in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit BTfoPu "Plant transformer susceptance on the converter side (terminal 2) in pu (base U2Nom, SnRef)" annotation(
    Dialog(tab = "Plant transformer"));
  parameter Types.PerUnit rTfoPu "Plant transformer ratio in pu: U2/U1 in no load conditions (terminal 1 on the regulated bus side, terminal 2 on the converter side)" annotation(
    Dialog(tab = "Plant transformer"));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = dynDroopPlantControl.plantControl.PRegGen0Pu) "Active power setpoint at the regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-114, 60}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 61}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = dynDroopPlantControl.plantControl.URef0Pu) "Voltage reference at the regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -61}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {0, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

  // Terminal
  Dynawo.Connectors.ACPower terminal(V(re(start = uReg0Pu.re), im(start = uReg0Pu.im)), i(re(start = iReg0Pu.re), im(start = iReg0Pu.im))) "Connector used to connect the plant to the grid (regulated bus)" annotation(
    Placement(transformation(origin = {94, 0}, extent = {{-8, -8}, {8, 8}}), iconTransformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.PEIR.Plants.General.Average.DynDroopPlantControl dynDroopPlantControl(EpsVIUpPu = EpsVIUpPu, EpsVIDownPu = EpsVIDownPu, Omega0Pu = Omega0Pu, OmegaRef0Pu = OmegaRef0Pu, tUFiltGFM = tUFiltGFM, CFilterPu = CFilterPu, DbdPu = DbdPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, IMaxVIPu = IMaxVIPu, Kdroop = Kdroop, Kfd = Kfd, Kff = Kff, Kfq = Kfq, Kip = Kip, Kiq = Kiq, KpVI = KpVI, Kpp = Kpp, Kpq = Kpq, KsiPLL = KsiPLL, OmegaMaxPLLPu = OmegaMaxPLLPu, OmegaMinPLLPu = OmegaMinPLLPu, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, LambdaPu = LambdaPu, Mq = Mq, OmegaPLL = OmegaPLL, Omegac = Omegac, Omegaf = Omegaf, Omegaff = Omegaff, P0Pu = PGfm0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PReg0Pu = PReg0Pu, Q0Pu = QGfm0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, QReg0Pu = QReg0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, U0Pu = UGfm0Pu, UReg0Pu = UReg0Pu, URegPhase0 = URegPhase0, UPhase0 = UPhaseGfm0, XRratio = XRratio, XVIPu = XVIPu, Mp = Mp, tPFilt = tPFilt, tQFilt = tQFilt, tUFilt = tUFilt, tVSC = tVSC) annotation(
    Placement(transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line(BPu = BPu, GPu = GPu, RPu = RPu, XPu = XPu,
    terminal1(V(re(start = uGfm0Pu.re), im(start = uGfm0Pu.im)), i(re(start = iLine10Pu.re), im(start = iLine10Pu.im))),
    terminal2(V(re(start = uTfo20Pu.re), im(start = uTfo20Pu.im)), i(re(start = iLine20Pu.re), im(start = iLine20Pu.im)))) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio Transformer(RPu = RTfoPu, XPu = XTfoPu, GPu = GTfoPu, BPu = BTfoPu, rTfoPu = rTfoPu,
    terminal1(V(re(start = uReg0Pu.re), im(start = uReg0Pu.im)), i(re(start = iReg0Pu.re), im(start = iReg0Pu.im))),
    terminal2(V(re(start = uTfo20Pu.re), im(start = uTfo20Pu.im)), i(re(start = iTfo20Pu.re), im(start = iTfo20Pu.im)))) annotation(
    Placement(transformation(origin = {52, 0}, extent = {{10, -10}, {-10, 10}})));

  // Initial parameters - frequency
  parameter Types.AngularVelocityPu Omega0Pu = SystemBase.omegaRef0Pu "Start value of the physical frequency of the grid and converter in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaRef0Pu = SystemBase.omegaRef0Pu "Start value of the rotation speed of the RI reference frame (omegaRefPu input) in pu (base omegaNom)";
  // Initial parameters - regulated bus (plant terminal)
  parameter Types.VoltageModulePu UReg0Pu "Start value of voltage amplitude at the regulated bus in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.Angle URegPhase0 "Start value of voltage angle at the regulated bus in rad" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ActivePowerPu PReg0Pu "Start value of active power at the regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ReactivePowerPu QReg0Pu "Start value of reactive power at the regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Initialization"));
  final parameter Types.ComplexVoltagePu uReg0Pu = Modelica.ComplexMath.fromPolar(UReg0Pu, URegPhase0) "Start value of the complex voltage at the regulated bus in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iReg0Pu = Modelica.ComplexMath.conj(Complex(PReg0Pu, QReg0Pu)/uReg0Pu) "Start value of the complex current at the regulated bus in pu (base UNom, SnRef) (receptor convention)";
  // Initial parameters - plant transformer terminal 2 (converter side)
  final parameter Types.ComplexImpedancePu ZTfoPu = Complex(RTfoPu, XTfoPu) "Plant transformer impedance in pu (base U2Nom, SnRef)";
  final parameter Types.ComplexAdmittancePu YTfoPu = Complex(GTfoPu, BTfoPu) "Plant transformer admittance in pu (base U2Nom, SnRef)";
  final parameter Types.ComplexVoltagePu uTfo20Pu = (rTfoPu*rTfoPu*uReg0Pu - ZTfoPu*iReg0Pu)/rTfoPu "Start value of the complex voltage at transformer terminal 2 in pu (base U2Nom)";
  final parameter Types.ComplexCurrentPu iTfo20Pu = YTfoPu*uTfo20Pu - iReg0Pu/rTfoPu "Start value of the complex current at transformer terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  // Initial parameters - converter terminal
  final parameter Types.ComplexImpedancePu ZLinePu = Complex(RPu, XPu) "Line impedance in pu (base UNom, SnRef)";
  final parameter Types.ComplexAdmittancePu YLinePu = Complex(GPu, BPu) "Line half-admittance in pu (base UNom, SnRef)";
  final parameter Types.ComplexCurrentPu iLine20Pu = -iTfo20Pu "Start value of the complex current at line terminal 2 in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uGfm0Pu = uTfo20Pu - ZLinePu*(iLine20Pu - YLinePu*uTfo20Pu) "Start value of the complex voltage at the converter terminal in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iLine10Pu = (uGfm0Pu - uTfo20Pu)/ZLinePu + YLinePu*uGfm0Pu "Start value of the complex current at line terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iGfm0Pu = -iLine10Pu "Start value of the complex current at the converter terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.VoltageModulePu UGfm0Pu = Modelica.ComplexMath.'abs'(uGfm0Pu) "Start value of voltage amplitude at the converter terminal in pu (base UNom)";
  final parameter Types.Angle UPhaseGfm0 = Modelica.ComplexMath.arg(uGfm0Pu) "Start value of voltage angle at the converter terminal in rad";
  final parameter Types.ActivePowerPu PGfm0Pu = Modelica.ComplexMath.real(uGfm0Pu*Modelica.ComplexMath.conj(iGfm0Pu)) "Start value of active power at the converter terminal in pu (base SnRef) (receptor convention)";
  final parameter Types.ReactivePowerPu QGfm0Pu = Modelica.ComplexMath.imag(uGfm0Pu*Modelica.ComplexMath.conj(iGfm0Pu)) "Start value of reactive power at the converter terminal in pu (base SnRef) (receptor convention)";

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  Transformer.switchOffSignal1 = false;
  Transformer.switchOffSignal2 = false;

  connect(Transformer.terminal1, terminal) annotation(
    Line(points = {{62, 0}, {94, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, Transformer.terminal2) annotation(
    Line(points = {{20, 0}, {42, 0}}, color = {0, 0, 255}));
  connect(dynDroopPlantControl.terminal, line.terminal1) annotation(
    Line(points = {{-22, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(Transformer.P1Pu, dynDroopPlantControl.PRegPu) annotation(
    Line(points = {{52, -10}, {52, -60}, {-60, -60}, {-60, 8}, {-44, 8}}, color = {0, 0, 127}));
  connect(Transformer.Q1Pu, dynDroopPlantControl.QRegPu) annotation(
    Line(points = {{62, -10}, {62, -40}, {-48, -40}, {-48, -6}, {-44, -6}}, color = {0, 0, 127}));
  connect(Transformer.U1Pu, dynDroopPlantControl.URegPu) annotation(
    Line(points = {{42, -10}, {42, -20}, {-44, -20}, {-44, -8}}, color = {0, 0, 127}));
  connect(URefPu, dynDroopPlantControl.URefPu) annotation(
    Line(points = {{-114, 0}, {-44, 0}, {-44, -2}}, color = {230, 97, 0}, pattern = LinePattern.Dot));
  connect(PRefPu, dynDroopPlantControl.PRefPu) annotation(
    Line(points = {{-114, 60}, {-60, 60}, {-60, 4}, {-44, 4}}, color = {230, 97, 0}, pattern = LinePattern.Dot));
  connect(omegaRefPu, dynDroopPlantControl.omegaRefPu) annotation(
    Line(points = {{0, 114}, {0, 20}, {-32, 20}, {-32, 12}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>Grid-forming plant made of a droop converter with its generic plant controller (DynDroopPlantControl), a plant line and a plant transformer, connected to the grid at the regulated bus (terminal).<br><br>The plant controller measures the voltage and the active and reactive powers at the transformer terminal 1 (regulated bus). The impedance and the shunt admittance of the plant transformer are on its terminal 2, connected to the converter side through the plant line. The operating point of the converter terminal (UGfm0Pu, UPhaseGfm0, PGfm0Pu, QGfm0Pu) is computed from the regulated bus operating point (UReg0Pu, URegPhase0, PReg0Pu, QReg0Pu) through the transformer and the line, so only the regulated bus operating point has to be provided.</body></html>"));
end DynDroopPlantControlFull;
