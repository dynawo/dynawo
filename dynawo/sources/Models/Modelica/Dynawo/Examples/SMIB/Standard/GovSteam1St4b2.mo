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
    P0Pu = -3.8,
    PNomAlt = 475,
    PNomTurb = 475,
    Q0Pu = 0,
    RDPPu = 0.02933,
    RQ1PPu = 0.0035,
    RQ2PPu = 0.02227,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.00128,
    SNom = 500,
    SnTfo = 500,
    U0Pu = 1,
    UBaseHV = 400,
    UBaseLV = 21,
    UNom = 21,
    UNomHV = 400,
    UNomLV = 21,
    UPhase0 = 0,
    XTfPu = 0,
    md = 0,
    mq = 0,
    nd = 0,
    nq = 0) annotation(
    Placement(visible = true, transformation(origin = {20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteam1 governor(
    Db1 = 0,
    Db2 = 0,
    Eps = 0,
    H0 = false,
    K = 25,
    K1 = 0.2,
    K2 = 0,
    K3 = 0.3,
    K4 = 0,
    K5 = 0.5,
    K6 = 0,
    K7 = 0,
    K8 = 0,
    pgv.table = [0, 0; 0.4, 0.75; 0.5, 0.91; 0.6, 0.98; 1, 1],
    pgv.tableOnFile = false,
    PgvTableName = "NoName",
    PMaxPu = 1,
    PMinPu = 0,
    Pm0Pu = generatorSynchronous.Pm0Pu,
    PmRef0Pu = 0.43125,
    Sdb1 = true,
    Sdb2 = true,
    TablesFile = "NoFile",
    Uc = -10,
    Uo = 1,
    ValveOn = true,
    t1 = 1e-5,
    t2 = 1e-5,
    t3 = 0.1,
    t4 = 0.3,
    t5 = 5,
    t6 = 0.5,
    t7 = 1e-5) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    UOel0Pu = 10,
    Us0Pu = generatorSynchronous.U0Pu,
    ut0Pu = generatorSynchronous.u0Pu,
    UUel0Pu = 0,
    VaMaxPu = 1,
    VaMinPu = -0.87,
    Vb0Pu = 10.162168,
    VbMaxPu = 11.63,
    VmMaxPu = 99,
    VmMinPu = -99,
    VrMaxPu = 1,
    VrMinPu = -0.87,
    XlPu = 0.124) annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UPssPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = 0.43125) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {156, 80}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = avr.UOel0Pu) annotation(
    Placement(visible = true, transformation(origin = {84, 66}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

  // Load
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, i0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.05 * generatorSynchronous.PNomAlt / 100, offset = 3.8, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initialization
  Dynawo.Electrical.Loads.Load_INIT load_INIT(P0Pu = PRefPu.offset, Q0Pu = QRefPu.k, U0Pu = generatorSynchronous.U0Pu, UPhase0 = generatorSynchronous.UPhase0) annotation(
    Placement(transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}})));

initial algorithm
  load.i0Pu.re := load_INIT.i0Pu.re;
  load.i0Pu.im := load_INIT.i0Pu.im;
  load.s0Pu.re := load_INIT.s0Pu.re;
  load.s0Pu.im := load_INIT.s0Pu.im;
  load.u0Pu.re := load_INIT.u0Pu.re;
  load.u0Pu.im := load_INIT.u0Pu.im;

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.deltaP = 0;
  load.deltaQ = 0;
  avr.running = generatorSynchronous.running.value;

  connect(generatorSynchronous.omegaPu, generatorSynchronous.omegaRefPu);
  connect(const.y, avr.UUelPu) annotation(
    Line(points = {{152, 80}, {110, 80}, {110, 54}, {118, 54}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UPssPu.y, avr.UPssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 50}, {118, 50}}, color = {0, 0, 127}));
  connect(UsRefPu.y, avr.UsRefPu) annotation(
    Line(points = {{61, 50}, {94, 50}, {94, 62}, {118, 62}}, color = {0, 0, 127}));
  connect(PmRefPu.y, governor.PmRefPu) annotation(
    Line(points = {{119, -20}, {90, -20}, {90, -30}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {100, 18}, {100, 58}, {118, 58}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -40}, {80, -40}}, color = {0, 0, 127}));
  connect(generatorSynchronous.uPu_out, avr.utPu) annotation(
    Line(points = {{4, 18}, {4, 30}, {152, 30}, {152, 53}, {142, 53}, {142, 52}}, color = {85, 170, 255}));
  connect(generatorSynchronous.iStatorPu_out, avr.itPu) annotation(
    Line(points = {{12, 18}, {12, 26}, {156, 26}, {156, 56}, {142, 56}}, color = {85, 170, 255}));
  connect(generatorSynchronous.IRotorPu_out, avr.IrPu) annotation(
    Line(points = {{28, 18}, {28, 80}, {100, 80}, {100, 70}, {118, 70}}, color = {0, 0, 127}));
  connect(const1.y, avr.UOelPu) annotation(
    Line(points = {{88, 66}, {118, 66}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 60}, {160, 60}, {160, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));
  connect(governor.Pm1Pu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{100, -36}, {110, -36}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{-20, -50}, {-34, -50}, {-34, -28}}, color = {0, 0, 127}));
  connect(PRefPu.y, load.PRefPu) annotation(
    Line(points = {{-58, -50}, {-46, -50}, {-46, -28}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 15, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end GovSteam1St4b2;
