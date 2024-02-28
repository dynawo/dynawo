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
   Ce0Pu = 0.95,
   Cm0Pu = 1,
   Cos2Eta0 = 0.586492,
   DPu = 0,
   Efd0Pu = 2.50789,
   ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
   H = 4,
   IRotor0Pu = 2.50789,
   IStator0Pu = 5.03993,
   Id0Pu = -0.921348,
   If0Pu = 1.35562,
   Iq0Pu = -0.408844,
   LDPPu = 0.19063,
   LQ1PPu = 0.51659,
   LQ2PPu = 0.24243,
   LambdaAD0Pu = 0.803398,
   LambdaAQ0Pu = -0.674593,
   LambdaAirGap0Pu = 1.04906,
   LambdaD0Pu = 0.803398,
   LambdaQ10Pu = -0.674593,
   LambdaQ20Pu = -0.674593,
   Lambdad0Pu = 0.665196,
   Lambdaf0Pu = 1.10733,
   Lambdaq0Pu = -0.73592,
   LdPPu = 0.15,
   LfPPu = 0.2242,
   LqPPu = 0.15,
   MdPPu = 1.85,
   MdSat0PPu = 1.85,
   Mds0Pu = 1.85,
   Mi0Pu = 1.7673,
   MqPPu = 1.65,
   MqSat0PPu = 1.65,
   Mqs0Pu = 1.65,
   MrcPPu = 0,
   MsalPu = 0.2,
   P0Pu = -4.75,
   PGen0Pu = 4.75,
   PNomAlt = 475,
   PNomTurb = 475,
   Pm0Pu = 1,
   Q0Pu = -1.56,
   QGen0Pu = 1.56,
   QStator0Pu = 1.56,
   RDPPu = 0.02933,
   RQ1PPu = 0.0035,
   RQ2PPu = 0.02227,
   RTfPu = 0,
   RaPPu = 0,
   RfPPu = 0.00128,
   SNom = 500,
   Sin2Eta0 = 0.413508,
   SnTfo = 500,
   Theta0 = 0.996978,
   ThetaInternal0 = 0.996978,
   U0Pu = 0.992,
   UBaseHV = 400,
   UBaseLV = 21,
   UNom = 21,
   UNomHV = 400,
   UNomLV = 21,
   UPhase0 = 0.161146,
   UStator0Pu = 0.992,
   Ud0Pu = 0.73592,
   Uf0Pu = 0.00173519,
   Uq0Pu = 0.665196,
   XTfPu = 0,
   md = 0,
   mq = 0,
   nd = 0,
   nq = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGOV1 governor(Dt = 0, Pm0Pu = generatorSynchronous.Pm0Pu, R = 0.05, Tg1 = 0.5, Tg2 = 3, Tg3 = 10, VMax = 1, VMin = 0) annotation(
    Placement(visible = true, transformation(origin = {90, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PSS2A1 pss(IC1 = 1, IC2 = 3, Ks1 = 10, Ks2 = 0.1564, Ks3 = 1, PGen0Pu = generatorSynchronous.P0Pu, PNomAlt = generatorSynchronous.PNomAlt, T1 = 0.25, T2 = 0.03, T3 = 0.15, T4 = 0.015, T6 = 1e-5, T7 = 2, T8 = 0.5, T9 = 0.1, Tw1 = 2, Tw2 = 2, Tw3 = 2, Tw4 = 1e-5, Upss0Pu = 0, VstMax = 0.1, VstMin = -0.1) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS avr(EMax = 4, EMin = 0, Efd0Pu = generatorSynchronous.Efd0Pu, K = 200, Ta = 3, Tb = 10, Te = 0.05, Upss0Pu = 0, Us0Pu = 0.992, UsRef0Pu = 1.00453945) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1.00453945) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu);

 // Network
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0.000242, UPu = 0.952859) annotation(
    Placement(visible = true, transformation(origin = {-132, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line gridImpedance(BPu = 0, GPu = 0, RPu = 0.0036, XPu = 0.036) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0.0003, XPu = 0.032, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, u0Pu = Complex(0.952267, 0)) annotation(
    Placement(visible = true, transformation(origin = {-80, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = 4.75);
  Modelica.Blocks.Sources.Constant QRefPu(k = 0.76);

  // Three-phase short circuit
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.000173, XPu = 0, tBegin = 0.1, tEnd = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-52, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{-12, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(gridImpedance.terminal2, transformer.terminal1) annotation(
    Line(points = {{-80, 0}, {-52, 0}}, color = {0, 0, 255}));
  connect(gridImpedance.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-120, 0}, {-132, 0}}, color = {0, 0, 255}));
  connect(load.terminal, gridImpedance.terminal2) annotation(
    Line(points = {{-80, -38}, {-80, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(governor.PmRefPu, PmRefPu.y);
  connect(nodeFault.terminal, transformer.terminal1) annotation(
    Line(points = {{-52, 50}, {-52, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -36}, {78, -36}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{38, 10}, {70, 10}, {70, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{38, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(pss.UpssPu, avr.UpssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(const.y, avr.UsRefPu) annotation(
    Line(points = {{21, 60}, {80, 60}, {80, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{102, -30}, {110, -30}, {110, -51}, {32, -51}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -60}, {8, -60}, {8, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"left: 118.2px; top: 339.49px; font-family: sans-serif;\">The purpose of the third test case is to compare the dynamic behaviour</span><span style=\"left: 706.595px; top: 339.49px; font-family: sans-serif;\"> of the model for the </span><span style=\"left: 118.2px; top: 363.686px; font-family: sans-serif;\">synchronous </span><span style=\"left: 231.599px; top: 363.686px; font-family: sans-serif;\">machine</span><span style=\"left: 300.802px; top: 363.686px; font-family: sans-serif;\"> with its whole </span><span style=\"left: 436.796px; top: 363.686px; font-family: sans-serif;\">control</span><span style=\"left: 491.996px; top: 363.686px; font-family: sans-serif;\"> in operation during and after a three</span><span style=\"left: 818.191px; top: 363.686px; font-family: sans-serif;\">-phase </span><span style=\"left: 118.2px; top: 388.286px; font-family: sans-serif;\">short</span><span style=\"left: 158.993px; top: 388.286px; font-family: sans-serif;\">-circuit</span><span style=\"left: 213.199px; top: 388.286px; font-family: sans-serif;\"> by </span><span style=\"left: 254.802px; top: 388.286px; font-family: sans-serif;\">analysing</span><span style=\"left: 332.597px; top: 388.286px; font-family: sans-serif;\"> the terminal voltage</span><span style=\"left: 577.4px; top: 388.29px; font-family: sans-serif;\">, the excitation voltage inside the </span><span style=\"left: 118.191px; top: 417.086px; font-family: sans-serif;\">generator</span><span style=\"left: 233.4px; top: 417.09px; font-family: sans-serif;\">, the active and reactive power of the </span><span style=\"left: 539.006px; top: 417.09px; font-family: sans-serif;\">synchronous machine</span><span style=\"left: 812.6px; top: 417.09px; font-family: sans-serif;\">&nbsp;as well </span><span style=\"left: 118.202px; top: 446.088px; font-family: sans-serif;\">as speed</span><span style=\"left: 203.35333333333332px; top: 446.2357029144049px; font-family: sans-serif;\">.</span><div><span style=\"left: 118.222px; top: 580.87px; font-family: sans-serif;\">At the event</span><span style=\"left: 216.827px; top: 580.87px; font-family: sans-serif;\">-time a </span><span style=\"left: 278.835px; top: 580.87px; font-family: sans-serif;\">bolted </span><span style=\"left: 334.238px; top: 580.87px; font-family: sans-serif;\">three-</span><span style=\"left: 382.446px; top: 580.87px; font-family: sans-serif;\">phase short circuit occurs at the </span><span style=\"left: 648.638px; top: 580.87px; font-family: sans-serif;\">high</span><span style=\"left: 683.23px; top: 580.87px; font-family: sans-serif;\">-voltage side of the </span><span style=\"left: 844.838px; top: 580.87px; font-family: sans-serif;\">unit&nbsp;</span><span style=\"left: 118.24px; top: 605.268px; font-family: sans-serif;\">transformer</span><span style=\"left: 322.241px; top: 605.268px; font-family: sans-serif;\">. After the fault duration of </span><span style=\"left: 590.485px; top: 606.393px; font-family: serif;\">0.1 s</span><span style=\"left: 639.6px; top: 605.29px; font-family: sans-serif;\">&nbsp;the </span><span style=\"left: 678.608px; top: 605.29px; font-family: sans-serif;\">initial system conditions </span><span style=\"left: 118.199px; top: 634.086px; font-family: sans-serif;\">are </span><span style=\"left: 149.792px; top: 634.086px; font-family: sans-serif;\">restored.</span><font face=\"sans-serif\"><br></font><span style=\"left: 226.8px; top: 446.09px; font-size: 18.4px; font-family: sans-serif; transform: scaleX(0.815219);\"></span><div><span style=\"left: 203.35333333333332px; top: 446.2357029144049px; font-family: sans-serif;\"><br></span></div></div><div><span style=\"left: 203.35333333333332px; top: 446.2357029144049px; font-family: sans-serif;\">The results obtained match perfectly the results presented in the report.</span></div>

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
