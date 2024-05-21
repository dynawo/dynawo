within Dynawo.Electrical.Controls.Converters;

model DroopControlV2_INIT "Initialization model for the grid forming control"
  /*
  * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */
  extends AdditionalIcons.Init;
  import Modelica.Constants.pi;
  
  
   /*The input parameters are P,Q, U and I*/
   
  /*Parameters of the GFM*/
  
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
      parameter Real Fsw = 1000 "Switching frequency of the VSC";
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
  parameter Real WLP = Wn / 5 "cutoff angular frequency of the first order filter to mesure P (in rad/s), equal to Wn/10";
  parameter Boolean Wref_FromPLL = false "TRUE if the reference for omegaSetSelected is coming from PLL otherwise is a fixe value";
  parameter Real WPLL = 1000 "Cut off angular frequency of a first order filter at the output of the PLL";
  parameter Real omegaSetPu = 1 "Fixe angular frequency as a reference  in pu (base omegaNom)";
  //Parameters of the Virtual Impedance Block
  parameter Real Rv = 0.09 "Gain of the active damping";
  parameter Real Wff = 60 "Cutoff pulsation of the active and reactive filters (in rad/s)";
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
  //Initialisation Parameters
  
   /*Operating Points*/
   /*i0Pu and u0Pu should be calculated from a Power Flow considering PRef0Pu and UFilterRef0Pu (QRef0Pu is not considered)*/
   /*So I have recover those values from a simulation test case */
   parameter Complex i0Pu = Complex(0, 0) "Start value of the complex current at ACPower PCC connection in pu (base UNom,SNom)";
   parameter Complex u0Pu = Complex(1,0)  "Start value of the complex voltage at ACPower PCC connection in pu (base UNom)";
   //parameter Real PRef0Pu = 1 "start value of the reference active power (SRef, UNom)";
  // parameter Real QRef0Pu = 0 "start-value of the reactive power reference  input (base UNom, SNom) (generator convention) ";
   //parameter Real UFilterRef0Pu = 1 "start-value of the module voltage reference to be reached after the RLC filter connection point (base UNom, SNom)";
Real UFilterRef0Pu;
Real PRef0Pu;
Real QRef0Pu;
 // Complex i0Pu;
  /*RLConnection*/
  Real omega0Pu;
  Real udFilter0Pu;
  Real uqFilter0Pu;
  /*Measurement Pcc*/
  Real PGen0Pu;
  Real QGen0Pu;
  Real UPolar0Pu;
  Real UPolarPhase0;
  //parameter Complex i0Pu = Complex(-0.59, -0.12);
//  parameter Complex i0Pu = Complex(-0.01, 0.22) "Start value of the complex current at ACPower PCC connection in pu (base UNom,SNom)";
//  parameter Complex u0Pu = Complex(0.99, -0.001) "Start value of the complex voltage at ACPower PCC connection in pu (base UNom)";

//  parameter Complex u0Pu = Complex(0.94, 0.29);
  Real udPcc0Pu;
  Real uqPcc0Pu;
  Real idPcc0Pu;
  Real iqPcc0Pu;
  //  parameter Real idPcc0Pu ;
  //  parameter Real iqPcc0Pu ;
  /*VSC*/
  Real PFilter0Pu;
  Real QFilter0Pu;
  Real idConv0Pu;
  Real iqConv0Pu;
  //  parameter Real idPcc0Pu ;
  //  parameter Real iqPcc0Pu ;
  Real udConv0Pu;
  Real uqConv0Pu;
  // parameter Real udFilter0Pu;
  // parameter Real uqFilter0Pu;
  /*VoltageFilterControl*/
  Real idConvRef0Pu;
  Real iqConvRef0Pu;
  // parameter Real idPcc0Pu;
  // parameter Real iqPcc0Pu;
  // parameter Real udFilter0Pu;
  // parameter Real uqFilter0Pu;
  Real udFilterRef0Pu;
  Real uqFilterRef0Pu;
  /*VoltageFilterReference*/
  Real DeltaVVId0;
  Real DeltaVVIq0;
//  Real QMesure0Pu;
//  parameter Real QRef0Pu = 0.1;
//  parameter Real UFilterRef0Pu = 1;
  //parameter Real  udFilterRef0Pu;
  //parameter Real  uqFilterRef0Pu;
  //VirtualImpedance
  //   parameter Real  DeltaVVId0;
  //   parameter Real  DeltaVVIq0;
  //   parameter Real  idConv0Pu;
  //   parameter Real  iqConv0Pu;
  Real RVI0;
  Real XVI0;
  //CurrentSaturation
  Real CurrentModule0;
  Real CurrentAngle0;
  /*CurrentFilterLoop*/
  Real udConvRef0Pu;
  Real uqConvRef0Pu;
  Real idConvSatRef0Pu;
  Real iqConvSatRef0Pu;
  //Droop Controls
  Real omegaPLL0Pu;
  parameter Real omegaRef0Pu = SystemBase.omegaRef0Pu;
//  Real PMesure0Pu;
//  parameter Real PRef0Pu = 1;
  Real omegaSetSelected0Pu;
  Real theta0;
  //  parameter Real omega0Pu ;
equation
/* Virtual impedance */
//IConvSquare0Pu = IdConv0Pu ^ 2 + IqConv0Pu ^ 2;
// DeltaIConvSquare0Pu = max((sqrt(IdConv0Pu ^ 2 + IqConv0Pu ^ 2) - 1 ), 0);
  RVI0 = KpRVI * max(sqrt(idConv0Pu ^ 2 + iqConv0Pu ^ 2) - 1, 0);
  XVI0 = RVI0 * SigmaXR;
  DeltaVVId0 = idConv0Pu * RVI0 - iqConv0Pu * XVI0;
  DeltaVVIq0 = iqConv0Pu * RVI0 + idConv0Pu * XVI0;
