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

model GovSteam1ExcIEEEST4BPssIEEE2B1 "Voltage reference step on the synchronous machine (and its regulations) connected to a zero current bus"
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
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEST4B avr(Efd0Pu = generatorSynchronous.Efd0Pu, Ifd0Pu = generatorSynchronous.IRotor0Pu, Kc = 0.113, Kg = 0, Ki = 0, Kim = 0, Kir = 10.75, Kp = 9.3, Kpm = 1, Kpr = 10.75, Thetap = 0, UOel0Pu = 10, Ub0Pu = 9.23476, Us0Pu = generatorSynchronous.U0Pu, VbMaxPu = 11.63, VmMaxPu = 99, VmMinPu = -99, VrMaxPu = 1, VrMinPu = -0.87, XlPu = 0.124, it0Pu = generatorSynchronous.i0Pu, tA = 0.02, tR = 0.02, ut0Pu = generatorSynchronous.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PssIEEE2B pss(KOmega = 1, KOmegaRef = 0, Ks1 = 12, Ks2 = 0.2, Ks3 = 1, PGen0Pu = -generatorSynchronous.P0Pu, SNom = generatorSynchronous.SNom, Vsi1MaxPu = 2, Vsi1MinPu = -2, Vsi2MaxPu = 2, Vsi2MinPu = -2, VstMaxPu = 0.1, VstMinPu = -0.1, t1 = 0.12, t10 = 0.01, t11 = 0.01, t2 = 0.02, t3 = 0.3, t4 = 0.02, t6 = 0.01, t7 = 2, t8 = 0.2, t9 = 0.1, tw1 = 2, tw2 = 2, tw3 = 2, tw4 = 1e-5) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.GovSteam1 governor(Db1 = 0, Db2 = 0, Eps = 0, H0 = false, K = 25, K1 = 0.2, K2 = 0, K3 = 0.3, K4 = 0, K5 = 0.5, K6 = 0, K7 = 0, K8 = 0, pgv.table = [0, 0; 0.4, 0.75; 0.5, 0.91; 0.6, 0.98; 1, 1], pgv.tableOnFile = false, PMaxPu = 1, PMinPu = 0, Pm0Pu = generatorSynchronous.Pm0Pu, PmRef0Pu = generatorSynchronous.Pm0Pu, Sdb1 = true, Sdb2 = true, Uc = -10, Uo = 1, ValveOn = true, t1 = 1e-5, t2 = 1e-5, t3 = 0.1, t4 = 0.3, t5 = 5, t6 = 0.5, t7 = 1e-5) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UsRefPu(height = 0.05, offset = 1, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {21, 35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

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
  connect(pss.UPssPu, avr.UPssPu) annotation(
    Line(points = {{101, 0}, {110, 0}, {110, 12}, {118, 12}}, color = {0, 0, 127}));
  connect(UsRefPu.y, avr.UsRefPu) annotation(
    Line(points = {{21, 60}, {80, 60}, {80, 24}, {118, 24}}, color = {0, 0, 127}));
  connect(PmRefPu.y, governor.PmRefPu) annotation(
    Line(points = {{119, -20}, {90, -20}, {90, -30}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{38, 18}, {118, 18}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{38, 10}, {60, 10}, {60, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{38, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, governor.omegaPu) annotation(
    Line(points = {{38, -6}, {60, -6}, {60, -40}, {80, -40}}, color = {0, 0, 127}));
  connect(generatorSynchronous.iStatorPu_out, complexToReal.u) annotation(
    Line(points = {{12, 18}, {12, 35}, {15, 35}}, color = {85, 170, 255}));
  connect(complexToReal.re, avr.itPuRe) annotation(
    Line(points = {{27, 38}, {78, 38}, {78, 16}, {114, 16}, {114, 6}, {122, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(complexToReal.im, avr.itPuIm) annotation(
    Line(points = {{27, 32}, {76, 32}, {76, 14}, {112, 14}, {112, 5}, {126, 5}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(generatorSynchronous.uPu_out, avr.utPu) annotation(
    Line(points = {{4, 18}, {4, 28}, {74, 28}, {74, 12}, {108, 12}, {108, 2}, {130, 2}, {130, 6}}, color = {85, 170, 255}));
  connect(generatorSynchronous.IRotorPu_out, avr.IfdPu) annotation(
    Line(points = {{28, 18}, {28, 22}, {72, 22}, {72, 11}, {106, 11}, {106, 1}, {136, 1}, {136, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(governor.Pm1Pu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{100, -36}, {110, -36}, {110, -60}, {32, -60}, {32, -16}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{141, 18}, {150, 18}, {150, -80}, {8, -80}, {8, -16}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, pss.omegaRefPu) annotation(
    Line(points = {{60, 0}, {78, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})));
end GovSteam1ExcIEEEST4BPssIEEE2B1;
