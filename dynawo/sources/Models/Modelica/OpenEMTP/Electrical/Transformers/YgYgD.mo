within OpenEMTP.Electrical.Transformers;
model YgYgD "3-phase 3-Winding transformer YgYgD"
  //3-phase data parameters in PU
  import Modelica.Constants.pi;
  parameter Real S[3](each unit = "MVA") "Nominal power {S1,S2,S2}";
  parameter Modelica.SIunits.Frequency f(start = 60) "Nominal frequency";
  parameter Real v[3](each unit = "kV RMSLL") " Nominal voltage {V1,V2,V3}";
  parameter Real R[3](each unit = "PU") "Winding R {R12,R13,R23}";
  parameter Real X[3](each unit = "PU") "Winding X {X12,X13,X23}";
  parameter Real MD[:, 2] = [0.002, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 2., 1.72] "Saturation characteristic [ i1(PU) ,  phi1(PU) ;  i2 , phi2 ; ... ]";
  parameter Real Rmg(unit = "PU", start = 500) " Core loss resistance";

// base parameters
  // S_common=S[1]
  final parameter Real Z_b1 = v[1] ^ 2 / S[1] "Impedance base side 1";
  final parameter Real Z_b2 = v[2] ^ 2 / S[1] "Impedance base side 2";
  final parameter Real Z_b3 = v[3] ^ 2 / S[1] "Impedance base side 3";
  final parameter Real i_b1 = 1000 * S[1] / (sqrt(3) * v[1]) "Base current side 1";
    //Actual parameters
  final parameter Real R1 = (1/2) * (R[1]/S[1]+R[2]/S[2]-R[3]/S[3]) * S[1] * Z_b1 "Resistance on side 1";
  final parameter Real R2 = (1/2) * (R[1]/S[1]-R[2]/S[2]+R[3]/S[3]) * S[1] * Z_b2 "Resistance on side 2";
  final parameter Real R3 = (3/2) * (-R[1]/S[1]+R[2]/S[2]+R[3]/S[3])* S[1] * Z_b3 "Resistance on side 3";
  final parameter Real L1 = (1/2) * (X[1]/S[1]+X[2]/S[2]-X[3]/S[3]) * S[1] * Z_b1/(2*pi*f) "Inductance on side 1";
  final parameter Real L2 = (1/2) * (X[1]/S[1]-X[2]/S[2]+X[3]/S[3]) * S[1] * Z_b2/(2*pi*f) "Inductance on side 2";
  final parameter Real L3 = (3/2) * (-X[1]/S[1]+X[2]/S[2]+X[3]/S[3])* S[1] * Z_b3/(2*pi*f) "Inductance on side 3";
  final parameter Real RatioYY = (v[2] / v[1]);
  final parameter Real RatioYD = (sqrt(3)*v[3]) / v[1];
  final parameter Real Rm =  Rmg * Z_b1 "Magnetizating resistance on side 1";
  final parameter Real im[:] = sqrt(2) * i_b1 * MD[:, 1];
  final parameter Real Phim[:] = (1000 * sqrt(2) * v[1] * MD[:, 2]) / (2 * pi * f * sqrt(3));
  final parameter Real MDD[:, 2] = [im, Phim];

  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation (
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug m annotation (
    Placement(visible = true, transformation(origin = {122, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation (
    Placement(visible = true, transformation(origin = {108, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation (
    Placement(visible = true, transformation(origin = {-120, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin = {146, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit transformer1_a(final g = RatioYY)  annotation (
    Placement(visible = true, transformation(origin = {0, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit transformer2_a(final g = RatioYD)  annotation (
    Placement(visible = true, transformation(origin = {12, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL1_a(L = L1, R = R1)  annotation (
    Placement(visible = true, transformation(origin = {-68, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R Rmag_a(R = Rm)  annotation (
    Placement(visible = true, transformation(origin = {-50, 72}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Nonlinear.L_Nonlinear Lmag_a(final T = MDD)  annotation (
    Placement(visible = true, transformation(origin = {-32, 72}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.RL RL2_a(L = L2, R = R2)  annotation (
    Placement(visible = true, transformation(origin = {50, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL3_a(L = L3, R = R3)  annotation (
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL2_b(L = L2, R = R2)  annotation (
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit transformer2_b(final g = RatioYD)  annotation (
    Placement(visible = true, transformation(origin = {12, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit transformer1_b(final g = RatioYY)  annotation (
    Placement(visible = true, transformation(origin = {0, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Nonlinear.L_Nonlinear Lmag_b(final T = MDD)  annotation (
    Placement(visible = true, transformation(origin = {-26, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.R Rmag_b(final R = Rm)  annotation (
    Placement(visible = true, transformation(origin = {-42, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.RL RL1_b(L = L1, R = R1)  annotation (
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL2_c(L = L2, R = R2)  annotation (
    Placement(visible = true, transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit transforme1_c(final g = RatioYY)  annotation (
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit transformer2_c(final g = RatioYD)  annotation (
    Placement(visible = true, transformation(origin = {12, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Nonlinear.L_Nonlinear Lmag_c(final T = MDD)  annotation (
    Placement(visible = true, transformation(origin = {-24, -100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.R Rmag_c(final R = Rm)  annotation (
    Placement(visible = true, transformation(origin = {-40, -100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.RLC_Branches.RL RL1_c(L = L1, R = R1)  annotation (
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL3_b(L = L3, R = R3)  annotation (
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.RL RL3_c(final L = L3, final R = R3)  annotation (
    Placement(visible = true, transformation(origin = {50, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_1a(k = 1, m = 3) annotation (
    Placement(visible = true, transformation(origin = {-90, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_1b(k = 2, m = 3) annotation (
    Placement(visible = true, transformation(origin = {-76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_1c(k = 3, m = 3) annotation (
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_2a(k = 1, m = 3) annotation (
    Placement(visible = true, transformation(origin = {96, 92}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_2b(k = 2, m = 3) annotation (
    Placement(visible = true, transformation(origin = {88, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_2c(k = 3, m = 3)
                                                                      annotation (
    Placement(visible = true, transformation(origin = {94, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_3b(k = 2, m = 3) annotation (
    Placement(visible = true, transformation(origin = {74, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_3c(k = 3, m = 3) annotation (
    Placement(visible = true, transformation(origin = {84, -120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_3a(k = 1, m = 3) annotation (
    Placement(visible = true, transformation(origin = {94, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(Ph_1b.plug_p, k) annotation (
    Line(points = {{-78, 0}, {-102, 0}, {-102, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(Ph_1a.plug_p, k) annotation (
    Line(points = {{-92, 92}, {-100, 92}, {-100, 0}, {-100, 0}}, color = {0, 0, 255}));



  connect(Ph_1c.plug_p, k) annotation (
    Line(points = {{-92, -80}, {-100, -80}, {-100, 0}, {-100, 0}}, color = {0, 140, 72}));
  connect(Ph_2a.plug_p, m) annotation (
    Line(points = {{98, 92}, {122, 92}, {122, 0}, {122, 0}}, color = {238, 46, 47}, thickness = 0.5));
  connect(Ph_2b.plug_p, m) annotation (
    Line(points = {{90, 0}, {122, 0}, {122, 0}, {122, 0}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Ph_2c.plug_p, m) annotation (
    Line(points = {{96, -80}, {122, -80}, {122, 0}, {122, 0}}, color = {0, 140, 72}, thickness = 0.5));
  connect(Ph_3c.plug_p, p) annotation (
    Line(points = {{86, -120}, {108, -120}, {108, -120}, {108, -120}}, color = {0, 140, 72}, thickness = 1));
  connect(Ph_3b.plug_p, p) annotation (
    Line(points = {{76, -40}, {108, -40}, {108, -120}, {108, -120}}, color = {0, 0, 255}, thickness = 1));
  connect(Ph_3a.plug_p, p) annotation (
    Line(points = {{96, 50}, {130, 50}, {130, -120}, {108, -120}}, color = {238, 46, 47}, thickness = 1));
  connect(transformer2_a.n2, Ph_3b.pin_p) annotation (
    Line(points = {{22, 30}, {72, 30}, {72, -40}}, color = {0, 0, 255}, thickness = 1));
  connect(transformer2_b.n2, Ph_3c.pin_p) annotation (
    Line(points = {{22, -60}, {82, -60}, {82, -120}}, color = {0, 140, 72}, thickness = 1));
  connect(transformer2_c.n2, RL3_a.n) annotation (
    Line(points = {{22, -140}, {68, -140}, {68, 50}, {60, 50}}, color = {238, 46, 47}, thickness = 1));
  connect(Ph_3a.pin_p, RL3_a.n) annotation (
    Line(points = {{92, 50}, {60, 50}, {60, 50}, {60, 50}}, color = {238, 46, 47}, thickness = 1));
  connect(Ph_3c.pin_p, RL3_c.n) annotation (
    Line(points = {{82, -120}, {60, -120}, {60, -120}, {60, -120}}, color = {0, 140, 72}, thickness = 1));
  connect(RL3_c.p, transformer2_c.p2) annotation (
    Line(points = {{40, -120}, {22, -120}}, color = {0, 140, 72}, thickness = 1));
  connect(transformer2_b.p2, RL3_b.p) annotation (
    Line(points = {{22, -40}, {40, -40}}, color = {0, 0, 255}, thickness = 1));
  connect(RL3_b.n, Ph_3b.pin_p) annotation (
    Line(points = {{60, -40}, {72, -40}, {72, -40}, {72, -40}}, color = {0, 0, 255}, thickness = 1));
  connect(RL3_a.p, transformer2_a.p2) annotation (
    Line(points = {{40, 50}, {22, 50}}, color = {238, 46, 47}, thickness = 1));
  connect(RL2_a.n, Ph_2a.pin_p) annotation (
    Line(points = {{60, 92}, {94, 92}, {94, 92}, {94, 92}}, color = {238, 46, 47}, thickness = 0.5));
  connect(RL2_a.p, transformer1_a.p2) annotation (
    Line(points = {{40, 92}, {10, 92}, {10, 82}, {10, 82}}, color = {238, 46, 47}, thickness = 0.5));
  connect(Ph_2b.pin_p, RL2_b.n) annotation (
    Line(points = {{86, 0}, {60, 0}, {60, 0}, {60, 0}}, color = {0, 0, 255}, thickness = 0.5));
  connect(RL2_b.p, transformer1_b.p2) annotation (
    Line(points = {{40, 0}, {10, 0}, {10, -8}, {10, -8}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Ph_2c.pin_p, RL2_c.n) annotation (
    Line(points = {{92, -80}, {60, -80}, {60, -80}, {60, -80}}, color = {0, 140, 72}, thickness = 0.5));
  connect(RL2_c.p, transforme1_c.p2) annotation (
    Line(points = {{40, -80}, {10, -80}, {10, -90}, {10, -90}, {10, -90}}, color = {0, 140, 72}, thickness = 0.5));
  connect(transformer1_a.n2, ground.p) annotation (
    Line(points = {{10, 62}, {146, 62}, {146, -120}, {146, -120}}, thickness = 0.5));
  connect(transforme1_c.n2, ground.p) annotation (
    Line(points = {{10, -110}, {146, -110}, {146, -120}, {146, -120}}, thickness = 0.5));
  connect(transformer1_b.n2, ground.p) annotation (
    Line(points = {{10, -28}, {146, -28}, {146, -120}, {146, -120}}, thickness = 0.5));
  connect(transformer2_c.p1, transforme1_c.p1) annotation (
    Line(points = {{2, -120}, {-12, -120}, {-12, -90}, {-10, -90}}, color = {0, 140, 72}));
  connect(transformer2_c.n1, transforme1_c.n1) annotation (
    Line(points = {{2, -140}, {-16, -140}, {-16, -110}, {-10, -110}}));
  connect(transformer2_b.p1, transformer1_b.p1) annotation (
    Line(points = {{2, -40}, {-14, -40}, {-14, -8}, {-10, -8}, {-10, -8}}, color = {0, 0, 255}));
  connect(transformer2_b.n1, transformer1_b.n1) annotation (
    Line(points = {{2, -60}, {-16, -60}, {-16, -28}, {-10, -28}, {-10, -28}}));
  connect(transformer2_a.p1, transformer1_a.p1) annotation (
    Line(points = {{2, 50}, {-16, 50}, {-16, 82}, {-10, 82}, {-10, 82}}, color = {238, 46, 47}));
  connect(transformer2_a.n1, transformer1_a.n1) annotation (
    Line(points = {{2, 30}, {-20, 30}, {-20, 62}, {-10, 62}, {-10, 62}}));
  connect(RL1_a.n, transformer1_a.p1) annotation (
    Line(points = {{-58, 92}, {-10, 92}, {-10, 82}}, color = {238, 46, 47}));
  connect(RL1_a.p, Ph_1a.pin_p) annotation (
    Line(points = {{-78, 92}, {-88, 92}}, color = {238, 46, 47}));
  connect(Lmag_a.p, RL1_a.n) annotation (
    Line(points = {{-32, 82}, {-32, 92}, {-58, 92}}, color = {238, 46, 47}));
  connect(Rmag_a.p, RL1_a.n) annotation (
    Line(points = {{-50, 82}, {-52, 82}, {-52, 92}, {-58, 92}, {-58, 92}}, color = {238, 46, 47}));
  connect(transformer1_a.n1, Lmag_a.n) annotation (
    Line(points = {{-10, 62}, {-32, 62}}));
  connect(Lmag_a.n, Rmag_a.n) annotation (
    Line(points = {{-32, 62}, {-50, 62}}, color = {0, 0, 255}));
  connect(Rmag_a.n, ground1.p) annotation (
    Line(points = {{-50, 62}, {-120, 62}, {-120, -120}, {-120, -120}}));
  connect(Lmag_b.n, Rmag_b.n) annotation (
    Line(points = {{-26, -28}, {-42, -28}, {-42, -28}, {-42, -28}}, color = {0, 0, 255}));
  connect(transformer1_b.n1, Lmag_b.n) annotation (
    Line(points = {{-10, -28}, {-26, -28}, {-26, -28}, {-26, -28}}));
  connect(Rmag_b.n, ground1.p) annotation (
    Line(points = {{-42, -28}, {-120, -28}, {-120, -120}, {-120, -120}}));
  connect(transforme1_c.n1, Lmag_c.n) annotation (
    Line(points = {{-10, -110}, {-24, -110}, {-24, -110}, {-24, -110}}));
  connect(Lmag_c.n, Rmag_c.n) annotation (
    Line(points = {{-24, -110}, {-40, -110}, {-40, -110}, {-40, -110}}, color = {0, 0, 255}));
  connect(Rmag_c.n, ground1.p) annotation (
    Line(points = {{-40, -110}, {-120, -110}, {-120, -120}, {-120, -120}}));
  connect(RL1_b.n, Rmag_b.p) annotation (
    Line(points = {{-50, 0}, {-42, 0}, {-42, -8}, {-42, -8}}, color = {0, 0, 255}));
  connect(RL1_b.n, Lmag_b.p) annotation (
    Line(points = {{-50, 0}, {-26, 0}, {-26, -8}, {-26, -8}}, color = {0, 0, 255}));
  connect(RL1_b.n, transformer1_b.p1) annotation (
    Line(points = {{-50, 0}, {-10, 0}, {-10, -8}, {-10, -8}}, color = {0, 0, 255}));
  connect(RL1_c.p, Ph_1c.pin_p) annotation (
    Line(points = {{-80, -80}, {-88, -80}}, color = {0, 140, 72}));
  connect(RL1_c.n, Rmag_c.p) annotation (
    Line(points = {{-60, -80}, {-40, -80}, {-40, -90}, {-40, -90}}, color = {0, 140, 72}));
  connect(RL1_c.n, Lmag_c.p) annotation (
    Line(points = {{-60, -80}, {-24, -80}, {-24, -90}, {-24, -90}}, color = {0, 140, 72}));
  connect(RL1_c.n, transforme1_c.p1) annotation (
    Line(points = {{-60, -80}, {-10, -80}, {-10, -90}, {-10, -90}}, color = {0, 140, 72}));
  annotation (
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-01 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "YgYgD", Icon(graphics={  Text(origin = {-91, -25}, extent = {{-9, 9}, {9, -9}}, textString = "1"), Ellipse(origin = {44, 31}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Line(origin = {68.449, 27.6164}, points = {{8.1422, 0}, {26.1422, 0}}, color = {0, 0, 255}), Line(origin = {-4.78261, -1.30435}, points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Line(origin = {-4.78261, -1.30435}, points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(origin = {-4.78261, -1.30435}, points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Ellipse(origin = {-24, 9}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Line(origin = {-85, 0}, points = {{13, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {-4.78261, -1.30435}, points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(origin = {-4.78261, -1.30435}, points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Line(origin = {-4.78261, -1.30435}, points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Line(origin = {62.6611, 34.5271}, points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Line(origin = {62.6611, 34.5271}, points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(origin = {62.6611, 34.5271}, points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Line(origin = {62.6611, 34.5271}, points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(origin = {62.6611, 34.5271}, points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Line(origin = {62.6611, 34.5271}, points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Text(origin = {-4, 16}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Ellipse(origin = {44, -29}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Text(origin = {97, 11}, extent = {{-9, 9}, {9, -9}}, textString = "2"), Text(origin = {99, -59}, extent = {{-9, 9}, {9, -9}}, textString = "3"), Line(origin = {2.89533, -46.892}, points = {{22, 8}, {36, 0}}, color = {238, 46, 47}, thickness = 1), Line(origin = {2.57423, -47.8553}, points = {{24, -6}, {36, 0}}, color = {0, 140, 72}, thickness = 1), Line(origin = {-2.88447, -47.8553}, points = {{28, 8}, {28, -6}}, color = {28, 108, 200}, thickness = 1), Line(origin = {68.3805, -40.9178}, points = {{8.1422, 0}, {26.1422, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")),
    Diagram(graphics = {Text(origin = {-12, 118}, extent = {{-10, 8}, {36, -8}}, textString = "YgYgD")}, coordinateSystem(initialScale = 0.1)));
end YgYgD;
