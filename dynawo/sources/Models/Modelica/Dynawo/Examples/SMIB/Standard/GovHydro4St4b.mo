within Dynawo.Examples.SMIB.Standard;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

model GovHydro4St4b "Active power variation on the load with governor GovHydro4"
  extends Icons.Example;

  // Generator and regulations
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(
    DPu = 0,
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
    H = 4,
    LDPPu = 0.19063,
    LQ1PPu = 0.165,
    LQ2PPu = 1e5,
    LdPPu = 0.15,
    LfPPu = 0.237322,
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
    RDPPu = 0.0293282,
    RQ1PPu = 0.0696063,
    RQ2PPu = 0,
    RTfPu = 0,
    RaPPu = 0,
    RfPPu = 0.0013386,
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
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {156, 80}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = true) annotation(
    Placement(visible = true, transformation(origin = {156, 68}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = avr.UOel0Pu) annotation(
    Placement(visible = true, transformation(origin = {84, 66}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic.GovHydro4 governor(
    ATurb = 1.2,
    DTurb = 1.1,
    DeltaOmegaDbPu = 0,
    DeltaOmegaEpsPu = 0,
    DeltaPDbPu = 0,
    GMax = 1,
    GMin = 0,
    HDam = 1,
    ModelInt = 1,
    Pm0Pu = 3.8 * 100 / generatorSynchronous.PNomTurb,
    QNl = 0,
    RPerm = 0.05,
    RTemp = 0.3,
    UC = -0.2,
    UO = 0.2,
    tG = 0.5,
    tP = 0.1,
    tR = 5,
    tW = 1) annotation(
    Placement(visible = true, transformation(origin = {100, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant omegaRef0(k = Dynawo.Electrical.SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {55, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRef0(k = governor.PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {55, -20}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UPssPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Load
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, i0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false)), u0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.05 * generatorSynchronous.PNomAlt / 100, offset = 3.8, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

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

  connect(generatorSynchronous.omegaPu, generatorSynchronous.omegaRefPu);
  connect(const.y, avr.UUelPu) annotation(
    Line(points = {{152, 80}, {110, 80}, {110, 54}, {118, 54}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UPssPu.y, avr.UPssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 50}, {118, 50}}, color = {0, 0, 127}));
  connect(UsRefPu.y, avr.UsRefPu) annotation(
    Line(points = {{61, 50}, {94, 50}, {94, 62}, {118, 62}}, color = {0, 0, 127}));
  connect(const1.y, avr.UOelPu) annotation(
    Line(points = {{88, 66}, {118, 66}}, color = {0, 0, 127}));
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-40, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{-20, -50}, {-34, -50}, {-34, -28}}, color = {0, 0, 127}));
  connect(PRefPu.y, load.PRefPu) annotation(
    Line(points = {{-58, -50}, {-46, -50}, {-46, -28}}, color = {0, 0, 127}));
  connect(PRef0.y, governor.PRefPu) annotation(
    Line(points = {{61, -20}, {70, -20}, {70, -28}, {77, -28}}, color = {0, 0, 127}));
  connect(omegaRef0.y, governor.omegaRefPu) annotation(
    Line(points = {{61, -40}, {77, -40}}, color = {0, 0, 127}));
  connect(governor.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{124, -40}, {140, -40}, {140, -80}, {32, -80}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{142, 60}, {160, 60}, {160, -100}, {8, -100}, {8, -16}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, avr.IrPu) annotation(
    Line(points = {{28, 18}, {28, 80}, {100, 80}, {100, 70}, {118, 70}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {100, 18}, {100, 58}, {118, 58}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {46, -6}, {46, -52}, {76, -52}}, color = {0, 0, 127}));
  connect(generatorSynchronous.uPu_out, avr.utPu) annotation(
    Line(points = {{4, 18}, {4, 30}, {152, 30}, {152, 53}, {142, 53}, {142, 52}}, color = {85, 170, 255}));
  connect(generatorSynchronous.iStatorPu_out, avr.itPu) annotation(
    Line(points = {{12, 18}, {12, 26}, {156, 26}, {156, 56}, {142, 56}}, color = {85, 170, 255}));
  connect(booleanConstant.y, avr.running) annotation(
    Line(points = {{152, 68}, {142, 68}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 50, Tolerance = 1e-06, Interval = 0.05),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case tests the governor GovHydro4 in combination with a synchronous generator three windings and the AVR St4b.&nbsp;</span><div><span style=\"font-size: 12px;\">An active load step of 0.05 pu is applied at t=0.1s.&nbsp;</span><div><br></div><div><span style=\"font-size: 12px;\"><div><br></div><div><figure>
    PGenPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovHydro4_PGen.png\">
    </figure>
    <figure>
    PmPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovHydro4_Pm.png\">
    </figure> <figure>UPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovHydro4_U.png\">
    </figure></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></span></div></div></body></html>"));
end GovHydro4St4b;
