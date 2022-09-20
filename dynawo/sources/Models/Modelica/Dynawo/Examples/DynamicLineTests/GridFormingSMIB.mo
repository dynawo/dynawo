within Dynawo.Examples.DynamicLineTests;

  /*
  * Copyright (c) 2020, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the 0.5L was not distributed with this
  * file, you can obtain one at http://mozilla.org/0.5L/2.0/.dynamic
  * SPDX-License-Identifier: 0.5L-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */


model GridFormingSMIB "Node fault on a equivalent SMIB model with a Grid Forming inverter source "

  import Dynawo;
  import Modelica;

  extends Icons.Example;

  parameter Real x = 0.5 "Emplacement of the fault relative to the line lenght : x= default location /line lenght";
  parameter Real deltat = 1 "Fault duration in seconds";
  parameter Real tbegin = 1 "Fault start time in seconds";

  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {20, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = -18.96118, UPu = 0.8681228)  annotation(
    Placement(visible = true, transformation(origin = {20, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.GridFormingControlDroopControl Droop(Cfilter = 0.066, IdConv0Pu = 0.8196814, IdPcc0Pu = 0.8196814, IdcSource0Pu = 0.8238318, IdcSourceRef0Pu = 0.8196814, Imax = 1, IqConv0Pu = -0.4996584, IqPcc0Pu = -0.5729309, Kff = 0.01, Kic = 1.19, Kiv = 1.161022, KpVI = 0.67, Kpc = 0.7388, Kpdc = 50, Kpv = 0.52, Lfilter = 0.15, Mp = 0.01 , Mq = 0, PRef0Pu = 0.9100013, QRef0Pu = 0.6360615, Rfilter = 0.005, Theta0 = 0.6533165, UdConv0Pu = 1.189236, UdFilter0Pu = 1.110189, UdcSource0Pu = 1.110189, UdcSourcePu(fixed = true), UqConv0Pu = 0.1204539, Wf = 50, Wff = 16.66, XRratio = 5, currentLoop(integratord(y_start = 0.00323126), integratorq(y_start = -0.000164394)), droopControl(firstOrder(y_start = -7.3445e-5), firstOrder1(y_start = 0.102988), firstOrder2(y_start = 0.00622874), firstOrder3(y_start = -0.0010158), integrator(y_start = -0.0502873)), idConvPu(fixed = true), idPccPu(fixed = true), iqConvPu(fixed = true), iqPccPu(fixed = true), udFilterPu(fixed = true), uqFilterPu(fixed = true)) annotation(
    Placement(visible = true, transformation(origin = {-28, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.Electrical.Sources.Converter Conv250(Cdc = 0.01, Cfilter = 0.066, IdConv0Pu = 0.8196814, IdPcc0Pu = 0.8196814, IdcSource0Pu = 0.8238318, IqConv0Pu = -0.4996584, IqPcc0Pu = -0.5729309, Lfilter = 0.15, Ltransformer = 0.2, PGenPu(fixed = true, start = 19.98), QGenPu(fixed = true, start = 9.68), Rfilter = 0.005, Rtransformer = 0.01, SNom = 2220, Theta0 = 0.6533165, UdConv0Pu = 1.189236, UdFilter0Pu = 1.110189, UdPcc0Pu = 0.987406, UdcSource0Pu = 1.110189, UqConv0Pu = 0.1204539, UqPcc0Pu = -0.158207, i0Pu = Complex(-22.18062, -0.9606586), theta(fixed = true, start = 0.653316), u0Pu = Complex(0.8802336, 0.4745406)) annotation(
    Placement(visible = true, transformation(origin = {20, 40}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.0001, XPu = 0.0001, tBegin = tbegin, tEnd = tbegin + deltat)  annotation(
    Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 1, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, -7}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRef250Pu(height = 0, offset = 1.11019, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, 47}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcSourceRef250Pu(height = 0, offset = 1.11019, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, 11}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRef250Pu(height = 0, offset = 0.819681, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, 28}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRef250Pu(height = 0, offset = 0.910001, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, 85}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef250Pu(height = 0, offset = 0.636062, startTime = 1) annotation(
    Placement(visible = true, transformation(origin = {-85, 66}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line(CPu = 0.000001, GPu = x * 0.0000375, LPu = x * 0.0375, RPu = x * 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), u10Pu = Complex(0.8754183, 0.1120892), u20Pu = Complex(0.8881165, 0.3208819), iRL0Pu = Complex(-11.09238, -0.4319979) )  annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.DynamicLine line1(CPu = 0.000001, GPu = (1 -x) * 0.0000375, LPu = (1 -x) * 0.0375, RPu = (1 -x) * 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.8754183, 0.1120892), iRL0Pu = Complex(-11.09238, -0.4319979) ) annotation(
   Placement(visible = true, transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.DynamicLine line2(CPu = 0.000001, GPu =  0.0000375, LPu =  0.0375, RPu =  0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.8881165, 0.3208819), iRL0Pu = Complex(-11.09238, -0.4319979) ) annotation(
     Placement(visible = true, transformation(origin = {40, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

initial equation
//  der(Conv250.theta)=0;
//  der(Conv250.idConvPu)=0;
//  der(Conv250.iqConvPu)=0;
//  der(Conv250.udFilterPu)=0;
//  der(Conv250.uqFilterPu)=0;
//  der(Conv250.idPccPu)=0;
//  der(Conv250.iqPccPu)=0;

equation
  line2.omegaPu = Droop.omegaRefPu;
  line.omegaPu = Droop.omegaRefPu;
  line1.omegaPu = Droop.omegaRefPu;
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
    Line(points = {{0, -40}, {0, -40}}, color = {0, 0, 255}));
  connect(line1.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{0, -60}, {0, -80}, {20, -80}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{40, -50}, {40, -80}, {20, -80}}, color = {0, 0, 255}));
  connect(line2.terminal1, transformer.terminal2) annotation(
    Line(points = {{40, -30}, {40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(Droop.uqConvRefPu, Conv250.uqConvRefPu) annotation(
    Line(points = {{-13, 34}, {5, 34}}, color = {0, 0, 127}));
  connect(Conv250.iqPccPu, Droop.iqPccPu) annotation(
    Line(points = {{35, 32}, {71.75, 32}, {71.75, 81}, {-36, 81}, {-36, 55}}, color = {0, 0, 127}));
  connect(Conv250.iqConvPu, Droop.iqConvPu) annotation(
    Line(points = {{35, 36}, {66.75, 36}, {66.75, 76}, {-33, 76}, {-33, 55}}, color = {0, 0, 127}));
  connect(Conv250.uqFilterPu, Droop.uqFilterPu) annotation(
    Line(points = {{35, 27}, {76.75, 27}, {76.75, 86}, {-41, 86}, {-41, 55}}, color = {0, 0, 127}));
  connect(Droop.theta, Conv250.theta) annotation(
    Line(points = {{-13, 53}, {5, 53}}, color = {0, 0, 127}));
  connect(Conv250.UdcSourcePu, Droop.UdcSourcePu) annotation(
    Line(points = {{35, 40}, {61.75, 40}, {61.75, 71}, {-28, 71}, {-28, 55}}, color = {0, 0, 127}));
  connect(Droop.IdcSourcePu, Conv250.IdcSourcePu) annotation(
    Line(points = {{-13, 40}, {5, 40}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefOutPu, Conv250.UdcSourceRefPu) annotation(
    Line(points = {{-13, 30}, {5, 30}}, color = {0, 0, 127}));
  connect(Droop.udConvRefPu, Conv250.udConvRefPu) annotation(
    Line(points = {{-13, 46}, {5, 46}}, color = {0, 0, 127}));
  connect(Droop.omegaPu, Conv250.omegaPu) annotation(
    Line(points = {{-13, 27}, {5, 27}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{-40, -40}, {0, -40}}, color = {0, 0, 255}));
  connect(UFilterRef250Pu.y, Droop.UFilterRefPu) annotation(
    Line(points = {{-79.5, 47}, {-63.25, 47}, {-63.25, 40}, {-43, 40}}, color = {0, 0, 127}));
  connect(IdcSourceRef250Pu.y, Droop.IdcSourceRefPu) annotation(
    Line(points = {{-79.5, 28}, {-61.25, 28}, {-61.25, 32}, {-43, 32}}, color = {0, 0, 127}));
  connect(Droop.UdcSourceRefPu, UdcSourceRef250Pu.y) annotation(
    Line(points = {{-43, 26}, {-56, 26}, {-56, 11}, {-79.5, 11}}, color = {0, 0, 127}));
  connect(Droop.idConvPu, Conv250.idConvPu) annotation(
    Line(points = {{-24, 55}, {-24, 66}, {56, 66}, {56, 44}, {35, 44}}, color = {0, 0, 127}));
  connect(Droop.idPccPu, Conv250.idPccPu) annotation(
    Line(points = {{-20, 55}, {-20, 62}, {52, 62}, {52, 48}, {35, 48}}, color = {0, 0, 127}));
  connect(Droop.udFilterPu, Conv250.udFilterPu) annotation(
    Line(points = {{-16, 55}, {-16, 58}, {48, 58}, {48, 53}, {35, 53}}, color = {0, 0, 127}));
  connect(PRef250Pu.y, Droop.PRefPu) annotation(
    Line(points = {{-79.5, 85}, {-52, 85}, {-52, 54}, {-43, 54}}, color = {0, 0, 127}));
  connect(QRef250Pu.y, Droop.QRefPu) annotation(
    Line(points = {{-79.5, 66}, {-58, 66}, {-58, 48}, {-43, 48}}, color = {0, 0, 127}));
  connect(transformer.terminal2, line.terminal1) annotation(
    Line(points = {{20, 0}, {0, 0}, {0, -20}}, color = {0, 0, 255}));
  connect(transformer.terminal1, Conv250.terminal) annotation(
    Line(points = {{20, 20}, {20, 26}}, color = {0, 0, 255}));
  connect(step.y, Droop.omegaRefPu) annotation(
    Line(points = {{-79.5, -7}, {-16, -7}, {-16, 26}}, color = {0, 0, 127}));


  annotation( preferredView = "text", experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06),
    Documentation(info = "<html><head></head><body> The purpose of this test case is to evaluate the transient stability of an regulated SMIB model with dynamic lines, using a governor for frequency regulation and a PI for voltage regulation, by evaluating the rotor angle Theta for a node fault starting at (t_begin = 1 s) and (t_end = t_begin + delta_t).
    The following figures show the excepted evolutions of the generator rotor angle for two range of fault time (the first one for delta_t = 0.1 s and the second one for delta_t = 1 s) :

    <figure>
    <img width=\"400\" src=\"modelica://Dynawo/Examples/DynamicLineTests/Images/smalltest.png\">
    </figure>

    <figure>
    <img width=\"400\" src=\"modelica://Dynawo/Examples/DynamicLineTests/Images/bigtest.png\">
    </figure>

The results show that for any type of default, the rotor angle have two possible evolutions : stabilizing at the initial value or increasing to the inital value + 2k.pi.

    </body></html>") );
end GridFormingSMIB;
