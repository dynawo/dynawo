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

model DynDroopPlantControl "GFM with droop control and a generic Plant Controller"
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

  // Inputs
  Modelica.Blocks.Interfaces.RealInput PRegPu(start = PReg0Pu) "Active power at the regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Placement(transformation(origin = {-114, 80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 79}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = plantControl.PRegGen0Pu) "Active power setpoint at the regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-114, 50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 49}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = plantControl.URef0Pu) "Voltage reference at the regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-114, -20}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -21}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Reactive power at the regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Placement(transformation(origin = {-114, -50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -53}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput URegPu(start = UReg0Pu) "Voltage module at the regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-112, -88}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-12, 114}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {1, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90)));

  // Terminal
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.PlantController.PlantControl plantControl(SNom = SNom, LambdaPu = LambdaPu, Kdroop = Kdroop, tQFilt = tQFilt, tPFilt = tPFilt, tUFilt = tUFilt, Kpq = Kpq, Kiq = Kiq, Kpp = Kpp, Kip = Kip, QMaxPu = QMaxPu, QMinPu = QMinPu, PMaxPu = PMaxPu, PMinPu = PMinPu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, DbdPu = DbdPu, QReg0Pu = QReg0Pu, Omega0Pu = Omega0Pu, UReg0Pu = UReg0Pu, PReg0Pu = PReg0Pu, Pinj0Pu = dynGFMDroop.ControlDroop.PRef0Pu, Qinj0Pu = dynGFMDroop.ControlDroop.QFilter0Pu) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop dynGFMDroop(tUFilt = tUFiltGFM, EpsVIUpPu = EpsVIUpPu, EpsVIDownPu = EpsVIDownPu, Omega0Pu = Omega0Pu, OmegaRef0Pu = OmegaRef0Pu, CFilterPu = CFilterPu, IMaxVIPu = IMaxVIPu, Kfd = Kfd, Kff = Kff, Kfq = Kfq, KpVI = KpVI, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Mq = Mq, P0Pu = P0Pu, Q0Pu = Q0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, Omegaf = Omegaf, Omegaff = Omegaff, XRratio = XRratio, XVIPu = XVIPu, tVSC = tVSC, Mp = Mp, Omegac = Omegac, OmegaPLL = OmegaPLL, KsiPLL = KsiPLL, OmegaMaxPLLPu = OmegaMaxPLLPu, OmegaMinPLLPu = OmegaMinPLLPu)annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}})));

  // Initial parameters - frequency
  parameter Types.AngularVelocityPu Omega0Pu = SystemBase.omegaRef0Pu "Start value of the physical frequency of the grid and converter in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaRef0Pu = SystemBase.omegaRef0Pu "Start value of the rotation speed of the RI reference frame (omegaRefPu input) in pu (base omegaNom)";
  // Initial parameters - converter terminal
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at the converter terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at the converter terminal in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at the converter terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at the converter terminal in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at the converter terminal in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at the converter terminal in pu (base UNom, SnRef) (receptor convention)";
  // Initial parameters - regulated bus
  parameter Types.VoltageModulePu UReg0Pu "Start value of voltage amplitude at the regulated bus in pu (base UNom)";
  parameter Types.Angle URegPhase0 "Start value of voltage angle at the regulated bus in rad";
  parameter Types.ActivePowerPu PReg0Pu "Start value of active power at the regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QReg0Pu "Start value of reactive power at the regulated bus in pu (base SnRef) (receptor convention)";

equation
  dynGFMDroop.switchOffSignal1 = false;
  dynGFMDroop.switchOffSignal2 = false;
  dynGFMDroop.switchOffSignal3 = false;
  // The plant controller acts on the converter through QFilterRefPu only: the converter voltage reference is kept at its initial value
  dynGFMDroop.UFilterRefPu = dynGFMDroop.ControlDroop.URef0Pu;

  connect(URefPu, plantControl.URefPu) annotation(
    Line(points = {{-114, -20}, {-90, -20}, {-90, -2}, {-61, -2}}, color = {0, 0, 127}));
  connect(QRegPu, plantControl.QRegPu) annotation(
    Line(points = {{-114, -50}, {-84, -50}, {-84, -5}, {-61, -5}}, color = {0, 0, 127}));
  connect(URegPu, plantControl.URegPu) annotation(
    Line(points = {{-114, -80}, {-76, -80}, {-76, -9}, {-61, -9}}, color = {0, 0, 127}));
  connect(PRefPu, plantControl.PRefPu) annotation(
    Line(points = {{-114, 50}, {-78, 50}, {-78, 5}, {-61, 5}}, color = {0, 0, 127}));
  connect(PRegPu, plantControl.PRegPu) annotation(
    Line(points = {{-114, 80}, {-74, 80}, {-74, 8}, {-61, 8}}, color = {0, 0, 127}));

  connect(dynGFMDroop.terminal, terminal) annotation(
    Line(points = {{42, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu, dynGFMDroop.omegaRefPu) annotation(
    Line(points = {{-12, 114}, {-12, 59}, {-26, 59}, {-26, 8.5}, {-2, 8.5}, {-2, 8}}, color = {0, 0, 127}));
  connect(plantControl.PInjRefPu, dynGFMDroop.PFilterRefPu) annotation(
    Line(points = {{-39, 6}, {-30.5, 6}, {-30.5, 16}, {-2, 16}}, color = {0, 0, 127}));
  connect(plantControl.QInjRefPu, dynGFMDroop.QFilterRefPu) annotation(
    Line(points = {{-39, -6}, {-19.5, -6}, {-19.5, -8}, {-2, -8}}, color = {0, 0, 127}));
  connect(dynGFMDroop.omegaDroopPu, plantControl.omegaPu) annotation(
    Line(points = {{32, 22}, {-86, 22}, {-86, 2}, {-61, 2}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>Grid-forming converter with a droop control (DynGFMDroop), driven by a generic plant controller (PlantControl).<br><br>The plant controller regulates the active power (with a frequency droop) and the voltage (with reactive power compensation) measured at the regulated bus, and sends active and reactive power references to the converter filter. The voltage reference of the converter (UFilterRefPu) is kept at its initial value: the plant controller acts on the voltage through the reactive power reference only, the converter Q-U droop (Mq) translating it into an internal voltage reference. The regulated bus measurements (URegPu, PRegPu, QRegPu) are inputs of this model: the network between the converter terminal and the regulated bus is modelled outside (see DynDroopPlantControlFull, which adds the plant line and transformer).<br><br>Conventions: regulated bus measurements and start values are in pu (base SnRef) in receptor convention, plant control setpoints and limits are in pu (base SNom) in generator convention.</body></html>"));
end DynDroopPlantControl;
