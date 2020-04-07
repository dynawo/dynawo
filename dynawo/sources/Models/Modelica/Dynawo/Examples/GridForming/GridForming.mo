within Dynawo.Examples.GridForming;

model GridForming "Grid Forming converters test case"
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
  import Dynawo;
  import Modelica;
  extends Icons.Example;
  parameter Types.ActivePowerPu PRefLoadPu = 11.25 "Active power request for the load in p.u (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in p.u (base SnRef)";
  Dynawo.Electrical.Controls.Converters.GridFormingControlDroopControl Droop(Cfilter = 0.066, Kff = 0.01, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, Lfilter = 0.15, Mp = 0.02, Mq = 0, Rfilter = 0.005, UdcSourcePu(fixed = true, start = 1.01369), Wf = 60, Wff = 16.66, XRratio = 5, currentLoop(integratord(y_start = 0.00323126), integratorq(y_start = -0.000164394)), droopControl(firstOrder(y_start = -7.3445e-5), firstOrder1(y_start = 0.102988), firstOrder2(y_start = 0.00622874), firstOrder3(y_start = -0.0010158), integrator(y_start = -0.0502873)), idConvPu(fixed = true, start = 0.622806), idPccPu(fixed = true, start = 0.622873), iqConvPu(fixed = true, start = -0.035099), iqPccPu(fixed = true, start = -0.101592), udFilterPu(fixed = true, start = 1.00755), uqFilterPu(fixed = true, start = 0.00101415)) "Droop controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {-101, 135}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv250(Cdc = 0.01, Cfilter = 0.066, Lfilter = 0.15, Ltransformer = 0.2, Rfilter = 0.005, Rtransformer = 0.01, SNom = 250) annotation(
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
  Dynawo.Electrical.Controls.Converters.GridFormingControlDispatchableVirtualOscillatorControl dVOC(dispatchableVirtualOscillatorControl.integrator.y_start = -0.00153422, currentLoop.integratord.y_start = 0.00360768, currentLoop.integratorq.y_start = -0.0001349, Alpha = 5000, Cfilter = 0.066, Eta = 1, KDvoc = 1.570796325, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, Lfilter = 0.15, Rfilter = 0.005, UdFilter0Pu = 1.0131, UdcSourcePu(fixed = true, start = 1.01259), XRratio = 5, idConvPu(fixed = true, start = 0.619091), idPccPu(fixed = true, start = 0.618988), iqConvPu(fixed = true, start = -0.036119), iqPccPu(fixed = true, start = -0.102981), udFilterPu(fixed = true, start = 1.01312), uqFilterPu(fixed = true, start = -0.00155433)) "dVOC controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {100, 135}, extent = {{15, -15}, {-15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv500(Cdc = 0.01, Cfilter = 0.066, Lfilter = 0.15, Ltransformer = 0.2, Rfilter = 0.005, Rtransformer = 0.01, SNom = 500) annotation(
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
  Dynawo.Electrical.Controls.Converters.GridFormingControlMatchingControl Matching(Cfilter = 0.066, KMatching = 1, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, Lfilter = 0.15, Rfilter = 0.005, UdcSourcePu(fixed = true, start = 1.0143), XRratio = 5, currentLoop(integratord(y_start = 0.00323221), integratorq(y_start = -0.000197609)), idConvPu(fixed = true, start = 0.63165), idPccPu(fixed = false, start = 0.631649), iqConvPu(fixed = true, start = -0.0410358), iqPccPu(fixed = true, start = -0.1079), udFilterPu(fixed = true, start = 1.0143), uqFilterPu(fixed = true, start = 0)) "Matching control controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {-102, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv1000(Cdc = 0.01, Cfilter = 0.066, Lfilter = 0.15, Ltransformer = 0.2, Rfilter = 0.005, Rtransformer = 0.01, SNom = 1000) annotation(
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
  Dynawo.Electrical.Events.Event.SingleBooleanEvent Disconnection(stateEvent1 = true, tEvent = 0.5);
