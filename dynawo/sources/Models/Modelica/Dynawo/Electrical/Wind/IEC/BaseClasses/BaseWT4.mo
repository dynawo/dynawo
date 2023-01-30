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
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //Circuit parameters
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
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

  //Measurement parameters
  parameter Types.PerUnit DfMaxPu "Maximum frequency ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tIFilt "Filter time constant for current measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "Measurement"));

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
  parameter Types.CurrentModulePu IMaxPu "Maximum continuous current at converter terminal in pu (base UNom, SNom)"  annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.CurrentModulePu IMaxDipPu "Maximum current during voltage dip at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean MdfsLim "Limitation of type 3 stator current (false: total current limitation, true: stator current limitation)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean Mqpri "Prioritisation of reactive power during FRT (false: active power priority, true: reactive power priority)" annotation(
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
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
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
    Placement(visible = true, transformation(origin = {107, -40}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frame for grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -19.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.IEC.WT4Injector wT4Injector(BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, XesPu = XesPu, i0Pu = i0Pu, tG = tG, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.Measurements measurements(DfMaxPu = DfMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIFilt, tPFilt = tPFilt, tQFilt = tQFilt, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, 80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.PLL pll(U0Pu = U0Pu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, tPll = tPll) annotation(
    Placement(visible = true, transformation(origin = {-20, 20}, extent = {{20, -20}, {-20, 20}}, rotation = 180)));
  Dynawo.Electrical.Controls.IEC.BaseControls.GridProtection gridProtection(U0Pu = U0Pu, UOverPu = UOverPu, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu) annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  //Initial parameters
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(pll.thetaPll, wT4Injector.theta) annotation(
    Line(points = {{2, 20}, {8, 20}, {8, -18}}, color = {0, 0, 127}));
  connect(gridProtection.fOCB, wT4Injector.fOCB) annotation(
    Line(points = {{38, 20}, {20, 20}, {20, -18}}, color = {255, 0, 255}));
  connect(wT4Injector.terminal, terminal) annotation(
    Line(points = {{42, -40}, {108, -40}}, color = {0, 0, 255}));
  connect(measurements.theta, pll.theta) annotation(
    Line(points = {{-2, 68}, {-50, 68}, {-50, 28}, {-42, 28}}, color = {0, 0, 127}));
  connect(measurements.omegaFiltPu, gridProtection.omegaFiltPu) annotation(
    Line(points = {{-2, 64}, {-20, 64}, {-20, 50}, {90, 50}, {90, 28}, {82, 28}}, color = {0, 0, 127}));
  connect(measurements.UFiltPu, gridProtection.UWTPFiltPu) annotation(
    Line(points = {{-2, 76}, {-10, 76}, {-10, 52}, {92, 52}, {92, 12}, {82, 12}}, color = {0, 0, 127}));
  connect(measurements.UPu, pll.UWTPu) annotation(
    Line(points = {{-2, 80}, {-52, 80}, {-52, 12}, {-42, 12}}, color = {0, 0, 127}));
  connect(wT4Injector.iWtPu, measurements.iPu) annotation(
    Line(points = {{42, -24}, {94, -24}, {94, 80}, {42, 80}}, color = {85, 170, 255}));
  connect(wT4Injector.uWtPu, measurements.uPu) annotation(
    Line(points = {{42, -28}, {96, -28}, {96, 92}, {42, 92}}, color = {85, 170, 255}));
  connect(omegaRefPu, measurements.omegaRefPu) annotation(
    Line(points = {{110, 60}, {60, 60}, {60, 68}, {42, 68}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(initialScale = 0.1, grid = {1, 1}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WT4")}),
    Diagram);
end BaseWT4;
