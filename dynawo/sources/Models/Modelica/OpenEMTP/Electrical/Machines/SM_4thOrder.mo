within OpenEMTP.Electrical.Machines;

model SM_4thOrder "Operational parameter PU model, one damper on q-axis"
  import PI = Modelica.Constants.pi;
  import Modelica.ComplexMath.fromPolar;
  import Modelica.ComplexMath.arg;
  constant Complex j = Complex(0, 1);
  //Nominal parameters
  parameter Real Pn(unit = "MVA") = 10000 "Nominal three phase power" annotation(
    Dialog(tab = "Machine parameters"));
  parameter Real fn(unit = "Hz") = 60 "Frequency" annotation(
    Dialog(tab = "Machine parameters"));
  parameter Real Vn(unit = "kV RMSLL") = 345 "Nominal line-to-line voltage" annotation(
    Dialog(tab = "Machine parameters"));
  parameter Real Ifn(unit = "A") = 3300 "Field current for 1 pu armature voltage" annotation(
    Dialog(tab = "Machine parameters"));
  //Mechnaical parameters
  parameter Real H(unit = "PU-s") = 5 annotation(
    Dialog(tab = "Mechanical parameters"));
  parameter Real F(unit = "Nm.s") = 0 annotation(
    Dialog(tab = "Mechanical parameters"));
  parameter Real P = 2 "Number of poles" annotation(
    Dialog(tab = "Mechanical parameters"));
  //Stator parameters
  parameter Real Rs(unit = "PU") = 0 "Stator resistance per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Sator Parameters"));
  parameter Real X0(unit = "PU") = 0.3 "Stator zero sequence inductance per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Sator Parameters"));
  parameter Real Xls(unit = "PU") = 0.3 "Stator leakage inductance per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Sator Parameters"));
  parameter Real Xd(unit = "PU") = 2 "Stator inductance in d-axis per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Sator Parameters"));
  parameter Real Xq(unit = "PU") = 1.9 "Stator inductance in q-axis per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Sator Parameters"));
  parameter Real Xpd(unit = "PU") = 0.6 "Transient inductance in d-axis per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Open circuit test data"));
  parameter Real Xpq(unit = "PU") = 0.8 "Transient inductance in q-axis per phase " annotation(
    Dialog(tab = "Electrical parameters", group = "Open circuit test data"));
  parameter Real Tpdo(unit = "S") = 7 "Transient open circuit constant time on d-axis " annotation(
    Dialog(tab = "Electrical parameters", group = "Open circuit test data"));
  parameter Real Tpqo(unit = "S") = 0.7 "Transient open circuit constant time on q-axis " annotation(
    Dialog(tab = "Electrical parameters", group = "Open circuit test data"));
  parameter Real Vt_ss[2] (each unit="PU") = {1, 0} "Vt_ss in polar form {Mod,Degree}" annotation(
    Dialog(tab = "Initial parameters"));
  parameter Real It_ss[2] (each unit="PU")= {0.23804650325053098, 0} "It_ss in polar form {Mod,Degree}" annotation(
    Dialog(tab = "Initial parameters"));
  parameter Modelica.SIunits.AngularVelocity dw0 = 0 annotation(
    Dialog(tab = "Initial parameters"));
  //Stator base calculations
  final parameter Real Sbase = Pn * 1e6;
  final parameter Real Wbase = 2 * PI * fn;
  final parameter Real Vsbase = Vn * sqrt(2 / 3) * 1e3;
  final parameter Real Isbase = Pn / sqrt(3) / Vn * sqrt(2) * 1e3;
  final parameter Real Zsbase = Vsbase / Isbase;
  final parameter Real Lsbase = Zsbase / Wbase;
  final parameter Real Phisbase = Lsbase * Isbase;
  final parameter Real Tbase = Sbase / Wbase;
  //Rotor base calculations
  final parameter Real Ifbase = Ifn * Lmd;
  final parameter Real Vfbase = Sbase / Ifbase;
  // Fundemental Parameters in PU
  final parameter Real Ld = Xd;
  final parameter Real Lq = Xq;
  final parameter Real Lls = Xls;
  final parameter Real Lmd = Ld - Lls;
  final parameter Real Lmq = Lq - Lls;
  final parameter Real Lpd = Xpd;
  final parameter Real Lpq = Xpq;
  final parameter Real Lplfd = (Lls * Lmd - Lmd * Lpd) / (Lpd - Lls - Lmd) "Llfd_prime";
  final parameter Real Lp1q = (Lls * Lmq - Lmq * Lpq) / (Lpq - Lls - Lmq) "L1q_prime";
  final parameter Real Rpfd = 1 / Wbase * (Lmd + Lplfd) / Tpdo "Rfd_prime";
  final parameter Real Rp1q = 1 / Wbase * (Lmq + Lp1q) / Tpqo "R1q_prime";
  final parameter Real Lffd = Lplfd + Lmd;
  final parameter Real Lkq1kq1 = Lp1q + Lmq;
  // Initial parameter calculation
  final parameter Complex Vss = fromPolar(+Vt_ss[1], Vt_ss[2]*PI/180);
  final parameter Complex Iss = fromPolar(-It_ss[1], It_ss[2]*PI/180);
  final parameter Complex Eap = Vss + (Rs + j * Lq) * Iss;
  final parameter Real Delta_q (unit = "rad") = arg(Eap) "Angle of q-axis";
  final parameter Real D1      (unit = "rad") = Delta_q-arg(Iss)"Angle Current wrt q-axis";
  final parameter Real Delta   (unit = "rad") = Delta_q-arg(Vss) "Power angle";
  final parameter Real vd (unit = "PU") = Vt_ss[1] * sin(Delta);
  final parameter Real vq (unit = "PU") = Vt_ss[1] * cos(Delta);
  final parameter Real id (unit = "PU") = It_ss[1] * sin(D1);
  final parameter Real iq (unit = "PU") = It_ss[1] * cos(D1);
  final parameter Real if0 (unit = "PU") = (vq + Rs * iq + Ld * id) / Lmd;
  final parameter Real vf0 (unit = "PU") = Rpfd*if0*Lmd/Rpfd ;
  final parameter Real Phi0[4] (each unit = "PU") = {-Lq * iq, (-Ld * id) + Lmd * if0, (-Lmd * id) + Lffd * if0, -Lmq * iq};
  final parameter Real Pm0(unit = "PU")   = Phi0[2]*iq-Phi0[1]*id"initial torque";
  //"{Phiq, Phid, Phifd, Phikq1}"
  final parameter Real R[4, 4] = diagonal({Rs, Rs, Rpfd, Rp1q});
  final parameter Real L[4, 4] = [Lq, 0, 0, Lmq; 0, Ld, Lmd, 0; 0, Lmd, Lffd, 0; Lmq, 0, 0, Lkq1kq1];

  Real W[4, 4] = [0, Wr, 0, 0; -Wr, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0] annotation(
    HideResult = true);
  Real Wr (unit = "PU") "Rotor speed";
  Real dw (unit = "PU")"Rotor speed deviation";
  Real Phi[4] (each unit = "PU") "{Phiq, Phid, Phifd, Phikq1}";
  Real A[4, 4] annotation(
    HideResult = true);
  Real u[4] annotation(
    HideResult = false);
  Real Te(unit = "PU");
  Real Tm(unit = "PU");
  Real Tnet(unit = "PU");
  Real Pe(unit = "PU");
  Real Ip[4](each unit = "PU"), I[4](each unit = "PU");
  //{Iq, Id, Ifd, Ikq1}
  Real i_pu[3](each unit = "PU");
  //{Ia, Ib, Ic}
  Real V_ab, V_bc, Vd, Vq " dq0 voltage";
  Modelica.SIunits.Angle d_theta " Deviation of rotor angle from frame";
  Modelica.SIunits.Angle theta "Electrical angle of rotor";
  Modelica.Blocks.Interfaces.RealInput Pm_pu annotation(
    Placement(visible = true, transformation(origin = {-72, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-144, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {152, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Vfd annotation(
    Placement(visible = true, transformation(origin = {-72, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-146, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Vd_pu = Vd annotation(
    Placement(visible = true, transformation(origin = {-36, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-112, -160}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Vq_pu = Vq annotation(
    Placement(visible = true, transformation(origin = {-12, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-50, -160}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput W_pu = Wr annotation(
    Placement(visible = true, transformation(origin = {16, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-32, 160}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Ifd_pu = I[3] * Lmd annotation(
    Placement(visible = true, transformation(origin = {40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {70, -160}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Vfss=vf0 annotation(
    Placement(visible = true, transformation(origin = {68, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {130, -160}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput Pmss=Pm0 annotation(
    Placement(visible = true, transformation(origin = {-10, 66}, extent = {{10, -10}, {-10, 10}}, rotation = -90), iconTransformation(origin = {-110, 160}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
initial equation
  Phi = Phi0;
  d_theta = Delta_q;
  dw = dw0;
equation
// Conversion from abc frame to dq0 fRsme
  V_ab = (Pk.pin[1].v - Pk.pin[2].v) / Vsbase;
  V_bc = (Pk.pin[2].v - Pk.pin[3].v) / Vsbase;
  Vq = (cos(theta) * (2 * V_ab + V_bc) + sqrt(3) * V_bc * sin(theta)) / 3;
  Vd = (sin(theta) * (2 * V_ab + V_bc) + (-sqrt(3) * V_bc * cos(theta))) / 3;
// State space equations
  u[1] = Vq "Vq_pu";
  u[2] = Vd "Vd_pu";
  u[3] = Vfd * Rpfd / Lmd "Vfd_pu";
  u[4] = 0;
  der(Phi) = Wbase * (A * Phi + u);
  A = -(R * Modelica.Math.Matrices.inv(L) + W);
  Ip = Modelica.Math.Matrices.inv(L) * Phi;
  I = {-Ip[1], -Ip[2], Ip[3], Ip[4]};
  Te = Phi[2] * I[1] - Phi[1] * I[2];
  Pe = Vd * I[2] + Vq * I[1];
  Tnet = Tm - Te + F * dw;
  Tm = Pm_pu / Wr;
  der(dw) = Tnet * (1 / 2 / H);
  Wr = 1 + dw;
  der(d_theta) = dw * Wbase;
  theta = d_theta + Wbase * time;
//Conversion to abc frame
  i_pu[1] = I[1] * cos(theta) + I[2] * sin(theta);
  i_pu[2] = (cos(theta) * ((-I[1]) - sqrt(3) * I[2]) + sin(theta) * (sqrt(3) * I[1] - I[2])) * 0.5;
  i_pu[3] = (-i_pu[1]) - i_pu[2];
//Measurements in actual values
  Pk.pin[1].i = -i_pu[1] * Isbase;
  Pk.pin[2].i = -i_pu[2] * Isbase;
  Pk.pin[3].i = -i_pu[3] * Isbase;
  annotation(
    defaultComponentName = "SM",
  Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}}, initialScale = 0.1), graphics = {Ellipse(origin = {0, -24}, lineColor = {0, 0, 255}, extent = {{-72, -44}, {70, 88}}, endAngle = 360), Text(origin = {-109, -60}, extent = {{-27, 16}, {27, -16}}, textString = "Vf"), Text(origin = {-101, 80}, extent = {{-27, 16}, {27, -16}}, textString = "Pm"), Text(extent = {{-68, 48}, {62, -46}}, textString = "SM"), Text(origin = {96, 108}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Rectangle(origin = {-24, 0}, lineColor = {0, 0, 255}, extent = {{-126, 150}, {174, -150}}), Text(origin = {-109, -128}, extent = {{-27, 16}, {27, -16}}, textString = "Vd"), Text(origin = {-45, -128}, extent = {{-27, 16}, {27, -16}}, textString = "Vq"), Text(origin = {-29, 132}, extent = {{-27, 16}, {27, -16}}, textString = "W"), Text(origin = {69, -129}, extent = {{-27, 16}, {27, -16}}, textString = "If"), Text(origin = {123, -129}, extent = {{-27, 16}, {27, -16}}, textString = "Vfss"), Text(origin = {123, -129}, extent = {{-27, 16}, {27, -16}}, textString = "Vfss"), Text(origin = {-105, 133}, extent = {{-27, 16}, {27, -16}}, textString = "Pmss")}),
    Documentation(info = "<html><head></head><body><!--StartFRsgment--><h1 class=\"r2018a notRsnslate\" itemprop=\"title\" style=\"box-sizing: border-box; margin: 0px 0px 16px; font-size: 22px; font-family: Arial, Helvetica, sans-serIfd; font-weight: normal; line-height: 1.136; color: rgb(196, 84, 0); padding: 0px 61px 2px 0px; -webkit-font-feature-settings: 'kern' 1; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(203, 203, 203); widows: 1; background-image: url(file:///C:/ProgRsm%20Files/MATLAB/R2018a/help/includes/product/images/responsive/global/r2018a.svg); background-color: rgb(255, 255, 255); background-size: 57px 32px; -webkit-tRsnsition: none !important; tRsnsition: none !important; background-position: 100% -2px; background-repeat: no-repeat no-repeat;\"><span class=\"refname\" style=\"box-sizing: border-box; tRsnsition: none !important; -webkit-tRsnsition: none !important;\">Synchronous Generator</span></h1><div class=\"doc_topic_desc\" style=\"box-sizing: border-box; padding: 3px 125px 0px 0px; margin: -15px 0px 15px; border-bottom-style: none; color: rgb(106, 106, 106); line-height: 1.3; overflow: hidden; font-family: Arial, Helvetica, sans-serIfd; font-size: 13px; widows: 1; background-color: rgb(255, 255, 255); -webkit-tRsnsition: none !important; tRsnsition: none !important;\"><div class=\"purpose_container\" style=\"box-sizing: border-box; tRsnsition: none !important; -webkit-tRsnsition: none !important;\"><p itemprop=\"purpose\" style=\"box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; float: left; -webkit-tRsnsition: none !important; tRsnsition: none !important;\">Model the dynamics of three-phase round-rotor or salient-pole synchronous machine at rotor reference fRsme. this modles has 2 damper winding on q axis and 1 damper on d-axis.</p></div></div><!--EndFRsgment--></body></html>", revisions = "<html><head></head><body><ul><li><em>2020-05-31 &nbsp;&nbsp;</em>&nbsp;by Alireza Masoom initially implemented</li></ul></body></html>"),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
  Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})));end SM_4thOrder;
