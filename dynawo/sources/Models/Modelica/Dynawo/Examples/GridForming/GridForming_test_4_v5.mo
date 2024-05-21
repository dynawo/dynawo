within Dynawo.Examples.GridForming;

model GridForming_test_4_v5 "Grid Forming converters test case"
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
  import Modelica.Constants.pi;
  extends Icons.Example;
  //parameter Types.ActivePowerPu PRefLoadPu = 1 "Active power request for the load in pu (base SnRef)";
  //parameter Types.ReactivePowerPu QRefLoadPu = 0 "Reactive power request for the load in pu (base SnRef)";
  
  //System parameters
  parameter Real Wn=2*pi*50 ; //System angular frequency
  parameter Real fNom=50; //system AC frequency
  
  
  //Power calculation at the PCC point
  
  parameter Real SNom=1000;
  //Nominal apparent power module for the converter
  //Parameters of the Filter
  parameter Real LFilter=0.15;
  parameter Real RFilter=0.005;
  parameter Real CFilter=0.066;
  
  //Parameters of the Transformer
  parameter Real LTransformer=0.15;
  parameter Real RTransformer=0.005;

 //Parameters of the Line grid connection
  parameter Real LConnection=0.5;
  parameter Real RConnection=0.005;


 // Parameter of the VSC
  parameter Real Fsw=5000;
  //Switching frequency of the VSC
  final parameter Real Wvsc=2*Fsw;//Bandwidth of the VSC
  final parameter Real TrVSC=1/Wvsc;//Time response of the VSC

 //Parameters for the Tunning of the Current Loop
  parameter Real EpsilonCurrent=0.7;
  parameter Real Gffc=1; //Sensitivity to the voltage at the capacitor of the Filter
  final parameter Real TrCurrent=10*TrVSC;//Time response of the current loop
 // final parameter Real Wnc=1/TrCurrent;//Bandwidth of the current loop
   final parameter Real Wnc=4/(EpsilonCurrent*TrCurrent);   //Bandwidth of the current loop
  final parameter Real Kpc=2*EpsilonCurrent*LFilter*Wnc/Wn-RFilter;
final parameter Real Kic=Kpc*Wnc/(2*EpsilonCurrent-RFilter*Wn/(LFilter*Wnc));
  //final parameter Real Kic=0;
  //final parameter Real Kpc=0.73;
