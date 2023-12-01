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

model GovSteam1St4b2 "Active power variation on the load"
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
   XTfPu = 0, i0Pu = Complex(-3.8, 0),
   md = 0,
   mq = 0,
   nd = 0,
   nq = 0, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteam1 governor(Db1 = 0, Db2 = 0, Eps = 0, H0 = false, K = 25, K1 = 0.2, K2 = 0, K3 = 0.3, K4 = 0, K5 = 0.5, K6 = 0, K7 = 0, K8 = 0, pgv.table = [0, 0; 0.4, 0.75; 0.5, 0.91; 0.6, 0.98; 1, 1], pgv.tableOnFile = false, PMaxPu = 1, PMinPu = 0, Pm0Pu = generatorSynchronous.Pm0Pu, PmRef0Pu = 0.43125, Sdb1 = true, Sdb2 = true, Uc = -10, Uo = 1, ValveOn = true, t1 = 1e-5, t2 = 1e-5, t3 = 0.1, t4 = 0.3, t5 = 5, t6 = 0.5, t7 = 1e-5) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = 0.43125) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UOelPu(k = 10) annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // Load
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.05 * generatorSynchronous.PNomAlt / 100, offset = 3.8, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.Machines.VoltageRegulators.Standard.St4b avr(
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
    Vb0Pu = 10.1622,
    VbMaxPu = 11.63,
    VmMaxPu = 99,
    VmMinPu = -99,
    VrMaxPu = 1,
    VrMinPu = -0.87,
    XlPu = 0.124) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.deltaP = 0;
  load.deltaQ = 0;

  connect(generatorSynchronous.omegaRefPu, generatorSynchronous.omegaPu);
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -40}, {80, -40}}, color = {0, 0, 127}));
  connect(PmRefPu.y, governor.PmRefPu) annotation(
    Line(points = {{119, -20}, {90, -20}, {90, -30}}, color = {0, 0, 127}));
  connect(governor.Pm1Pu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{100, -36}, {110, -36}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{-20, -50}, {-34, -50}, {-34, -28}}, color = {0, 0, 127}));
  connect(PRefPu.y, load.PRefPu) annotation(
    Line(points = {{-58, -50}, {-46, -50}, {-46, -28}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));
  connect(UsRefPu.y, avr.UsRefPu) annotation(
    Line(points = {{22, 60}, {100, 60}, {100, 20}, {118, 20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(const.y, avr.UPssPu) annotation(
    Line(points = {{101, 0}, {106, 0}, {106, 8}, {118, 8}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
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
    Line(points = {{101, 0}, {106, 0}, {106, 12}, {118, 12}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(const.y, avr.USclOelPu) annotation(
    Line(points = {{101, 0}, {106, 0}, {106, 32}, {150, 32}, {150, 26}, {142, 26}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(const.y, avr.USclUelPu) annotation(
    Line(points = {{101, 0}, {106, 0}, {106, 32}, {150, 32}, {150, 22}, {142, 22}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end GovSteam1St4b2;
