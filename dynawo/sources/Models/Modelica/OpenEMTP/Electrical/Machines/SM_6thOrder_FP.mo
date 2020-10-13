within OpenEMTP.Electrical.Machines;

model SM_6thOrder_FP "Synchronous generator 1 damper on d-axis and 2 damper on q axis"
 import PI=Modelica.Constants.pi;
  //Nominal parameters
 parameter Real Pb (unit = "MVA") = 555      "Nominal line-to-line voltage"
   annotation (Dialog(tab="Machine parameters"));
 parameter Real fn (unit = "Hz" ) = 60       "Frequency"
   annotation (Dialog(tab="Machine parameters"));
 parameter Real Vn (unit = "kV RMSLL") = 24  "Nominal line-to-line voltage"
   annotation (Dialog(tab="Machine parameters"));
 //Mechnaical parameters
 parameter Real H (unit = "PU-s") = 3.7
   annotation (Dialog(tab="Mechanical parameters"));
 parameter Real F (unit = "Nm.s") = 0
   annotation (Dialog(tab="Mechanical parameters"));
    //Stator parameters
 parameter Real Rs (unit = "ohm")= 0.0031 "Stator resistance per phase "
    annotation (Dialog(tab="Electrical parameters", group = "Sator Parameters"));
 parameter Real Ll (unit = "H")  = 4.12900e-04 "Stator leakage inductance "
    annotation (Dialog(tab="Electrical parameters", group = "Sator Parameters"));
 parameter Real Lmd (unit = "H") = 0.004569600000000 "Direct-axis magnetizing inductance viewed from stator "
    annotation (Dialog(tab="Electrical parameters", group = "Sator Parameters"));
 parameter Real Lmq (unit = "H") = 0.004432000000000 "quadrature-axis magnetizing inductance viewed from stator "
    annotation (Dialog(tab="Electrical parameters", group = "Sator Parameters"));
  //Field parameters
 parameter Real Rf   (unit = "ohm")= 0.071500000000000 "Field resistance"
    annotation (Dialog(tab="Electrical parameters", group = "Field Parameters"));
 parameter Real Llfd (unit = "H")  = 0.052118152118566 "Field leakage inductance"
    annotation (Dialog(tab="Electrical parameters", group = "Field Parameters"));
 parameter Real Lffd (unit = "H")  = 0.576920000000000 "Field self inductance "
    annotation (Dialog(tab="Electrical parameters", group = "Field Parameters"));

//Dampers parameters
 parameter Real Rkq1_prime  (unit = "ohm")= 0.006424216216216 " Damper Kq1 resistance refered to stator"
    annotation (Dialog(tab="Electrical parameters", group = "Damper Parameters"));
 parameter Real Llkq1_prime (unit = "H")  = 0.001996439606145 "Damper Kq1 leakage inductance refered to stator"
    annotation (Dialog(tab="Electrical parameters", group = "Damper Parameters"));
 parameter Real Rkq2_prime  (unit = "ohm")= 0.0245760000000000 " Damper Kq2 resistance refered to stator"
    annotation (Dialog(tab="Electrical parameters", group = "Damper Parameters"));
 parameter Real Llkq2_prime (unit = "H")  = 0.000344118795874368 "Damper Kq2 leakage inductance refered to stator"
    annotation (Dialog(tab="Electrical parameters", group = "Damper Parameters"));
 parameter Real Rkd_prime   (unit = "ohm")= 0.0294745945945946 " Damper Kd resistance refered to stator"
    annotation (Dialog(tab="Electrical parameters", group = "Damper Parameters"));
 parameter Real Llkd_prime  (unit = "H")  =  0.000471580397866234 "Damper Kd leakage inductance refered to stator"
    annotation (Dialog(tab="Electrical parameters", group = "Damper Parameters"));



 final parameter Real R[6,6] = diagonal({Rs_pu,Rs_pu,Rf_pu,Rkd_prime_pu,Rkq1_prime_pu,Rkq2_prime_pu})
 annotation(HideResult=true);
 final parameter Real L[6,6]= [
 Lq_pu           ,0               ,0               ,0               ,Lmq_pu           ,Lmq_pu;
 0               ,Ld_pu           ,Lmd_pu          ,Lmd_pu          ,0                ,0;
 0               ,Lmd_pu          ,Lffd_pu         ,Lmd_pu          ,0                ,0;
 0               ,Lmd_pu          ,Lmd_pu          ,Lkdkd_prime_pu  ,0                ,0;
 Lmq_pu          ,0               ,0               ,0               ,Lkq1kq1_prime_pu ,Lmq_pu;
 Lmq_pu          ,0               ,0               ,0               ,Lmq_pu           ,Lkq2kq2_prime_pu]
 annotation(HideResult=true);

 parameter Real Phi0[6]= {0,1.000004303388919,1.099314884351315,1.000004303388919,0,0}
 annotation (Dialog(tab="Initial values"));
 parameter Modelica.SIunits.Angle d_theta0=0
 annotation (Dialog(tab="Initial values"));
 parameter Modelica.SIunits.AngularVelocity dw0=0
 annotation (Dialog(tab="Initial values"));