/*Measurement PCC*/
// u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
//  Complex(P0Pu, Q0Pu) = u0Pu * ComplexMath.conj(i0Pu);
/* Park's transformations dq */
/*DQ reference frame change from network reference to converter reference in pu*/
  [udPcc0Pu; uqPcc0Pu] = [cos(theta0), sin(theta0); -sin(theta0), cos(theta0)] * [u0Pu.re; u0Pu.im];
  [idPcc0Pu; iqPcc0Pu] = -[cos(theta0), sin(theta0); -sin(theta0), cos(theta0)] * [i0Pu.re; i0Pu.im] * SystemBase.SnRef / SNom;
/* Power Calculation in SnRef convention (generator convention) */
  PGen0Pu = (udPcc0Pu * idPcc0Pu + uqPcc0Pu * iqPcc0Pu) * SNom / SystemBase.SnRef;
  QGen0Pu = (uqPcc0Pu * idPcc0Pu - udPcc0Pu * iqPcc0Pu) * SNom / SystemBase.SnRef;
//  QMesure0Pu = QGen0Pu;
//  PMesure0Pu = PGen0Pu;
  QRef0Pu=QGen0Pu;
/*Complex voltage*/
// uComplexPu=terminal.V;
/* Phase and Module calculation of voltage at ACPower PCC connection */
  UPolarPhase0 = Modelica.ComplexMath.arg(u0Pu);
  UPolar0Pu = Modelica.ComplexMath.'abs'(u0Pu);
/*RL Transformer*/
  0 = udFilter0Pu - RTransformer * idPcc0Pu + omega0Pu * LTransformer * iqPcc0Pu - udPcc0Pu;
  0 = uqFilter0Pu - RTransformer * iqPcc0Pu - omega0Pu * LTransformer * idPcc0Pu - uqPcc0Pu;
/*RLC Filter*/
  0 = udConv0Pu - RFilter * idConv0Pu + omega0Pu * LFilter * iqConv0Pu - udFilter0Pu;
  0 = uqConv0Pu - RFilter * iqConv0Pu - omega0Pu * LFilter * idConv0Pu - uqFilter0Pu;
  0 = idConv0Pu + omega0Pu * CFilter * uqFilter0Pu - idPcc0Pu;
  0 = iqConv0Pu - omega0Pu * CFilter * udFilter0Pu - iqPcc0Pu;
// iConv0Pu = sqrt(idConv0Pu * idConv0Pu + iqConv0Pu * iqConv0Pu);
/*Current Control -- References*/
  udConvRef0Pu = (idConvSatRef0Pu - idConv0Pu) * (Kpc + 1) - LFilter * omega0Pu * iqConv0Pu + Gffc * udFilter0Pu;
  uqConvRef0Pu = (iqConvSatRef0Pu - iqConv0Pu) * (Kpc + 1) + LFilter * omega0Pu * idConv0Pu + Gffc * uqFilter0Pu;
  
  udConvRef0Pu=udConv0Pu;
  uqConvRef0Pu=uqConv0Pu;
/*Voltage Control Loop -- References*/
  idConvRef0Pu = (udFilterRef0Pu - udFilter0Pu) * (Kpv + 1) + CFilter * omega0Pu * uqFilter0Pu + Gffv * idPcc0Pu;
  iqConvRef0Pu = (uqFilterRef0Pu - uqFilter0Pu) * (Kpv + 1) + CFilter * omega0Pu * udFilter0Pu + Gffv * idPcc0Pu;
/*Voltage Reference Loop -- References*/
  udFilterRef0Pu = (QRef0Pu - QGen0Pu) * Mq + UFilterRef0Pu - DeltaVVId0;
  uqFilterRef0Pu = -DeltaVVIq0;
/*Current Saturation -- References*/
   CurrentModule0 = sqrt(idConvRef0Pu * idConvRef0Pu + iqConvRef0Pu * iqConvRef0Pu);
  CurrentAngle0 = atan2(iqConvRef0Pu, idConvRef0Pu);
  
  if CurrentModule0 > Imax then
    idConvSatRef0Pu = Imax * cos(CurrentAngle0);
    iqConvSatRef0Pu = Imax * sin(CurrentAngle0);
  else
    if CurrentModule0 < Imin then
      idConvSatRef0Pu = Imin * cos(CurrentAngle0);
      iqConvSatRef0Pu = Imin * sin(CurrentAngle0);
    else
      idConvSatRef0Pu = idConvRef0Pu;
      iqConvSatRef0Pu = iqConvRef0Pu;
    end if;
  end if;
/*PLL*/
  omegaPLL0Pu = omegaRef0Pu;
/*DroopControl*/
  theta0 = omega0Pu - omegaRef0Pu;
  omega0Pu = Mp * (PRef0Pu - PGen0Pu) + omegaSetSelected0Pu;
  if Wref_FromPLL then
    omegaSetSelected0Pu = omegaPLL0Pu;
  else
    omegaSetSelected0Pu = omegaSetPu;
  end if;
/*VSC*/
/* Power Calculation in base SNom, UNom (generator convetion)*/
  PFilter0Pu = udFilter0Pu * idPcc0Pu + uqFilter0Pu * iqPcc0Pu;
  QFilter0Pu = uqFilter0Pu * idPcc0Pu - udFilter0Pu * iqPcc0Pu;
  annotation(
    preferredView = "text",
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.002));
end DroopControlV2_INIT;