within Dynawo.Examples.GridForming;

model GridForming_test_4_v2_Syncr_v2 "Grid Forming converters test case"
  /*
                  * Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
                  * See AUTHORS.txt
                  * All rights reserved.
                  * This Source Code Form is subject to the terms of the Mozilla Public
                  * License, v. 2.0. If a copy of the MPL was not distributed with this
                  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
                  * SPDX-License-Identifier: MPL-2.0
                  *
                  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
                  */
  extends Icons.Example;
  import Modelica.Constants.pi;
  //Parameters for the Tunning of the Current Loop
  parameter Real EpsilonCurrent = 0.7;
  parameter Real Gffc = 1;
  //Sensitivity to the voltage at the capacitor of the Filter
  final parameter Real TrCurrent = 10 * TrVSC;
  //Time response of the current loop
  // final parameter Real Wnc=1/TrCurrent;//Bandwidth of the current loop
  final parameter Real Wnc = 4 / (EpsilonCurrent * TrCurrent);
  //Bandwidth of the current loop
  //final parameter Real Kpc = 2 * EpsilonCurrent * LFilter * Wnc / Wn - RFilter;
  // final parameter Real Kic = Kpc * Wnc / (2 * EpsilonCurrent - RFilter * Wn / (LFilter * Wnc));
  //final parameter Real Kic=0;
  //final parameter Real Kpc=0.73;
  final parameter Real Kpc = 2 * EpsilonCurrent * Kic / Wnc - RFilter;
  final parameter Real Kic = LFilter * Wnc * Wnc / Wn;
  //System parameters
  parameter Real Wn = 2 * pi * 50;
  //System angular frequency
  parameter Real fNom = 50;
  //system AC frequency
  //Power calculation at the PCC point
  parameter Real SNom = SystemBase.SnRef;
  //Nominal apparent power module for the converter
  //Parameters of the Filter
  parameter Real LFilter = 0.15;
  parameter Real RFilter = 0.005;
  parameter Real CFilter = 0.066;
  //Parameters of the Transformer
  parameter Real LTransformer = 0.15;
  parameter Real RTransformer = 0.005;
  //Parameters of the Line grid connection
  parameter Real LConnection = 0.5;
  parameter Real RConnection = 0.005;
  // Parameter of the VSC
  parameter Real Fsw = 5000;
  //Switching frequency of the VSC
  final parameter Real Wvsc = 2 * Fsw;
  //Bandwidth of the VSC
  final parameter Real TrVSC = 1 / Wvsc;
  //Time response of the VSC
  parameter Types.ActivePowerPu PRefLoadPu = 1 "Active power request for the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  //Parameters for the Tunning of the Voltage Loop
  parameter Real EpsilonVoltage = 0.7;
  parameter Real Gffv = 1;
  //Sensitivity to the voltage at the capacitor of the Filter
  final parameter Real TrVoltage = 50 * TrCurrent;
  //Time response of the voltage loop
  final parameter Real Wnv = 4 / (EpsilonVoltage * TrVoltage);
  //Bandwidth of the current loop
  //final parameter Real Wnv=1/TrVoltage;//Bandwidth of the voltage loop
  // final parameter Real Kpv=2*EpsilonVoltage*CFilter*Wnv/Wn;
  //final parameter Real Kiv=Kpv*Wnv/(2*EpsilonVoltage);
  final parameter Real Kiv = Wnv * Wnv * CFilter / Wn;
  final parameter Real Kpv = 2 * EpsilonVoltage * Kiv / Wnv;
  // final parameter Real Kpv=0.03;
  // final parameter Real Kiv=2.1;
  //Parameters of the Power synchronisation block to find the frequency of the Grid
  parameter Real Mp = 0.05;
  //Guillaume thesis 0.01Wn .. 0.1Wn
  parameter Real WLP = Wn / 5;
  // Guillaume Thesis
  parameter Boolean Wref_FromPLL = false;
  parameter Real WPLL = 1000;
  parameter Real PLL_W_start = 1;
  //Filtre at the input of the pll
  //Parameters of the Virtual Impedance Block
  parameter Real Rv = 0.09;
  //Gain of the active damping
  parameter Real Wff = 60 "Cutoff pulsation of the active and reactive filters (in rad/s)";
  //Reactive Power block
  parameter Real Mq = 0 "0.05 Reactive power droop control coefficient";
  parameter Real Wf = Wn / 10 "Cutoff pulsation of the reactive filter (in rad/s)";
  Dynawo.Electrical.Lines.Line Line23(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {13713.5, -944.5}, extent = {{-255.5, -255.5}, {255.5, 255.5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanStep Disconnection(startValue = false, startTime = 0.5);
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {16329, -832}, extent = {{-172, -172}, {172, 172}}, rotation = 90)));
  Dynawo.Examples.GridForming.MeasurementPcc measurementPcc(SNom = 1000) annotation(
    Placement(visible = true, transformation(origin = {13103, -197}, extent = {{-455, -455}, {455, 455}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(KiPLL = 795, KpPLL = 3) annotation(
    Placement(visible = true, transformation(origin = {-1815.5, 2936.5}, extent = {{-362.5, -362.5}, {362.5, 362.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step omegaRefPu(height = SystemBase.omegaRef0Pu, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-3147.5, 2359.5}, extent = {{-156.5, -156.5}, {156.5, 156.5}}, rotation = 0)));
  Dynawo.Examples.GridForming.Gridconnection gridconnection(LTransformer = 0.15, RTransformer = 0.005) annotation(
    Placement(visible = true, transformation(origin = {10808, -280}, extent = {{-434, -434}, {434, 434}}, rotation = 0)));
  Dynawo.Examples.GridForming.Converter_v2 converter_v2(CFilter = CFilter, LFilter = LFilter, RFilter = RFilter, TrVSC = TrVSC) annotation(
    Placement(visible = true, transformation(origin = {8240.94, -550.1}, extent = {{-420.056, -756.1}, {420.056, 756.1}}, rotation = 0)));
  Dynawo.Examples.GridForming.CurrentFilterLoop currentFilterLoop(EpsilonCurrent = 0.7, Fsw = Fsw, Gffc = Gffc, Kic = Kic, Kpc = Kpc, Lf = LFilter, Rf = RFilter) annotation(
    Placement(visible = true, transformation(origin = {5196.42, -557.899}, extent = {{-657.418, -788.899}, {657.418, 788.899}}, rotation = 0)));
  Dynawo.Examples.GridForming.VoltageFiltreControl voltageFiltreControl(Cf = CFilter, Gffv = Gffv, Kiv = Kiv, Kpv = Kpv, Wn = 314) annotation(
    Placement(visible = true, transformation(origin = {-1806.72, -433.9}, extent = {{-427.723, -769.9}, {427.723, 769.9}}, rotation = 0)));
  Dynawo.Examples.GridForming.VoltagePOI voltagePOI(Mq = Mq, Rv = Rv, Wf = Wf, Wff = Wff) annotation(
    Placement(visible = true, transformation(origin = {-4413, -427.2}, extent = {{-377, -678.6}, {377, 678.6}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0.2, offset = 0.8, startTime = 3) annotation(
    Placement(visible = true, transformation(origin = {-6271, 642}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 1, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-6269, 185}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
  Dynawo.Examples.GridForming.synchronisation synchronisation(Mp = Mp, WLP = WLP, WPLL = WPLL, Wref_FromPLL = true, PLL_W_start = PLL_W_start) annotation(
    Placement(visible = true, transformation(origin = {500, 1730}, extent = {{-417, -417}, {417, 417}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step3(height = 1, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-1449, 1544}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step4(height = 0.7, offset = 0.3, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-1471, 2083}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
  Dynawo.Examples.GridForming.VI vi annotation(
    Placement(visible = true, transformation(origin = {-6557.56, -1652.9}, extent = {{-529.556, -476.6}, {529.556, 476.6}}, rotation = 0)));
  Dynawo.Examples.GridForming.CurrentSaturation currentSaturation(Imax = 1.5, Imin = 0) annotation(
    Placement(visible = true, transformation(origin = {1421.5, -445.5}, extent = {{-827.5, -827.5}, {827.5, 827.5}}, rotation = 0)));
equation
  Line23.switchOffSignal1.value = false;
  Line23.switchOffSignal2.value = false;
//  connect(PrefPu.y, synchronisation.PRefPu) annotation(
//    Line(points = {{-473, -1.5}, {-423.875, -1.5}, {-423.875, -3.5}, {-420.75, -3.5}, {-420.75, 86}, {-321, 86}}, color = {0, 0, 127}));
//  connect(UFilter.y, VoltagePOI.QRefPu) annotation(
//    Line(points = {{-354, 238}, {-274, 238}}, color = {0, 0, 127}));
//  connect(QRefpu.y, VoltagePOI.UFilterRefPu) annotation(
//    Line(points = {{-355, 198}, {-311, 198}, {-311, 226}, {-274, 226}}, color = {0, 0, 127}));
//  connect(DeltaVVI.y, VoltagePOI.DeltaVVId) annotation(
//    Line(points = {{-259, 174}, {-239, 174}, {-239, 196}}, color = {0, 0, 127}));
//  connect(DeltaVVI.y, VoltagePOI.DeltaVVIq) annotation(
//    Line(points = {{-259, 174}, {-228, 174}, {-228, 196}}, color = {0, 0, 127}));
  connect(Line23.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{13969, -944.5}, {16329, -944.5}, {16329, -832}}, color = {0, 0, 255}));
  connect(measurementPcc.terminal, Line23.terminal1) annotation(
    Line(points = {{12784.5, -672}, {12784.5, -944.73}, {13458, -944.73}}, color = {0, 0, 255}));
  connect(step.y, voltagePOI.UFilterRefPu) annotation(
    Line(points = {{-6133.5, 642}, {-5716, 642}, {-5716, 101}, {-4828, 101}}, color = {0, 0, 127}));
  connect(step1.y, voltagePOI.QRefPu) annotation(
    Line(points = {{-6131.5, 185}, {-5955, 185}, {-5955, -58}, {-4828, -58}}, color = {0, 0, 127}));
  connect(voltagePOI.udFilterRefPu, voltageFiltreControl.udFilterRefPu) annotation(
    Line(points = {{-3998, -299}, {-3456, -299}, {-3456, 182}, {-2269, 182}}, color = {0, 0, 127}));
  connect(voltagePOI.uqFilterRefPu, voltageFiltreControl.uqFilterRefPu) annotation(
    Line(points = {{-3998, -499}, {-3356, -499}, {-3356, 15}, {-2273, 15}}, color = {0, 0, 127}));
  connect(currentFilterLoop.udConvRefPu, converter_v2.udConvRefPu) annotation(
    Line(points = {{5898, -41}, {7779, -41}, {7779, -46}}, color = {0, 0, 127}));
  connect(currentFilterLoop.uqConvRefPu, converter_v2.uqConvRefPu) annotation(
    Line(points = {{5898, -768}, {7039, -768}, {7039, -298}, {7779, -298}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-2975, 2359.5}, {-2703, 2359.5}, {-2703, 2719}, {-2214, 2719}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, synchronisation.omegaPLLSetPu) annotation(
    Line(points = {{-1417, 3118}, {500, 3118}, {500, 2189}}, color = {0, 0, 127}));
  connect(synchronisation.omegaPu, voltageFiltreControl.omegaPu) annotation(
    Line(points = {{959, 1492}, {1329, 1492}, {1329, 710}, {-1807, 710}, {-1807, 379}}, color = {0, 0, 127}));
  connect(synchronisation.omegaPu, currentFilterLoop.omegaPu) annotation(
    Line(points = {{959, 1492}, {1336, 1492}, {1336, 717}, {5196, 717}, {5196, 275}}, color = {0, 0, 127}));
  connect(currentFilterLoop.omegaPu, converter_v2.omegaPu) annotation(
    Line(points = {{5196, 275}, {5255, 275}, {5255, 717}, {8241, 717}, {8241, 248}}, color = {0, 0, 127}));
  connect(converter_v2.omegaPu, gridconnection.omegaPu) annotation(
    Line(points = {{8241, 248}, {8305, 248}, {8305, 695}, {10808, 695}, {10808, 178}}, color = {0, 0, 127}));
  connect(synchronisation.theta, measurementPcc.theta) annotation(
    Line(points = {{959, 1939}, {13103, 1939}, {13103, 288}}, color = {0, 0, 127}));
  connect(converter_v2.udFilterPu, gridconnection.udFilterPu) annotation(
    Line(points = {{8703, -508}, {9521, -508}, {9521, -521}, {10331, -521}}, color = {0, 0, 127}));
  connect(converter_v2.uqFilterPu, gridconnection.uqFilterPu) annotation(
    Line(points = {{8703, -676}, {9604, -676}, {9604, -618}, {10331, -618}}, color = {0, 0, 127}));
  connect(measurementPcc.udPccPu, gridconnection.udPccPu) annotation(
    Line(points = {{13603.5, 0}, {14300, 0}, {14300, -1336}, {9732, -1336}, {9732, 77}, {10331, 77}}, color = {0, 0, 127}));
  connect(measurementPcc.uqPccPu, gridconnection.uqPccPu) annotation(
    Line(points = {{13603.5, -101}, {14240, -101}, {14240, -1450}, {9785, -1450}, {9785, -5}, {10331, -5}}, color = {0, 0, 127}));
  connect(gridconnection.idPccPu, measurementPcc.idPccPu) annotation(
    Line(points = {{11285, -169}, {12602.5, -169}, {12602.5, -172}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, measurementPcc.iqPccPu) annotation(
    Line(points = {{11285, -314}, {12602.5, -314}, {12602.5, -308}}, color = {0, 0, 127}));
  connect(converter_v2.idConvPu, currentFilterLoop.idConvPu) annotation(
    Line(points = {{8703, 80}, {9226, 80}, {9226, -1759}, {3737, -1759}, {3737, -89}, {4491, -89}}, color = {0, 0, 127}));
  connect(converter_v2.iqConvPu, currentFilterLoop.iqConvPu) annotation(
    Line(points = {{8703, -138}, {9272, -138}, {9272, -1865}, {3805, -1865}, {3805, -917}, {4495, -917}}, color = {0, 0, 127}));
  connect(converter_v2.udFilterPu, currentFilterLoop.udFilterPu) annotation(
    Line(points = {{8703, -508}, {9407, -508}, {9407, -2122}, {3541, -2122}, {3541, -383}, {4495, -383}}, color = {0, 0, 127}));
  connect(converter_v2.uqFilterPu, currentFilterLoop.uqFilterPu) annotation(
    Line(points = {{8703, -676}, {9491, -676}, {9491, -2273}, {3420, -2273}, {3420, -1198}, {4495, -1198}}, color = {0, 0, 127}));
  connect(currentFilterLoop.udFilterPu, voltageFiltreControl.udFilterPu) annotation(
    Line(points = {{4495, -383}, {3458, -383}, {3458, -2106}, {-2869, -2106}, {-2869, -249}, {-2277, -249}, {-2277, -263}}, color = {0, 0, 127}));
  connect(currentFilterLoop.uqFilterPu, voltageFiltreControl.uqFilterPu) annotation(
    Line(points = {{4495, -1198}, {3299, -1198}, {3299, -2265}, {-2990, -2265}, {-2990, -460}, {-2277, -460}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, converter_v2.idPccPu) annotation(
    Line(points = {{11285, -314}, {11574, -314}, {11574, -1578}, {7384, -1578}, {7384, -634}, {7779, -634}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, converter_v2.iqPccPu) annotation(
    Line(points = {{11285, -314}, {11657, -314}, {11657, -1646}, {7512, -1646}, {7512, -869}, {7779, -869}}, color = {0, 0, 127}));
  connect(converter_v2.idPccPu, voltageFiltreControl.idPccPu) annotation(
    Line(points = {{7779, -634}, {7369, -634}, {7369, -1872}, {-2778, -1872}, {-2778, -862}, {-2277, -862}}, color = {0, 0, 127}));
  connect(converter_v2.iqPccPu, voltageFiltreControl.iqPccPu) annotation(
    Line(points = {{7779, -869}, {7573, -869}, {7573, -1955}, {-2680, -1955}, {-2680, -1033}, {-2277, -1033}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.idPccPu, voltagePOI.idPccPu) annotation(
    Line(points = {{-2277, -862}, {-2786, -862}, {-2786, -1872}, {-5315, -1872}, {-5315, -503}, {-4828, -503}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.iqPccPu, voltagePOI.iqPccPu) annotation(
    Line(points = {{-2277, -1033}, {-2673, -1033}, {-2673, -1955}, {-5225, -1955}, {-5225, -653}, {-4828, -653}}, color = {0, 0, 127}));
  connect(converter_v2.idConvPu, vi.idConvPu) annotation(
    Line(points = {{8703, 80}, {9234, 80}, {9234, -2325}, {-7671, -2325}, {-7671, -1653}, {-7151, -1653}}, color = {0, 0, 127}));
  connect(converter_v2.iqConvPu, vi.iqConvPu) annotation(
    Line(points = {{8703, -138}, {9302, -138}, {9302, -2378}, {-7565, -2378}, {-7565, -1881}, {-7145, -1881}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.omegaPu, vi.omegaPu) annotation(
    Line(points = {{-1807, 379}, {-1812, 379}, {-1812, 1004}, {-6908, 1004}, {-6908, -1123}, {-6558, -1123}}, color = {0, 0, 127}));
  connect(step4.y, synchronisation.PRefPu) annotation(
    Line(points = {{-1333, 2083}, {-876, 2083}, {-876, 1980}, {41, 1980}}, color = {0, 0, 127}));
  connect(step3.y, synchronisation.omegaRefPu) annotation(
    Line(points = {{-1311, 1544}, {-1012, 1544}, {-1012, 1438}, {41, 1438}}, color = {0, 0, 127}));
  connect(measurementPcc.PGenPu, synchronisation.PFilterPu) annotation(
    Line(points = {{13603.5, -399}, {14677, -399}, {14677, 793}, {-559, 793}, {-559, 1697}, {41, 1697}}, color = {0, 0, 127}));
  connect(measurementPcc.QGenPu, voltagePOI.QFilterPu) annotation(
    Line(points = {{13603.5, -531}, {14655, -531}, {14655, -2688}, {-8086, -2688}, {-8086, -254}, {-4828, -254}}, color = {0, 0, 127}));
  connect(vi.DeltaVVId, voltagePOI.DeltaVVId) annotation(
    Line(points = {{-5975, -1388}, {-5653, -1388}, {-5653, -925}, {-4828, -925}}, color = {0, 0, 127}));
  connect(vi.DeltaVVIq, voltagePOI.DeltaVVIq) annotation(
    Line(points = {{-5975, -1791}, {-5062, -1791}, {-5062, -1061}, {-4828, -1061}}, color = {0, 0, 127}));
  connect(currentSaturation.idConvRefPu, currentFilterLoop.idConvRefPu) annotation(
    Line(points = {{2332, -114.5}, {3402, -114.5}, {3402, 100}, {4495, 100}}, color = {0, 0, 127}));
  connect(currentSaturation.iqConvRefPu, currentFilterLoop.iqConvRefPu) annotation(
    Line(points = {{2332, -611}, {3810, -611}, {3810, -681}, {4495, -681}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.idConvRefPu, currentSaturation.idConvFiltre) annotation(
    Line(points = {{-1336, -211}, {511, -211}, {511, -148}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.iqConvRefPu, currentSaturation.iqConvFiltre) annotation(
    Line(points = {{-1336, -528}, {511, -528}, {511, -462}}, color = {0, 0, 127}));
  connect(measurementPcc.uPu, pll.uPu) annotation(
    Line(points = {{13503, -677}, {13413, -677}, {13413, -829}, {11852, -829}, {11852, 3578}, {-2738, 3578}, {-2738, 3154}, {-2214, 3154}}, color = {85, 170, 255}));
protected
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case consists in three different grid-forming converters (one with a droop control, one with a dispatchable virtual oscillator control and one with a matching control) connected to a load. At t = 0.5 s the line connecting the 250 MVA (droop) and the 1000 MVA (matching) converters is opened. At t = 1.5 s, a short-circuit occurs in the middle of one of the lines connecting the 250 MVA (droop) and the 500 MVA (dVOC) converters. It is cleared after 150ms. This test case and the grid-forming converters controls come from the Horizon 2020 European project MIGRATE, and more precisely from its Deliverables 3.2 and 3.3 that can be found on the project website : https://www.h2020-migrate.eu/downloads.html.
    </div><div><br></div><div>The two following figures show the expected evolution of the frequency and the current for each converter during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/frequency.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/GridForming/Resources/Images/current.png\">
    </figure>
    One can remark that after the events, the frequencies of the three converters are equal and close to their value before the events, thanks to the power-sharing allowed by the outer loop controls (droop, matching and dVOC).</div><div><br></div><div> One can also remark that during the fault, the currents of the three converters are limited at a value lower than 1.2 pu thanks to the virtual impedance. More details can be found in the MIGRATE project deliverables.</div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>"),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-8090, 3830}, {16520, -2700}})));
end GridForming_test_4_v2_Syncr_v2;