// final parameter Real Kpc=2*EpsilonCurrent*Kic/Wnc-RFilter;
// final parameter Real Kic=LFilter*Wnc*Wnc/Wn;
 
  //Parameters for the Tunning of the Voltage Loop
  parameter Real EpsilonVoltage=0.7;
  parameter Real Gffv=1; //Sensitivity to the voltage at the capacitor of the Filter
   final parameter Real TrVoltage=50*TrCurrent;//Time response of the voltage loop
   final parameter Real Wnv=4/(EpsilonVoltage*TrVoltage);//Bandwidth of the current loop
  //final parameter Real Wnv=1/TrVoltage;//Bandwidth of the voltage loop
 // final parameter Real Kpv=2*EpsilonVoltage*CFilter*Wnv/Wn;
 //final parameter Real Kiv=Kpv*Wnv/(2*EpsilonVoltage);
  final parameter Real Kiv=Wnv*Wnv*CFilter/Wn;
  final parameter Real Kpv=2*EpsilonVoltage*Kiv/Wnv;
 //final parameter Real Kpv=0.52;
  //final parameter Real Kiv=1.16;


  //Parameters of the Power synchronisation block to find the frequency of the Grid
  
    parameter Real Mp=0.05; //Guillaume thesis 0.01Wn .. 0.1Wn
    parameter Real WLP=Wn/5;   // Guillaume Thesis
    parameter Boolean Wref_FromPLL=false;
    parameter Real WPLL=1000; //Filtre at the input of the PLL

    
  
  //Parameters of the Virtual Impedance Block
  parameter Real Rv=0.09; //Gain of the active damping
  parameter Real Wff=60 "Cutoff pulsation of the active and reactive filters (in rad/s)";
  
  //Reactive Power block
  parameter Real Mq =0 "0.05 Reactive power droop control coefficient";
  parameter Real Wf=Wn/10 "Cutoff pulsation of the reactive filter (in rad/s)";

  //Parameters of the pll Tiene que ser mas rapido que el VSC porque el VSC necesita la frecuencia del sistema para poder //plantear las ecuaciones R L
  parameter Real KiPLL=795; // PLL integrator gain
  parameter Real KpPLL=3; //PLL proportional gain
 
 
  // Modelica.Blocks.Sources.BooleanStep Disconnection(startValue = false, startTime = 0.5);
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {7309.5, 893.5}, extent = {{-311.5, -311.5}, {311.5, 311.5}}, rotation = 90)));
  Dynawo.Electrical.Lines.Line Line23(BPu = 0.00003, GPu = 0, RPu = RConnection, XPu = LConnection) annotation(
    Placement(visible = true, transformation(origin = {9091, 875}, extent = {{-467, -467}, {467, 467}}, rotation = 0)));
  Dynawo.Examples.GridForming.MeasurementPcc measurementPcc(SNom=SNom) annotation(
    Placement(visible = true, transformation(origin = {12624, -847}, extent = {{-414, -414}, {414, 414}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(KiPLL=KiPLL,KpPLL=KpPLL) annotation(
    Placement(visible = true, transformation(origin = {-1900.5, 1776.5}, extent = {{-378.5, -378.5}, {378.5, 378.5}}, rotation = 0)));
  Dynawo.Examples.GridForming.Gridconnection gridconnection(LTransformer=LTransformer,RTransformer=RTransformer)  annotation(
    Placement(visible = true, transformation(origin = {10169.5, -844.5}, extent = {{-418.5, -418.5}, {418.5, 418.5}}, rotation = 0)));
  Dynawo.Examples.GridForming.VoltagePOI voltagePOI(Mq =Mq ,Wf =Wf,Wff=Wff,Rv=Rv ) annotation(
    Placement(visible = true, transformation(origin = {-1082.34, -892.662}, extent = {{-475.662, -475.662}, {475.662, 475.662}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefpu(height = 0, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-2849, -1136}, extent = {{-161, -161}, {161, 161}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilter( height = 1,offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-2857, -524}, extent = {{-169, -169}, {169, 169}}, rotation = 0)));
  Modelica.Blocks.Sources.Step omegaRefPu(height = SystemBase.omegaRef0Pu, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-2815.5, 191.5}, extent = {{-183.5, -183.5}, {183.5, 183.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PrefPu( height = 0.3,offset = 0.3, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-2816.5, 961.5}, extent = {{-186.5, -186.5}, {186.5, 186.5}}, rotation = 0)));
  Dynawo.Examples.GridForming.synchronisation PowerSynchronisation(WLP=WLP,Mp =Mp,Wref_FromPLL=Wref_FromPLL,WPLL=WPLL) annotation(
    Placement(visible = true, transformation(origin = {-734, 540}, extent = {{-463, -463}, {463, 463}}, rotation = 0)));
  Dynawo.Examples.GridForming.VoltageFiltreControl voltageFiltreControl(Kpv=Kpv,Kiv=Kiv,Gffv=Gffv,Cf=CFilter) annotation(
    Placement(visible = true, transformation(origin = {1671, -902}, extent = {{-471.5, -471.5}, {471.5, 471.5}}, rotation = 0)));
  Dynawo.Examples.GridForming.CurrentFilterLoop currentFilterLoop(Kpc=Kpc,Kic=Kic,Gffc=Gffc,Lf=LFilter) annotation(
    Placement(visible = true, transformation(origin = {4340.01, -900.68}, extent = {{-578.014, -481.681}, {578.014, 481.681}}, rotation = 0)));
  Dynawo.Examples.GridForming.Converter_v2 converter_v2(TrVSC=TrVSC,LFilter=LFilter,RFilter=RFilter,CFilter=CFilter) annotation(
    Placement(visible = true, transformation(origin = {7596.85, -915.85}, extent = {{-484.15, -484.15}, {484.15, 484.15}}, rotation = 0)));
 Dynawo.Examples.GridForming.VI vi1 annotation(
    Placement(visible = true, transformation(origin = {-2932.44, -2161.4}, extent = {{-363.333, -327}, {363.333, 327}}, rotation = 0)));
 Modelica.Blocks.Sources.Step Imax(height = 0, offset = 1.4, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {220, -2894}, extent = {{-161, -161}, {161, 161}}, rotation = 0)));
 Modelica.Blocks.Sources.Step Imin(height = 0, offset = 1.4, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {225, -3409}, extent = {{-161, -161}, {161, 161}}, rotation = 0)));
 Dynawo.Examples.GridForming.CurrentSaturation currentSaturation annotation(
    Placement(visible = true, transformation(origin = {2196.5, -3484.75}, extent = {{-492.5, -738.75}, {492.5, 738.75}}, rotation = 0)));
equation
  Line23.switchOffSignal1.value = false;
  Line23.switchOffSignal2.value = false;
  connect(gridconnection.idPccPu, measurementPcc.idPccPu) annotation(
    Line(points = {{10630, -738}, {11539, -738}, {11539, -824}, {12169, -824}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, measurementPcc.iqPccPu) annotation(
    Line(points = {{10630, -877}, {11523, -877}, {11523, -948}, {12169, -948}}, color = {0, 0, 127}));
  connect(gridconnection.idPccPu, voltagePOI.idPccPu) annotation(
    Line(points = {{10630, -738}, {11124, -738}, {11124, -1921}, {-2197, -1921}, {-2197, -946}, {-1606, -946}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, voltagePOI.iqPccPu) annotation(
    Line(points = {{10630, -877}, {11201, -877}, {11201, -2008}, {-2156, -2008}, {-2156, -1051}, {-1606, -1051}}, color = {0, 0, 127}));
  connect(measurementPcc.udPccPu, gridconnection.udPccPu) annotation(
    Line(points = {{13079, -668}, {13552, -668}, {13552, -1460}, {9193, -1460}, {9193, -500}, {9709, -500}}, color = {0, 0, 127}));
  connect(measurementPcc.uqPccPu, gridconnection.uqPccPu) annotation(
    Line(points = {{13079, -760}, {13495, -760}, {13495, -1531}, {9132, -1531}, {9132, -568}, {9709, -568}, {9709, -579}}, color = {0, 0, 127}));
  connect(PrefPu.y, PowerSynchronisation.PRefPu) annotation(
    Line(points = {{-2611, 962}, {-2207, 962}, {-2207, 818}, {-1243, 818}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, PowerSynchronisation.omegaRefPu) annotation(
    Line(points = {{-2614, 192}, {-1243, 192}, {-1243, 216}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-2614, 192}, {-2489, 192}, {-2489, 1549}, {-2317, 1549}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, PowerSynchronisation.omegaPLLSetPu) annotation(
    Line(points = {{-1484, 1966}, {-734, 1966}, {-734, 1049}}, color = {0, 0, 127}));
  connect(Line23.terminal2, measurementPcc.terminal) annotation(
    Line(points = {{9558, 875}, {11672, 875}, {11672, -1398}, {12334, -1398}, {12334, -1279}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, Line23.terminal1) annotation(
    Line(points = {{7310, 894}, {8624, 894}, {8624, 875}}, color = {0, 0, 255}));
  connect(measurementPcc.uPu, pll.uPu) annotation(
    Line(points = {{12988, -1284}, {12978, -1284}, {12978, -1654}, {13782, -1654}, {13782, 1301}, {-41, 1301}, {-41, 2300}, {-2474, 2300}, {-2474, 2004}, {-2317, 2004}}, color = {85, 170, 255}));
  connect(UFilter.y, voltagePOI.UFilterRefPu) annotation(
    Line(points = {{-2671, -524}, {-2138.5, -524}, {-2138.5, -523}, {-1606, -523}}, color = {0, 0, 127}));
  connect(QRefpu.y, voltagePOI.QRefPu) annotation(
    Line(points = {{-2672, -1136}, {-2474, -1136}, {-2474, -634}, {-1606, -634}}, color = {0, 0, 127}));
  connect(measurementPcc.PGenPu, PowerSynchronisation.PFilterPu) annotation(
    Line(points = {{13079, -1031}, {13992, -1031}, {13992, -2429}, {-2248, -2429}, {-2248, 543}, {-1243, 543}, {-1243, 503}}, color = {0, 0, 127}));
  connect(measurementPcc.QGenPu, voltagePOI.QFilterPu) annotation(
    Line(points = {{13079, -1151}, {14128, -1151}, {14128, -2580}, {-2323, -2580}, {-2323, -771}, {-1606, -771}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, converter_v2.iqPccPu) annotation(
    Line(points = {{10630, -877}, {11465, -877}, {11465, -2338}, {6683, -2338}, {6683, -1120}, {7064, -1120}}, color = {0, 0, 127}));
  connect(converter_v2.uqFilterPu, gridconnection.uqFilterPu) annotation(
    Line(points = {{8129, -997}, {9022, -997}, {9022, -1170}, {9709, -1170}}, color = {0, 0, 127}));
  connect(converter_v2.udFilterPu, gridconnection.udFilterPu) annotation(
    Line(points = {{8129, -889}, {9063, -889}, {9063, -1077}, {9709, -1077}}, color = {0, 0, 127}));
  connect(converter_v2.uqFilterPu, voltageFiltreControl.uqFilterPu) annotation(
    Line(points = {{8129, -997}, {8876, -997}, {8876, -2108}, {302, -2108}, {302, -919}, {1152, -919}, {1152, -918}}, color = {0, 0, 127}));
  connect(converter_v2.udFilterPu, voltageFiltreControl.udFilterPu) annotation(
    Line(points = {{8129, -889}, {8926, -889}, {8926, -2140}, {352, -2140}, {352, -777}, {1152, -777}, {1152, -797}}, color = {0, 0, 127}));
  connect(gridconnection.idPccPu, converter_v2.idPccPu) annotation(
    Line(points = {{10630, -738}, {10975, -738}, {10975, -1629}, {6530, -1629}, {6530, -970}, {7064, -970}}, color = {0, 0, 127}));
  connect(converter_v2.iqConvPu, currentFilterLoop.iqConvPu) annotation(
    Line(points = {{8129, -652}, {8789, -652}, {8789, -1808}, {3242, -1808}, {3242, -1127}, {3723, -1127}, {3723, -1120}}, color = {0, 0, 127}));
  connect(converter_v2.idConvPu, currentFilterLoop.idConvPu) annotation(
    Line(points = {{8129, -512}, {8717, -512}, {8717, -1762}, {3170, -1762}, {3170, -630}, {3720, -630}, {3720, -614}}, color = {0, 0, 127}));
  connect(vi1.DeltaVVIq, voltagePOI.DeltaVVId) annotation(
    Line(points = {{-2533, -2256}, {-2075, -2256}, {-2075, -1241}, {-1606, -1241}}, color = {0, 0, 127}));
  connect(vi1.DeltaVVId, voltagePOI.DeltaVVIq) annotation(
    Line(points = {{-2533, -1980}, {-1980, -1980}, {-1980, -1337}, {-1606, -1337}}, color = {0, 0, 127}));
  connect(converter_v2.iqConvPu, vi1.iqConvPu) annotation(
    Line(points = {{8129, -652}, {8629, -652}, {8629, -4451}, {-3690, -4451}, {-3690, -2318}, {-3336, -2318}}, color = {0, 0, 127}));
  connect(converter_v2.idConvPu, vi1.idConvPu) annotation(
    Line(points = {{8129, -512}, {8759, -512}, {8759, -4523}, {-3861, -4523}, {-3861, -2161}, {-3339, -2161}}, color = {0, 0, 127}));
  connect(gridconnection.idPccPu, voltageFiltreControl.idPccPu) annotation(
    Line(points = {{10630, -738}, {11018, -738}, {11018, -2478}, {531, -2478}, {531, -1164}, {1152, -1164}}, color = {0, 0, 127}));
  connect(gridconnection.iqPccPu, voltageFiltreControl.iqPccPu) annotation(
    Line(points = {{10630, -877}, {11412, -877}, {11412, -2314}, {603, -2314}, {603, -1269}, {1152, -1269}}, color = {0, 0, 127}));
 connect(Imax.y, currentSaturation.Imax) annotation(
    Line(points = {{397, -2894}, {1655, -2894}}, color = {0, 0, 127}));
 connect(Imin.y, currentSaturation.Imin) annotation(
    Line(points = {{402, -3409}, {697, -3409}, {697, -3189}, {1655, -3189}}, color = {0, 0, 127}));
 connect(voltageFiltreControl.idConvRefPu, currentSaturation.iqConvPu) annotation(
    Line(points = {{2190, -766}, {2334, -766}, {2334, -1736}, {1202, -1736}, {1202, -3534}, {1655, -3534}}, color = {0, 0, 127}));
 connect(voltageFiltreControl.iqConvRefPu, currentSaturation.idConvPu) annotation(
    Line(points = {{2190, -960}, {2440, -960}, {2440, -1800}, {1124, -1800}, {1124, -3879}, {1655, -3879}}, color = {0, 0, 127}));
 connect(Imax.y, currentSaturation.Imax) annotation(
    Line(points = {{397, -2894}, {1506, -2894}, {1506, -2908}}, color = {0, 0, 127}));
 connect(Imin.y, currentSaturation.Imin) annotation(
    Line(points = {{402, -3409}, {697, -3409}, {697, -3203}, {1506, -3203}}, color = {0, 0, 127}));
 connect(voltageFiltreControl.idConvRefPu, currentSaturation.iqConvPu) annotation(
    Line(points = {{2190, -766}, {2334, -766}, {2334, -1736}, {1202, -1736}, {1202, -3541}, {2082, -3541}}, color = {0, 0, 127}));
 connect(voltageFiltreControl.iqConvRefPu, currentSaturation.idConvPu) annotation(
    Line(points = {{2190, -960}, {2440, -960}, {2440, -1800}, {1124, -1800}, {1124, -3886}, {2082, -3886}}, color = {0, 0, 127}));
 connect(currentFilterLoop.uqConvRefPu, converter_v2.udConvRefPu) annotation(
    Line(points = {{4957, -628}, {7064, -628}, {7064, -593}}, color = {0, 0, 127}));
 connect(currentFilterLoop.udConvRefPu, converter_v2.uqConvRefPu) annotation(
    Line(points = {{4957, -1061}, {6280, -1061}, {6280, -754}, {7064, -754}}, color = {0, 0, 127}));
 connect(currentSaturation.idConvRefPu, currentFilterLoop.idConvRefPu) annotation(
    Line(points = {{2738, -3288}, {2970, -3288}, {2970, -499}, {3723, -499}}, color = {0, 0, 127}));
 connect(currentSaturation.iqConvRefPu, currentFilterLoop.iqConvRefPu) annotation(
    Line(points = {{2738, -3583}, {3035, -3583}, {3035, -976}, {3723, -976}}, color = {0, 0, 127}));
 connect(converter_v2.udFilterPu, currentFilterLoop.udFilterPu) annotation(
    Line(points = {{8129, -889}, {8335, -889}, {8335, -1401}, {2878, -1401}, {2878, -794}, {3723, -794}}, color = {0, 0, 127}));
 connect(converter_v2.uqFilterPu, currentFilterLoop.uqFilterPu) annotation(
    Line(points = {{8129, -997}, {8584, -997}, {8584, -1596}, {3138, -1596}, {3138, -1291}, {3723, -1291}}, color = {0, 0, 127}));
 connect(pll.omegaPLLPu, voltageFiltreControl.omegaPu) annotation(
    Line(points = {{-1484, 1966}, {1671, 1966}, {1671, -404}}, color = {0, 0, 127}));
 connect(pll.phi, measurementPcc.theta) annotation(
    Line(points = {{-1484, 1814}, {2747, 1814}, {2747, 271}, {12624, 271}, {12624, -405}}, color = {0, 0, 127}));
 connect(pll.omegaPLLPu, vi1.omegaPu) annotation(
    Line(points = {{-1484, 1966}, {581, 1966}, {581, -147}, {-3442, -147}, {-3442, -1645}, {-2932, -1645}, {-2932, -1798}}, color = {0, 0, 127}));
 connect(UFilter.y, voltageFiltreControl.udFilterRefPu) annotation(
    Line(points = {{-2671, -524}, {-2536, -524}, {-2536, -266}, {206, -266}, {206, -525}, {1162, -525}}, color = {0, 0, 127}));
 connect(QRefpu.y, voltageFiltreControl.uqFilterRefPu) annotation(
    Line(points = {{-2672, -1136}, {-2449, -1136}, {-2449, -337}, {27, -337}, {27, -627}, {1157, -627}}, color = {0, 0, 127}));
 connect(pll.omegaPLLPu, currentFilterLoop.omegaPu) annotation(
    Line(points = {{-1484, 1966}, {3160, 1966}, {3160, -31}, {4340, -31}, {4340, -392}}, color = {0, 0, 127}));
 connect(pll.omegaPLLPu, converter_v2.omegaPu) annotation(
    Line(points = {{-1484, 1966}, {3778, 1966}, {3778, 36}, {7597, 36}, {7597, -405}}, color = {0, 0, 127}));
 connect(pll.omegaPLLPu, gridconnection.omegaPu) annotation(
    Line(points = {{-1484, 1966}, {4516, 1966}, {4516, 397}, {10170, 397}, {10170, -403}}, color = {0, 0, 127}));
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
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-3870, 2310}, {14150, -4540}})));
end GridForming_test_4_v5;