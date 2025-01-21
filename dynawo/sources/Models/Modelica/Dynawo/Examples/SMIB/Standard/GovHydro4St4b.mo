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

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.St4b avr(Efd0Pu = generatorSynchronous.Efd0Pu, Ir0Pu = generatorSynchronous.IRotor0Pu, it0Pu = generatorSynchronous.i0Pu, Kc = 0.113, Kg = 0, Ki = 0, Kim = 0, Kir = 10.75, Kp = 9.3, Kpm = 1, Kpr = 10.75, tA = 0.02, Thetap = 0, tR = 0.02, UOel0Pu = 10, Us0Pu = generatorSynchronous.U0Pu, ut0Pu = generatorSynchronous.u0Pu, VaMaxPu = 1, VaMinPu = -0.87, Vb0Pu = 10.162168, VbMaxPu = 11.63, VmMaxPu = 99, VmMinPu = -99, VrMaxPu = 1, VrMinPu = -0.87, XlPu = 0.124) annotation(
    Placement(visible = true, transformation(origin = {130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {156, 80}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = avr.UOel0Pu) annotation(
    Placement(visible = true, transformation(origin = {84, 66}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Dynawo.Examples.BaseClasses.GeneratorSynchronousThreeWindingsInterfaces generatorSynchronous(DPu = 0, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad, H = 4, P0Pu = -3.8, PNomAlt = 475, PNomTurb = 475, Q0Pu = 0, RTfPu = 0, RaPu = 0, SNom = 500, SnTfo = 500, Tpd0 = 5.143, Tppd0 = 0.042, Tppq0 = 0.083, Tpq0 = 2.16, U0Pu = 1, UBaseHV = 400, UBaseLV = 21, UNom = 21, UNomHV = 400, UNomLV = 21, UPhase0 = 0, XTfPu = 0, XdPu = 2, XlPu = 0.15, XpdPu = 0.35, XppdPu = 0.25, XppqPu = 0.3, XpqPu = 0.5, XqPu = 1.8, md = 0, mq = 0, nd = 0, nq = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic.GovHydro4 governor(ATurb = 1.2, DTurb = 1.1, DeltaOmegaDbPu = 0, DeltaOmegaEpsPu = 0, DeltaPDbPu = 0, GMax = 1, GMin = 0, HDam = 1, ModelInt = 1, Pm0Pu = 3.8 * 100 / generatorSynchronous.PNomTurb, QNl = 0, RPerm = 0.05, RTemp = 0.3, UC = -0.2, UO = 0.2, tG = 0.5, tP = 0.1, tR = 5, tW = 1) annotation(
    Placement(visible = true, transformation(origin = {100, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta load(alpha = 2, beta = 2, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRef0(k = Dynawo.Electrical.SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {55, -41}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRef0(k = governor.PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {55, -21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.05 * generatorSynchronous.PNomAlt / 100, offset = 3.8, startTime = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UPssPu(k = 0) annotation(
    Placement(visible = true, transformation(origin = {90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    Line(points = {{101, 30}, {110, 30}, {110, 50}, {118, 50}}, color = {0, 0, 127}));
  connect(UsRefPu.y, avr.UsRefPu) annotation(
    Line(points = {{61, 50}, {94, 50}, {94, 62}, {118, 62}}, color = {0, 0, 127}));
  connect(const1.y, avr.UOelPu) annotation(
    Line(points = {{88, 66}, {118, 66}}, color = {0, 0, 127}));
  connect(load.terminal, generatorSynchronous.terminal) annotation(
    Line(points = {{-40, -20}, {-33, -20}, {-33, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(QRefPu.y, load.QRefPu) annotation(
    Line(points = {{-20, -50}, {-34, -50}, {-34, -28}}, color = {0, 0, 127}));
  connect(PRefPu.y, load.PRefPu) annotation(
    Line(points = {{-58, -50}, {-46, -50}, {-46, -28}}, color = {0, 0, 127}));
  connect(PRef0.y, governor.PRefPu) annotation(
    Line(points = {{60.5, -21}, {68.75, -21}, {68.75, -27}, {77, -27}}, color = {0, 0, 127}));
  connect(omegaRef0.y, governor.omegaRefPu) annotation(
    Line(points = {{60.5, -41}, {73.75, -41}, {73.75, -40}, {77, -40}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PmPu_in, governor.PmPu) annotation(
    Line(points = {{16, 0}, {-20, 0}, {-20, -32}, {40, -32}, {40, -80}, {140, -80}, {140, -40}, {124, -40}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{142, 60}, {152, 60}, {152, 0}, {-16, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, avr.IrPu) annotation(
    Line(points = {{-18, -10}, {-32, -10}, {-32, 80}, {101, 80}, {101, 70}, {118, 70}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu_out, avr.UsPu) annotation(
    Line(points = {{-6, 18}, {-6, 30}, {76, 30}, {76, 48}, {104, 48}, {104, 58}, {118, 58}}, color = {0, 0, 127}));
  connect(governor.omegaPu, generatorSynchronous.omegaPu_out) annotation(
    Line(points = {{76, -52}, {20, -52}, {20, -26}, {0, -26}, {0, -18}}, color = {0, 0, 127}));
  connect(generatorSynchronous.uPu_out, avr.utPu) annotation(
    Line(points = {{18, 14}, {144, 14}, {144, 52}, {142, 52}}, color = {85, 170, 255}));
  connect(avr.itPu, generatorSynchronous.iStatorPu_out) annotation(
    Line(points = {{142, 56}, {148, 56}, {148, 10}, {18, 10}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 50, Tolerance = 1e-06, Interval = 0.05),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case tests the governor GovHydro4 in combination with a synchrounours generator three windings and the AVR St4b.&nbsp;</span><div><span style=\"font-size: 12px;\">An active load step of 0.05 pu is applied at t=0.1s.&nbsp;</span><div><br></div><div><span style=\"font-size: 12px;\"><div><br></div><div><figure>
    PGenPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovHydro4_PGen.png\">
    </figure>
    <figure>
    PmPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovHydro4_Pm.png\">
    </figure> <figure>UPu:</figure><figure><img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/GovHydro4_U.png\">
    </figure></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></span></div></div></body></html>"));
end GovHydro4St4b;
