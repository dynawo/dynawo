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

model TestCase3 "Bolted three-phase short circuit at the high-level side of the transformer"
  extends Icons.Example;

  // Generator and regulations
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    DPu = 0,
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 4,
    LDPPu = 0.19063,
    LQ1PPu = 0.51659,
    LQ2PPu = 0.24243,
    LdPPu = 0.15,
    LfPPu = 0.2242,
    LqPPu = 0.15,
    MdPPu = 1.85,
    MdPPuEfd = 1,
    MqPPu = 1.65,
    MrcPPu = 0,
    MsalPu = 0.2,
    P0Pu = -4.75,
    PNomAlt = 475,
    PNomTurb = 475,
    Q0Pu = -1.56,
    RDPPu = 0.02933,
    RQ1PPu = 0.0035,
    RQ2PPu = 0.02227,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.00128,
    SNom = 500,
    SnTfo = 500,
    U0Pu = 0.992,
    UBaseHV = 400,
    UBaseLV = 21,
    UNom = 21,
    UNomHV = 400,
    UNomLV = 21,
    UPhase0 = 0.161146,
    XTfPu = 0,
    md = 0,
    mq = 0,
    nd = 0,
    nq = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
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
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
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
  Modelica.Blocks.Sources.Constant const(k = avr.UsRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = governor.R * generatorSynchronous.Pm0Pu);

  // Network
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.000242, UPu = 0.952859) annotation(
    Placement(visible = true, transformation(origin = {-132, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line gridImpedance(BPu = 0, GPu = 0, RPu = 0.0036, XPu = 0.036) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0.0003, XPu = 0.032, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, i0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-80, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 4.75);
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.76);

  // Three-phase short circuit
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.000173, XPu = 0, tBegin = 0.1, tEnd = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-52, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initialization
  Dynawo.Electrical.Loads.Load_INIT load_INIT(P0Pu = PRefPu.k, Q0Pu = QRefPu.k, U0Pu = 0.952267, UPhase0 = 0) annotation(
    Placement(transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}})));

initial algorithm
  load.i0Pu.re := load_INIT.i0Pu.re;
  load.i0Pu.im := load_INIT.i0Pu.im;
  load.s0Pu.re := load_INIT.s0Pu.re;
  load.s0Pu.im := load_INIT.s0Pu.im;
  load.u0Pu.re := load_INIT.u0Pu.re;
  load.u0Pu.im := load_INIT.u0Pu.im;

equation
  load.PRefPu = PRefPu.y;
  load.QRefPu = QRefPu.y;
  gridImpedance.switchOffSignal1.value = false;
  gridImpedance.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.deltaP = 0;
  load.deltaQ = 0;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  Omega0Pu.setPoint.value = pss.omegaRefPu;
  Omega0Pu.setPoint.value = governor.omegaRefPu;

  connect(Omega0Pu.setPoint, generatorSynchronous.omegaRefPu);
  connect(PmRefPu.y, governor.PmRefPu);
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{-12, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(gridImpedance.terminal2, transformer.terminal1) annotation(
    Line(points = {{-80, 0}, {-52, 0}}, color = {0, 0, 255}));
  connect(gridImpedance.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-120, 0}, {-132, 0}}, color = {0, 0, 255}));
  connect(load.terminal, gridImpedance.terminal2) annotation(
    Line(points = {{-80, -38}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, transformer.terminal1) annotation(
    Line(points = {{-52, 50}, {-52, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -34}, {78, -34}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{38, 10}, {60, 10}, {60, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{38, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(pss.VPssPu, avr.UpssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(const.y, avr.UsRefPu) annotation(
    Line(points = {{81, 60}, {100, 60}, {100, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{101, -30}, {110, -30}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>The purpose of the third test case is to compare the dynamic behaviour of the model for the synchronous machine with its whole control in operation during and after a three-phase short-circuit by analysing the terminal voltage, the excitation voltage inside the generator, the active and reactive power of the synchronous machine as well as speed.<div><br></div>At the event time a bolted three-phase short circuit occurs at the high-voltage side of the unit transformer. After the fault duration of 0.1 s the initial system conditions are restored.<div><br></div>The results obtained match perfectly the results presented in the report.

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/UPuTestCase3.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/EfdPuTestCase3.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/OmegaPuTestCase3.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/UpssPuTestCase3.png\">
    </figure>

    </body></html>"));
end TestCase3;
