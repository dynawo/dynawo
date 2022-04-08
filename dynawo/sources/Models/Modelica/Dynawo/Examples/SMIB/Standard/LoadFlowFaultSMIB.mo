within Dynawo.Examples.SMIB.Standard;


/*
  Equivalent circuit and conventions:

             I11,V11                -Ix,Vx   Ix,Vx                   I21,V21
       |------->-------(1-x)(R1+jX1)----<--->-------x(R2+jX2)---------<----|
       |               |           |              |           |            |
       |    (1-x)(G1+jB1)   (1-x)(G1+jB1)    x(G1+jB1)   x(G1+jB1)         |
  -----|               |           |              |           |            |----(U01)-RLTr+jXTr--<--(U0,P0,Q0,U0Ph)
       |              ---         ---            ---         ---           |
       |    I12,V12                                                I22,V22 |
       |------------------->-----------R2+jX2-----------------------<------|
                                   |           |
                                 G2+jB2     G2+jB2
                                   |           |
                                  ---         ---   terminal2.V

*/

model LoadFlowFaultSMIB
  import Dynawo;
  parameter Real x=0.2  "Emplacement of the fault relative to the line lenght x= default location /line lenght";
  parameter Real XLigne1=0.0375;
  parameter Real RLigne1=0.00375;
  parameter Real BLigne1=0.0000375;
  parameter Real GLigne1=0;
  parameter Real XLigne2=0.0375;
  parameter Real RLigne2=0.00375;
  parameter Real BLigne2=0;
  parameter Real GLigne2=0.0000375;
  parameter Real XTransfo=0.00675;
  parameter Real RTransfo=0;
  parameter Real U0Pu= 1;
  parameter Real U0Phase = 0.494442;
  parameter Real P0 = 19.98;
  parameter Real Q0 = 9.68;
  Real U1Pu;
  Real U1Phase;
  Types.ComplexVoltagePu U22;




  Types.ComplexVoltagePu U0;
  Types.ComplexCurrentPu I0;
  Types.ComplexVoltagePu U01;

  Types.ComplexVoltagePu U11;
  Types.ComplexVoltagePu U12;
  Types.ComplexCurrentPu I11;
  Types.ComplexCurrentPu I12;

  Types.ComplexVoltagePu U21;

  Types.ComplexCurrentPu I21;
  Types.ComplexCurrentPu I22;

  Types.ComplexVoltagePu Vx;
  Types.ComplexCurrentPu Ix;



  Types.ComplexImpedancePu ZTransfoPu (re = RTransfo, im = XTransfo) ;
  Types.ComplexImpedancePu ZLigne1Pu (re = RLigne1, im = XLigne1) ;
  Types.ComplexAdmittancePu YLigne1Pu (re = GLigne1, im = BLigne1);
  Types.ComplexImpedancePu ZLigne2Pu (re = RLigne2, im = XLigne2) ;
  Types.ComplexAdmittancePu YLigne2Pu (re = GLigne2, im = BLigne2);


equation

  U0=ComplexMath.fromPolar(U0Pu,U0Phase);
  U0*ComplexMath.conj(I0)=Complex(P0,Q0);
  U01=U0-ZTransfoPu*I0;

    (1-x)*ZLigne1Pu*(-Ix - (1-x)*YLigne1Pu * Vx) = Vx - U11;
    (1-x)*ZLigne1Pu * (I11 - (1-x)*YLigne1Pu * U11) = U11 - Vx;

    x*ZLigne1Pu*(I21 - x*YLigne1Pu * U21) = U21 - Vx;
    x*ZLigne1Pu*(Ix - x*YLigne1Pu* Vx) = Vx - U21;

    ZLigne2Pu * (I12 - YLigne2Pu * U12) = U12 - U22;
    ZLigne2Pu * (I22 - YLigne2Pu * U22) = U22 - U12;





  U21=U01;
  U11=U12;
  U21=U22;
  I21+I22=I0;
  ComplexMath.fromPolar(U1Pu,U1Phase)=U12;





  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002));
end LoadFlowFaultSMIB;
