within Dynawo.Examples.ENTSOE;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model TestCase1 "Voltage reference step on the synchronous machine (and its regulations) connected to a zero current bus"
  extends Icons.Example;

  // Generator and regulations
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    Ce0Pu(fixed = false),
    Cm0Pu(fixed = false),
    Cos2Eta0(fixed = false),
    DPu = 0,
    Efd0Pu(fixed = false),
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 4,
    IRotor0Pu(fixed = false),
    IStator0Pu(fixed = false),
    Id0Pu(fixed = false),
    If0Pu(fixed = false),
    Iq0Pu(fixed = false),
    LDPPu = 0.19063,
    LQ1PPu = 0.51659,
    LQ2PPu = 0.24243,
    LambdaAD0Pu(fixed = false),
    LambdaAQ0Pu(fixed = false),
    LambdaAirGap0Pu(fixed = false),
    LambdaD0Pu(fixed = false),
    LambdaQ10Pu(fixed = false),
    LambdaQ20Pu(fixed = false),
    Lambdad0Pu(fixed = false),
    Lambdaf0Pu(fixed = false),
    Lambdaq0Pu(fixed = false),
    LdPPu = 0.15,
    LfPPu = 0.2242,
    LqPPu = 0.15,
    MdPPu = 1.85,
    MdPPuEfdNom(fixed = false),
    MdSat0PPu(fixed = false),
    Mds0Pu(fixed = false),
    Mi0Pu(fixed = false),
    MqPPu = 1.65,
    MqSat0PPu(fixed = false),
    Mqs0Pu(fixed = false),
    MrcPPu = 0,
    MsalPu = 0.2,
    P0Pu = 0,
    PGen0Pu(fixed = false),
    PNomAlt = 475,
    PNomTurb = 475,
    Pm0Pu(fixed = false),
    Q0Pu = 0,
    QGen0Pu(fixed = false),
    QStator0Pu(fixed = false),
    RDPPu = 0.02933,
    RQ1PPu = 0.0035,
    RQ2PPu = 0.02227,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.00128,
    SNom = 500,
    Sin2Eta0(fixed = false),
    SnTfo = 500,
    Theta0(fixed = false),
    ThetaInternal0(fixed = false),
    U0Pu = 1,
    UBaseHV = 400,
    UBaseLV = 21,
    UNom = 21,
    UNomHV = 400,
    UNomLV = 21,
    UPhase0 = 0,
    UStator0Pu(fixed = false),
    Ud0Pu(fixed = false),
    Uf0Pu(fixed = false),
    Uq0Pu(fixed = false),
    XTfPu = 0,
    md = 0,
    mq = 0,
    nd = 0,
    nq = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS avr(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    EMax = 4,
    EMin = 0,
    K = 200,
    Ta = 3,
    Tb = 10,
    Te = 0.05,
    Us0Pu = generatorSynchronous.UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2a pss(
    Ks1 = 10,
    Ks2 = 0.1564,
    Ks3 = 1,
    M = 1,
    N = 0,
    OmegaMaxPu = 999,
    OmegaMinPu = -999,
    PGen0Pu = -generatorSynchronous.P0Pu,
    PGenMaxPu = 999,
    PGenMinPu = -999,
    SNom = generatorSynchronous.PNomAlt,
    t1 = 0.25,
    t2 = 0.03,
    t3 = 0.15,
    t4 = 0.015,
    t6 = 1e-5,
    t7 = 2,
    t8 = 0.5,
    t9 = 0.1,
    tW1 = 2,
    tW2 = 2,
    tW3 = 2,
    tW4 = 1e-5,
    VPssMaxPu = 0.1,
    VPssMinPu = -0.1) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGov1 governor(
    Dt = 0,
    Pm0Pu = generatorSynchronous.Pm0Pu,
    R = 0.05,
    t1 = 0.5,
    t2 = 3,
    t3 = 10,
    VMax = 1,
    VMin = 0) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.05, offset = 1.005, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = governor.R * generatorSynchronous.Pm0Pu);

  // Bus
  Dynawo.Electrical.Buses.Bus currentBus annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));

  // Initialization
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousInt_INIT generatorSynchronousInt_INIT(
    DPu = generatorSynchronous.DPu,
    ExcitationPu = generatorSynchronous.ExcitationPu,
    H = generatorSynchronous.H,
    LDPu = generatorSynchronous.LDPPu,
    LQ1Pu = generatorSynchronous.LQ1PPu,
    LQ2Pu = generatorSynchronous.LQ2PPu,
    LdPu = generatorSynchronous.LdPPu,
    LfPu = generatorSynchronous.LfPPu,
    LqPu = generatorSynchronous.LqPPu,
    MdPu = generatorSynchronous.MdPPu,
    MdPuEfd = generatorSynchronous.MdPPuEfd,
    MqPu = generatorSynchronous.MqPPu,
    MrcPu = generatorSynchronous.MrcPPu,
    P0Pu = generatorSynchronous.P0Pu,
    PNomAlt = generatorSynchronous.PNomAlt,
    PNomTurb = generatorSynchronous.PNomTurb,
    Q0Pu = generatorSynchronous.Q0Pu,
    RDPu = generatorSynchronous.RDPPu,
    RQ1Pu = generatorSynchronous.RQ1PPu,
    RQ2Pu = generatorSynchronous.RQ2PPu,
    RTfPu = generatorSynchronous.RTfPu,
    RaPu = generatorSynchronous.RaPPu,
    RfPu = generatorSynchronous.RfPPu,
    SNom = generatorSynchronous.SNom,
    SnTfo = generatorSynchronous.SnTfo,
    U0Pu = generatorSynchronous.U0Pu,
    UBaseHV = generatorSynchronous.UBaseHV,
    UBaseLV = generatorSynchronous.UBaseLV,
    UNom = generatorSynchronous.UNom,
    UNomHV = generatorSynchronous.UNomHV,
    UNomLV = generatorSynchronous.UNomLV,
    UPhase0 = generatorSynchronous.UPhase0,
    XTfPu = generatorSynchronous.XTfPu,
    md = generatorSynchronous.md,
    mq = generatorSynchronous.mq,
    nd = generatorSynchronous.nd,
    nq = generatorSynchronous.nq) annotation(
    Placement(visible = true, transformation(origin = {-130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  Omega0Pu.setPoint.value = pss.omegaRefPu;
  Omega0Pu.setPoint.value = governor.omegaRefPu;

  connect(Omega0Pu.setPoint, generatorSynchronous.omegaRefPu);
  connect(PmRefPu.y, governor.PmRefPu);
  connect(currentBus.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-120, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -34}, {78, -34}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{38, 10}, {60, 10}, {60, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(pss.VPssPu, avr.UpssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(step.y, avr.UsRefPu) annotation(
    Line(points = {{21, 60}, {70, 60}, {70, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{101, -40}, {110, -40}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));

initial algorithm
  generatorSynchronous.Ce0Pu := generatorSynchronousInt_INIT.Ce0Pu;
  generatorSynchronous.Cm0Pu := generatorSynchronousInt_INIT.Cm0Pu;
  generatorSynchronous.Cos2Eta0 := generatorSynchronousInt_INIT.Cos2Eta0;
  generatorSynchronous.Efd0Pu := generatorSynchronousInt_INIT.Efd0Pu;
  generatorSynchronous.IRotor0Pu := generatorSynchronousInt_INIT.IRotor0Pu;
  generatorSynchronous.IStator0Pu := generatorSynchronousInt_INIT.IStator0Pu;
  generatorSynchronous.Id0Pu := generatorSynchronousInt_INIT.Id0Pu;
  generatorSynchronous.If0Pu := generatorSynchronousInt_INIT.If0Pu;
  generatorSynchronous.Iq0Pu := generatorSynchronousInt_INIT.Iq0Pu;
  generatorSynchronous.LambdaAD0Pu := generatorSynchronousInt_INIT.LambdaAD0Pu;
  generatorSynchronous.LambdaAQ0Pu := generatorSynchronousInt_INIT.LambdaAQ0Pu;
  generatorSynchronous.LambdaAirGap0Pu := generatorSynchronousInt_INIT.LambdaAirGap0Pu;
  generatorSynchronous.LambdaD0Pu := generatorSynchronousInt_INIT.LambdaD0Pu;
  generatorSynchronous.LambdaQ10Pu := generatorSynchronousInt_INIT.LambdaQ10Pu;
  generatorSynchronous.LambdaQ20Pu := generatorSynchronousInt_INIT.LambdaQ20Pu;
  generatorSynchronous.Lambdad0Pu := generatorSynchronousInt_INIT.Lambdad0Pu;
  generatorSynchronous.Lambdaf0Pu := generatorSynchronousInt_INIT.Lambdaf0Pu;
  generatorSynchronous.Lambdaq0Pu := generatorSynchronousInt_INIT.Lambdaq0Pu;
  generatorSynchronous.MdPPuEfdNom := generatorSynchronousInt_INIT.MdPPuEfdNom;
  generatorSynchronous.MdSat0PPu := generatorSynchronousInt_INIT.MdSat0PPu;
  generatorSynchronous.Mds0Pu := generatorSynchronousInt_INIT.Mds0Pu;
  generatorSynchronous.Mi0Pu := generatorSynchronousInt_INIT.Mi0Pu;
  generatorSynchronous.MqSat0PPu := generatorSynchronousInt_INIT.MqSat0PPu;
  generatorSynchronous.Mqs0Pu := generatorSynchronousInt_INIT.Mqs0Pu;
  generatorSynchronous.PGen0Pu := generatorSynchronousInt_INIT.PGen0Pu;
  generatorSynchronous.Pm0Pu := generatorSynchronousInt_INIT.Pm0Pu;
  generatorSynchronous.QGen0Pu := generatorSynchronousInt_INIT.QGen0Pu;
  generatorSynchronous.QStator0Pu := generatorSynchronousInt_INIT.QStator0Pu;
  generatorSynchronous.Sin2Eta0 := generatorSynchronousInt_INIT.Sin2Eta0;
  generatorSynchronous.Theta0 := generatorSynchronousInt_INIT.Theta0;
  generatorSynchronous.ThetaInternal0 := generatorSynchronousInt_INIT.ThetaInternal0;
  generatorSynchronous.UStator0Pu := generatorSynchronousInt_INIT.UStator0Pu;
  generatorSynchronous.Ud0Pu := generatorSynchronousInt_INIT.Ud0Pu;
  generatorSynchronous.Uf0Pu := generatorSynchronousInt_INIT.Uf0Pu;
  generatorSynchronous.Uq0Pu := generatorSynchronousInt_INIT.Uq0Pu;

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>The purpose of the first test case is to compare the dynamic behaviour of the model for the synchronous machine and its AVR by analysing the terminal voltage and the excitation voltage inside the machine.<div><br></div>The test consists of a no-load operation with a step on the voltage reference value (+ 0.05 pu) done at t = 0.1 s.<div><br></div>The results obtained perfectly match the results presented in the ENTSO-E report.

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/EfdPuTestCase1.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/UPuTestCase1.png\">
    </figure>

</body></html>"));
end TestCase1;
