within Dynawo.Examples.GridForming.PlantControl;

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

model DynGFMCCPlantControl "GFM with current-controlled VSM control and a generic Plant Controller (compact plant model)"
  extends Modelica.Icons.Example;

  // Operating point at the regulated bus (plant terminal)
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu UReg0Pu = 1.02343286532015 "Start value of voltage amplitude at the regulated bus in pu (base UNom)";
  parameter Types.Angle URegPhase0 = 0.0464048380960457 "Start value of voltage angle at the regulated bus in rad";
  parameter Types.ActivePowerPu PReg0Pu = -9.89773532110073 "Start value of active power at the regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QReg0Pu = -4.02696677575302 "Start value of reactive power at the regulated bus in pu (base SnRef) (receptor convention)";

  Modelica.Blocks.Sources.Constant URefPu(k = dynCCVSMPlantControlFull.dynCCVSMPlantControl.plantControl.URef0Pu) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = dynCCVSMPlantControlFull.dynCCVSMPlantControl.plantControl.PRegGen0Pu) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(transformation(origin = {80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(transformation(origin = {80, 6}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  Dynawo.Electrical.PEIR.Plants.General.Average.DynCCVSMPlantControlFull dynCCVSMPlantControlFull(EpsVIUpPu = 0.01, EpsVIDownPu = 0.01, EpsUpPu = 0.01, EpsDownPu = 0.01, tSat = 0.01, Omega0Pu = 0.99, OmegaRef0Pu = 1, SNom = SNom, UReg0Pu = UReg0Pu, URegPhase0 = URegPhase0, PReg0Pu = PReg0Pu, QReg0Pu = QReg0Pu, kVSM = 650, H = 5, KDampingAngle = 0.00318, KpVI = 0.6, XRratio = 10, IMaxVIPu = 1.2, DeltaIConvMaxPu = 0.1, Mq = 0.2, Kff = 0, Omegaf = 31.4159, Omegaff = 60, XVIPu = 0.06, Omegac = 1000, Kfd = 0.8, Kfq = 0, ImaxPu = 1.2, IminPu = 0, tVSC = 0.0002, LambdaPu = 0.1, Kdroop = 0, tQFilt = 0.1, tPFilt = 1, tUFilt = 0.1, Kpq = 0.01, Kiq = 0.1, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 10, QMinPu = -10, PMaxPu = 10, PMinPu = -10, RFilterPu = 0.015, LFilterPu = 0.15, CFilterPu = 1e-5, RTransformerPu = 0.006, LTransformerPu = 0.06, OmegaPLL = 100, OmegaMaxPLLPu = 10, OmegaMinPLLPu = -10, KsiPLL = 1, RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0, RTfoPu = 0.0005, XTfoPu = 0.005, GTfoPu = 0, BTfoPu = 0, rTfoPu = 1) annotation(
    Placement(transformation(origin = {-1, -1}, extent = {{-21, -21}, {21, 21}})));
  Dynawo.Electrical.Sources.AcGridRoCoF acGridRoCoF(RoCoFPu = 0.01, tRoCoFStart = 10, deltaOmega0Pu = -0.01, tRoCoFDuration = 3, U0Pu = 1, UPhase0 = 0, ReturnRoCoF = true) annotation(
    Placement(transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}})));

equation
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;

  connect(omegaRefPu.y, dynCCVSMPlantControlFull.omegaRefPu) annotation(
    Line(points = {{0, 79}, {0, 22}, {-1, 22}}, color = {0, 0, 127}));
  connect(PRefPu.y, dynCCVSMPlantControlFull.PRefPu) annotation(
    Line(points = {{-59, 20}, {-39.5, 20}, {-39.5, 12}, {-24, 12}}, color = {0, 0, 127}));
  connect(URefPu.y, dynCCVSMPlantControlFull.URefPu) annotation(
    Line(points = {{-59, -20}, {-39.5, -20}, {-39.5, -14}, {-24, -14}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, acGridRoCoF.omegaRefPu) annotation(
    Line(points = {{0, 79}, {0, 75}, {38, 75}}, color = {0, 0, 127}));
  connect(acGridRoCoF.aCPower, line1.terminal1) annotation(
    Line(points = {{61.5, 77}, {61.5, 76}, {80, 76}, {80, 60}}, color = {0, 0, 255}));
  connect(dynCCVSMPlantControlFull.terminal, measurements.terminal1) annotation(
    Line(points = {{19, -1}, {19, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, measurements.terminal2) annotation(
    Line(points = {{80, 40}, {80, 12}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram,
    Documentation(info = "<html><head></head><body>This test case illustrates a generic power plant controller driving one of the grid-forming converter architectures of this package (VSM, droop and current-controlled VSM).<br><br><div>The plant controller (see Dynawo.Electrical.Controls.PEIR.BaseControls.PlantController.PlantControl for more information) regulates the following quantities at a chosen bus, here the point of common coupling with the grid:</div><div>- the active power P<sub>Reg</sub>, with a frequency droop term;</div><div>- the compensated voltage U<sub>Reg</sub> + λ · Q<sub>Reg</sub>, by acting on the reactive power reference of the converter.</div><div><br></div><div>The studied GFM control is here a VSM with a Current Saturation block and a PI control on the angle. The test case explores the behaviour of active current at the PCC with&nbsp;<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">\"a strong grid\" with SCR = 20 (base UNom, SNom)</span>&nbsp;in the case of a RoCoF :&nbsp;</div><div>- Starting frequency of 49.5 Hz</div><div>- RoCoF starting at t = 10 s</div><div>- RoCoF duration of 3 s</div><div>- RoCoF : +0.5 Hz/s</div><div>- A return to the initial frequency (49.5 Hz) is scheduled after 3 seconds</div><div><br></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Fig 1 : Active current in p.u measured at the PCC (receptor convention from the measurements block, base SNom).</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div><div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/ppc_ccvsm.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div></div></div></body></html>"));
end DynGFMCCPlantControl;
