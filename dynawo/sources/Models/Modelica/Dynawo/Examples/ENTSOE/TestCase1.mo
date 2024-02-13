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
   Ce0Pu = 0,
   Cm0Pu = 0,
   Cos2Eta0 = 1,
   DPu = 0,
   Efd0Pu = 1,
   ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
   H = 4,
   IRotor0Pu = 1,
   IStator0Pu = 0,
   Id0Pu = 0,
   If0Pu = 0.540541,
   Iq0Pu = 0,
   LDPPu = 0.19063,
   LQ1PPu = 0.51659,
   LQ2PPu = 0.24243,
   LambdaAD0Pu = 1,
   LambdaAQ0Pu = 0,
   LambdaAirGap0Pu = 1,
   LambdaD0Pu = 1,
   LambdaQ10Pu = 0,
   LambdaQ20Pu = 0,
   Lambdad0Pu = 1,
   Lambdaf0Pu = 1.121189,
   Lambdaq0Pu = 0,
   LdPPu = 0.15,
   LfPPu = 0.2242,
   LqPPu = 0.15,
   MdPPu = 1.85,
   MdSat0PPu = 1.85,
   Mds0Pu = 1.85,
   Mi0Pu = 1.85,
   MqPPu = 1.65,
   MqSat0PPu = 1.65,
   Mqs0Pu = 1.65,
   MrcPPu = 0,
   MsalPu = 0.2,
   P0Pu = 0,
   PGen0Pu = 0,
   PNomAlt = 475,
   PNomTurb = 475,
   Pm0Pu = 0,
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
   Sin2Eta0 = 0,
   SnTfo = 500,
   Theta0 = 0,
   ThetaInternal0 = 0,
   U0Pu = 1,
   UBaseHV = 400,
   UBaseLV = 21,
   UNom = 21,
   UNomHV = 400,
   UNomLV = 21,
   UPhase0 = 0,
   UStator0Pu = 1,
   Ud0Pu = 0,
   Uf0Pu = 0.000691892,
   Uq0Pu = 1,
   XTfPu = 0,
   md = 0,
   mq = 0,
   nd = 0,
   nq = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS avr(
    EMax = 4,
    EMin = 0,
    Efd0Pu = generatorSynchronous.Efd0Pu,
    K = 200,
    Ta = 3,
    Tb = 10,
    Te = 0.05,
    Upss0Pu = 0,
    Us0Pu = 1,
    UsRef0Pu = 1.005) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2a pss(
    Ks1 = 10,
    Ks2 = 0.1564,
    Ks3 = 1,
    M = 1,
    N = 1,
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
    t8 = 1e-5,
    t9 = 1e-5,
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
  Modelica.Blocks.Sources.Constant const(k = 1);
  Modelica.Blocks.Sources.Step step(height = 0.05, offset = 1.005, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = governor.R * generatorSynchronous.Pm0Pu);

  // Bus
  Dynawo.Electrical.Buses.Bus currentBus annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;

  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(governor.omegaRefPu, const.y);
  connect(governor.PmRefPu, PmRefPu.y);
  connect(const.y, pss.omegaRefPu);
  connect(currentBus.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-120, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -34}, {78, -34}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{38, 10}, {70, 10}, {70, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{38, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(pss.VPssPu, avr.UpssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(step.y, avr.UsRefPu) annotation(
    Line(points = {{21, 60}, {70, 60}, {70, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{102, -30}, {110, -30}, {110, -51}, {32, -51}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -60}, {8, -60}, {8, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"left: 118.2px; top: 569.49px; font-family: sans-serif;\">The purpose of the first test case is to compare the dynamic behaviour</span><span style=\"left: 698.591px; top: 569.49px; font-family: sans-serif;\">r of the model for the </span><span style=\"left: 118.2px; top: 594.09px; font-family: sans-serif;\">synchronous </span><span style=\"left: 234.194px; top: 594.09px; font-family: sans-serif;\">machine </span><span style=\"left: 315.393px; top: 594.09px; font-family: sans-serif;\">and </span><span style=\"left: 357.989px; top: 594.09px; font-family: sans-serif;\">its AVR</span><span style=\"left: 425.977px; top: 594.09px; font-family: sans-serif;\"> by </span><span style=\"left: 469.18px; top: 594.09px; font-family: sans-serif;\">analysing</span><span style=\"left: 546.773px; top: 594.09px; font-family: sans-serif;\"> the terminal voltage</span><span style=\"left: 794.4px; top: 594.09px; font-family: sans-serif;\">&nbsp;and the </span><span style=\"left: 118.2px; top: 622.886px; font-family: sans-serif;\">excitation voltage </span><span style=\"left: 306.2px; top: 622.89px; font-family: sans-serif;\">inside</span><span style=\"left: 363.994px; top: 622.89px; font-family: sans-serif;\"> the </span><span style=\"left: 409.387px; top: 622.89px; font-family: sans-serif;\">machine</span><span style=\"left: 478.59px; top: 622.89px; font-family: sans-serif;\">.&nbsp;</span><div><span style=\"left: 478.59px; top: 622.89px; font-family: sans-serif;\">The test consists of a no-load operation with a step on the voltage reference value (+ 0.05 pu) done at t = 0.1 s.</span></div><div><span style=\"left: 478.59px; top: 622.89px; font-family: sans-serif;\"><br></span></div><div><span style=\"left: 478.59px; top: 622.89px; font-family: sans-serif;\">The results obtained perfectly match the results presented in the ENTSO-E report.</span></div>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/EfdPuTestCase1.png\">
    </figure>

    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/ENTSOE/Resources/UPuTestCase1.png\">
    </figure>

</body></html>"));
end TestCase1;
