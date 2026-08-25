within Dynawo.Electrical.Controls.PEIR.BaseControls.Plant;

model DynVSMPlantControl "GFM with VSM control and a generic Plant Controller"
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
  // Operating Point - GFM
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at GFM terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at GFM terminal in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at GFM terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at GFM terminal in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminalof the GFM in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at terminalof the GFM in pu (base UNom, SnRef) (receptor convention)";
  // Operating Point - PCC
  parameter Types.VoltageModulePu UPcc0Pu "Start value of voltage amplitude at PCC terminal in pu (base UNom)";
  parameter Types.Angle UPccPhase0 "Start value of voltage angle at PCC terminal in rad";
  parameter Types.ActivePowerPu PPcc0Pu "Start value of active power at PCC terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QPcc0Pu "Start value of reactive power at PCC terminal in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uPcc0Pu = Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0) "Start value of the complex voltage at terminalof the PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iPcc0Pu = Modelica.ComplexMath.conj(Complex(PPcc0Pu, QPcc0Pu)/uPcc0Pu) "Start value of the complex current at terminalof the PCC in pu (base UNom, SnRef) (receptor convention)";

  parameter Types.Time tUFiltGFM = 0.01 "Filter time constant for voltage measurement in s";
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain" annotation(
    Dialog(tab = "VSM"));
  parameter Types.Time H "Inertia constant in s" annotation(
    Dialog(tab = "VSM"));
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kic "Integral gain of the current loop" annotation(
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
  // PlantControl parameters
  //Parameters -- gains
  parameter Types.PerUnit Lambd "Gain for voltage/reactive power regulation" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kdroop "Gain for frequency/active power regulation"annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- time constants
  parameter Real tQFilt "Time constant for the reactive power filter (in s)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real tPFilt "Time constant for the active power filter (in s)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real tUFilt "Time constant for the voltage filter (in s)"annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- PI gains
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop"annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kiq "PI integral gain - voltage/Q loop"annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop"annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit Kip "PI integral gain - active power loop"annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- output limits (base SNref, receptor convention, i.e. same base as PI internal signals before final conversion)
  parameter Real QMaxPu "Maximum reactive power reference before base/sign conversion (pu, base SNref)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real QMinPu "Minimum reactive power reference before base/sign conversion (pu, base SNref)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real PMaxPu "Maximum active power reference before base/sign conversion (pu, base SNref)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real PMinPu "Minimum active power reference before base/sign conversion (pu, base SNref)"annotation(
    Dialog(tab = "Plant Control"));
  //Parameters -- deadbands and frequency droop limiter
  parameter Real FEMaxPu "Maximum frequency error after droop limiter (pu)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real FEMinPu "Minimum frequency error after droop limiter (pu)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real FDbd1Pu "Frequency deadband lower threshold (pu, positive value)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real FDbd2Pu "Frequency deadband upper threshold (pu, positive value)"annotation(
    Dialog(tab = "Plant Control"));
  parameter Real DbdPu "Voltage error deadband half-width (pu)"annotation(
    Dialog(tab = "Plant Control"));

  //Inputs
  Modelica.Blocks.Interfaces.RealInput UPccPu(start = UPcc0Pu) "Voltage at the PCC in p.u. (base UNom)" annotation(
    Placement(transformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-112, -88}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = UPcc0Pu + Lambd * QPcc0Pu) "Reference voltage at the PCC in p.u. (base UNom)" annotation(
    Placement(transformation(origin = {-114, -20}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -21}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput QPccPu(start = QPcc0Pu) "Reactive power at the PCC in p.u. (receptor convention, base SNref)" annotation(
    Placement(transformation(origin = {-114, -50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -53}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PPccPu(start = PPcc0Pu) "Active power at the PCC in p.u. (receptor convention, base SNref)" annotation(
    Placement(transformation(origin = {-114, 80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 79}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PPcc0Pu) annotation(
    Placement(transformation(origin = {-114, 50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 49}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = 1.0) annotation(
    Placement(transformation(origin = {-12, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = U0Pu) annotation(
    Placement(transformation(origin = {-52, -60}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {1, -111}, extent = {{-11, -11}, {11, 11}}, rotation = 90)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSM DynGFMVSM(SNom = SNom, kVSM = kVSM, H = H, KpVI = KpVI, XRratio = XRratio, IMaxVI = IMaxVI, Mq = Mq, Wf = Wf, Wff = Wff, Kff = Kff, XVI = XVI, Kpc = Kpc, Kic = Kic, Kfd = Kfd, Kfq = Kfq, RFilterPu = RFilterPu, LFilterPu = LFilterPu, CFilterPu = CFilterPu, RTransformerPu = RTransformerPu, LTransformerPu = LTransformerPu, tVSC = tVSC, U0Pu = U0Pu, UPhase0 = UPhase0, P0Pu = P0Pu, Q0Pu = Q0Pu, OmegaSetPu = 1.0)  annotation(
    Placement(transformation(origin = {25, -3}, extent = {{-21, -21}, {21, 21}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Plant.PlantControl plantControl(SNom = SNom, Lambd = Lambd, Kdroop = Kdroop, tQFilt = tQFilt, tPFilt = tPFilt, tUFilt = tUFilt, Kpq = Kpq, Kiq = Kiq, Kpp = Kpp, Kip = Kip, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, QPcc0Pu = QPcc0Pu, Omega0Pu = 1.0, UPcc0Pu = UPcc0Pu, PPcc0Pu = PPcc0Pu)  annotation(
    Placement(transformation(origin = {-62, -2}, extent = {{-10, -10}, {10, 10}})));
  Connectors.ACPower terminal annotation(
    Placement(transformation(origin = {96, -2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  DynGFMVSM.switchOffSignal1 = false;
  DynGFMVSM.switchOffSignal2 = false;
  DynGFMVSM.switchOffSignal3 = false;
  connect(plantControl.QInjRefPu, DynGFMVSM.QFilterRefPu) annotation(
    Line(points = {{-51, -8}, {-28.5, -8}, {-28.5, -11}, {2, -11}}, color = {0, 0, 127}));
  connect(DynGFMVSM.omegaVSMPu, plantControl.omegaPu) annotation(
    Line(points = {{38, 20}, {-98, 20}, {-98, 0}, {-73, 0}}, color = {0, 0, 127}));
  connect(plantControl.PInjRefPu, DynGFMVSM.PFilterRefPu) annotation(
    Line(points = {{-51, 4}, {-24, 4}, {-24, 14}, {2, 14}}, color = {0, 0, 127}));
  connect(omegaRefPu, DynGFMVSM.omegaRefPu) annotation(
    Line(points = {{-12, 114}, {-12, 6}, {2, 6}}, color = {0, 0, 127}));
  connect(UFilterRefPu, DynGFMVSM.UFilterRefPu) annotation(
    Line(points = {{-52, -60}, {-6, -60}, {-6, -20}, {2, -20}}, color = {0, 0, 127}));
  connect(URefPu, plantControl.URefPu) annotation(
    Line(points = {{-114, -20}, {-90, -20}, {-90, -4}, {-74, -4}}, color = {0, 0, 127}));
  connect(QPccPu, plantControl.QPccPu) annotation(
    Line(points = {{-114, -50}, {-84, -50}, {-84, -8}, {-74, -8}}, color = {0, 0, 127}));
  connect(UPccPu, plantControl.UPccPu) annotation(
    Line(points = {{-114, -80}, {-76, -80}, {-76, -10}, {-74, -10}}, color = {0, 0, 127}));
  connect(PRefPu, plantControl.PRefPu) annotation(
    Line(points = {{-114, 50}, {-78, 50}, {-78, 2}, {-74, 2}}, color = {0, 0, 127}));
  connect(PPccPu, plantControl.PPccPu) annotation(
    Line(points = {{-114, 80}, {-74, 80}, {-74, 6}}, color = {0, 0, 127}));
  connect(DynGFMVSM.terminal, terminal) annotation(
    Line(points = {{48, -2}, {96, -2}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram);
end DynVSMPlantControl;
