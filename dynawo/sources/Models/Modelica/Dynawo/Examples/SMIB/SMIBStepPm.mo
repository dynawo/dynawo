within Dynawo.Examples.SMIB;

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

model SMIBStepPm "Synchronous machine infinite bus - Step on Pm"
  import Dynawo;
  extends Icons.Example;
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.90081)  annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0, XPu = 0.022522)  annotation(
    Placement(visible = true, transformation(origin = {-32, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0, XPu = 0.04189)  annotation(
    Placement(visible = true, transformation(origin = {-32, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Machines.GeneratorSynchronous generatorSynchronous(
    ExcitationPu = Dynawo.Electrical.Machines.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad,
    H = 3.5, DPu = 0,
    PNomAlt = 2200, PNomTurb = 2220, SNom = 2220,
    SnTfo = 2220, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, XTfPu = 0, RTfPu = 0,
    P0Pu = -19.98, Q0Pu= -9.68, U0Pu = 1, UPhase0 = 0.494451,
    RaPPu = 0.003,
    LdPPu = 0.15,
    MdPPu = 1.66,
    LDPPu = 0.16634,
    RDPPu = 0.03339,
    MrcPPu = 0,
    LfPPu = 0.16990,
    RfPPu = 0.00074,
    LqPPu = 0.15,
    MqPPu = 1.61,
    LQ1PPu = 0.92815,
    RQ1PPu = 0.00924,
    LQ2PPu = 0.12046,
    RQ2PPu = 0.02821,
    PGen0Pu = 19.979054,
    QGen0Pu = 9.679016,
    UStator0Pu = 1,
    QStator0Pu = 9.679016,
    Theta0 = 1.224005,
    ThetaInternal0 = 1.224005,
    IRotor0Pu = 2.420685,
    IStator0Pu = 22.199820,
    Efd0Pu = 2.420747,
    Cm0Pu = 0.903, Ce0Pu = 0.903, Pm0Pu = 0.903,
    Id0Pu = -0.924857, If0Pu = 1.458244, Iq0Pu = -0.380294,
    LambdaD0Pu = 0.885353, Lambdad0Pu = 0.746631, Lambdaf0Pu = 1.133115,
    LambdaQ10Pu = -0.612268, LambdaQ20Pu = -0.612268, Lambdaq0Pu = -0.669312,
    Ud0Pu = 0.666538, Uf0Pu = 0.001079, Uq0Pu = 0.745490)  annotation(
    Placement(visible = true, transformation(origin = {82, 1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.903, Height = 0.008, tStep = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint EfdPu(Value0 = 2.420747);
equation
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{56, 0}, {82, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, -20}, {0, -20}, {0, 0}, {16, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, transformer.terminal1) annotation(
    Line(points = {{-12, 20}, {1.42109e-14, 20}, {1.42109e-14, -4.26324e-14}, {16, -4.26324e-14}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, 20}, {-62, 20}, {-62, -4.26324e-14}, {-92, -4.26324e-14}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-52, -20}, {-62, -20}, {-62, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(generatorSynchronous.PmPu, PmPu.step);
  connect(generatorSynchronous.efdPu, EfdPu.setPoint);
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.0001, Interval = 0.015,
    __OpenModelica_commandLineOptions = "--daeMode"),
    Documentation(info = "<html><head></head><body> This test case represents a synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a step variation on the generator  mechanical power Pm.</body></html>"));
end SMIBStepPm;