//Stator base calculations
 final parameter Real Wbase= 2*PI*fn;
 final parameter Real Vsbase=Vn*sqrt(2/3)*1e3;
 final parameter Real Isbase=(Pb/sqrt(3)/Vn)*sqrt(2)*1e3;
 final parameter Real Zsbase=Vsbase/Isbase;
 final parameter Real Lsbase=Zsbase/Wbase;
 final parameter Real Phisbase=Lsbase*Isbase;
 final parameter Real Tbase=Pb*1e6/Wbase;

//Rotor Base calculations
 final parameter Real Lmfd         = Lffd-Llfd;
 final parameter Real Ns_Nfd       = sqrt((2/3) * (Lmd/Lmfd));
 final parameter Real Ifbase=Ns_Nfd*(3/2)*Isbase;
 final parameter Real Vfbase=Pb*1e6/Ifbase;
 final parameter Real Zfbase=Vfbase/Ifbase;
 final parameter Real Lfbase=Zfbase/Wbase;

//Stator parameter calculations
 final parameter Real Lq=Lmq + Ll;
 final parameter Real Ld=Lmd + Ll;
 //Field parameters referred to the stator
 final parameter Real Rf_prime = Rf*3/2*Ns_Nfd^2;
 final parameter Real Llfd_prime=Llfd*3/2*Ns_Nfd^2;
 final parameter Real Lsfd = (2 / 3) * (1 / Ns_Nfd) * Lmd;
//maximum mutual inductance between stator winding and the field winding
  //Nominal field voltage
 final parameter Real Ifn = Vsbase/Lsfd/(2*PI*60);
 final parameter Real Vfn = Rf*Ifn;

//Nominal field voltage and current referred to stator
 final parameter Real Vfn_prime = Rf_pu/Lmd_pu*Vsbase;
 final parameter Real Ifn_prime = Isbase/Lmd_pu;

// Inertia
 final parameter Real J (unit=" kg.m^2")= 2*H*(Pb*1e6)/Wbase^2;
//Per unit parameters
 final parameter Real Rs_pu = Rs/Zsbase;
 final parameter Real Rf_pu = Rf/Zfbase;
 final parameter Real Rkq1_prime_pu=Rkq1_prime/Zsbase;
 final parameter Real Rkq2_prime_pu=Rkq2_prime/Zsbase;
 final parameter Real Rkd_prime_pu=Rkd_prime/Zsbase;
 final parameter Real Lq_pu = Lq/Lsbase;
 final parameter Real Lmq_pu = Lmq/Lsbase;
 final parameter Real Ld_pu = Ld/Lsbase;
 final parameter Real Lmd_pu = Lmd/Lsbase;
 final parameter Real Lffd_pu=Lffd/Lfbase;
 final parameter Real Llfd_pu          = Lffd_pu - Lmd_pu;    // shall check
 final parameter Real Llkq1_prime_pu   = Llkq1_prime / Lsbase;
 final parameter Real Llkq2_prime_pu   = Llkq2_prime / Lsbase;
 final parameter Real Llkd_prime_pu    = Llkd_prime  / Lsbase;
 final parameter Real Lkq1kq1_prime_pu = Llkq1_prime_pu + Lmq_pu;
 final parameter Real Lkq2kq2_prime_pu = Llkq2_prime_pu + Lmq_pu;
 final parameter Real Lkdkd_prime_pu   = Llkd_prime_pu  + Lmd_pu;

