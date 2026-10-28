within Dynawo.Examples.IndexReduction;

model TestIndex


Real x1;
Real x2;
Real x3;
Real x4;
Real x5;
Real x6;
Real x7;
Real x8;
Real x9;
Real x10;
Real x11;
Real y1;
Real y2;
Real y4;
Real y10;
Real y16;
Real u1;
Real u2;
Real u3;
Real u4;
Real u5;
Real u6;

equation

x1 + x3 + x4 + x5 = 0.0;
x2 + x6 + x7 + x8 = 0.0;
0.01 * der(x1) = y1 ;
0.01 * der(x2) = y2 ;
der(x9)  = y4 - y1;
der(x10) = y10 - y1;
der(x11) = y16 - y1 ;
(y4 - y1) + 0.01 * x6 + 0.1 * der(x6)  = u4 - y2 ;
(y10 - y1) + 0.01 * x7 + 0.1 * der(x7) = u5 - y2 ;
(y16 - y1) + 0.01 * x8 + 0.1 * der(x8) = u6 - y2 ;
0.01 * x3 + 0.1 * der(x3) = u1 - y4 ;
0.01 * x4 + 0.1 * der(x4) = u2 - y10 ;
0.01 * x5 + 0.1 * der(x5) = u3 - y16 ;
x3 - 1/68135 * y4 + 1/68135 * y1 - 0.1 * x9  + x6 = 0.0 ;
x4 - 1/68135 * y10 + 1/68135 * y1 - 0.1 * x10 + x7 = 0.0 ;
x5 - 1/68135 * y16 + 1/68135 * y1 - 0.1 * x11 + x8 = 0.0 ;

u1 = cos(2* 3.14 * 50 * time);
u2 = cos(2* 3.14 * 50 * time - 2 * 3.14);
u3 = cos(2* 3.14 * 50 * time + 2 * 3.14);
u4 = cos(2* 3.14 * 50 * time + 0.04);
u5 = cos(2* 3.14 * 50 * time - 2 * 3.14 + 0.04);
u6 = cos(2* 3.14 * 50 * time + 2 * 3.14 + 0.04);

end TestIndex;
