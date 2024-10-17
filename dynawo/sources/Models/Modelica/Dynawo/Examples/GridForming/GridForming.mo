within Dynawo.Examples.GridForming;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GridForming "Grid Forming converters test case"
  extends Icons.Example;

  parameter Types.ActivePowerPu PRefLoadPu = 11.25 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";

  Dynawo.Electrical.Controls.Converters.GridFormingControlDroopControl Droop(CFilter = 0.066, IMaxVI = 1, Kff = 0.01, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, LFilter = 0.15, Mp = 0.02, Mq = 0, RFilter = 0.005, UFilterRef0Pu = 1, UdcSourcePu(fixed = true, start = 1.01369), Wf = 60, Wff = 16.66, XRratio = 5, currentLoop(integratord(y_start = 0.00323126), integratorq(y_start = -0.000164394)), droopControl(firstOrder(y_start = -7.3445e-5), firstOrder1(y_start = 0.102988), firstOrder2(y_start = 0.00622874), firstOrder3(y_start = -0.0010158), integrator(y_start = -0.0502873)), idConvPu(fixed = true, start = 0.622806), idPccPu(fixed = true, start = 0.622873), iqConvPu(fixed = true, start = -0.035099), iqPccPu(fixed = true, start = -0.101592), udFilterPu(fixed = true, start = 1.00755), uqFilterPu(fixed = true, start = 0.00101415)) "Droop controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {-107, 135}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv250(Cdc = 0.01, CFilter = 0.066, LFilter = 0.15, LTransformer = 0.2, RFilter = 0.005, RTransformer = 0.01, SNom = 250) annotation(
    Placement(visible = true, transformation(origin = {-62, 135}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef250Pu(height = 0, offset = 0.6238, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 169}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef250Pu(height = 0, offset = 0.0769, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 152}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef250Pu(height = 0, offset = 1.0138, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 135}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef250Pu(height = 0, offset = 0.6153, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 118}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef250Pu(height = 0, offset = 1.0138, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 101}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.GridFormingControlDispatchableVirtualOscillatorControl dVOC(Alpha = 5000, CFilter = 0.066, Eta = 1, IMaxVI = 1, KDvoc = 1.570796325, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, LFilter = 0.15, RFilter = 0.005, UFilterRef0Pu = 1.0131, UdFilter0Pu = 1.0131, UdcSourcePu(fixed = true, start = 1.01259), XRratio = 5, currentLoop(integratord(y_start = 0.00360768), integratorq(y_start = -0.0001349)), dispatchableVirtualOscillatorControl(integrator(y_start = -0.00153422)), idConvPu(fixed = true, start = 0.619091), idPccPu(fixed = true, start = 0.618988), iqConvPu(fixed = true, start = -0.036119), iqPccPu(fixed = true, start = -0.102981), udFilterPu(fixed = true, start = 1.01312), uqFilterPu(fixed = true, start = -0.00155433)) "dVOC controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {107, 135}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv500(Cdc = 0.01, CFilter = 0.066, LFilter = 0.15, LTransformer = 0.2, RFilter = 0.005, RTransformer = 0.01, SNom = 500) annotation(
    Placement(visible = true, transformation(origin = {63, 135}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef500Pu(height = 0, offset = 0.6036, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 169}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef500Pu(height = 0, offset = 0.072, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 152}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef500Pu(height = 0, offset = 1.0131, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 135}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef500Pu(height = 0, offset = 0.5958, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 118}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef500Pu(height = 0, offset = 1.0131, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {145, 101}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.GridFormingControlMatchingControl Matching(CFilter = 0.066, IMaxVI = 1, KMatching = 1, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, LFilter = 0.15, RFilter = 0.005, UFilterRef0Pu = 1, UdcSourcePu(fixed = true, start = 1.0143), XRratio = 5, currentLoop(integratord(y_start = 0.00323221), integratorq(y_start = -0.000197609)), idConvPu(fixed = true, start = 0.63165), idPccPu(fixed = false, start = 0.631649), iqConvPu(fixed = true, start = -0.0410358), iqPccPu(fixed = true, start = -0.1079), udFilterPu(fixed = true, start = 1.0143), uqFilterPu(fixed = true, start = 0)) "Matching control controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {-107, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv1000(Cdc = 0.01, CFilter = 0.066, LFilter = 0.15, LTransformer = 0.2, RFilter = 0.005, RTransformer = 0.01, SNom = 1000) annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-15, 15}, {15, -15}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef1000Pu(height = 0, offset = 1.0143, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, -17}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef1000Pu(height = 0, offset = 0.63, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef1000Pu(height = 0, offset = 1.0143, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-145, 17}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Lines.Line Line12(BPu = 0.0000075, GPu = 0, RPu = 0.00075, XPu = 0.0075) annotation(
    Placement(visible = true, transformation(origin = {-62, 45}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line Line13(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375) annotation(
    Placement(visible = true, transformation(origin = {63, 45}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line Line23(BPu = 0.00003, GPu = 0, RPu = 0.003, XPu = 0.03) annotation(
    Placement(visible = true, transformation(origin = {0, 107}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line Line23Bis1(BPu = 0.000015, GPu = 0, RPu = 0.0015, XPu = 0.015) annotation(
    Placement(visible = true, transformation(origin = {-35, 74}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line Line23Bis2(BPu = 0.000015, GPu = 0, RPu = 0.0015, XPu = 0.015) annotation(
    Placement(visible = true, transformation(origin = {35, 74}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta Load(PPu(fixed = true, start = 10.9955), QPu(fixed = false, start = 0), alpha = 2, beta = 0, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-15, 100}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault Fault(RPu = 0.0001, XPu = 0.001, tBegin = 1.5, tEnd = 1.65) annotation(
    Placement(visible = true, transformation(origin = {0, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanStep Disconnection(startValue = false, startTime = 0.5);

equation
  Line12.switchOffSignal2.value = Disconnection.y;
  Line12.switchOffSignal1.value = false;
  Line13.switchOffSignal1.value = false;
  Line13.switchOffSignal2.value = false;
  Line23.switchOffSignal1.value = false;
  Line23.switchOffSignal2.value = false;
  Line23Bis1.switchOffSignal1.value = false;
  Line23Bis1.switchOffSignal2.value = false;
  Line23Bis2.switchOffSignal1.value = false;
  Line23Bis2.switchOffSignal2.value = false;
  Load.switchOffSignal1.value = false;
  Load.switchOffSignal2.value = false;
  Conv250.switchOffSignal1.value = false;
  Conv250.switchOffSignal2.value = false;
  Conv250.switchOffSignal3.value = false;
  Conv500.switchOffSignal1.value = false;
  Conv500.switchOffSignal2.value = false;
  Conv500.switchOffSignal3.value = false;
  Conv1000.switchOffSignal1.value = false;
  Conv1000.switchOffSignal2.value = false;
  Conv1000.switchOffSignal3.value = false;
  Load.PRefPu = PRefLoadPu;
  Load.QRefPu = QRefLoadPu;
  Load.deltaP = 0;
  Load.deltaQ = 0;
  connect(Droop.theta, Conv250.theta) annotation(
    Line(points = {{-91, 148.5}, {-78, 148.5}}, color = {0, 0, 127}));
  connect(Droop.udConvRefPu, Conv250.udConvRefPu) annotation(
    Line(points = {{-91, 141}, {-78, 141}}, color = {0, 0, 127}));
  connect(Droop.IdcSourcePu, Conv250.IdcSourcePu) annotation(
    Line(points = {{-91, 135}, {-78, 135}}, color = {0, 0, 127}));
  connect(Droop.uqConvRefPu, Conv250.uqConvRefPu) annotation(
    Line(points = {{-91, 129}, {-78, 129}}, color = {0, 0, 127}));
  connect(Droop.omegaPu, Conv250.omegaPu) annotation(
    Line(points = {{-91, 121.5}, {-78, 121.5}}, color = {0, 0, 127}));
  connect(dVOC.theta, Conv500.theta) annotation(
    Line(points = {{91, 148.5}, {79, 148.5}}, color = {0, 0, 127}));
  connect(dVOC.udConvRefPu, Conv500.udConvRefPu) annotation(
    Line(points = {{91, 141}, {79, 141}}, color = {0, 0, 127}));
  connect(dVOC.IdcSourcePu, Conv500.IdcSourcePu) annotation(
    Line(points = {{91, 135}, {79, 135}}, color = {0, 0, 127}));
  connect(dVOC.uqConvRefPu, Conv500.uqConvRefPu) annotation(
    Line(points = {{91, 129}, {79, 129}}, color = {0, 0, 127}));
  connect(dVOC.omegaPu, Conv500.omegaPu) annotation(
    Line(points = {{91, 121.5}, {79, 121.5}}, color = {0, 0, 127}));
  connect(Matching.omegaPu, Conv1000.omegaPu) annotation(
    Line(points = {{-87.5, 10.5}, {-84.5, 10.5}, {-84.5, 13.5}, {-78, 13.5}}, color = {0, 0, 127}));
  connect(Matching.uqConvRefPu, Conv1000.uqConvRefPu) annotation(
    Line(points = {{-91, -6}, {-84.5, -6}, {-84.5, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(Matching.IdcSourcePu, Conv1000.IdcSourcePu) annotation(
    Line(points = {{-91, 0}, {-78, 0}}, color = {0, 0, 127}));
  connect(Matching.udConvRefPu, Conv1000.udConvRefPu) annotation(
    Line(points = {{-91, 6}, {-84.5, 6}, {-84.5, -6}, {-78, -6}}, color = {0, 0, 127}));
  connect(Matching.theta, Conv1000.theta) annotation(
    Line(points = {{-91, 13.5}, {-84.5, 13.5}, {-84.5, -13.5}, {-78, -13.5}}, color = {0, 0, 127}));
  connect(Conv250.terminal, Line12.terminal2) annotation(
    Line(points = {{-62, 119}, {-62, 60}}, color = {0, 0, 255}));
  connect(Line12.terminal1, Conv1000.terminal) annotation(
    Line(points = {{-62, 30}, {-62, 16}}, color = {0, 0, 255}));
  connect(Conv250.terminal, Line23.terminal1) annotation(
    Line(points = {{-62, 119}, {-62, 107}, {-15, 107}}, color = {0, 0, 255}));
  connect(Line23.terminal2, Conv500.terminal) annotation(
    Line(points = {{15, 107}, {63, 107}, {63, 119}}, color = {0, 0, 255}));
  connect(Conv250.terminal, Line23Bis1.terminal1) annotation(
    Line(points = {{-62, 119}, {-62, 74}, {-50, 74}}, color = {0, 0, 255}));
  connect(Line23Bis2.terminal2, Conv500.terminal) annotation(
    Line(points = {{50, 74}, {63, 74}, {63, 119}}, color = {0, 0, 255}));
  connect(Conv500.terminal, Line13.terminal2) annotation(
    Line(points = {{63, 119}, {63, 60}}, color = {0, 0, 255}));
  connect(Line13.terminal1, Conv1000.terminal) annotation(
    Line(points = {{63, 30}, {63, 16}, {-62, 16}}, color = {0, 0, 255}));
  connect(Line23Bis1.terminal2, Line23Bis2.terminal1) annotation(
    Line(points = {{-20, 74}, {20, 74}}, color = {0, 0, 255}));
  connect(Matching.omegaPu, dVOC.omegaRefPu) annotation(
    Line(points = {{-87.5, 10.5}, {-87.5, 116}, {93.5, 116}, {93.5, 119}}, color = {0, 0, 127}));
  connect(Load.terminal, Line23.terminal1) annotation(
    Line(points = {{-15, 100}, {-15, 107}}, color = {0, 0, 255}));
  connect(Matching.omegaPu, Matching.omegaRefPu) annotation(
    Line(points = {{-87.5, 10.5}, {-87.5, 13}, {-90, 13}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefOutPu, Conv250.UdcSourceRefPu) annotation(
    Line(points = {{-91, 124.5}, {-78, 124.5}}, color = {0, 0, 127}));
  connect(dVOC.UdcSourceRefOutPu, Conv500.UdcSourceRefPu) annotation(
    Line(points = {{91, 124.5}, {79, 124.5}}, color = {0, 0, 127}));
  connect(Matching.UdcSourceRefOutPu, Conv1000.UdcSourceRefPu) annotation(
    Line(points = {{-91, -10.5}, {-84.5, -10.5}, {-84.5, 10.5}, {-78, 10.5}}, color = {0, 0, 127}));
  connect(Matching.omegaPu, Droop.omegaRefPu) annotation(
    Line(points = {{-87.5, 10.5}, {-87.5, 116}, {-93.5, 116}, {-93.5, 119}}, color = {0, 0, 127}));
  connect(UFilterRef250Pu.y, Droop.UFilterRefPu) annotation(
    Line(points = {{-139, 135}, {-123, 135}}, color = {0, 0, 127}));
  connect(IdcSourceRef250Pu.y, Droop.IdcSourceRefPu) annotation(
    Line(points = {{-139.5, 118}, {-130, 118}, {-130, 126}, {-123, 126}}, color = {0, 0, 127}));
  connect(QRef250Pu.y, Droop.QRefPu) annotation(
    Line(points = {{-139.5, 152}, {-130, 152}, {-130, 144}, {-123, 144}}, color = {0, 0, 127}));
  connect(IdcSourceRef1000Pu.y, Matching.IdcSourceRefPu) annotation(
    Line(points = {{-139.5, 0}, {-131.25, 0}, {-131.25, -9}, {-123, -9}}, color = {0, 0, 127}));
  connect(UdcSourceRef1000Pu.y, Matching.UdcSourceRefPu) annotation(
    Line(points = {{-139.5, 17}, {-128.75, 17}, {-128.75, -15}, {-123, -15}}, color = {0, 0, 127}));
  connect(UFilterRef1000Pu.y, Matching.UFilterRefPu) annotation(
    Line(points = {{-139.5, -17}, {-128.75, -17}, {-128.75, 0}, {-123, 0}}, color = {0, 0, 127}));
  connect(UFilterRef500Pu.y, dVOC.UFilterRefPu) annotation(
    Line(points = {{140, 135}, {123, 135}}, color = {0, 0, 127}));
  connect(QRef500Pu.y, dVOC.QRefPu) annotation(
    Line(points = {{139.5, 152}, {130, 152}, {130, 144}, {123, 144}}, color = {0, 0, 127}));
  connect(IdcSourceRef500Pu.y, dVOC.IdcSourceRefPu) annotation(
    Line(points = {{139.5, 118}, {130, 118}, {130, 126}, {123, 126}}, color = {0, 0, 127}));
  connect(Line23Bis1.terminal2, Fault.terminal) annotation(
    Line(points = {{-20, 74}, {0, 74}, {0, 44}}, color = {0, 0, 255}));
  connect(PRef250Pu.y, Droop.PRefPu) annotation(
    Line(points = {{-139, 169}, {-129, 169}, {-129, 150}, {-123, 150}}, color = {0, 0, 127}));
  connect(UdcSourceRef250Pu.y, Droop.UdcSourceRefPu) annotation(
    Line(points = {{-139, 101}, {-129, 101}, {-129, 120}, {-123, 120}}, color = {0, 0, 127}));
  connect(UdcSourceRef500Pu.y, dVOC.UdcSourceRefPu) annotation(
    Line(points = {{140, 101}, {129, 101}, {129, 120}, {123, 120}}, color = {0, 0, 127}));
  connect(PRef500Pu.y, dVOC.PRefPu) annotation(
    Line(points = {{140, 169}, {129, 169}, {129, 150}, {123, 150}}, color = {0, 0, 127}));
  connect(Conv250.udFilterPu, Droop.udFilterPu) annotation(
    Line(points = {{-46, 148.5}, {-35, 148.5}, {-35, 151}, {-94, 151}}, color = {0, 0, 127}));
  connect(Conv250.idPccPu, Droop.idPccPu) annotation(
    Line(points = {{-46, 144}, {-34, 144}, {-34, 153}, {-98, 153}, {-98, 151}}, color = {0, 0, 127}));
  connect(Conv250.idConvPu, Droop.idConvPu) annotation(
    Line(points = {{-46, 139.5}, {-33, 139.5}, {-33, 154}, {-103, 154}, {-103, 151}, {-102.5, 151}}, color = {0, 0, 127}));
  connect(Conv250.UdcSourcePu, Droop.UdcSourcePu) annotation(
    Line(points = {{-46, 135}, {-32, 135}, {-32, 155}, {-107, 155}, {-107, 151}}, color = {0, 0, 127}));
  connect(Conv250.iqConvPu, Droop.iqConvPu) annotation(
    Line(points = {{-46, 130.5}, {-31, 130.5}, {-31, 156}, {-112, 156}, {-112, 151}}, color = {0, 0, 127}));
  connect(Conv250.iqPccPu, Droop.iqPccPu) annotation(
    Line(points = {{-46, 126}, {-30, 126}, {-30, 157}, {-116, 157}, {-116, 151}}, color = {0, 0, 127}));
  connect(Conv250.uqFilterPu, Droop.uqFilterPu) annotation(
    Line(points = {{-46, 121.5}, {-29, 121.5}, {-29, 158}, {-121, 158}, {-121, 151}}, color = {0, 0, 127}));
  connect(Conv500.udFilterPu, dVOC.udFilterPu) annotation(
    Line(points = {{47, 148.5}, {35, 148.5}, {35, 152}, {94, 152}, {94, 151}}, color = {0, 0, 127}));
  connect(Conv500.idPccPu, dVOC.idPccPu) annotation(
    Line(points = {{47, 144}, {34, 144}, {34, 153}, {98, 153}, {98, 151}}, color = {0, 0, 127}));
  connect(Conv500.idConvPu, dVOC.idConvPu) annotation(
    Line(points = {{47, 139.5}, {33, 139.5}, {33, 154}, {102, 154}, {102, 151}}, color = {0, 0, 127}));
  connect(Conv500.UdcSourcePu, dVOC.UdcSourcePu) annotation(
    Line(points = {{47, 135}, {32, 135}, {32, 155}, {107, 155}, {107, 151}}, color = {0, 0, 127}));
  connect(Conv500.iqConvPu, dVOC.iqConvPu) annotation(
    Line(points = {{47, 130.5}, {31, 130.5}, {31, 156}, {111, 156}, {111, 151}}, color = {0, 0, 127}));
  connect(Conv500.iqPccPu, dVOC.iqPccPu) annotation(
    Line(points = {{47, 126}, {30, 126}, {30, 157}, {116, 157}, {116, 151}}, color = {0, 0, 127}));
  connect(Conv500.uqFilterPu, dVOC.uqFilterPu) annotation(
    Line(points = {{47, 121.5}, {29, 121.5}, {29, 158}, {121, 158}, {121, 151}}, color = {0, 0, 127}));
  connect(Conv1000.udFilterPu, Matching.udFilterPu) annotation(
    Line(points = {{-46, -13.5}, {-35, -13.5}, {-35, -17}, {-94, -17}, {-94, 16}}, color = {0, 0, 127}));
  connect(Conv1000.idPccPu, Matching.idPccPu) annotation(
    Line(points = {{-46, -9}, {-34, -9}, {-34, -18}, {-98, -18}, {-98, 16}}, color = {0, 0, 127}));
  connect(Conv1000.idConvPu, Matching.idConvPu) annotation(
    Line(points = {{-46, -4.5}, {-33, -4.5}, {-33, -19}, {-102.5, -19}, {-102.5, 16}}, color = {0, 0, 127}));
  connect(Conv1000.UdcSourcePu, Matching.UdcSourcePu) annotation(
    Line(points = {{-46, 0}, {-32, 0}, {-32, -20}, {-107, -20}, {-107, 16}}, color = {0, 0, 127}));
  connect(Conv1000.iqConvPu, Matching.iqConvPu) annotation(
    Line(points = {{-46, 4.5}, {-31, 4.5}, {-31, -21}, {-112, -21}, {-112, 16}}, color = {0, 0, 127}));
  connect(Conv1000.iqPccPu, Matching.iqPccPu) annotation(
    Line(points = {{-46, 9}, {-30, 9}, {-30, -22}, {-116, -22}, {-116, 16}}, color = {0, 0, 127}));
  connect(Conv1000.uqFilterPu, Matching.uqFilterPu) annotation(
    Line(points = {{-46, 13.5}, {-29, 13.5}, {-29, -23}, {-121, -23}, {-121, 16}}, color = {0, 0, 127}));
  connect(Conv250.PFilterPu, Droop.PFilterPu) annotation(
    Line(points = {{-72, 119}, {-72, 114}, {-96, 114}, {-96, 119}}, color = {0, 0, 127}));
  connect(Conv250.QFilterPu, Droop.QFilterPu) annotation(
    Line(points = {{-51, 119}, {-51, 110}, {-118, 110}, {-118, 119}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-6, Interval = 0.006),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", s = "ida", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in three different grid-forming converters (one with a droop control, one with a dispatchable virtual oscillator control and one with a matching control) connected to a load. At t = 0.5 s the line connecting the 250 MVA (droop) and the 1000 MVA (matching) converters is opened. At t = 1.5 s, a short-circuit occurs in the middle of one of the lines connecting the 250 MVA (droop) and the 500 MVA (dVOC) converters. It is cleared after 150ms. This test case and the grid-forming converters controls come from the Horizon 2020 European project MIGRATE, and more precisely from its Deliverables 3.2 and 3.3 that can be found on the project website : https://www.h2020-migrate.eu/downloads.html.
    </div><div><br></div><div>The two following figures show the expected evolution of the frequency and the current for each converter during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/frequency.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/current.png\">
    </figure>
    One can remark that after the events, the frequencies of the three converters are equal and close to their value before the events, thanks to the power-sharing allowed by the outer loop controls (droop, matching and dVOC).</div><div><br></div><div> One can also remark that during the fault, the currents of the three converters are limited at a value lower than 1.2 pu thanks to the virtual impedance. More details can be found in the MIGRATE project deliverables.</div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>"),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-150, -100}, {150, 200}})));
end GridForming;