// Variables
 Real Pm_pu =Pm/(Pb*1e6);
 Real W[6,6]=[0   ,Wr   ,0   ,0    ,0    ,0      ;
             -Wr  ,0    ,0   ,0    ,0    ,0      ;
              0   ,0    ,0   ,0    ,0    ,0      ;
              0   ,0    ,0   ,0    ,0    ,0      ;
              0   ,0    ,0   ,0    ,0    ,0      ;
              0   ,0    ,0   ,0    ,0    ,0      ]
              annotation(HideResult=false);
 Real Wr;
 Real dw;
 Real Phi[6] annotation(HideResult=false);     //{Phiq, Phid, Phifd_pu, Phikd, Phikq1, Phikq2}
 Real A[6,6] annotation(HideResult=true);
 Real u[6] = {Vq,Vd,Vfd_pu,0,0,0} annotation(HideResult=true);
 Modelica.SIunits.Angle d_theta " Deviation of rotor angle from frame";
 Modelica.SIunits.Angle theta_e "Electrical angle of rotor";
 Real Te_pu, Te;
 Real Pe_pu, Pe;
 Real Qe_pu, Qe;
 Real Ip[6],I[6],i_pu[3];     //{Iq, Id, Ifd_pu, Ikd, Ikq1, Ikq2}
 Real V_ab, V_bc ,
       Vd     , Vq     " dq0 voltage";
 Real Vfd_pu=Vf/Vfbase;

 Modelica.Blocks.Interfaces.RealInput Pm annotation(
    Placement(visible = true, transformation(origin = {-72, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-118, 78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

 Modelica.Blocks.Interfaces.RealInput Vf annotation(
    Placement(visible = true, transformation(origin = {-72, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput Vd_pu=Vd annotation(
    Placement(visible = true, transformation(origin = {-36, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-48, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealOutput Vq_pu=Vq annotation(
    Placement(visible = true, transformation(origin = {-12, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealOutput W_pu=Wr annotation(
    Placement(visible = true, transformation(origin = {16, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Interfaces.RealOutput Ifd_pu=I[3] annotation(
    Placement(visible = true, transformation(origin = {40, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
initial equation
 der(Phi)     = zeros(6);
 d_theta = d_theta0;
 dw      = dw0;

equation
// Conversion from abc fRsme to dq0 fRsme
 V_ab = (Pk.pin[1].v - Pk.pin[2].v) / Vsbase;
 V_bc = (Pk.pin[2].v - Pk.pin[3].v) / Vsbase;
 Vq   = (cos(theta_e) * (2 *V_ab + V_bc) + ( sqrt(3) * V_bc * sin(theta_e))) / 3;
 Vd   = (sin(theta_e) * (2 *V_ab + V_bc) + (-sqrt(3) * V_bc * cos(theta_e))) / 3;
// State space equations
 der(Phi) = Wbase * (A * Phi + u);
 A        =- ( R * Modelica.Math.Matrices.inv(L) + W);
 Ip       = Modelica.Math.Matrices.inv(L) * Phi;
 I        = {-Ip[1], -Ip[2], Ip[3], Ip[4], Ip[5], Ip[6]};
 Te_pu    = Phi[2] * I[1] - Phi[1] * I[2];
 Pe_pu    = Vd * I[2] + Vq * I[1];
//Pe=Vd*Id + Vq * Iq
  Qe_pu = Vq * I[2] - Vd * I[1];
//Qe=Vq*Id - Vd * Iq
  der(dw) = (Pm_pu / Wr - Te_pu + F * dw) * (1 / 2 / H);
 Wr      = 1 + dw;
 der(d_theta) = dw*Wbase;
 theta_e      = d_theta + Wbase * time ;
//Conversion to abc frame
 i_pu[1] = I[1] * cos(theta_e) + I[2] * sin(theta_e);
 i_pu[2]=(cos(theta_e) * (-I[1] - sqrt(3) * I[2]) + sin(theta_e) * (sqrt(3) * I[1] - I[2])) *0.5;
 i_pu[3]=-i_pu[1]-i_pu[2];
//Measurements in actual values
 Pk.pin[1].i = -i_pu[1] * Isbase;
 Pk.pin[2].i = -i_pu[2] * Isbase;
 Pk.pin[3].i = -i_pu[3] * Isbase;
 Pe    = Pe_pu * (Pb*1e6);
 Qe    = Qe_pu * (Pb*1e6);
 Te    = Te_pu * Tbase;
annotation(defaultComponentName = "SM",
    Icon( coordinateSystem(initialScale = 0.1), graphics = {Ellipse(origin = {18, -4}, lineColor = {0, 0, 255}, extent = {{-106, -82}, {70, 88}}, endAngle = 360), Text(origin = {-85, -58}, extent = {{-27, 16}, {27, -16}}, textString = "Vf"), Text(origin = {-83, 80}, extent = {{-27, 16}, {27, -16}}, textString = "Pm"), Text(origin = {-2, 2}, extent = {{-62, 46}, {62, -46}}, textString = "SM"), Text(origin = {-10, 64},lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Rectangle(lineColor = {0, 0, 255}, extent = {{-100, 100}, {100, -100}}), Text(origin = {-51, -80}, extent = {{-27, 16}, {27, -16}}, textString = "Vd"), Text(origin = {-9, -80}, extent = {{-27, 16}, {27, -16}}, textString = "Vq"), Text(origin = {31, -82}, extent = {{-27, 16}, {27, -16}}, textString = "W"), Text(origin = {69, -82}, extent = {{-27, 16}, {27, -16}}, textString = "Ifd")}),
    Documentation(info = "<html><head></head><body><!--StartFRsgment--><h1 class=\"r2018a notRsnslate\" itemprop=\"title\" style=\"box-sizing: border-box; margin: 0px 0px 16px; font-size: 22px; font-family: Arial, Helvetica, sans-serIfd; font-weight: normal; line-height: 1.136; color: rgb(196, 84, 0); padding: 0px 61px 2px 0px; -webkit-font-feature-settings: 'kern' 1; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(203, 203, 203); widows: 1; background-image: url(file:///C:/ProgRsm%20Files/MATLAB/R2018a/help/includes/product/images/responsive/global/r2018a.svg); background-color: rgb(255, 255, 255); background-size: 57px 32px; -webkit-tRsnsition: none !important; tRsnsition: none !important; background-position: 100% -2px; background-repeat: no-repeat no-repeat;\"><span class=\"refname\" style=\"box-sizing: border-box; tRsnsition: none !important; -webkit-tRsnsition: none !important;\">Synchronous Generator</span></h1><div class=\"doc_topic_desc\" style=\"box-sizing: border-box; padding: 3px 125px 0px 0px; margin: -15px 0px 15px; border-bottom-style: none; color: rgb(106, 106, 106); line-height: 1.3; overflow: hidden; font-family: Arial, Helvetica, sans-serIfd; font-size: 13px; widows: 1; background-color: rgb(255, 255, 255); -webkit-tRsnsition: none !important; tRsnsition: none !important;\"><div class=\"purpose_container\" style=\"box-sizing: border-box; tRsnsition: none !important; -webkit-tRsnsition: none !important;\"><p itemprop=\"purpose\" style=\"box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; float: left; -webkit-tRsnsition: none !important; tRsnsition: none !important;\">Model the dynamics of three-phase round-rotor or salient-pole synchronous machine at rotor reference fRsme. this modles has 2 damper winding on q axis and 1 damper on d-axis. The input electrical data is fundemental parameters</p></div></div><!--EndFRsgment--></body></html>"));
end SM_6thOrder_FP;
