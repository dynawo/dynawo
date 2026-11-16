within Dynawo.Examples.GridForming.VSM;

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

model DynGFMVSMSmibConvPLL "Single machine infinite bus test case for Grid Forming VSM model with dynamic filter and transformer -- omegaPLL passed to the converter"

  extends Modelica.Icons.Example;

  Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = 0.005, XPu = 0.05) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(transformation(origin = {-90, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {-90, 20}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Converters.General.Average.GridForming.DynGFMVSMConvPLL DynGFMVSMConvPLL(CFilterPu = 1e-05, H = 5, IMaxVIPu = 1.2, Kfd = 0.8, Kff = 0, Kfq = 0, KpVI = 0.6, LFilterPu = 0.15, LTransformerPu = 0.06, Mq = 0.2, P0Pu = -9.440979955569425, Q0Pu = -0.642916511452948, RFilterPu = 0.015, RTransformerPu = 0.006, SNom = 1000, U0Pu = 0.954110360567147, UPhase0 = 0.513677943263305, Omegaf = 31.4159, Omegaff = 60, XRratio = 10, XVIPu = 0.06, kVSM = 150, tVSC = 0.0004, OmegaPLL = 100, OmegaMaxPLLPu = 10, OmegaMinPLLPu = -10, KsiPLL = 1, Omegac = 1000, EpsVIUpPu = 0.01, EpsVIDownPu = 0.01) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant PRefPu(k = 0.95) annotation(
    Placement(transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBusWithVariations infiniteBusWithVariations(dUPhaseEvt = 0.416, tUPhaseEvt = 10, U0Pu = 1, UEvtPu = 1, omega0Pu = 1, omegaEvtPu = 1, UPhase = 0, tUEvtStart = 0, tUEvtEnd = 0, tOmegaEvtStart = 0, tOmegaEvtEnd = 0) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.Utilities.Measurements measurements(SNom = 1000) annotation(
    Placement(transformation(origin = {30, 1.77636e-15}, extent = {{-10, -10}, {10, 10}})));

equation
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  DynGFMVSMConvPLL.switchOffSignal1 = false;
  DynGFMVSMConvPLL.switchOffSignal2 = false;
  DynGFMVSMConvPLL.switchOffSignal3 = false;

  connect(omegaRefPu.y, DynGFMVSMConvPLL.omegaRefPu) annotation(
    Line(points = {{-79, 20}, {-50, 20}, {-50, 8}, {-42, 8}}, color = {0, 0, 127}));
  connect(QRefPu.y, DynGFMVSMConvPLL.QFilterRefPu) annotation(
    Line(points = {{-79, -20}, {-60, -20}, {-60, -8}, {-42, -8}}, color = {0, 0, 127}));
  connect(URefPu.y, DynGFMVSMConvPLL.UFilterRefPu) annotation(
    Line(points = {{-79, -60}, {-56, -60}, {-56, -16}, {-42, -16}}, color = {0, 0, 127}));
  connect(PRefPu.y, DynGFMVSMConvPLL.PFilterRefPu) annotation(
    Line(points = {{-79, 60}, {-79, 61}, {-46, 61}, {-46, 15.5}, {-42, 15.5}, {-42, 16}}, color = {0, 0, 127}));
  connect(line.terminal2, infiniteBusWithVariations.terminal) annotation(
    Line(points = {{80, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(DynGFMVSMConvPLL.terminal, measurements.terminal1) annotation(
    Line(points = {{2, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, line.terminal1) annotation(
    Line(points = {{40, 0}, {60, 0}}, color = {0, 0, 255}));

  annotation(
    preferredView = "diagram",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.0244379),
    Documentation(info = "<html><head></head><body><div><div>This test case is part of a larger framework aiming at comparing different GFM control architectures with a standard Angle Phase jump at an Infinite Bus. The chosen test case belongs to the I18 Grid code under the name S_VoltageAngleStep7_OC4 corresponding to :&nbsp;</div><div>- An operating condition of P = 0.95 p.u. and Q = 0 p.u. (active and reactive power references at the converter filter)</div><div>- An angle step at the voltage bus of 0.416 rad (~ 23.84°)</div><div>- A minimal Short Circuit Ratio (SCR) representing a \"weak grid\".</div><div><br></div><div>Tested architectures feature :&nbsp;</div><div>- A dynamic Virtual Synchronous Machine control but with the frequency in the converter being the one measured by the PLL (DynGFMVSMConvPLL). This variant gives results very close to those of the DynGFMVSM model.&nbsp;</div><div><div><span style=\"font-size: 12px;\"><br></span></div><div>The GFM is connected to an infinite bus with the following variations :&nbsp;</div><div><span style=\"font-size: 12px;\">- At t=10s, a phase jump is simulated with a value of +0.416 radians, corresponding to the&nbsp;</span>S_VoltageAngleStep7_OC4 scenario depicted in the I18 documentation.&nbsp;</div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The graph shows the evolution of measurements.IpPuSNom : the active current in p.u measured at the Point of Common Coupling (PCC) in base SNom, in receptor convention.</div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br></div><div style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><b>Fig 1 : Active current in p.u measured at the PCC (receptor convention from the measurements block, base SNom).</b></div></div></div></div><div><br></div><div><div><div style=\"font-size: 12px;\"><img width=\"1000\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/convpll_smib.png\"></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><br></div></div></div></body></html>"));
end DynGFMVSMSmibConvPLL;
