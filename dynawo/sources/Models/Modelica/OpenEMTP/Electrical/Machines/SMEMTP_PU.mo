within OpenEMTP.Electrical.Machines;

model SMEMTP_PU
  import PI = Modelica.Constants.pi;
// All values are in PU
  parameter Real Ra = 0;
  parameter Real Lmd = 1.7;
  parameter Real Lmq = 1.6;
  parameter Real Ld = 2;
  parameter Real Lq = 1.9;
  parameter Real L0 = 0.3;
  parameter Real Lff = 2.0643;
  parameter Real LQQ = 2.3273;
  parameter Real Rf = 7.8224e-04;
  parameter Real RQ1 = 0.0088;
  parameter Real H(unit = "PU-s") = 5;
  final parameter Real Isbase = 1.673479041129350e+04;
  final parameter Real Vsbase = 345e3;
  final parameter Real Wbase = 120 * PI;
  final parameter Real L[5, 5] =
  [Ld, 0, 0, Lmd, 0;
   0, Lq, 0, 0, Lmq;
   0, 0 , L0, 0, 0 ;
   Lmd, 0, 0, Lff, 0;
    0, Lmq, 0, 0, LQQ];
  Real Phi[5];
  //{Phid, Phiq, Phi0,  Phifd, Phiq1}
  Real u[5];
  //{Vd, Vq, V0,  Vfd, Vq1}
  Real I[5];
  //{id, iq, i0,  ifd, iq1}
  Real i[5](each unit = "PU");
  //{Ia, Ib, Ic, Ifd, IQ}
  Real Wr;
  Real Te;
  Real dw;
  Real InvT[5, 5];
  Real A[5, 5];
  Real Ip[5];
  Modelica.SIunits.Angle d_theta " Deviation of rotor angle from frame";
  Modelica.SIunits.Angle theta "Electrical angle of rotor";
  Modelica.Blocks.Interfaces.RealInput Pm annotation(
    Placement(visible = true, transformation(origin = {-72, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-118, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Vfd annotation(
    Placement(visible = true, transformation(origin = {-72, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Real Va_pu = Pk.pin[1].v / Vsbase, Vb_pu = Pk.pin[2].v / Vsbase, Vc_pu = Pk.pin[3].v / Vsbase;
  Real V[5] = {Va_pu, Vb_pu, Vc_pu,-Vfd, 0};
  Real W[5, 5] =
  [0, Wr, 0, 0, 0;
   -Wr, 0, 0, 0, 0;
    0, 0, 0, 0, 0;
    0, 0, 0, 0, 0;
    0, 0, 0, 0, 0] annotation(
    HideResult = true);
  final parameter Real R[5, 5] = diagonal({Ra, Ra, Ra, Rf, RQ1});
equation
  InvT = sqrt(2 / 3) * [cos(theta), cos(theta - 2 * PI / 3), cos(theta + 2 * PI / 3), 0, 0; sin(theta), sin(theta - 2 * PI / 3), sin(theta + 2 * PI / 3), 0, 0; 1 / sqrt(2), 1 / sqrt(2), 1 / sqrt(2), 0, 0; 0, 0, 0, sqrt(3 / 2), 0; 0, 0, 0, 0, sqrt(3 / 2)];
  u = InvT * V;
// Voltage vector in dq frame
  der(Phi) = -Wbase * (A * Phi + u);
  A = (R * Modelica.Math.Matrices.inv(L) + W);
  Ip = Modelica.Math.Matrices.inv(L) * Phi;
  I = {Ip[1], Ip[2], Ip[3], Ip[4], Ip[5]};
  Te = Phi[1] * I[2] - Phi[2] * I[1];
  der(dw) = (Pm / Wr - Te) * (1 / 2 / H);
  Wr = 1 + dw;
  der(d_theta) = dw * Wbase;
  theta = d_theta + Wbase * time;
//Conversion to abc frame
  i = transpose(InvT) * I;
//Measurements in actual values
  Pk.pin[1].i = i[1] * Isbase;
  Pk.pin[2].i = i[2] * Isbase;
  Pk.pin[3].i = i[3] * Isbase;
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.0002));
end SMEMTP_PU;
