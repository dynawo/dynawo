within Dynawo.Examples.SMIB.Standard;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model GovSteam1St4bPss2b1 "Voltage reference step on the synchronous machine (and its regulations) connected to a zero current bus"
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
   XTfPu = 0, i0Pu = Complex(0, 0),
   md = 0,
   mq = 0,
   nd = 0,
   nq = 0, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b avr(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    Ir0Pu = generatorSynchronous.IRotor0Pu,
    it0Pu = generatorSynchronous.i0Pu,
    Kc = 0.113,
    Kg = 0,
    Ki = 0,
    Kim = 0,
    Kir = 10.75,
    Kp = 9.3,
    Kpm = 1,
    Kpr = 10.75,
    tA = 0.02,
    Thetap = 0,
    tR = 0.02,
    UOelPu.start = 10,
    Us0Pu = generatorSynchronous.U0Pu,
    ut0Pu = generatorSynchronous.u0Pu,
    VaMaxPu = 99,
    VaMinPu = -99,
    Vb0Pu = 9.23476,
    VbMaxPu = 11.63,
    VmMaxPu = 99,
    VmMinPu = -99,
    VrMaxPu = 1,
    VrMinPu = -0.87,
    XlPu = 0.124) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.Pss2b pss(
    KOmega = 1,
    KOmegaRef = 0,
    Ks1 = 12,
    Ks2 = 0.2,
    Ks3 = 1,
    M = 5,
    N = 1,
    OmegaMaxPu = 2,
    OmegaMinPu = -2,
    PGen0Pu = -generatorSynchronous.P0Pu,
    PGenMaxPu = 2,
    PGenMinPu = -2,
    SNom = generatorSynchronous.SNom,
    t1 = 0.12,
    t2 = 0.02,
    t3 = 0.3,
    t4 = 0.02,
    t6 = 0.01,
    t7 = 2,
    t8 = 0.2,
    t9 = 0.1,
    t10 = 0.01,
    t11 = 0.01,
    tW1 = 2,
    tW2 = 2,
    tW3 = 2,
    tW4 = 1e-5,
    VPssMaxPu = 0.1,
    VPssMinPu = -0.1) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteam1 governor(Db1 = 0, Db2 = 0, Eps = 0, H0 = false, K = 25, K1 = 0.2, K2 = 0, K3 = 0.3, K4 = 0, K5 = 0.5, K6 = 0, K7 = 0, K8 = 0, pgv.table = [0, 0; 0.4, 0.75; 0.5, 0.91; 0.6, 0.98; 1, 1], pgv.tableOnFile = false, PMaxPu = 1, PMinPu = 0, Pm0Pu = generatorSynchronous.Pm0Pu, PmRef0Pu = generatorSynchronous.Pm0Pu, Sdb1 = true, Sdb2 = true, Uc = -10, Uo = 1, ValveOn = true, t1 = 1e-5, t2 = 1e-5, t3 = 0.1, t4 = 0.3, t5 = 5, t6 = 0.5, t7 = 1e-5) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UsRefPu(height = 0.05, offset = 1, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {50, -14}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UOelPu(k = 10) annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // Bus
  Dynawo.Electrical.Buses.Bus currentBus annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;

  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(currentBus.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-120, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(PmRefPu.y, governor.PmRefPu) annotation(
    Line(points = {{119, -20}, {90, -20}, {90, -30}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{38, 10}, {60, 10}, {60, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -40}, {80, -40}}, color = {0, 0, 127}));
  connect(governor.Pm1Pu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{100, -36}, {110, -36}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));
  connect(const.y, pss.omegaRefPu) annotation(
    Line(points = {{54, -14}, {70, -14}, {70, -6}, {78, -6}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(UsRefPu.y, avr.UsRefPu) annotation(
    Line(points = {{22, 60}, {100, 60}, {100, 20}, {118, 20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pss.VPssPu, avr.UPssPu) annotation(
    Line(points = {{102, 0}, {110, 0}, {110, 8}, {118, 8}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, avr.IrPu) annotation(
    Line(points = {{28, 18}, {28, 28}, {118, 28}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {80, 18}, {80, 16}, {118, 16}}, color = {0, 0, 127}));
  connect(generatorSynchronous.uPu_out, avr.utPu) annotation(
    Line(points = {{4, 18}, {4, 40}, {160, 40}, {160, 10}, {142, 10}}, color = {85, 170, 255}));
  connect(generatorSynchronous.iStatorPu_out, avr.itPu) annotation(
    Line(points = {{12, 18}, {12, 36}, {158, 36}, {158, 14}, {142, 14}}, color = {85, 170, 255}));
  connect(UOelPu.y, avr.UOelPu) annotation(
    Line(points = {{119, 60}, {110, 60}, {110, 24}, {118, 24}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(const.y, avr.UUelPu) annotation(
    Line(points = {{54, -14}, {106, -14}, {106, 12}, {118, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(const.y, avr.USclOelPu) annotation(
    Line(points = {{54, -14}, {106, -14}, {106, 32}, {150, 32}, {150, 26}, {142, 26}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(const.y, avr.USclUelPu) annotation(
    Line(points = {{54, -14}, {106, -14}, {106, 32}, {150, 32}, {150, 22}, {142, 22}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end GovSteam1St4bPss2b1;
