within Dynawo.Electrical.Controls.Converters;

model DroopControlV3 "Grid Forming converters test case"
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
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffGenerator;
  //Parameters for the Tunning of the Current Loop
  parameter Real EpsilonCurrent = 0.7 "damping of the close current loop";
  parameter Real Gffc = 1 "sensitivity to the voltage variation at the RLC filter capacitance";
  final parameter Real TrCurrent = 10 * TrVSC "settling time of the current loop";
  final parameter Real Wnc = 4 / (EpsilonCurrent * TrCurrent) "angular frequency cut-off of the current control loop in rad/s";
  final parameter Real Kpc = 2 * EpsilonCurrent * Kic / Wnc - RFilter "proportional gain in pu";
  final parameter Real Kic = LFilter * Wnc * Wnc / Wn "integral gain in rad/s";
  
  //System parameters
  final parameter Real Wn = 2 * pi * fNom "System angular frequency";
  parameter Real fNom = 50 "System AC frequency";
  parameter Real SNom = SystemBase.SnRef * 1 "Nominal apparent power for the converter";
  
  //Parameters of the RLC Filter
  parameter Real LFilter = 0.15 "RLC filter inductor in pu";
  parameter Real RFilter = 0.005 "RLC filter resistance in pu";
  parameter Real CFilter = 0.066 "RLC filter capacitance in pu";
  
  //Parameters of the Transformer between the converter and the PCC
  parameter Real LTransformer = 0.15 "Transformer inductance in pu (base UNom, SNom)";
  parameter Real RTransformer = 0.005 "Transformer resistance in pu (base UNom, SNom)";
  
  // Parameter of the VSC
  parameter Real Fsw = 1000 "Switching frequency of the VSC (hz)";
  final parameter Real Wvsc = 2 * Fsw "angular frequency cut-off of the VSC";
  final parameter Real TrVSC = 1 / Wvsc "Time response of the VSC";
  
  //Parameters for the Tunning of the Voltage Loop
  parameter Real EpsilonVoltage = 0.7 "damping of the close voltage loop";
  parameter Real Gffv = 1 "sensitivity to the grid current (current mesured at the PCC point)";
  final parameter Real TrVoltage = 50 * TrCurrent "settling time of the voltage close loop";
  final parameter Real Wnv = 4 / (EpsilonVoltage * TrVoltage) "angular frequency cut-off of the current control loop in rad/s";
  final parameter Real Kiv = Wnv * Wnv * CFilter / Wn "integral gain in rad/s";
  final parameter Real Kpv = 2 * EpsilonVoltage * Kiv / Wnv "proportional gain in pu";
 
  //Parameters of the Power synchronisation block to find the frequency of the Grid
  parameter Real Mp = 0.05 "active power droop control coefficient, 0.01Wn< Mp <0.1Wn";
  parameter Real WLP = Wn / 10 "cutoff angular frequency of the first order filter to mesure P (in rad/s), equal to Wn/10";
  parameter Boolean Wref_FromPLL = false "TRUE if the reference for omegaSetSelected is coming from PLL otherwise is a fixe value";
  parameter Real WPLL = 1000 "Cut off angular frequency of a first order filter at the output of the PLL";
  parameter Real omegaSetPu = 1 "Fixe angular frequency as a reference  in pu (base omegaNom)";
  
  //Parameters of the Virtual Impedance Block
  parameter Real Rv = 0.09 "Gain of the active damping";
  parameter Real Wff = 60 "Cutoff pulsation of the high-pass first order filter of the Transient Virtual Resistor (in rad/s)";
  
  //Reactive Power block
  parameter Real Mq = 0.05 "Reactive power droop control coefficient";
  parameter Real Wf = Wn / 10 "Cutoff pulsation of the low-pass first order filter to read the reactive power (in rad/s)";
  
  //PLL block
  parameter Real KiPLL = 795 "integral coefficient of the PI-PLL";
  parameter Real KpPLL = 3 "proportional coefficient of the PI-PLL";
  
  //Current Saturation
  parameter Real Imax = 1.5 "max value for the current reference";
  parameter Real Imin = 0 "min value for the current reference";
  
  //Virtual Impedance
  parameter Real KpRVI = 0.6 "constant to calculate RVI";
  parameter Real SigmaXR = 10 "constant to calculate XVI";
  







  
  
  /*RLConnection*/
  parameter Real idPcc0Pu "Start value of the d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Real iqPcc0Pu "Start value of the q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Real omega0Pu "Start value of the angular reference frequency for the VSC system(omega) ";
  parameter Real udFilter0Pu "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Real uqFilter0Pu "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)" ;     
  parameter Real udPcc0Pu "Start value of the q-axis voltage at the grid connection point in pu (base UNom, SNom)";
  parameter Real uqPcc0Pu "Start value of the d-axis voltage at the grid connection point in pu (base UNom, SNom)";
  
  /*Measurement Pcc*/
  parameter Real PGen0Pu "Start value of active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Real QGen0Pu "Start value of reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Real UPolar0Pu "Start value of voltage angle at ACPower PCC connection in rad";
  parameter Real UPolarPhase0 "Start value of voltage module at ACPower PCC connection in pu (base UNom)";
  parameter Complex i0Pu "Start value of the complex current at ACPower PCC connection in pu (base UNom,SNom)";
  parameter Real theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Complex u0Pu "Start value of the complex voltage at ACPower PCC connection in pu (base UNom)";


  /*VSC*/

  parameter Real PFilter0Pu "Active Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Real QFilter0Pu "Reactive Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Real idConv0Pu "d-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";     
  parameter Real iqConv0Pu "q-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Real udConv0Pu "The d-axis voltage at the inverter bridge output in pu (base UNom, SNom)";
  parameter Real uqConv0Pu "The q-axis voltage at the inverter bridge output in pu (base UNom, SNom)";


 /*VoltageFilterControl*/
   parameter Real idConvRef0Pu "Start value of the d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
   parameter Real iqConvRef0Pu "Start value of the q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
   parameter  Real udFilterRef0Pu "Start value of the d-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
   parameter Real uqFilterRef0Pu "Start value of the q-axis voltage reference after the RLC filter in pu (base UNom, SNom)";

