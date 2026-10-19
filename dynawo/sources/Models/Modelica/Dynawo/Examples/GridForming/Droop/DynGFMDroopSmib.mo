within Dynawo.Examples.GridForming.Droop;

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

model DynGFMDroopSmib "Single machine infinite bus test case for Grid Forming Droop model with dynamic filter and transformer"

  extends Modelica.Icons.Example;

  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-114, 56}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMDroop DynGFMDroop(CFilterPu = 1e-05, Kfd = 1, Kff = 0, Kfq = 0, KpVI = 0.1, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.013, P0Pu = -9.443037592902463, Q0Pu = -0.9381894849771695, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.9739263489925247, UPhase0 = 0.5006269557826585, Omegaf = 40, Omegaff = 50, XRratio = 10, XVIPu = 0.06, tVSC = 0.0004, Mp = 0.013, Omegac = 1000, OmegaPLL = 100, OmegaMaxPLLPu = 10, OmegaMinPLLPu = -10, KsiPLL = 1, IMaxVIPu = 1.2, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-27, 1}, extent = {{-23, -23}, {23, 23}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(U0Pu = 1, UEvtPu = 1, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0, dUPhaseEvt = 0.416, tUPhaseEvt = 10) annotation(
    Placement(transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000) annotation(
    Placement(transformation(origin = {20, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal1 = false;
  DynGFMDroop.switchOffSignal2 = false;
  DynGFMDroop.switchOffSignal3 = false;

  connect(PRefPu.y, DynGFMDroop.PFilterRefPu) annotation(
    Line(points = {{-102, 56}, {-102, 57}, {-52, 57}, {-52, 19}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, DynGFMDroop.omegaRefPu) annotation(
    Line(points = {{-100, 20}, {-62, 20}, {-62, 10}, {-52, 10}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMDroop.QFilterRefPu) annotation(
    Line(points = {{-100, -20}, {-66, -20}, {-66, -8}, {-52, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMDroop.UFilterRefPu) annotation(
    Line(points = {{-100, -60}, {-100, -57}, {-52, -57}, {-52, -17}}, color = {0, 0, 127}));
  connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{54, 0}, {84, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{30, 0}, {34, 0}}, color = {0, 0, 255}));
  connect(DynGFMDroop.terminal, measurements.terminal1) annotation(
    Line(points = {{-2, 1}, {-2, 4}, {10, 4}, {10, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Documentation(info = "<html><head></head><body><div><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus. The chosen test case belongs to the I18 Grid code under the name S_VoltageAngleStep7_OC4 corresponding to :&nbsp;</div><div>- An operating condition of P = 0.95 p.u. and Q = 0 p.u. (active and reactive power references at the converter filter)</div><div>- An angle step at the voltage bus of 0.416 rad (~ 23.84°)</div><div>- A minimal Short Circuit Ratio (SCR) representing a \"weak grid\".</div><div><br></div><div>The tested architecture features a Grid-Forming converter with dynamic Droop control (DynGFMDroop)</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.416 radians, corresponding to the&nbsp;</span>S_VoltageAngleStep7_OC4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">The graph shows the evolution of measurements.IpPuSNom : the active current in p.u measured at the Point of Common Coupling (PCC) in base SNom, in receptor convention.</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Fig 1 : Active current in p.u measured at the PCC (receptor convention from the measurements block, base SNom).</b></div></div></div></div><div style=\"font-size: 12px;\"><b><br></b></div><div><div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/droop_smib.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div></div></div></body></html>"));
end DynGFMDroopSmib;
