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

model TestCase2 "Active power variation on the load"
  extends Icons.Example;

  // Generator and regulations
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    Ce0Pu = 0.76,
    Cm0Pu = 0.8,
    Cos2Eta0 = 0.459383,
    DPu = 0,
    Efd0Pu = 1.81724,
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 4,
    IRotor0Pu = 1.81724,
    IStator0Pu = 3.8,
    Id0Pu = -0.613552,
    If0Pu = 0.982291,
    Iq0Pu = -0.448503,
    LDPPu = 0.19063,
    LQ1PPu = 0.51659,
    LQ2PPu = 0.24243,
    LambdaAD0Pu = 0.682168,
    LambdaAQ0Pu = -0.740029,
    LambdaAirGap0Pu = 1.00648,
    LambdaD0Pu = 0.682168,
    LambdaQ10Pu = -0.740029,
    LambdaQ20Pu = -0.740029,
    Lambdad0Pu = 0.590135,
    Lambdaf0Pu = 0.902397,
    Lambdaq0Pu = -0.807305,
    LdPPu = 0.15,
    LfPPu = 0.2242,
    LqPPu = 0.15,
    MdPPu = 1.85,
    MdSat0PPu = 1.85,
    Mds0Pu = 1.85,
    Mi0Pu = 1.74188,
    MqPPu = 1.65,
    MqSat0PPu = 1.65,
    Mqs0Pu = 1.65,
    MrcPPu = 0,
    MsalPu = 0.2,
    P0Pu = -3.8,
    PGen0Pu = 3.8,
    PNomAlt = 475,
    PNomTurb = 475,
    Pm0Pu = 0.8,
    Q0Pu = 0,
    QGen0Pu = 0,
    QStator0Pu = 0,
    RDPPu = 0.02933,
    RQ1PPu = 0.0035,
    RQ2PPu = 0.02227,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.00128,
    SNom = 500,
    Sin2Eta0 = 0.540617,
    SnTfo = 500,
    Theta0 = 0.93957,
    ThetaInternal0 = 0.93957,
    U0Pu = 1,
    UBaseHV = 400,
    UBaseLV = 21,
    UNom = 21,
    UNomHV = 400,
    UNomLV = 21,
    UPhase0 = 0,
    UStator0Pu = 1,
    Ud0Pu = 0.807305,
    Uf0Pu = 0.00125733,
    Uq0Pu = 0.590135,
    XTfPu = 0,
    md = 0,
    mq = 0,
    nd = 0,
    nq = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS avr(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    EMax = 4,
    EMin = 0,
    K = 200,
    Ta = 3,
    Tb = 10,
    Te = 0.05,
    Us0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGOV11 governor(Dt = 0, Pm0Pu = generatorSynchronous.Pm0Pu, R = 0.05, Tg1 = 0.5, Tg2 = 3, Tg3 = 10, VMax = 1, VMin = 0) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 1.0090862) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu);

  // Load
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0);
  Modelica.Blocks.Sources.Step PRefPu(height = 0.05 * generatorSynchronous.PNomAlt / 100, offset = 3.8, startTime = 0.1);

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  load.PRefPu = PRefPu.y;
  load.QRefPu = QRefPu.y;
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.deltaP = 0;
  load.deltaQ = 0;
  connect(generatorSynchronous.omegaRefPu, generatorSynchronous.omegaPu);
  connect(governor.PmRefPu, PmRefPu.y);
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -36}, {78, -36}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{102, -30}, {110, -30}, {110, -51}, {32, -51}, {32, -16}}, color = {0, 0, 127}));
  connect(const.y, avr.UpssPu) annotation(
    Line(points = {{102, 0}, {110, 0}, {110, 12}, {118, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(const1.y, avr.UsRefPu) annotation(
    Line(points = {{21, 60}, {50, 60}, {50, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -60}, {8, -60}, {8, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"left: 118.2px; top: 922.29px; font-family: sans-serif;\">The purpose of the second test case is to compare the dynamic behaviour</span><span style=\"left: 730px; top: 922.29px; font-family: sans-serif;\">r of the model for </span><span style=\"left: 118.2px; top: 946.688px; font-family: sans-serif;\">the synchronous generator and its governor</span><span style=\"left: 489.199px; top: 946.688px; font-family: sans-serif;\"> by </span><span style=\"left: 524.803px; top: 946.688px; font-family: sans-serif;\">analy</span><span style=\"left: 568.411px; top: 946.688px; font-family: sans-serif;\">sing</span><span style=\"left: 602.212px; top: 946.688px; font-family: sans-serif;\"> the terminal voltage</span><span style=\"left: 835.4px; top: 946.69px; font-family: sans-serif;\">, the </span><span style=\"left: 118.205px; top: 975.688px; font-family: sans-serif;\">active and mechanical power of the </span><span style=\"left: 414.206px; top: 975.688px; font-family: sans-serif;\">synchronous machine</span><span style=\"left: 712.4px; top: 975.69px; font-family: sans-serif;\">, the reactive power </span><span style=\"left: 118.209px; top: 1004.69px; font-family: sans-serif;\">of the synchronous machine</span><span style=\"left: 383.4px; top: 1004.69px; font-family: sans-serif;\">&nbsp;and </span><span style=\"left: 426.806px; top: 1004.69px; font-family: sans-serif;\">the </span><span style=\"left: 458.803px; top: 1004.69px; font-family: sans-serif;\">speed</span><span style=\"left: 540.4px; top: 1004.69px; font-family: sans-serif;\">.</span><div><span style=\"left: 540.4px; top: 1004.69px;\"><span style=\"font-family: sans-serif; left: 118.2px; top: 187.49px;\">At the event</span><span style=\"font-family: sans-serif; left: 216.198px; top: 187.49px;\">-time the active power demand of the additional constant impedance </span><span style=\"font-family: sans-serif; left: 776.202px; top: 187.49px;\">is increased </span><span style=\"left: 118.2px; top: 211.888px;\"><font face=\"sans-serif\">by </font><font face=\"serif\">0.05 pu</font><font face=\"sans-serif\">.</font></span></span></div><div><span style=\"left: 540.4px; top: 1004.69px;\"><span style=\"left: 118.2px; top: 211.888px;\"><font face=\"sans-serif\"><br></font></span></span></div><div><span style=\"left: 540.4px; top: 1004.69px;\"><span style=\"left: 118.2px; top: 211.888px;\"><font face=\"sans-serif\">The results obtained perfectly match the ones presented in the ENTSO-E report.</font></span></span></div>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/UPuTestCase2.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/PmPuTestCase2.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/OmegaPuTestCase2.png\">
    </figure>

</body></html>"));
end TestCase2;
