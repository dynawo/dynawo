within Dynawo.Examples.DynamicLineTests;
/*

Load flow for a two machines connected to a load PQ .
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
model TwoMachinesLoadFlow

import Dynawo;
parameter Real X1 = 0.03370;
parameter Real R1 = 0.016854;
parameter Real U0pu = 1;
parameter Real phi0 = 0;
parameter Real P0 = 3.8;
parameter Real Q0 = 0;

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


end TwoMachinesLoadFlow;
