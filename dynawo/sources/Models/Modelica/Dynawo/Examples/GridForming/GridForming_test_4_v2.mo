within Dynawo.Examples.GridForming;

model GridForming_test_4_v2 "Grid Forming converters test case"
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
  
    parameter Real Mp=0.05; //Guillaume thesis 0.01Wn .. 0.1Wn
    parameter Real WLP=Wn/5;   // Guillaume Thesis
    parameter Boolean Wref_FromPLL=false;
    parameter Real WPLL=1000; //Filtre at the input of the pll
    
    
    
  //Parameters of the Virtual Impedance Block
  parameter Real Rv=0.09; //Gain of the active damping
  parameter Real Wff=60 "Cutoff pulsation of the active and reactive filters (in rad/s)";
  
  //Reactive Power block
  parameter Real Mq =0.2 "0.05 Reactive power droop control coefficient";
  parameter Real Wf=Wn/10 "Cutoff pulsation of the reactive filter (in rad/s)";
  
  Dynawo.Electrical.Lines.Line Line23(BPu = 0.00003, GPu = 0, RPu = 0.005, XPu = 0.5) annotation(
    Placement(visible = true, transformation(origin = {159, 384}, extent = {{-58, -58}, {58, 58}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanStep Disconnection(startValue = false, startTime = 0.5);
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-28.5, 383.5}, extent = {{-33.5, -33.5}, {33.5, 33.5}}, rotation = 90)));
  Dynawo.Examples.GridForming.MeasurementPcc measurementPcc(SNom = 1000) annotation(
    Placement(visible = true, transformation(origin = {411.5, 491.5}, extent = {{-74.5, -74.5}, {74.5, 74.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(KiPLL = 795, KpPLL = 3) annotation(
    Placement(visible = true, transformation(origin = {243, -62}, extent = {{-49, -49}, {49, 49}}, rotation = 0)));
  Modelica.Blocks.Sources.Step omegaRefPu(height = SystemBase.omegaRef0Pu, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-123, -84}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
  Dynawo.Examples.GridForming.Gridconnection gridconnection(LTransformer = 0.15, RTransformer = 0.005) annotation(
    Placement(visible = true, transformation(origin = {671.5, 230.5}, extent = {{-73.5, -73.5}, {73.5, 73.5}}, rotation = 0)));
  Dynawo.Examples.GridForming.Converter_v2 converter_v2(CFilter = CFilter, LFilter = LFilter, RFilter = RFilter, TrVSC = TrVSC) annotation(
    Placement(visible = true, transformation(origin = {-305, 174}, extent = {{-80, -144}, {80, 144}}, rotation = 0)));
  Dynawo.Examples.GridForming.CurrentFilterLoop currentFilterLoop(EpsilonCurrent = 0.7, Fsw = Fsw, Gffc = Gffc, Kic = Kic, Kpc = Kpc, Lf = LFilter, Rf = RFilter) annotation(
    Placement(visible = true, transformation(origin = {-1027.33, 178.2}, extent = {{-150.667, -180.8}, {150.667, 180.8}}, rotation = 0)));
  Dynawo.Examples.GridForming.VoltageFiltreControl voltageFiltreControl(Cf = CFilter, Gffv = Gffv, Kiv = Kiv, Kpv = Kpv, Wn = 314) annotation(
    Placement(visible = true, transformation(origin = {-2600.44, 48.8}, extent = {{-249.556, -449.2}, {249.556, 449.2}}, rotation = 0)));
  Dynawo.Examples.GridForming.VoltagePOI voltagePOI(Mq = Mq, Rv = Rv, Wf = Wf, Wff = Wff)  annotation(
    Placement(visible = true, transformation(origin = {-4229, 316.2}, extent = {{-304, -547.2}, {304, 547.2}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 1, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-5456, 772}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 1, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-5460, 351}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step2(height = 0, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-5442, -282}, extent = {{-125, -125}, {125, 125}}, rotation = 0)));
equation
  Line23.switchOffSignal1.value = false;
  Line23.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, Line23.terminal1) annotation(
    Line(points = {{-28.5, 383.5}, {49.75, 383.5}, {49.75, 384}, {101, 384}}, color = {0, 0, 255}));
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
  connect(omegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-84.5, -84}, {114.25, -84}, {114.25, -91}, {189, -91}}, color = {0, 0, 127}));
  connect(Line23.terminal2, measurementPcc.terminal) annotation(
    Line(points = {{217, 384}, {346, 384}, {346, 410}}, color = {0, 0, 255}));
  connect(gridconnection.idPccPu, measurementPcc.idPccPu) annotation(
    Line(points = {{752, 264}, {762, 264}, {762, 577}, {233, 577}, {233, 499}, {330, 499}}, color = {0, 0, 127}));
  connect(measurementPcc.udPccPu, gridconnection.udPccPu) annotation(
    Line(points = {{493, 544}, {545, 544}, {545, 294}, {591, 294}}, color = {0, 0, 127}));
  connect(measurementPcc.uqPccPu, gridconnection.uqPccPu) annotation(
    Line(points = {{493, 520}, {528, 520}, {528, 260}, {591, 260}, {591, 269}}, color = {0, 0, 127}));
  connect(measurementPcc.uPu, pll.uPu) annotation(
    Line(points = {{477, 410}, {485, 410}, {485, 334}, {858, 334}, {858, -199}, {-383, -199}, {-383, -33}, {189, -33}}, color = {85, 170, 255}));
  connect(gridconnection.iqPccPu, measurementPcc.iqPccPu) annotation(
    Line(points = {{752, 220}, {836, 220}, {836, 609}, {207, 609}, {207, 466}, {273, 466}, {273, 469}, {330, 469}}, color = {0, 0, 127}));
  connect(measurementPcc.theta, pll.phi) annotation(
    Line(points = {{412, 571}, {434, 571}, {434, 585}, {932, 585}, {932, -57}, {297, -57}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, gridconnection.omegaPu) annotation(
    Line(points = {{297, -37}, {879, -37}, {879, 418}, {672, 418}, {672, 308}}, color = {0, 0, 127}));
  connect(gridconnection.idPccPu, converter_v2.idPccPu) annotation(
    Line(points = {{752, 249}, {957, 249}, {957, -159}, {-485, -159}, {-485, 159}, {-393, 159}, {-393, 158}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, converter_v2.iqPccPu) annotation(
    Line(points = {{752, 225}, {1008, 225}, {1008, -226}, {-557, -226}, {-557, 113}, {-393, 113}}, color = {0, 0, 127}));
  connect(converter_v2.idConvPu, currentFilterLoop.idConvPu) annotation(
    Line(points = {{-217, 294}, {-171, 294}, {-171, 491}, {-1367, 491}, {-1367, 286}, {-1189, 286}}, color = {0, 0, 127}));
  connect(converter_v2.iqConvPu, currentFilterLoop.iqConvPu) annotation(
    Line(points = {{-217, 252}, {-90, 252}, {-90, 565}, {-1390, 565}, {-1390, 96}, {-1188, 96}}, color = {0, 0, 127}));
  connect(converter_v2.udFilterPu, gridconnection.udFilterPu) annotation(
    Line(points = {{-217, 182}, {591, 182}, {591, 190}}, color = {0, 0, 127}));
  connect(converter_v2.uqFilterPu, gridconnection.uqFilterPu) annotation(
    Line(points = {{-217, 150}, {274, 150}, {274, 173}, {591, 173}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, converter_v2.omegaPu) annotation(
    Line(points = {{297, -37}, {357, -37}, {357, -289}, {-685, -289}, {-685, 402}, {-305, 402}, {-305, 326}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, currentFilterLoop.omegaPu) annotation(
    Line(points = {{297, -37}, {420, -37}, {420, -320}, {-755, -320}, {-755, 433}, {-1027, 433}, {-1027, 369}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, voltageFiltreControl.omegaPu) annotation(
    Line(points = {{297, -37}, {652, -37}, {652, -1263}, {-2204, -1263}, {-2204, 792}, {-2600, 792}, {-2600, 523}}, color = {0, 0, 127}));
  connect(gridconnection.idPccPu, voltageFiltreControl.idPccPu) annotation(
    Line(points = {{752, 249}, {1110, 249}, {1110, -724}, {-3203, -724}, {-3203, -201}, {-2875, -201}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, voltageFiltreControl.iqPccPu) annotation(
    Line(points = {{752, 225}, {1320, 225}, {1320, -807}, {-3093, -807}, {-3093, -301}, {-2875, -301}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.uqFilterPu, converter_v2.uqFilterPu) annotation(
    Line(points = {{-2875, 34}, {-3398, 34}, {-3398, -1354}, {768, -1354}, {768, 77}, {15, 77}, {15, 150}, {-217, 150}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.udFilterPu, converter_v2.udFilterPu) annotation(
    Line(points = {{-2875, 149}, {-3319, 149}, {-3319, -1444}, {331, -1444}, {331, 241}, {-217, 241}, {-217, 182}}, color = {0, 0, 127}));
  connect(converter_v2.udFilterPu, currentFilterLoop.udFilterPu) annotation(
    Line(points = {{-217, 182}, {57, 182}, {57, 670}, {-1431, 670}, {-1431, 218}, {-1188, 218}}, color = {0, 0, 127}));
  connect(converter_v2.uqFilterPu, currentFilterLoop.uqFilterPu) annotation(
    Line(points = {{-217, 150}, {117, 150}, {117, 722}, {-1429, 722}, {-1429, 32}, {-1188, 32}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.iqConvRefPu, currentFilterLoop.iqConvRefPu) annotation(
    Line(points = {{-2326, -6}, {-2042, -6}, {-2042, -162}, {-1770, -162}, {-1770, 150}, {-1188, 150}}, color = {0, 0, 127}));
  connect(voltageFiltreControl.idConvRefPu, currentFilterLoop.idConvRefPu) annotation(
    Line(points = {{-2326, 179}, {-1876, 179}, {-1876, 329}, {-1188, 329}}, color = {0, 0, 127}));
  connect(currentFilterLoop.udConvRefPu, converter_v2.udConvRefPu) annotation(
    Line(points = {{-867, 297}, {-619, 297}, {-619, 270}, {-393, 270}}, color = {0, 0, 127}));
  connect(currentFilterLoop.uqConvRefPu, converter_v2.uqConvRefPu) annotation(
    Line(points = {{-867, 130}, {-606, 130}, {-606, 222}, {-393, 222}}, color = {0, 0, 127}));
  connect(voltagePOI.udFilterRefPu, voltageFiltreControl.udFilterRefPu) annotation(
    Line(points = {{-3895, 420}, {-2870, 420}, {-2870, 408}}, color = {0, 0, 127}));
  connect(voltagePOI.uqFilterRefPu, voltageFiltreControl.uqFilterRefPu) annotation(
    Line(points = {{-3895, 258}, {-2872, 258}, {-2872, 311}}, color = {0, 0, 127}));
  connect(step.y, voltagePOI.UFilterRefPu) annotation(
    Line(points = {{-5318, 772}, {-4952, 772}, {-4952, 742}, {-4563, 742}}, color = {0, 0, 127}));
  connect(step1.y, voltagePOI.QRefPu) annotation(
    Line(points = {{-5322, 351}, {-5029, 351}, {-5029, 614}, {-4563, 614}}, color = {0, 0, 127}));
  connect(step2.y, voltagePOI.DeltaVVId) annotation(
    Line(points = {{-5304.5, -282}, {-5011, -282}, {-5011, -85}, {-4563, -85}}, color = {0, 0, 127}));
  connect(step2.y, voltagePOI.DeltaVVIq) annotation(
    Line(points = {{-5304.5, -282}, {-4939, -282}, {-4939, -195}, {-4563, -195}}, color = {0, 0, 127}));
  connect(voltagePOI.idPccPu, voltageFiltreControl.idPccPu) annotation(
    Line(points = {{-4563, 255}, {-5061, 255}, {-5061, -806}, {-3703, -806}, {-3703, -201}, {-2875, -201}}, color = {0, 0, 127}));
  connect(voltagePOI.iqPccPu, voltageFiltreControl.iqPccPu) annotation(
    Line(points = {{-4563, 134}, {-4961, 134}, {-4961, -634}, {-3151, -634}, {-3151, -301}, {-2875, -301}}, color = {0, 0, 127}));
  connect(voltagePOI.QFilterPu, converter_v2.QFilterPu) annotation(
    Line(points = {{-4563, 456}, {-5219, 456}, {-5219, -1109}, {-32, -1109}, {-32, 57}, {-217, 57}}, color = {0, 0, 127}));
protected
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 3, Tolerance = 0.000001),
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
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-5110, 930}, {1330, -1450}})));
end GridForming_test_4_v2;