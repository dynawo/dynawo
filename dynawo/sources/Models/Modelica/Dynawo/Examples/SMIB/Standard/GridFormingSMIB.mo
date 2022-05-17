within Dynawo.Examples.SMIB.Standard;

model GridFormingSMIB
  /*
  * Copyright (c) 2020, RTE (http://www.rte-france.com)
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

  parameter Real x = 0.5;
  parameter Real deltat = 0.3;
  parameter Real tbegin = 1;

  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {24, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = -18.9567, UPu = 0.868123)  annotation(
    Placement(visible = true, transformation(origin = {20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = x *0.0000375, RPu = x *0.00375, XPu = x *0.0375)  annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = (1 - x) *0.0000375, RPu = (1 - x) *0.00375, XPu = (1 - x) *0.0375) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0.0000375, RPu = 0.00375, XPu = 0.0375) annotation(
    Placement(visible = true, transformation(origin = {40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Converters.GridFormingControlDroopControl Droop(Cfilter = 0.066, IdConv0Pu = 0.819681, IdPcc0Pu = 0.819681, IdcSource0Pu = 0.823832, IdcSourceRef0Pu = 0.819681, IqConv0Pu = -0.499658, IqPcc0Pu = -0.572931, Kff = 0.01, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, Lfilter = 0.15, Mp = 0.01, Mq = 0, PRef0Pu = 0.91001, QRef0Pu = 0.636062, Rfilter = 0.005, Theta0 = 0.653316, UdConv0Pu = 1.18924, UdFilter0Pu = 1.11019, UdcSource0Pu = 1.11019, UdcSourcePu(fixed = false), UqConv0Pu = 0.120454, Wf = 60, Wff = 16.66, XRratio = 5, currentLoop(integratord(y_start = 0.00323126), integratorq(y_start = -0.000164394)), droopControl(firstOrder(y_start = -7.3445e-5), firstOrder1(y_start = 0.102988), firstOrder2(y_start = 0.00622874), firstOrder3(y_start = -0.0010158), integrator(y_start = -0.0502873)), idConvPu(fixed = false), idPccPu(fixed = false), iqConvPu(fixed = false), iqPccPu(fixed = false), udFilterPu(fixed = false), uqFilterPu(fixed = false)) annotation(
    Placement(visible = true, transformation(origin = {-29, 41}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv250(Cdc = 0.01, Cfilter = 0.066, IdConv0Pu = 0.819681, IdPcc0Pu = 0.819681, IdcSource0Pu = 0.823832, IqConv0Pu = -0.499658, IqPcc0Pu = -0.572931, Lfilter = 0.15, Ltransformer = 0.2, PGenPu(fixed = true, start = 19.98), QGenPu(fixed = true, start = 9.68), Rfilter = 0.005, Rtransformer = 0.01, SNom = 2220, Theta0 = 0.653316, UdConv0Pu = 1.18924, UdFilter0Pu = 1.11019, UdPcc0Pu = 0.9687406, UdcSource0Pu = 1.11019, UqConv0Pu = 0.120454, UqPcc0Pu = -0.158207, i0Pu = Complex(-22.1806, -0.960659), theta(fixed = true, start = 0.653316), u0Pu = Complex(0.880234, 0.474541)) annotation(
    Placement(visible = true, transformation(origin = {23, 41}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.0001, XPu = 0.0001, tBegin = tbegin, tEnd = tbegin + deltat)  annotation(
    Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 1, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-57, -9}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef250Pu(height = 0, offset = 1.11019, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-87, 41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef250Pu(height = 0, offset = 1.11019, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-67, 7}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef250Pu(height = 0, offset = 0.819681, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-77, 24}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef250Pu(height = 0, offset = 0.910001, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-81, 79}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef250Pu(height = 0, offset = 0.636062, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-81, 62}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
initial equation
//  der(Conv250.theta)=0;
//  der(Conv250.idConvPu)=0;
//  der(Conv250.iqConvPu)=0;
//  der(Conv250.udFilterPu)=0;
//  der(Conv250.uqFilterPu)=0;
//  der(Conv250.idPccPu)=0;
//  der(Conv250.iqPccPu)=0;
equation
  Conv250.switchOffSignal1.value = false;
  Conv250.switchOffSignal2.value = false;
  Conv250.switchOffSignal3.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  connect(line.terminal2, line1.terminal1) annotation(
    Line(points = {{0, -20}, {0, -30}}, color = {0, 0, 255}));
  connect(line1.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{0, -50}, {0, -60}, {20, -60}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{40, -40}, {40, -60}, {20, -60}}, color = {0, 0, 255}));
  connect(line2.terminal1, transformer.terminal2) annotation(
    Line(points = {{40, -20}, {40, 0}, {24, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, line.terminal1) annotation(
    Line(points = {{24, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(Droop.uqConvRefPu, Conv250.uqConvRefPu) annotation(
    Line(points = {{-13.25, 35}, {7, 35}}, color = {0, 0, 127}));
  connect(Conv250.iqPccPu, Droop.iqPccPu) annotation(
    Line(points = {{39, 32}, {71.75, 32}, {71.75, 81}, {-38, 81}, {-38, 57}}, color = {0, 0, 127}));
  connect(Conv250.iqConvPu, Droop.iqConvPu) annotation(
    Line(points = {{39, 36.5}, {66.75, 36.5}, {66.75, 76}, {-34, 76}, {-34, 57}}, color = {0, 0, 127}));
  connect(Conv250.uqFilterPu, Droop.uqFilterPu) annotation(
    Line(points = {{39, 27.5}, {76.75, 27.5}, {76.75, 86}, {-43, 86}, {-43, 57}}, color = {0, 0, 127}));
  connect(Droop.theta, Conv250.theta) annotation(
    Line(points = {{-13.25, 54.5}, {7, 54.5}}, color = {0, 0, 127}));
  connect(Conv250.UdcSourcePu, Droop.UdcSourcePu) annotation(
    Line(points = {{39, 41}, {61.75, 41}, {61.75, 71}, {-29, 71}, {-29, 57}}, color = {0, 0, 127}));
  connect(Droop.IdcSourcePu, Conv250.IdcSourcePu) annotation(
    Line(points = {{-13.25, 41}, {7, 41}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefOutPu, Conv250.UdcSourceRefPu) annotation(
    Line(points = {{-13.25, 30.5}, {7, 30.5}}, color = {0, 0, 127}));
  connect(Droop.udConvRefPu, Conv250.udConvRefPu) annotation(
    Line(points = {{-13.25, 47}, {7, 47}}, color = {0, 0, 127}));
  connect(Droop.omegaPu, Conv250.omegaPu) annotation(
    Line(points = {{-13.25, 27.5}, {7, 27.5}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{-40, -40}, {-20, -40}, {-20, -20}, {0, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal1, Conv250.terminal) annotation(
    Line(points = {{24, 20}, {24, 23}, {23, 23}, {23, 25}}, color = {0, 0, 255}));
  connect(UFilterRef250Pu.y, Droop.UFilterRefPu) annotation(
    Line(points = {{-81.5, 41}, {-45, 41}}, color = {0, 0, 127}));
  connect(IdcSourceRef250Pu.y, Droop.IdcSourceRefPu) annotation(
    Line(points = {{-72, 24}, {-58, 24}, {-58, 32}, {-44, 32}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefPu, UdcSourceRef250Pu.y) annotation(
    Line(points = {{-44, 26}, {-56, 26}, {-56, 7}, {-61.5, 7}}, color = {0, 0, 127}));
  connect(Droop.idConvPu, Conv250.idConvPu) annotation(
    Line(points = {{-24, 56}, {-24, 66}, {56, 66}, {56, 45.5}, {39, 45.5}}, color = {0, 0, 127}));
  connect(Droop.idPccPu, Conv250.idPccPu) annotation(
    Line(points = {{-20, 56}, {-20, 62}, {52, 62}, {52, 50}, {39, 50}}, color = {0, 0, 127}));
  connect(Droop.udFilterPu, Conv250.udFilterPu) annotation(
    Line(points = {{-16, 56}, {-16, 58}, {48, 58}, {48, 54.5}, {39, 54.5}}, color = {0, 0, 127}));
  connect(PRef250Pu.y, Droop.PRefPu) annotation(
    Line(points = {{-76, 80}, {-52, 80}, {-52, 56}, {-44, 56}}, color = {0, 0, 127}));
  connect(QRef250Pu.y, Droop.QRefPu) annotation(
    Line(points = {{-76, 62}, {-58, 62}, {-58, 50}, {-44, 50}}, color = {0, 0, 127}));
  connect(step.y, Droop.omegaRefPu) annotation(
    Line(points = {{-52, -8}, {-16, -8}, {-16, 26}}, color = {0, 0, 127}));
end GridFormingSMIB;
