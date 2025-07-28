within Dynawo.Examples.Wind.IEC.Neplan;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPP4ACurrentSource2015 "Wind Power Plant Type 4A model from IEC 61400-27-1:2015 standard with infinite bus - fault and reference tracking tests (Active and reactive power steps)"
  extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  Dynawo.Electrical.Wind.IEC.WPP.WPP4ACurrentSource2015 wPP4ACurrentSource(DPMaxP4APu = 1, DPRefMaxPu = 1, DPRefMinPu = -1, DPwpRefMaxPu = 1, DPwpRefMinPu = -1, DXRefMaxPu = 10, DXRefMinPu = -10, DfMaxPu = 1, DipMaxPu = 1, DiqMaxPu = 100, DiqMinPu = -100, IMaxDipPu = 1.3, IMaxPu = 1.3, IqH1Pu = 1.05, IqMaxPu = 1.05, IqMinPu = -1.05, IqPostPu = 0, Kipaw = 100, Kiq = 2.25, Kiqaw = 100, Kiu = 10, Kiwpp = 5, Kiwpx = 10, Kpaw = 1000, Kpq = 1.1, Kpqu = 20, Kpu = 2, Kpwpp = 2.25, Kpwpx = 0.5, Kqv = 2, KwppRef = 1.5, KwpqRef = 0, Kwpqu = 0, MdfsLim = false, MqG = 2, MqUvrt = 1, Mqpri = true, MwpqMode = 0, Mzc = false, P0Pu = -PRefPu.offset*wPP4ACurrentSource.SNom/SystemBase.SnRef, PKiwppMaxPu = 1, PKiwppMinPu = -1, PRefMaxPu = 1, PRefMinPu = 0, Q0Pu = -QRefPu.offset*wPP4ACurrentSource.SNom/SystemBase.SnRef, QMaxPu = 0.8, QMinPu = -0.8, QlConst = true, RDropPu = 0, SNom = 100, U0Pu = 1.00018, UMaxPu = 1.1, UMinPu = 0.9, UOverPu = 1.1, UPhase0 = 0.219441, UPll1Pu = 999, UPll2Pu = 0.13, URef0Pu = 0, UUnderPu = 0.9, Udb1Pu = 0.9, Udb2Pu = 1.1, UpquMaxPu = 1.1, UqDipPu = 0.9, UwpqDipPu = 0.8, XDropPu = 0, XKiwpxMaxPu = 1, XKiwpxMinPu = -1, XRefMaxPu = 1, XRefMinPu = -1, fOverPu = 1.1, fUnderPu = 0.9, tG = 0.01, tPFiltQ = 0.01, tPFiltql = 0.01, tPOrdP4A = 0.1, tPll = 0.01, tPost = 0, tQord = 0.05, tS = 0.001, tUFilt = 0.01, tUFiltP4A = 0.01, tUFiltQ = 0.01, tUFiltcl = 0.01, tUFiltql = 0.01, tUqFilt = 0.01, tWPPFiltP = 0.01, tWPPFiltQ = 0.01, tWPQFiltQ = 0.01, tWPUFiltQ = 0.01, tWPfFiltP = 0.01, tfFilt = 0.01, tpft = 0., tpfv = 0.3933, tphiFilt = 0.02, txft = 0, txfv = 0.1, PPCLocal = true, BMvHvPu = 0.001, GMvHvPu = 0.0005, RMvHvPu = 0.001, XMvHvPu = 0.01, BLvTrPu = 0.001, GLvTrPu = 0.0005, RLvTrPu = 0.001, XLvTrPu = 0.01, ConverterLVControl = false) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexConstant complexConst(k = Complex(1, 0)) annotation(
    Placement(transformation(origin = {-104, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(transformation(origin = {-116, -52}, extent = {{-4, -4}, {4, 4}}, rotation = 90)));

  // Faults
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  // Reference inputs
  Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.5, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = 0.41, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -0.21, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal1.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal2.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal3.value = false;

  connect(wPP4ACurrentSource.terminal, transformer1.terminal1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, wPP4ACurrentSource.terminal) annotation(
    Line(points = {{-90, -40}, {-90, 0}, {-99, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, wPP4ACurrentSource.omegaRefPu) annotation(
    Line(points = {{-139, -80}, {-125, -80}, {-125, -6}, {-121, -6}}, color = {0, 0, 127}));
  connect(PRefPu.y, wPP4ACurrentSource.PWPRefPu) annotation(
    Line(points = {{-139, -40}, {-130, -40}, {-130, 2}, {-121, 2}}, color = {0, 0, 127}));
  connect(QRefPu.y, wPP4ACurrentSource.QWPRefPu) annotation(
    Line(points = {{-139, 0}, {-135, 0}, {-135, 4}, {-121, 4}}, color = {0, 0, 127}));
  connect(tanPhi.y, wPP4ACurrentSource.tanPhi) annotation(
    Line(points = {{-139, 40}, {-130, 40}, {-130, 6}, {-121, 6}}, color = {0, 0, 127}));
  connect(URefPu.y, wPP4ACurrentSource.UWPRefPu) annotation(
    Line(points = {{-139, 80}, {-125, 80}, {-125, 8}, {-121, 8}}, color = {0, 0, 127}));
  connect(complexConst.y, wPP4ACurrentSource.uPccPu) annotation(
    Line(points = {{-104, -79}, {-104, -10}}, color = {85, 170, 255}));
  connect(const.y, wPP4ACurrentSource.PPccPu) annotation(
    Line(points = {{-116, -48}, {-116, -10}}, color = {0, 0, 127}));
  connect(const.y, wPP4ACurrentSource.QPccPu) annotation(
    Line(points = {{-116, -48}, {-116, -40}, {-110, -40}, {-110, -10}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode");
end WPP4ACurrentSource2015;
