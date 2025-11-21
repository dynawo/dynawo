within Dynawo.Examples.SMIB.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model GovSteamEuSt4b "Active power variation on the load with governor GovSteamEU"
  extends Icons.Example;

  // Generator and regulations
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    DPu = 0,
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 4,
    LDPPu = 0.2,
    LQ1PPu = 0.444231,
    LQ2PPu = 0.2625,
    LdPPu = 0.15,
    LfPPu = 0.224242,
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
    RDPPu = 0.0303152,
    RQ1PPu = 0.00308618,
    RQ2PPu = 0.0234897,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.00128379,
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
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b avr(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    Ir0Pu = generatorSynchronous.IRotor0Pu,
    Kc = 0.113,
    Kg = 0,
    Ki = 0,
    Kim = 0,
    Kir = 10.75,
    Kp = 9.3,
    Kpm = 1,
    Kpr = 10.75,
    Thetap = 0,
    UOel0Pu = 10,
    Us0Pu = generatorSynchronous.UStator0Pu,
    UUel0Pu = 0,
    VaMaxPu = 1,
    VaMinPu = -0.87,
    Vb0Pu = 10.162168,
    VbMaxPu = 11.63,
    VmMaxPu = 99,
    VmMinPu = -99,
    VrMaxPu = 1,
    VrMinPu = -0.87,
    XlPu = 0.124,
    it0Pu = generatorSynchronous.i0Pu,
    tA = 0.02,
    tR = 0.02,
    ut0Pu = generatorSynchronous.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteamEu governor(
    CHcPu = -3.3,
    CHoPu = 0.17,
    CIcPu = -2.2,
    CIoPu = 0.123,
    DeltaOmegaDbPu = 0.0004,
    DeltafDbPu = 0,
    HHpMaxPu = 1,
    KE = 0.65,
    KFCor = 20,
    KHp = 0.277,
    KLp = 0.723,
    KOmegaCor = 20,
    OmegaFMaxPu = 0.05,
    OmegaFMinPu = -0.05,
    OmegaMax1Pu = 1.025,
    OmegaMax2Pu = 1.05,
    OmegaOmegaMaxPu = 0.1,
    OmegaOmegaMinPu = -1,
    PBaseMw = generatorSynchronous.PNomTurb,
    PGen0Pu = generatorSynchronous.PGen0Pu,
    PGenBaseMw = SystemBase.SnRef,
    PMaxPu = 1,
    PRhMaxPu = 1.4,
    Pm0Pu = generatorSynchronous.Pm0Pu,
    SimxPu = 0.425,
    tB = 100,
    tDp = 1e-9,
    tEn = 0.1,
    tF = 1e-9,
    tFp = 1e-9,
    tHp = 0.31,
    tIp = 2,
    tLp = 0.45,
    tOmega = 0.02,
    tP = 0.07,
    tRh = 8,
    tVHp = 0.1,
    tVLp = 0.15) annotation(
    Placement(visible = true, transformation(origin = {126, -46}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PGovernorRefPu(k = governor.PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {58, -34}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = Dynawo.Electrical.SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {76, -56}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UPssPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {100, 18}, {100, 58}, {118, 58}}, color = {0, 0, 127}));
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
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{-20, -50}, {-34, -50}, {-34, -28}}, color = {0, 0, 127}));
  connect(PRefPu.y, load.PRefPu) annotation(
    Line(points = {{-58, -50}, {-46, -50}, {-46, -28}}, color = {0, 0, 127}));
  connect(PGovernorRefPu.y, governor.PRefPu) annotation(
    Line(points = {{65, -34}, {104, -34}}, color = {0, 0, 127}));
  connect(OmegaRef.y, governor.fRefPu) annotation(
    Line(points = {{83, -56}, {96, -56}, {96, -42}, {104, -42}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(OmegaRef.y, governor.omegaRefPu) annotation(
    Line(points = {{83, -56}, {104, -56}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(governor.omegaPu, generatorSynchronous.omegaPu_out) annotation(
    Line(points = {{104, -60}, {98, -60}, {98, -66}, {44, -66}, {44, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(governor.fPu, generatorSynchronous.omegaPu_out) annotation(
    Line(points = {{104, -46}, {44, -46}, {44, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, governor.PGenPu) annotation(
    Line(points = {{38, 10}, {72, 10}, {72, -30}, {104, -30}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{150, -46}, {154, -46}, {154, -72}, {32, -72}, {32, -16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.02),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">This test case has been created to test the GovSteamEU governor model.&nbsp;</span><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">It has been derived from&nbsp;</span>Dynawo.Examples.SMIB.Standard.GovSteam1St4b2.</div><div><br></div><div><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">It represents a 500 MVA synchronous machine connected to an infinite bus through a transformer and a line, with&nbsp;</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">an active and reactive load between the transformer and the line.</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\"><br><br>A load step is introduced at t=0.1 s.</span></div><div><font face=\"DejaVu Sans Mono\"><br></font></div><div><font face=\"DejaVu Sans Mono\">Below the response of generated active power, mechanical power, voltage and frequency are shown.</font></div><div><br></div><div><font face=\"DejaVu Sans Mono\">
    <figure>PGenPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovSteamEu_PGenPu.jpg\"><br></figure><figure>PmPu:</figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovSteamEu_PmPu.jpg\">
    </figure><figure>UPu:</figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovSteamEu_UPu.jpg\">&nbsp;</figure><figure>OmegaPu:</figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovSteamEu_OmegaPu.jpg\">
    </figure><br></font></div></body></html>"));
end GovSteamEuSt4b;
