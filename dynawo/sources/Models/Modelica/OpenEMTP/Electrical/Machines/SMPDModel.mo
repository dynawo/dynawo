within OpenEMTP.Electrical.Machines;

model SMPDModel
 import PI=Modelica.Constants.pi;
Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

// Modelica.Blocks.Interfaces.RealInput Vfd=843.0707 annotation(
//    Placement(visible = true, transformation(origin = {-72, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 parameter Real Vfd=843.0707;
 parameter Real Ra  =0.1;
 parameter Real Rf  =0.2485506629E+00;
 parameter Real RQ1	=0.2802156577E+01;
 parameter Real Maf	=0.226427101368366;
 parameter Real MaQ	=0.213107860111403;
 parameter Real Lff	=1.739854640472860;
 parameter Real LQQ	=1.961509604106552;
 parameter Real Ls=0.044201306570197;
 parameter Real Ms=0.017364799009720;
 parameter Real Lm=0.001052412061195;
 parameter Real p=2 "Nomber of poles";
 parameter Real H=5	;
 Real beta;
 Real L11=Ls+Lm*cos(2*beta);
 Real L22=Ls+Lm*cos(2*(beta-2*PI/3));
 Real L33=Ls+Lm*cos(2*(beta+2*PI/3));

 Real L12=-Ms+Lm*cos(2*beta-2*PI/3), L21=L12;
 Real L13=-Ms+Lm*cos(2*beta+2*PI/3), L31=L13;
 Real L23=-Ms+Lm*cos(2*(beta)),L32=L23 ;

 Real L1f=Maf*cos(beta),Lf1=L1f;
 Real L2f=Maf*cos(beta-2*PI/3),Lf2=L2f;
 Real L3f=Maf*cos(beta+2*PI/3),Lf3=L3f;

 Real L1Q=MaQ*sin(beta), LQ1=L1Q;
 Real L2Q=MaQ*sin(beta-2*PI/3), LQ2=L2Q;
 Real L3Q=MaQ*sin(beta+2*PI/3), LQ3=L3Q;

 Real LfQ=0, LQf=LfQ;

 Real L[5,5]=
 [L11,   L12,  L13,  L1f,   L1Q;
  L21,   L22,  L23,  L2f,   L2Q;
  L31,   L32,  L33,  L3f,   L3Q;
  Lf1,   Lf2,  Lf3,  Lff,   LfQ;
  LQ1,   LQ2,  LQ3,  LQf,   LQQ];

 final parameter Real R[5,5] = diagonal({Ra , Ra , Ra , Rf ,RQ1 });

 Real V[5]={Pk.pin[1].v,Pk.pin[2].v,Pk.pin[3].v,-Vfd,0};
// Real V[5]={1000*i[1],1000*i[2],1000*i[3],-Vfd,0};
 Real i[5]; ////{ia, ib, ic,  ifd, iq1}

 Real Phi[5];     //{Phia, Phib, Phic,  Phifd, Phiq1}
// Real A[5,5] annotation(HideResult=false);
initial equation
//der(Phi) =zeros(5);
equation
V=-R*i-der(Phi);
Phi=L*i;
// der(Phi) = A * Phi -V;
// A        = - R * Modelica.Math.Matrices.inv(L) ;
// i        = Modelica.Math.Matrices.inv(L) * Phi;
// beta=PI*120*time;
 Tgen       = Phi[2] * I[1] - Phi[1] * I[2];
 Te=Tgen/Tbase;
 der(dw)  = (Pm / Wr - Te ) * (1 / 2 / H);
 Wr       = 1 + dw;
 der(d_theta) = dw*Wbase;
 theta_e      = d_theta + Wbase * time ;
 Pk.pin[1].i =i[1];
 Pk.pin[2].i =i[2];
 Pk.pin[3].i =i[3];
annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}));
end SMPDModel;
