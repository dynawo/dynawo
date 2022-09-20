within Dynawo.Examples.DynamicLineTests;

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

  model LoadFlow_SMIBdynamicLineFault " Load flow configuration for the infinite bus initialization for SMIBdynamicLineFault or SMIBdynamicLineFault_INIT"

/*
  Equivalent circuit and conventions:

             I11,V11                -Ix,Vx   Ix,Vx                I21,V21
       |------->-----(1-x)(R1+jX1)----<--->-------x(R1+jX1)------<----|
       |               |           |              |           |       |
       |    (1-x)(G1+jB1)   (1-x)(G1+jB1)    x(G1+jB1)   x(G1+jB1)    |
  -----|               |           |              |           |       |-(U01)-RLTr+jXTr--<--
       |              ---         ---            ---         ---      |          (U0,P0,Q0,U0Ph)
       |    I12,V12                                           I22,V22 |
       |----------------->-----------R2+jX2--------------------<------|
                                   |           |
                                 G2+jB2     G2+jB2
                                   |           |
                                  ---         ---

*/

  import Dynawo;

  extends Icons.Example;

  parameter Types.PerUnit XLigne1= 0.0375 "Reactance of the line 1 in pu (base SnRef, UNom) ";
  parameter Types.PerUnit RLigne1= 0.00375  "Resistance of the line 1 in pu (base SnRef, UNom) ";
  parameter Types.PerUnit BLigne1= 0 "Half-susceptance of the line 1 in pu (base SnRef, UNom)";
  parameter Types.PerUnit GLigne1 = 0.0000375 "Half-conductance of the line 1 in pu (base SnRef, UNom)";
  parameter Types.PerUnit XLigne2 = 0.0375 "Reactance of the line 2 in pu (base SnRef, UNom) ";
  parameter Types.PerUnit RLigne2 = 0.00375 "Resistance of the line 2 in pu (base SnRef, UNom) ";
  parameter Types.PerUnit BLigne2 = 0 "Half-susceptance of the line 2 in pu (base SnRef, UNom)";
  parameter Types.PerUnit GLigne2 = 0.0000375 "Half-conductance of the line 1 in pu (base SnRef, UNom)";
  parameter Types.PerUnit XTransfo = 0.00675 "Reactance of the transformater in pu (base SnRef, UNom) ";
  parameter Types.PerUnit RTransfo = 0 "Resistance of the transformater in pu (base SnRef, UNom) ";
  parameter Types.PerUnit U0Pu = 1"Initial voltage amplitude at the machine in pu (base UNom)";
  parameter Types.Angle U0Phase = 0.49 "Start value of the voltage phase at the machine in rad";
  parameter Types.ActivePowerPu P0 = 19.98 "Start value of the active power at the machine in pu (base SnRef)";
  parameter Types.ReactivePowerPu Q0 = 9.68 "Start value of the reactive power at the machine in pu (base SnRef)";
  parameter Types.ComplexImpedancePu ZTransfoPu (re = RTransfo, im = XTransfo) "Transformater impedance";
  Types.ComplexImpedancePu ZLigne1Pu (re = RLigne1, im = XLigne1) "Line 1 impedance";
  parameter Types.ComplexAdmittancePu YLigne1Pu (re = GLigne1, im = BLigne1) "Line 1 half-admittance";
  Types.ComplexImpedancePu ZLigne2Pu (re = RLigne2, im = XLigne2) "Line 2 impedance";
  parameter Types.ComplexAdmittancePu YLigne2Pu (re = GLigne2, im = BLigne2) "Line 2 half-admittance";

  Types.PerUnit U1Pu   "Voltage amplitude at the infinite bus in pu (base Unom)";
  Types.Angle U1Phase   "Voltage phase at the infinite bus in rad";
  Types.ComplexVoltagePu U0  "Start value of the complex voltage at the machine in pu (base Unom)";
  Types.ComplexCurrentPu I0 "Start value of the complex current at the machine in pu (base Snref, Unom)";
  Types.ComplexVoltagePu U01 "Complex voltage at the transformater in pu (base Unom)";
  Types.ComplexVoltagePu U11 "Complex voltage at the line 1 on terminal 1 in pu (base Unom)";
  Types.ComplexVoltagePu U12 "Complex voltage at the line 1 on terminal 2 in pu (base Unom)";
  Types.ComplexCurrentPu I11 "Complex current at the line 1 on terminal 1 in pu (base SnRef, Unom)";
  Types.ComplexCurrentPu I12 "Complex current at the line 1 on terminal 2 in pu (base SnRef, Unom)";
  Types.ComplexVoltagePu U21 "Complex voltage at the line 2 on terminal 1 in pu (base Unom)";
  Types.ComplexVoltagePu U22 "Complex voltage at the line 2 on terminal 2 in pu (base Unom)";
  Types.ComplexCurrentPu I21 "Complex current at the line 2 on terminal 1 in pu (base SnRef, Unom)";
  Types.ComplexCurrentPu I22 "Complex current at the line 2 on terminal 2 in pu (base SnRef, Unom)";
  Types.ComplexVoltagePu Vx "Complex voltage at the fault emplacement in pu (base Unom) ";
  Types.ComplexCurrentPu Ix "Complex current at the fault emplacement in pu (base Unom) ";
  Types.ComplexApparentPowerPu S01 ;
  Types.PerUnit Q01;
  Types.PerUnit P01;

equation
  U11 = ComplexMath.fromPolar(U1Pu, U1Phase);
  U0 = ComplexMath.fromPolar(U0Pu, U0Phase);
  U0 * ComplexMath.conj(I0) = Complex(P0, Q0);
  U01 = U0 - ZTransfoPu * I0;
  S01 = U01 * ComplexMath.conj(I0);
  Q01 = S01.im;
  P01 = S01.re;
  (1 - x) * ZLigne1Pu * (-Ix - (1 - x) * YLigne1Pu * Vx) = Vx - U11;
  (1 - x) * ZLigne1Pu * (I11 - (1 - x) * YLigne1Pu * U11) = U11 - Vx;
  x * ZLigne1Pu * (I21 - x * YLigne1Pu * U21) = U21 - Vx;
  x * ZLigne1Pu * (Ix - x * YLigne1Pu * Vx) = Vx - U21;
  ZLigne2Pu * (I12 - YLigne2Pu * U12) = U12 - U22;
  ZLigne2Pu * (I22 - YLigne2Pu * U22) = U22 - U12;
  U21 = U01;
  U11 = U12;
  U21 = U22;
  I21 + I22 = I0;


  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
This model is a load flow that can be used to correctly initialize the complex voltage at the infinite bus for SMIBdynamicLineFault and SMIBdynamicLineFault_INIT for given values of lines parameters and machine initial U,P and Q. </body></html>"));
 end LoadFlow_SMIBdynamicLineFault;
