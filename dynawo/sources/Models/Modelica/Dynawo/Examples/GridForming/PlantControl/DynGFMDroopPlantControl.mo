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

model DynGFMDroopPlantControl "GFM with Droop control and a generic Plant Controller (compact plant model)"
  extends Modelica.Icons.Example;

  // Operating point at the regulated bus (plant terminal), consistent with AcGrid at 1 /_ 0 behind line1
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power module for the converter";
  parameter Types.VoltageModulePu UReg0Pu = 0.995667946619379 "Start value of voltage amplitude at the regulated bus in pu (base UNom)";
  parameter Types.Angle URegPhase0 = 0.0477619859090303 "Start value of voltage angle at the regulated bus in rad";
  parameter Types.ActivePowerPu PReg0Pu = -9.35033980050001 "Start value of active power at the regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QReg0Pu = 1.570601995 "Start value of reactive power at the regulated bus in pu (base SnRef) (receptor convention)";

  Modelica.Blocks.Sources.Constant URefPu(k = dynDroopPlantControlFull.dynDroopPlantControl.plantControl.URef0Pu) annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = dynDroopPlantControlFull.dynDroopPlantControl.plantControl.PRegGen0Pu) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-20, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.PEIR.Plants.General.Average.DynDroopPlantControlFull dynDroopPlantControlFull(EpsVIUpPu = 0.01, EpsVIDownPu = 0.01, Omega0Pu = 0.99, OmegaRef0Pu = 1, SNom = SNom, UReg0Pu = UReg0Pu, URegPhase0 = URegPhase0, PReg0Pu = PReg0Pu, QReg0Pu = QReg0Pu, CFilterPu = 1e-05, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0.01, Kfq = 0, KpVI = 0.1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.05, RFilterPu = 0.015, RTransformerPu = 0.006, Omegaf = 40, Omegaff = 60, XRratio = 10, XVIPu = 0.06, tVSC = 0.0004, Mp = 0.05, Omegac = 1000, OmegaPLL = 100, OmegaMaxPLLPu = 10, OmegaMinPLLPu = -10, KsiPLL = 1, LambdaPu = 0.1, Kdroop = 0.001, tQFilt = 0.1, tPFilt = 0.1, tUFilt = 0.1, Kpq = 0.01, Kiq = 0.1, Kpp = 0.3, Kip = 0.3, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001, QMaxPu = 10, QMinPu = -10, PMaxPu = 2.0, PMinPu = -2.0, RPu = 0.0005, XPu = 0.005, GPu = 0, BPu = 0, RTfoPu = 0.0005, XTfoPu = 0.005, GTfoPu = 0, BTfoPu = 0, rTfoPu = 1) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.0005, XPu = 0.005) annotation(
    Placement(transformation(origin = {80, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Sources.AcGridRoCoF acGridRoCoF(RoCoFPu = 0.01, tRoCoFStart = 10, deltaOmega0Pu = -0.01, tRoCoFDuration = 3, U0Pu = 1, UPhase0 = 0, ReturnRoCoF = true) annotation(
    Placement(transformation(origin = {30, 70}, extent = {{-10, -10}, {10, 10}})));

equation
  line1.switchOffSignal1 = false;
  line1.switchOffSignal2 = false;

  connect(omegaRefPu.y, dynDroopPlantControlFull.omegaRefPu) annotation(
    Line(points = {{-20, 79}, {-20, 22}}, color = {0, 0, 127}));
  connect(PRefPu.y, dynDroopPlantControlFull.PRefPu) annotation(
    Line(points = {{-59, 20}, {-52, 20}, {-52, 12}, {-42, 12}}, color = {0, 0, 127}));
  connect(URefPu.y, dynDroopPlantControlFull.URefPu) annotation(
    Line(points = {{-59, -20}, {-50.5, -20}, {-50.5, -12}, {-42, -12}}, color = {0, 0, 127}));
  connect(dynDroopPlantControlFull.terminal, measurements.terminal1) annotation(
    Line(points = {{-1, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line1.terminal1) annotation(
    Line(points = {{60, 0}, {81, 0}, {81, 20}, {80, 20}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, acGridRoCoF.omegaRefPu) annotation(
    Line(points = {{-20, 79}, {-20, 75}, {18, 75}}, color = {0, 0, 127}));
  connect(acGridRoCoF.aCPower, line1.terminal2) annotation(
    Line(points = {{41.5, 77}, {41.5, 76}, {80.75, 76}, {80.75, 40}, {80, 40}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Diagram,
  Documentation(info = "<html><head></head><body>This test case illustrates a generic power plant controller driving one of the grid-forming converter architectures of this package (VSM, droop and current-controlled VSM).<br><br><div>The plant controller (see Dynawo.Electrical.Controls.PEIR.BaseControls.PlantController.PlantControl for more information) regulates the following quantities at a chosen bus, here the point of common coupling with the grid:</div><div>- the active power P<sub>Reg</sub>, with a frequency droop term;</div><div>- the compensated voltage U<sub>Reg</sub> + λ · Q<sub>Reg</sub>, by acting on the reactive power reference of the converter.</div><div><br></div><div>The studied GFM control is here a droop. The test case explores the behaviour of active current at the PCC with&nbsp;<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">\"a strong grid\" with SCR = 20 (base UNom, SNom)</span>&nbsp;in the case of a RoCoF :&nbsp;</div><div>- Starting frequency of 49.5 Hz</div><div>- RoCoF starting at t = 10 s</div><div>- RoCoF duration of 3 s</div><div>- RoCoF : +0.5 Hz/s</div><div>- A return to the initial frequency (49.5 Hz) is scheduled after 3 seconds</div><div><br></div><div><b style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">Fig 1 : Active current in p.u measured at the PCC (receptor convention from the measurements block, base SNom).</b></div><div style=\"font-size: 12px;\"><b><br></b></div><div><div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/ppc_droop.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div></div></div></body></html>"));
end DynGFMDroopPlantControl;
