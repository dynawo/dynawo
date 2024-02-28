within Dynawo.Electrical.Wind.IEC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseWT4 "Base model for Wind Turbine Type 4 from IEC 61400-27-1 standard"
  extends Dynawo.Electrical.Controls.IEC.Parameters.GridProtectionParameters;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));

  //Control parameters
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMinPu "Minimum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kipaw "Anti-windup gain for active current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kiqaw "Anti-windup gain for reactive current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time tG "Current generation time constant in s" annotation(
    Dialog(tab = "Control"));

  //Measurement parameters for control
  parameter Types.PerUnit DfcMaxPu "Maximum frequency control ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tfcFilt "Filter time constant for frequency control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tIcFilt "Filter time constant for current control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tPcFilt "Filter time constant for active power control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tQcFilt "Filter time constant for reactive power control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tUcFilt "Filter time constant for voltage control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));

  //Measurement parameters for protection
  parameter Types.PerUnit DfpMaxPu "Maximum frequency protection ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tfpFilt "Filter time constant for frequency protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tIpFilt "Filter time constant for current protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tPpFilt "Filter time constant for active power protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tQpFilt "Filter time constant for reactive power protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tUpFilt "Filter time constant for voltage protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));

  //PLL parameters
  parameter Types.Time tPll "PLL first order filter time constant in s" annotation(
    Dialog(tab = "PLL"));
  parameter Types.VoltageModulePu UPll1Pu "Voltage below which the angle of the voltage is filtered and possibly also frozen, in pu (base UNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.VoltageModulePu UPll2Pu "Voltage below which the angle of the voltage is frozen, in pu (base UNom) (UPll2Pu < UPll1Pu typically)" annotation(
    Dialog(tab = "PLL"));

  //PControl parameters
  parameter Types.PerUnit Kpaw "Anti-windup gain for active power in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage dip threshold for power control in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxDipPu "Maximum current during voltage dip at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.CurrentModulePu IMaxPu "Maximum continuous current at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean MdfsLim "Limitation of type 3 stator current (false: total current limitation, true: stator current limitation)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean Mqpri "Prioritization of reactive power during FRT (false: active power priority, true: reactive power priority)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.VoltageModulePu UpquMaxPu "WT voltage in the operation point where zero reactive power can be delivered, in pu (base UNom)" annotation(
    Dialog(tab = "CurrentLimiter"));

  //QControl parameters
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqH1Pu "Maximum reactive current injection during dip in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMaxPu "Maximum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMinPu "Minimum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqPostPu "Post-fault reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiu "Voltage PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer MqG "General Q control mode (0-4): Voltage control (0), Reactive power control (1), Open loop reactive power control (2), Power factor control (3), Open loop power factor control (4)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit RDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPost "Length of time period where post-fault reactive power is injected, in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tQord "Reactive power order lag time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMaxPu "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMinPu "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqDipPu "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom) (typically equal to UpquMaxPu)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu URef0Pu "User-defined bias in voltage reference in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit XDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));

  //QLimiter parameters
  parameter Boolean QlConst "True if limits are constant" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMaxPu "Constant maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMinPu "Constant minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));

  //Grid protection parameters
  parameter Types.PerUnit fOverPu "WT over frequency protection activation threshold in pu (base fNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.PerUnit fUnderPu "WT under frequency protection activation threshold in pu (base fNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.VoltageModulePu UOverPu "WT over voltage protection activation threshold in pu (base UNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.VoltageModulePu UUnderPu "WT under voltage protection activation threshold in pu (base UNom)" annotation(
    Dialog(tab = "GridProtection"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frame for grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 130}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -19.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.IEC.WT4Injector wT4Injector(BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, XesPu = XesPu, i0Pu = i0Pu, tG = tG, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries.Measurements protectionMeasurements(DfMaxPu = DfpMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIpFilt, tPFilt = tPpFilt, tQFilt = tQpFilt, tS = tS, tUFilt = tUpFilt, tfFilt = tfpFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{20, 20}, {-20, -20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries.Measurements controlMeasurements(DfMaxPu = DfcMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIcFilt, tPFilt = tPcFilt, tQFilt = tQcFilt, tS = tS, tUFilt = tUcFilt, tfFilt = tfcFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries.PLL pll(U0Pu = U0Pu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, tPll = tPll, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-20, 20}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries.GridProtection gridProtection(U0Pu = U0Pu, UOverPu = UOverPu, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, TabletUoverUwtfilt11 = TabletUoverUwtfilt11, TabletUoverUwtfilt12 = TabletUoverUwtfilt12, TabletUoverUwtfilt21 = TabletUoverUwtfilt21, TabletUoverUwtfilt22 = TabletUoverUwtfilt22, TabletUoverUwtfilt31 = TabletUoverUwtfilt31, TabletUoverUwtfilt32 = TabletUoverUwtfilt32, TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUunderUwtfilt11 = TabletUunderUwtfilt11, TabletUunderUwtfilt12 = TabletUunderUwtfilt12, TabletUunderUwtfilt21 = TabletUunderUwtfilt21, TabletUunderUwtfilt22 = TabletUunderUwtfilt22, TabletUunderUwtfilt31 = TabletUunderUwtfilt31, TabletUunderUwtfilt32 = TabletUunderUwtfilt32, TabletUunderUwtfilt = TabletUunderUwtfilt, Tabletfoverfwtfilt11 = Tabletfoverfwtfilt11, Tabletfoverfwtfilt12 = Tabletfoverfwtfilt12, Tabletfoverfwtfilt21 = Tabletfoverfwtfilt21, Tabletfoverfwtfilt22 = Tabletfoverfwtfilt22, Tabletfoverfwtfilt31 = Tabletfoverfwtfilt31, Tabletfoverfwtfilt32 = Tabletfoverfwtfilt32, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfunderfwtfilt11 = Tabletfunderfwtfilt11, Tabletfunderfwtfilt12 = Tabletfunderfwtfilt12, Tabletfunderfwtfilt21 = Tabletfunderfwtfilt21, Tabletfunderfwtfilt22 = Tabletfunderfwtfilt22, Tabletfunderfwtfilt31 = Tabletfunderfwtfilt31, Tabletfunderfwtfilt32 = Tabletfunderfwtfilt32, Tabletfunderfwtfilt = Tabletfunderfwtfilt) annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(wT4Injector.terminal, terminal) annotation(
    Line(points = {{42, -40}, {130, -40}}, color = {0, 0, 255}));
  connect(gridProtection.fOCB, wT4Injector.fOCB) annotation(
    Line(points = {{60, -2}, {60, -10}, {20, -10}, {20, -18}}, color = {255, 0, 255}));
  connect(pll.thetaPll, wT4Injector.theta) annotation(
    Line(points = {{-20, -2}, {-20, -10}, {8, -10}, {8, -18}}, color = {0, 0, 127}));
  connect(omegaRefPu, protectionMeasurements.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 116}, {48, 116}, {48, 102}}, color = {0, 0, 127}));
  connect(omegaRefPu, controlMeasurements.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 116}, {-68, 116}, {-68, 102}}, color = {0, 0, 127}));
  connect(protectionMeasurements.omegaFiltPu, gridProtection.omegaFiltPu) annotation(
    Line(points = {{44, 58}, {44, 50}, {52, 50}, {52, 42}}, color = {0, 0, 127}));
  connect(protectionMeasurements.UFiltPu, gridProtection.UWTPFiltPu) annotation(
    Line(points = {{56, 58}, {56, 50}, {68, 50}, {68, 42}}, color = {0, 0, 127}));
  connect(controlMeasurements.theta, pll.theta) annotation(
    Line(points = {{-68, 58}, {-68, 50}, {-12, 50}, {-12, 42}}, color = {0, 0, 127}));
  connect(wT4Injector.iWtPu, controlMeasurements.iPu) annotation(
    Line(points = {{42, -24}, {100, -24}, {100, 106}, {-80, 106}, {-80, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.iWtPu, protectionMeasurements.iPu) annotation(
    Line(points = {{42, -24}, {100, -24}, {100, 106}, {60, 106}, {60, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.uWtPu, controlMeasurements.uPu) annotation(
    Line(points = {{42, -28}, {104, -28}, {104, 110}, {-92, 110}, {-92, 102}}, color = {85, 170, 255}));
  connect(wT4Injector.uWtPu, protectionMeasurements.uPu) annotation(
    Line(points = {{42, -28}, {104, -28}, {104, 110}, {72, 110}, {72, 102}}, color = {85, 170, 255}));
  connect(controlMeasurements.UPu, pll.UWTPu) annotation(
    Line(points = {{-80, 58}, {-80, 48}, {-28, 48}, {-28, 42}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WT4")}),
  Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}})));
end BaseWT4;