/*VoltageFilterReference*/
   parameter Real DeltaVVId0 "d-axis delta voltage virtual impedance (base UNom, SNom)";
   parameter Real DeltaVVIq0 "q-axis delta voltage virtual impedance (base UNom, SNom)";
   parameter Real QMesure0Pu "start-value of the reactive power mesured (base UNom, SNom) (generator convention)";
   parameter Real   QRef0Pu "start-value of the reactive power reference  input (base UNom, SNom) (generator convention) " ;
   parameter Real   UFilterRef0Pu "start-value of the module voltage reference to be reached after the RLC filter connection point (base UNom, SNom)";

  
  //VirtualImpedance
   parameter Real  RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
   parameter Real  XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";

  
  //CurrentSaturation
   parameter Real  CurrentModule0 "start value of the Module of the current in dq representation idConvPu,iqConvPu";  
   parameter Real  CurrentAngle0 "start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu"; 
   parameter Real idConvSatRef0Pu "start value of the satured-value of id";
   parameter Real iqConvSatRef0Pu "start value of the satured-value of iq";
   
  /*CurrentFilterLoop*/
   
   parameter Real udConvRef0Pu "d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";
   parameter  Real uqConvRef0Pu "q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";

   
 //Droop Controls
   parameter Real omegaPLL0Pu "start value of PLL Frequency  in pu (base omegaNom)";
   parameter Real omegaRef0Pu "start value of frequency system reference in pu (base omegaNom)";
   parameter Real PMesure0Pu "start value of the active power mesured, base (SRef, UNom) ";
   parameter Real PRef0Pu "start value of the reference active power (SRef, UNom)";
   parameter Real omegaSetSelected0Pu "start value of the angular frequency selected";

  
  Dynawo.Electrical.Controls.Converters.BaseControls.RLConnection RLConnection(LTransformer = LTransformer, RTransformer = RTransformer, idPcc0Pu = idPcc0Pu, iqPcc0Pu = iqPcc0Pu, omega0Pu = omega0Pu, udFilter0Pu = udFilter0Pu, udPcc0Pu = udPcc0Pu, uqFilter0Pu = uqFilter0Pu, uqPcc0Pu = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {10808, -280}, extent = {{-434, -434}, {434, 434}}, rotation = 0)));
  BaseControls.MeasurementPcc measurementPcc(PGen0Pu = PGen0Pu, QGen0Pu = QGen0Pu, SNom = SNom, UPolar0Pu = UPolar0Pu, UPolarPhase0 = UPolarPhase0, i0Pu = Complex(i0Pu.re, i0Pu.im), idPcc0Pu = idPcc0Pu, iqPcc0Pu = iqPcc0Pu, theta0 = theta0, u0Pu = Complex(u0Pu.re, u0Pu.im), udPcc0Pu = udPcc0Pu, uqPcc0Pu = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {13103, -197}, extent = {{-455, -455}, {455, 455}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(KiPLL = KiPLL, KpPLL = KpPLL, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-1807.5, 2944.5}, extent = {{-362.5, -362.5}, {362.5, 362.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.BridgeInverterRLC VSC(CFilter = CFilter, LFilter = LFilter, PFilter0Pu = PFilter0Pu, QFilter0Pu = QFilter0Pu, RFilter = RFilter, TrVSC = TrVSC, idConv0Pu = idConv0Pu, idPcc0Pu = idPcc0Pu, iqConv0Pu = iqConv0Pu, iqPcc0Pu = iqPcc0Pu, omega0Pu = omega0Pu, udConv0Pu = udConv0Pu,  udConvRef0Pu = udConvRef0Pu, udFilter0Pu = udFilter0Pu, uqConv0Pu = uqConv0Pu, uqConvRef0Pu = uqConvRef0Pu,   uqFilter0Pu = uqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {8240.94, -550.1}, extent = {{-420.056, -756.1}, {420.056, 756.1}}, rotation = 0)));
   Dynawo.Electrical.Controls.Converters.InnerControls.VoltageFilterControl VoltageFilterControl(Cf = CFilter, Gffv = Gffv, Kiv = Kiv, Kpv = Kpv, Wn = Wn , idConvRef0Pu = idConvRef0Pu, idPcc0Pu = idPcc0Pu, iqConvRef0Pu = iqConvRef0Pu, iqPcc0Pu = iqPcc0Pu, udFilter0Pu = udFilter0Pu, udFilterRef0Pu = udFilterRef0Pu, uqFilter0Pu = uqFilter0Pu, uqFilterRef0Pu = uqFilterRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-1806.72, -433.9}, extent = {{-427.723, -769.9}, {427.723, 769.9}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.OuterControls.VoltageFilterReference VoltageFilterReference(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0,Mq = Mq, QMesure0Pu = QMesure0Pu, QRef0Pu = QRef0Pu, Rv = Rv, UFilterRef0Pu = UFilterRef0Pu, Wf = Wf, Wff = Wff, idPcc0Pu = idPcc0Pu, iqPcc0Pu = iqPcc0Pu, udFilterRef0Pu = udFilterRef0Pu, uqFilterRef0Pu = uqFilterRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-4413, -427.2}, extent = {{-377, -678.6}, {377, 678.6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.InnerControls.VirtualImpedance  VirtualImpedance(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0,KpRVI = KpRVI, RVI0 = RVI0, SigmaXR = SigmaXR, XVI0 = XVI0, idConv0Pu = idConv0Pu, iqConv0Pu = iqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-6557.56, -1652.9}, extent = {{-529.556, -476.6}, {529.556, 476.6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentSaturation currentSaturation(CurrentAngle0 = CurrentAngle0, CurrentModule0 = CurrentModule0,Imax = Imax, Imin = Imin, idConvRef0Pu = idConvRef0Pu, idConvSatRef0Pu = idConvSatRef0Pu, iqConvRef0Pu = iqConvRef0Pu, iqConvSatRef0Pu = iqConvSatRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {1421.5, -445.5}, extent = {{-827.5, -827.5}, {827.5, 827.5}}, rotation = 0)));
  Dynawo.Connectors.ACPower PCC annotation(
    Placement(visible = true, transformation(origin = {16606, -966}, extent = {{-180, -180}, {180, 180}}, rotation = 0), iconTransformation(origin = {120, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaRefPu annotation(
    Placement(visible = true, transformation(origin = {-5192.5, 2089.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-114, -50}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PrefPu annotation(
    Placement(visible = true, transformation(origin = {-2988.5, 1991.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-114, -2}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu annotation(
    Placement(visible = true, transformation(origin = {-7646.5, 1661.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-116, 42}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QrefPu annotation(
    Placement(visible = true, transformation(origin = {-7641.5, 555.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-116, 84}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization.DroopControl droopControl(Mp = Mp, PMesure0Pu = PMesure0Pu, PRef0Pu =PRef0Pu, WLP = WLP, WPLL = WPLL, Wref_FromPLL = Wref_FromPLL, omega0Pu = omega0Pu, omegaPLL0Pu = omegaPLL0Pu, omegaRef0Pu = omegaRef0Pu, omegaSetPu = omegaSetPu, omegaSetSelected0Pu = omegaSetSelected0Pu, theta0 = theta0)  annotation(
    Placement(visible = true, transformation(origin = {886.5, 2158.5}, extent = {{-634.5, -634.5}, {634.5, 634.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentFilterLoop currentFilterLoop(EpsilonCurrent = EpsilonCurrent, Fsw = Fsw, Gffc = Gffc, Kic = Kic, Kpc = Kpc, Lf = LFilter, Rf = RFilter, Wn = Wn, Wnc = Wnc, idConv0Pu = idConv0Pu,  idConvSatRef0Pu = idConvSatRef0Pu, iqConv0Pu = iqConv0Pu,  iqConvSatRef0Pu = iqConvSatRef0Pu, omega0Pu = omega0Pu, udConvRef0Pu = udConvRef0Pu, udFilter0Pu = udFilter0Pu, uqConvRef0Pu = uqConvRef0Pu, uqFilter0Pu = uqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {5247.92, -619.699}, extent = {{-708.918, -850.699}, {708.918, 850.699}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput omegaPu annotation(
    Placement(visible = true, transformation(origin = {16233.5, 1757.5}, extent = {{-504.5, -504.5}, {504.5, 504.5}}, rotation = 0), iconTransformation(origin = {118, 76}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
equation



  connect(VoltageFilterReference.udFilterRefPu, VoltageFilterControl.udFilterRefPu) annotation(
    Line(points = {{-3998, -299}, {-3456, -299}, {-3456, 182}, {-2269, 182}}, color = {0, 0, 127}));
  connect(VoltageFilterReference.uqFilterRefPu, VoltageFilterControl.uqFilterRefPu) annotation(
    Line(points = {{-3998, -499}, {-3356, -499}, {-3356, 15}, {-2273, 15}}, color = {0, 0, 127}));
  connect(VSC.omegaPu, RLConnection.omegaPu) annotation(
    Line(points = {{8241, 248}, {8305, 248}, {8305, 695}, {10808, 695}, {10808, 178}}, color = {0, 0, 127}));
  connect(VSC.udFilterPu, RLConnection.udFilterPu) annotation(
    Line(points = {{8703, -508}, {9521, -508}, {9521, -521}, {10331, -521}}, color = {0, 0, 127}));
  connect(VSC.uqFilterPu, RLConnection.uqFilterPu) annotation(
    Line(points = {{8703, -676}, {9604, -676}, {9604, -618}, {10331, -618}}, color = {0, 0, 127}));
  connect(measurementPcc.udPccPu, RLConnection.udPccPu) annotation(
    Line(points = {{13603.5, 0}, {14300, 0}, {14300, -1336}, {9732, -1336}, {9732, 77}, {10331, 77}}, color = {0, 0, 127}));
  connect(measurementPcc.uqPccPu, RLConnection.uqPccPu) annotation(
    Line(points = {{13603.5, -101}, {14240, -101}, {14240, -1450}, {9785, -1450}, {9785, -5}, {10331, -5}}, color = {0, 0, 127}));
  connect(RLConnection.idPccPu, measurementPcc.idPccPu) annotation(
    Line(points = {{11285, -169}, {12602.5, -169}, {12602.5, -172}}, color = {0, 0, 127}));
  connect(RLConnection.iqPccPu, measurementPcc.iqPccPu) annotation(
    Line(points = {{11285, -314}, {12602.5, -314}, {12602.5, -308}}, color = {0, 0, 127}));
  connect(VSC.idConvPu, VirtualImpedance.idConvPu) annotation(
    Line(points = {{8703, 80}, {9234, 80}, {9234, -2325}, {-7671, -2325}, {-7671, -1653}, {-7151, -1653}}, color = {0, 0, 127}));
  connect(VSC.iqConvPu, VirtualImpedance.iqConvPu) annotation(
    Line(points = {{8703, -138}, {9302, -138}, {9302, -2378}, {-7565, -2378}, {-7565, -1881}, {-7145, -1881}}, color = {0, 0, 127}));
  connect(VirtualImpedance.DeltaVVId, VoltageFilterReference.DeltaVVId) annotation(
    Line(points = {{-5975, -1388}, {-5653, -1388}, {-5653, -925}, {-4828, -925}}, color = {0, 0, 127}));
  connect(VirtualImpedance.DeltaVVIq, VoltageFilterReference.DeltaVVIq) annotation(
    Line(points = {{-5975, -1791}, {-5062, -1791}, {-5062, -1061}, {-4828, -1061}}, color = {0, 0, 127}));
  connect(measurementPcc.uComplexPu, pll.uPu) annotation(
    Line(points = {{13503, -677}, {13413, -677}, {13413, -829}, {11852, -829}, {11852, 3578}, {-2738, 3578}, {-2738, 3162}, {-2206, 3162}}, color = {85, 170, 255}));
  connect(measurementPcc.terminal, PCC) annotation(
    Line(points = {{12785, -672}, {12838, -672}, {12838, -966}, {16606, -966}}, color = {0, 0, 255}));
  connect(OmegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-5192, 2090}, {-3723, 2090}, {-3723, 2727}, {-2206, 2727}}, color = {0, 0, 127}));
  connect(UFilterRefPu, VoltageFilterReference.UFilterRefPu) annotation(
    Line(points = {{-7646.5, 1661.5}, {-7071.5, 1661.5}, {-7071.5, 1673}, {-5792, 1673}, {-5792, 101}, {-4828, 101}}, color = {0, 0, 127}));
  connect(QrefPu, VoltageFilterReference.QRefPu) annotation(
    Line(points = {{-7641, 556}, {-6449, 556}, {-6449, -58}, {-4828, -58}}, color = {0, 0, 127}));
 connect(PrefPu, droopControl.PRefPu) annotation(
    Line(points = {{-2988, 1992}, {-1039, 1992}, {-1039, 2557}, {189, 2557}, {189, 2539}}, color = {0, 0, 127}));
 connect(droopControl.theta, measurementPcc.theta) annotation(
    Line(points = {{1584, 2476}, {13103, 2476}, {13103, 288}}, color = {0, 0, 127}));
 connect(VoltageFilterControl.omegaPu, droopControl.omegaPu) annotation(
    Line(points = {{-1807, 379}, {-1613, 379}, {-1613, 990}, {1577, 990}, {1577, 1394.5}, {1584, 1394.5}, {1584, 1797}}, color = {0, 0, 127}));
 connect(droopControl.omegaRefPu, OmegaRefPu) annotation(
    Line(points = {{189, 1714}, {-3740, 1714}, {-3740, 2090}, {-5192, 2090}}, color = {0, 0, 127}));
 connect(droopControl.omegaPu, currentFilterLoop.omegaPu) annotation(
    Line(points = {{1584, 1797}, {5248, 1797}, {5248, 278}}, color = {0, 0, 127}));
 connect(VSC.uqFilterPu, currentFilterLoop.uqFilterPu) annotation(
    Line(points = {{8703, -676}, {9491, -676}, {9491, -2273}, {3420, -2273}, {3420, -1310}, {4492, -1310}}, color = {0, 0, 127}));
 connect(VSC.udFilterPu, currentFilterLoop.udFilterPu) annotation(
    Line(points = {{8703, -508}, {9407, -508}, {9407, -2122}, {3541, -2122}, {3541, -431}, {4492, -431}}, color = {0, 0, 127}));
 connect(VSC.iqConvPu, currentFilterLoop.iqConvPu) annotation(
    Line(points = {{8703, -138}, {9272, -138}, {9272, -1865}, {3805, -1865}, {3805, -1007}, {4492, -1007}}, color = {0, 0, 127}));
 connect(VSC.idConvPu, currentFilterLoop.idConvPu) annotation(
    Line(points = {{8703, 80}, {9226, 80}, {9226, -1759}, {3737, -1759}, {3737, -114}, {4487, -114}}, color = {0, 0, 127}));
 connect(currentFilterLoop.omegaPu, VSC.omegaPu) annotation(
    Line(points = {{5248, 278}, {5255, 278}, {5255, 717}, {8241, 717}, {8241, 248}}, color = {0, 0, 127}));
 connect(currentFilterLoop.uqConvRefPu, VSC.uqConvRefPu) annotation(
    Line(points = {{6004, -847}, {7039, -847}, {7039, -298}, {7779, -298}}, color = {0, 0, 127}));
 connect(currentFilterLoop.udConvRefPu, VSC.udConvRefPu) annotation(
    Line(points = {{6004, -62}, {7779, -62}, {7779, -46}}, color = {0, 0, 127}));
 connect(currentSaturation.idConvRefPu, currentFilterLoop.idConvSatRefPu) annotation(
    Line(points = {{2332, -114}, {3364, -114}, {3364, 75}, {4492, 75}, {4492, 89}}, color = {0, 0, 127}));
 connect(currentSaturation.iqConvRefPu, currentFilterLoop.iqConvSatRefPu) annotation(
    Line(points = {{2332, -611}, {2832, -611}, {2832, -752}, {4492, -752}}, color = {0, 0, 127}));
 connect(VoltageFilterControl.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{-1336, -211}, {511, -211}, {511, -148}}, color = {0, 0, 127}));
 connect(VoltageFilterControl.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{-1336, -528}, {511, -528}, {511, -462}}, color = {0, 0, 127}));
 connect(RLConnection.idPccPu, VSC.idPccPu) annotation(
    Line(points = {{11285, -169}, {11565, -169}, {11565, -1613}, {7139, -1613}, {7139, -634}, {7779, -634}}, color = {0, 0, 127}));
 connect(RLConnection.iqPccPu, VSC.iqPccPu) annotation(
    Line(points = {{11285, -314}, {11720, -314}, {11720, -1680}, {7233, -1680}, {7233, -869}, {7779, -869}}, color = {0, 0, 127}));
 connect(RLConnection.idPccPu, VoltageFilterControl.idPccPu) annotation(
    Line(points = {{11285, -169}, {11538, -169}, {11538, -2038}, {-3313, -2038}, {-3313, -862}, {-2277, -862}}, color = {0, 0, 127}));
 connect(RLConnection.idPccPu, VoltageFilterReference.idPccPu) annotation(
    Line(points = {{11285, -169}, {11605, -169}, {11605, -2159}, {-5459, -2159}, {-5459, -503}, {-4828, -503}}, color = {0, 0, 127}));
 connect(RLConnection.iqPccPu, VoltageFilterControl.iqPccPu) annotation(
    Line(points = {{11285, -314}, {11997, -314}, {11997, -1977}, {-2517, -1977}, {-2517, -1039}, {-2277, -1039}, {-2277, -1033}}, color = {0, 0, 127}));
 connect(RLConnection.iqPccPu, VoltageFilterReference.iqPccPu) annotation(
    Line(points = {{11285, -314}, {12057, -314}, {12057, -2476}, {-5357, -2476}, {-5357, -653}, {-4828, -653}}, color = {0, 0, 127}));
 connect(pll.omegaPLLPu, droopControl.omegaPLLPu) annotation(
    Line(points = {{-1409, 3126}, {-845, 3126}, {-845, 1149}, {861, 1149}, {861, 1461}}, color = {0, 0, 127}));
 
 connect(omegaPu, droopControl.omegaPu) annotation(
    Line(points = {{16234, 1758}, {1584, 1758}, {1584, 1797}}, color = {0, 0, 127}));
 connect(currentFilterLoop.udFilterPu, VoltageFilterControl.udFilterPu) annotation(
    Line(points = {{4492, -431}, {3458, -431}, {3458, -2106}, {-2869, -2106}, {-2869, -249}, {-2277, -249}, {-2277, -263}}, color = {0, 0, 127}));
 connect(currentFilterLoop.uqFilterPu, VoltageFilterControl.uqFilterPu) annotation(
    Line(points = {{4492, -1310}, {3299, -1310}, {3299, -2265}, {-2990, -2265}, {-2990, -460}, {-2277, -460}}, color = {0, 0, 127}));
 connect(VSC.PFilterPu, droopControl.PMesurePu) annotation(
    Line(points = {{8703, -979}, {9122, -979}, {9122, -2796}, {14934, -2796}, {14934, 3105}, {-736, 3105}, {-736, 2108}, {189, 2108}}, color = {0, 0, 127}));
 connect(VSC.QFilterPu, VoltageFilterReference.QMesurePu) annotation(
    Line(points = {{8703, -1163}, {8902, -1163}, {8902, -3060}, {-5988, -3060}, {-5988, -254}, {-4828, -254}}, color = {0, 0, 127}));
protected
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.001),
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
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-8090, 3580}, {16810, -2710}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {-173, 99}, extent = {{-33, 19}, {33, -19}}, textString = "QrefPu"), Text(origin = {-175, 51}, extent = {{-33, 19}, {33, -19}}, textString = "UrefPu"), Text(origin = {-173, 11}, extent = {{-33, 19}, {33, -19}}, textString = "PrefPu"), Text(origin = {-179, -39}, extent = {{-45, 25}, {45, -25}}, textString = "OmegaRefPu"), Text(origin = {173, 29}, extent = {{-33, 19}, {33, -19}}, textString = "PCC"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-5, 3}, extent = {{-69, 43}, {69, -43}}, textString = "GFM"), Text(origin = {173, 93}, extent = {{-33, 19}, {33, -19}}, textString = "OmegaPu")}));
end DroopControlV3;