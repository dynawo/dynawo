within OpenEMTP.Electrical.Machines;
model SMEMTP
 import PI=Modelica.Constants.pi;
 parameter Real Sn( unit = "MVA") = 10000      "Nominal power";
 parameter Real Ra = 0;
 parameter Real Xl = 0.3570750000E+01;
 parameter Real X0 = 0.3570750000E+01;
 parameter Real Xd = 0.2380500000E+02;
 parameter Real Rf = 0.2485506629E+00;
 parameter Real Xf = 0.6559097468E+03;
 parameter Real Xaf= 0.1045454545E+03;
 parameter Real Xq= 0.2261475000E+02;
 parameter Real RQ1= 0.2802156577E+01;
 parameter Real XQ1= 0.7394716995E+03;
 parameter Real XaQ1=0.9839572193E+02;
 parameter Real p =  2 "Nomber of poles";
 parameter Real J =  0.7036193308E+06;
 parameter Real H( unit = "PU-s") = 5;

 final parameter Real Wbase =     120*PI;
 final parameter Real Tbase =  Sn*1e6/Wbase;
 final parameter Real L[5,5]= (1/Wbase) *
 [Xd,   0,    0,    Xaf,   0;
  0,    Xq,   0,    0,     XaQ1;
  0,    0,    X0,   0,     0;
 Xaf,   0,    0,    Xf,    0;
  0,    XaQ1, 0,    0,     XQ1];

 final parameter Real R[5,5] = diagonal({Ra,  Ra,  Ra,  Rf, RQ1});
  Real W[5,5]=[0   ,Wr   ,0   ,0    , 0;
              -Wr  ,0    ,0   ,0    , 0;
               0   ,0    ,0   ,0    , 0;
               0   ,0    ,0   ,0    , 0;
               0   ,0    ,0   ,0    , 0];

 Real Wr( start=Wbase); // Electrical rotor angular velocity
 Real Wm= (2/p) * Wr; // Mechanical rotor angular velocity
 Real Phi[5];     //{Phid, Phiq, Phi0,  Phifd, Phiq1}
 Real u[5]; ////{Vd, Vq, V0,  Vfd, Vq1}
 Real I[5]; ////{id, iq, i0,  ifd, iq1}
 Real i[5]; ////{ia, ib, ic,  ifd, iq1}
 Modelica.Blocks.Interfaces.RealInput Pm annotation (
    Placement(visible = true, transformation(origin = {-72, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-118, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput Vfd annotation (
    Placement(visible = true, transformation(origin = {-72, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.SIunits.Angle theta( start=0.1) "Electrical angle of rotor";

 Real V[5]={Pk.pin[1].v,Pk.pin[2].v,Pk.pin[3].v,-Vfd,0};
 Real InvT[5,5];
 Real Tgen;  //electrodynamic torque of the machine
 Real Tm = Pm / Wm;
 Real A[5,5];
equation
// Electrical Equations
 InvT = sqrt(2/3)*
        [cos(theta), cos(theta-2*PI/3), cos(theta+2*PI/3),  0,          0;
         sin(theta), sin(theta-2*PI/3), sin(theta+2*PI/3),  0,          0;
         1/sqrt(2),  1/sqrt(2),         1/sqrt(2),          0,          0;
         0,          0,                 0,                 sqrt(3/2),   0;
         0,          0,                 0,                 0,          sqrt(3/2)];
 u    = InvT * V;   // Voltage vector in dq frame
 der(Phi) = A * Phi - u;
 A        = -( R * Modelica.Math.Matrices.inv(L) + W);
 I        = Modelica.Math.Matrices.inv(L) * Phi;
 Tgen = Phi[2] * I[1] - Phi[1] * I[2];
// Mechnaical Equations
 J* der(Wm) = Tm - Tgen;
 der(theta) = Wr;

 i=transpose(InvT)*I;
 Pk.pin[1].i =i[1];
 Pk.pin[2].i =i[2];
 Pk.pin[3].i =i[3];
end SMEMTP;
