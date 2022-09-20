within Dynawo.Examples.DynamicLineTests;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPD0.5-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model TwoMachinesLoadFlow "Load flow for a two (or three) machines connected to a load PQ"

/*
Equivalent circuit :

                                U03,P03,phi03,Q03
                                   |
                                   |
                                 (R1+jX1)
                                   |
      U01,P01,phi01,Q01         I0 U1 I1                    U02,P02,phi02,Q02

       |------->-----(R1+jX1)----<-|->-------(R1+jX1)------<----|
                                   |
                                 (P,Q)
                                   |
                                   |
*/

  import Dynawo;
  import Modelica;

  extends Icons.Example;

  parameter Real X1 = 0.03370 "Reactance in pu (base SnRef)";
  parameter Real R1 = 0.016854 "Resistance in pu (base SnRef)";
  parameter Real U0pu = 1 "Start value of voltage amplitude in pu (base UNom)";
  parameter Real phi0 = 0 "Start value of voltage phase (in rad)";
  parameter Real P0 = 3.8 "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  parameter Real Q0 = 0 "Start value of active power at terminal in pu (base SnRef) (generator convention)";

  Types.ComplexVoltagePu U0 = ComplexMath.fromPolar(U0pu,phi0);
  Types.ComplexImpedancePu Z = Complex(R1,X1);
  Types.ComplexCurrentPu I0;
  Types.ComplexVoltagePu U1;
  Types.ComplexApparentPowerPu s0 = Complex(P0,Q0);
  Types.ComplexCurrentPu Ipq;
  Types.ComplexApparentPowerPu s1 ;
  Types.ActivePowerPu P;
  Types.ReactivePowerPu Q;

equation
  s0 = U0 * ComplexMath.conj(I0) ;
  Z * I0 = U0 - U1;
  3 * I0 = Ipq;
  s1 = U1 * ComplexMath.conj(Ipq);
  P = s1.re ;
  Q = s1.im ;


 annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
    Initialize the multi machines model twomachines.mo for a given machine and line configuration.
</body></html>"));
end TwoMachinesLoadFlow;
