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
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS avr(EMax = 4, EMin = 0, Efd0Pu = generatorSynchronous.Efd0Pu, K = 200, Ta = 3, Tb = 10, Te = 0.05, Upss0Pu = 0, Us0Pu = 1, UsRef0Pu = 1.0090862 ) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGOV1 governor(Dt = 0, Pm0Pu = generatorSynchronous.Pm0Pu, R = 0.05, Tg1 = 0.5, Tg2 = 3, Tg3 = 10, VMax = 1, VMin = 0) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 1.0090862) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

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
  connect(PmRefPu.y, governor.PmRefPu) annotation(
    Line(points = {{120, -20}, {70, -20}, {70, -40}, {78, -40}}, color = {0, 0, 127}));
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -46}, {79, -46}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{101, -40}, {110, -40}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(const.y, avr.UpssPu) annotation(
    Line(points = {{102, 0}, {110, 0}, {110, 12}, {118, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(const1.y, avr.UsRefPu) annotation(
    Line(points = {{21, 60}, {50, 60}, {50, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {152, 18}, {152, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body>The purpose of the second test case is to compare the dynamic behaviour of the model for the synchronous generator and its governor by analysing the terminal voltage, the active and mechanical power of the synchronous machine, the reactive power of the synchronous machine and the speed.<div><br></div>At the event time the active power demand of the additional constant impedance is increased by 0.05 pu.<div><br></div>The results obtained perfectly match the ones presented in the ENTSO-E report.

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