equation
  Line12.switchOffSignal1.value = false;
  connect(Disconnection.state1, Line12.switchOffSignal2);
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
  Load.PRefPu.value = PRefLoadPu;
  Load.QRefPu.value = QRefLoadPu;
  connect(Droop.theta, Conv250.theta) annotation(
    Line(points = {{-85, 148.5}, {-78, 148.5}}, color = {0, 0, 127}));
  connect(Droop.udConvRefPu, Conv250.udConvRefPu) annotation(
    Line(points = {{-85, 141}, {-78, 141}}, color = {0, 0, 127}));
  connect(Droop.IdcSourcePu, Conv250.IdcSourcePu) annotation(
    Line(points = {{-85, 135}, {-78, 135}}, color = {0, 0, 127}));
  connect(Droop.uqConvRefPu, Conv250.uqConvRefPu) annotation(
    Line(points = {{-85, 129}, {-78, 129}}, color = {0, 0, 127}));
  connect(Droop.omegaPu, Conv250.omegaPu) annotation(
    Line(points = {{-85, 121.5}, {-78, 121.5}}, color = {0, 0, 127}));
  connect(dVOC.theta, Conv500.theta) annotation(
    Line(points = {{84, 148.5}, {79, 148.5}}, color = {0, 0, 127}));
  connect(dVOC.udConvRefPu, Conv500.udConvRefPu) annotation(
    Line(points = {{84, 141}, {79, 141}}, color = {0, 0, 127}));
  connect(dVOC.IdcSourcePu, Conv500.IdcSourcePu) annotation(
    Line(points = {{84, 135}, {79, 135}}, color = {0, 0, 127}));
  connect(dVOC.uqConvRefPu, Conv500.uqConvRefPu) annotation(
    Line(points = {{84, 129}, {79, 129}}, color = {0, 0, 127}));
  connect(dVOC.omegaPu, Conv500.omegaPu) annotation(
    Line(points = {{84, 121.5}, {79, 121.5}}, color = {0, 0, 127}));
  connect(Matching.omegaPu, Conv1000.omegaPu) annotation(
    Line(points = {{-86, 13.5}, {-78, 13.5}}, color = {0, 0, 127}));
  connect(Matching.uqConvRefPu, Conv1000.uqConvRefPu) annotation(
    Line(points = {{-86, 6}, {-78, 6}}, color = {0, 0, 127}));
  connect(Matching.IdcSourcePu, Conv1000.IdcSourcePu) annotation(
    Line(points = {{-86, 0}, {-78, 0}}, color = {0, 0, 127}));
  connect(Matching.udConvRefPu, Conv1000.udConvRefPu) annotation(
    Line(points = {{-86, -6}, {-78, -6}}, color = {0, 0, 127}));
  connect(Matching.theta, Conv1000.theta) annotation(
    Line(points = {{-86, -13.5}, {-78, -13.5}}, color = {0, 0, 127}));
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
    Line(points = {{-86, 13.5}, {-86, 116}, {86.5, 116}, {86.5, 119}}, color = {0, 0, 127}));
  connect(Load.terminal, Line23.terminal1) annotation(
    Line(points = {{-15, 100}, {-15, 107}}, color = {0, 0, 255}));
  connect(Matching.omegaPu, Matching.omegaRefPu) annotation(
    Line(points = {{-86, 13.5}, {-86, 16}, {-88.5, 16}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefOutPu, Conv250.UdcSourceRefPu) annotation(
    Line(points = {{-85, 124.5}, {-78, 124.5}}, color = {0, 0, 127}));
  connect(dVOC.UdcSourceRefOutPu, Conv500.UdcSourceRefPu) annotation(
    Line(points = {{84, 124.5}, {79, 124.5}}, color = {0, 0, 127}));
  connect(Matching.UdcSourceRefOutPu, Conv1000.UdcSourceRefPu) annotation(
    Line(points = {{-86, 10.5}, {-78, 10.5}}, color = {0, 0, 127}));
  connect(Matching.omegaPu, Droop.omegaRefPu) annotation(
    Line(points = {{-86, 13.5}, {-86, 116}, {-87.5, 116}, {-87.5, 119}}, color = {0, 0, 127}));
  connect(UFilterRef250Pu.y, Droop.UFilterRefPu) annotation(
    Line(points = {{-139, 135}, {-117, 135}}, color = {0, 0, 127}));
  connect(IdcSourceRef250Pu.y, Droop.IdcSourceRefPu) annotation(
    Line(points = {{-139.5, 118}, {-130, 118}, {-130, 126}, {-117, 126}}, color = {0, 0, 127}));
  connect(QRef250Pu.y, Droop.QRefPu) annotation(
    Line(points = {{-139.5, 152}, {-130, 152}, {-130, 144}, {-117, 144}}, color = {0, 0, 127}));
  connect(UdcSourceRef250Pu.y, Droop.UdcSourceRefPu) annotation(
    Line(points = {{-139.5, 101}, {-120, 101}, {-120, 120}, {-117, 120}}, color = {0, 0, 127}));
  connect(PRef250Pu.y, Droop.PRefPu) annotation(
    Line(points = {{-139.5, 169}, {-120, 169}, {-120, 150}, {-117, 150}}, color = {0, 0, 127}));
  connect(IdcSourceRef1000Pu.y, Matching.IdcSourceRefPu) annotation(
    Line(points = {{-139.5, 0}, {-118, 0}}, color = {0, 0, 127}));
  connect(UdcSourceRef1000Pu.y, Matching.UdcSourceRefPu) annotation(
    Line(points = {{-139.5, 17}, {-128.75, 17}, {-128.75, 14}, {-118, 14}}, color = {0, 0, 127}));
  connect(UFilterRef1000Pu.y, Matching.UFilterRefPu) annotation(
    Line(points = {{-139.5, -17}, {-128.75, -17}, {-128.75, -14}, {-118, -14}}, color = {0, 0, 127}));
  connect(UFilterRef500Pu.y, dVOC.UFilterRefPu) annotation(
    Line(points = {{140, 135}, {116, 135}, {116, 135}, {116, 135}}, color = {0, 0, 127}));
  connect(QRef500Pu.y, dVOC.QRefPu) annotation(
    Line(points = {{139.5, 152}, {130, 152}, {130, 144}, {116, 144}}, color = {0, 0, 127}));
  connect(PRef500Pu.y, dVOC.PRefPu) annotation(
    Line(points = {{139.5, 169}, {120, 169}, {120, 150}, {116, 150}}, color = {0, 0, 127}));
  connect(IdcSourceRef500Pu.y, dVOC.IdcSourceRefPu) annotation(
    Line(points = {{139.5, 118}, {130, 118}, {130, 126}, {116, 126}}, color = {0, 0, 127}));
  connect(UdcSourceRef500Pu.y, dVOC.UdcSourceRefPu) annotation(
    Line(points = {{139.5, 101}, {120, 101}, {120, 120}, {116, 120}}, color = {0, 0, 127}));
  connect(Conv250.udFilterPu, Droop.udFilterPu) annotation(
    Line(points = {{-46, 148.5}, {-42, 148.5}, {-42, 152}, {-88, 152}, {-88, 151}}, color = {0, 0, 127}));
  connect(Conv250.idPccPu, Droop.idPccPu) annotation(
    Line(points = {{-46, 144}, {-41, 144}, {-41, 153}, {-92, 153}, {-92, 151}}, color = {0, 0, 127}));
  connect(Conv250.idConvPu, Droop.idConvPu) annotation(
    Line(points = {{-46, 139.5}, {-40, 139.5}, {-40, 154}, {-97, 154}, {-97, 151}, {-96.5, 151}}, color = {0, 0, 127}));
  connect(Conv250.UdcSourcePu, Droop.UdcSourcePu) annotation(
    Line(points = {{-46, 135}, {-39, 135}, {-39, 155}, {-101, 155}, {-101, 151}, {-101, 151}}, color = {0, 0, 127}));
  connect(Conv250.iqConvPu, Droop.iqConvPu) annotation(
    Line(points = {{-46, 131}, {-38, 131}, {-38, 156}, {-106, 156}, {-106, 151}, {-106, 151}}, color = {0, 0, 127}));
  connect(Conv250.iqPccPu, Droop.iqPccPu) annotation(
    Line(points = {{-46, 126}, {-37, 126}, {-37, 157}, {-110, 157}, {-110, 151}, {-110, 151}}, color = {0, 0, 127}));
  connect(Conv250.uqFilterPu, Droop.uqFilterPu) annotation(
    Line(points = {{-46, 122}, {-36, 122}, {-36, 158}, {-115, 158}, {-115, 151}, {-115, 151}}, color = {0, 0, 127}));
  connect(Conv500.udFilterPu, dVOC.udFilterPu) annotation(
    Line(points = {{47, 149}, {43, 149}, {43, 152}, {87, 152}, {87, 151}, {87, 151}}, color = {0, 0, 127}));
  connect(Conv500.idPccPu, dVOC.idPccPu) annotation(
    Line(points = {{47, 144}, {42, 144}, {42, 153}, {91, 153}, {91, 151}, {91, 151}}, color = {0, 0, 127}));
  connect(Conv500.idConvPu, dVOC.idConvPu) annotation(
    Line(points = {{47, 140}, {41, 140}, {41, 154}, {95, 154}, {95, 151}, {95, 151}}, color = {0, 0, 127}));
  connect(Conv500.UdcSourcePu, dVOC.UdcSourcePu) annotation(
    Line(points = {{47, 135}, {40, 135}, {40, 155}, {100, 155}, {100, 151}, {100, 151}}, color = {0, 0, 127}));
  connect(Conv500.iqConvPu, dVOC.iqConvPu) annotation(
    Line(points = {{47, 131}, {39, 131}, {39, 156}, {104, 156}, {104, 151}, {104, 151}}, color = {0, 0, 127}));
  connect(Conv500.iqPccPu, dVOC.iqPccPu) annotation(
    Line(points = {{47, 126}, {38, 126}, {38, 157}, {109, 157}, {109, 151}, {109, 151}}, color = {0, 0, 127}));
  connect(Conv500.uqFilterPu, dVOC.uqFilterPu) annotation(
    Line(points = {{47, 122}, {37, 122}, {37, 158}, {114, 158}, {114, 151}, {114, 151}}, color = {0, 0, 127}));
  connect(Line23Bis1.terminal2, Fault.terminal) annotation(
    Line(points = {{-20, 74}, {0, 74}, {0, 44}}, color = {0, 0, 255}));
  connect(Conv1000.udFilterPu, Matching.udFilterPu) annotation(
    Line(points = {{-46, -13.5}, {-42, -13.5}, {-42, -17}, {-89, -17}, {-89, -16}}, color = {0, 0, 127}));
  connect(Conv1000.idPccPu, Matching.idPccPu) annotation(
    Line(points = {{-46, -9}, {-41, -9}, {-41, -18}, {-93, -18}, {-93, -16}}, color = {0, 0, 127}));
  connect(Conv1000.idConvPu, Matching.idConvPu) annotation(
    Line(points = {{-46, -4.5}, {-40, -4.5}, {-40, -19}, {-97.5, -19}, {-97.5, -16}}, color = {0, 0, 127}));
  connect(Conv1000.UdcSourcePu, Matching.UdcSourcePu) annotation(
    Line(points = {{-46, 0}, {-39, 0}, {-39, -20}, {-102, -20}, {-102, -16}}, color = {0, 0, 127}));
  connect(Conv1000.iqConvPu, Matching.iqConvPu) annotation(
    Line(points = {{-46, 4.5}, {-38, 4.5}, {-38, -21}, {-107, -21}, {-107, -16}}, color = {0, 0, 127}));
  connect(Conv1000.iqPccPu, Matching.iqPccPu) annotation(
    Line(points = {{-46, 9}, {-37, 9}, {-37, -22}, {-111, -22}, {-111, -16}}, color = {0, 0, 127}));
  connect(Conv1000.uqFilterPu, Matching.uqFilterPu) annotation(
    Line(points = {{-46, 13.5}, {-36, 13.5}, {-36, -23}, {-115.5, -23}, {-115.5, -16}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.0001),
    Documentation(info = "<html><head></head><body> This test case consists in three different grid-forming converters (one with a droop control, one with a dispatchable virtual oscillator control and one with a matching control) connected to a load. At t = 0.5s the line connecting the 250MW and the 1000MW converters is opened. At t = 1.5s, a short-circuit occurs in the middle of one of the lines connecting the 250MW and the 500MW converters. It is cleared after 150ms. This test case and the grid-forming converters controls come from the Horizon 2020 European project MIGRATE, and more precisely from its Deliverables 3.2 and 3.3 that can be found on the project website : https://www.h2020-migrate.eu/downloads.html.</body></html>"),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-150, -100}, {150, 200}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end GridForming;
