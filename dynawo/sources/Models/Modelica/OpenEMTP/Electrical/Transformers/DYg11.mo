within OpenEMTP.Electrical.Transformers;
model DYg11  "DYg11/DYg+30 three phase transformer"

  //3-phase data parameters in PU
  import Modelica.Constants.pi;
  parameter Real S(unit = "MVA", start = 200) "Nominal power";
  parameter Modelica.SIunits.Frequency f(start = 60) "Nominal frequency";
  parameter Real v1(unit = "kV RMSLL", start = 315) "Winding 1 voltage";
  parameter Real v2(unit = "kV RMSLL", start = 120) "Winding 2 voltage";
  parameter Real R(unit = "PU", start = 0.00375) "Winding R";
  parameter Real X(unit = "PU", start = 0.015) "Winding X";
  parameter Real D(start = 0.9) "Winding impedance on winding 1";
  parameter Real MD[:, 2] = [0.002, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 2., 1.72] "Saturation characteristic [ i1(PU) ,  phi1(PU) ;  i2 , phi2 ; ... ]";
  parameter Real Rmg(unit = "PU", start = 500) " Core loss resistance";
  final parameter Integer C1 = 3;
  // Y:C1=1 Delta: C1=3
  final parameter Integer C2 = 1;
  // Y:C2=1 Delta: C2=3
  // base parameters
  final parameter Real Z_b1 = v1 ^ 2 / S "Impedance base side 1";
  final parameter Real Z_b2 = v2 ^ 2 / S "Impedance base side 2";
  final parameter Real i_b1 = 1000 * S / (sqrt(3) * v1) "Base current side 1";
    //Actual parameters
  final parameter Real R1 = C1 * R * Z_b1 * D "Resistance on side 1";
  final parameter Real R2 = C2 * R * Z_b2 * (1 - D) "Resistance on side 2";
  final parameter Real L1 = C1 * X * Z_b1 * D / (2 * pi * f) "Inductance on side 1";
  final parameter Real L2 = C2 * X * Z_b2 * (1 - D) / (2 * pi * f) "Inductance on side 2";
  final parameter Real Ratio = v2 /(sqrt(3) * v1);
  final parameter Real Rm = C1 * Rmg * Z_b1 "Magnetizating resistance on side 1";
  final parameter Real im[:] = sqrt(2/3) * i_b1 * MD[:, 1];
  final parameter Real Phim[:] = (1000 * sqrt(2) * v1 * MD[:, 2]) / (2 * pi * f);
  final parameter Real MDD[:, 2] = [im, Phim];
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation (
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug m annotation (
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_a(k = 1, m = 3) annotation (
    Placement(visible = true, transformation(origin = {-72, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_b(k = 2, m = 3) annotation (
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_c(k = 3, m = 3) annotation (
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_A(k = 1, m = 3) annotation (
    Placement(visible = true, transformation(origin = {60, 66}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_B(k = 2, m = 3) annotation (
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_C(k = 3, m = 3) annotation (
    Placement(visible = true, transformation(origin = {60, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.Nonideal_Unit Nonideal_Unit_A(Lmag = MDD,Lp = L1, Ls = L2, Rmag = Rm, Rp = R1, Rs = R2, t = Ratio)  annotation (
    Placement(visible = true, transformation(origin = {0, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.Nonideal_Unit Nonideal_Unit_B(Lmag = MDD,Lp = L1, Ls = L2, Rmag = Rm, Rp = R1, Rs = R2, t = Ratio)  annotation (
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.Nonideal_Unit Nonideal_Unit_C(Lmag = MDD,Lp = L1, Ls = L2, Rmag = Rm, Rp = R1, Rs = R2, t = Ratio)  annotation (
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation (
    Placement(visible = true, transformation(origin = {40, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(Ph_a.plug_p, k) annotation (
    Line(points = {{-74, 66}, {-100, 66}, {-100, 0}, {-100, 0}}, color = {255, 0, 0}));
  connect(Ph_b.plug_p, k) annotation (
    Line(points = {{-72, 0}, {-98, 0}, {-98, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(Ph_c.plug_p, k) annotation (
    Line(points = {{-72, -60}, {-100, -60}, {-100, -2}, {-100, -2}, {-100, 0}}, color = {0, 140, 72}));
  connect(Nonideal_Unit_A.Pin_k, Ph_A.pin_p) annotation (
    Line(points = {{10, 66}, {58, 66}}, color = {238, 46, 47}, thickness = 0.5));
  connect(Ph_A.plug_p, m) annotation (
    Line(points = {{62, 66}, {100, 66}, {100, 0}, {100, 0}}, color = {238, 46, 47}, thickness = 0.5));
  connect(m, Ph_B.plug_p) annotation (
    Line(points = {{100, 0}, {62, 0}, {62, 0}, {62, 0}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Ph_C.plug_p, m) annotation (
    Line(points = {{62, -60}, {100, -60}, {100, 0}, {100, 0}}, color = {0, 140, 72}, thickness = 0.5));
  connect(Nonideal_Unit_A.Pin_i, Ph_a.pin_p) annotation (
    Line(points = {{-10, 66}, {-70, 66}, {-70, 66}, {-70, 66}}, color = {238, 46, 47}));
  connect(Nonideal_Unit_A.Pin_j, Nonideal_Unit_B.Pin_i) annotation (
    Line(points = {{-10, 46}, {-40, 46}, {-40, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(Ph_b.pin_p, Nonideal_Unit_B.Pin_i) annotation (
    Line(points = {{-68, 0}, {-10, 0}}, color = {0, 0, 255}));
  connect(Nonideal_Unit_B.Pin_j, Nonideal_Unit_C.Pin_i) annotation (
    Line(points = {{-10, -20}, {-40, -20}, {-40, -60}, {-10, -60}}, color = {0, 140, 72}));
  connect(Ph_c.pin_p, Nonideal_Unit_C.Pin_i) annotation (
    Line(points = {{-68, -60}, {-10, -60}, {-10, -60}, {-10, -60}}, color = {0, 140, 72}));
  connect(Nonideal_Unit_C.Pin_j, Nonideal_Unit_A.Pin_i) annotation (
    Line(points = {{-10, -80}, {-52, -80}, {-52, 66}, {-10, 66}, {-10, 66}}, color = {255, 0, 0}));
  connect(Ph_B.pin_p, Nonideal_Unit_B.Pin_k) annotation (
    Line(points = {{58, 0}, {10, 0}}, color = {0, 0, 255}, thickness = 0.5));
  connect(Ph_C.pin_p, Nonideal_Unit_C.Pin_k) annotation (
    Line(points = {{58, -60}, {10, -60}, {10, -60}, {10, -60}}, color = {0, 140, 72}, thickness = 0.5));
  connect(Nonideal_Unit_A.Pin_m, Nonideal_Unit_C.Pin_m) annotation (
    Line(points = {{10, 46}, {40, 46}, {40, -80}, {10, -80}, {10, -80}}, thickness = 0.5));
  connect(Nonideal_Unit_B.Pin_m, Nonideal_Unit_C.Pin_m) annotation (
    Line(points = {{10, -20}, {40, -20}, {40, -80}, {10, -80}, {10, -80}}, thickness = 0.5));
  connect(ground.p, Nonideal_Unit_C.Pin_m) annotation (
    Line(points = {{40, -86}, {40, -86}, {40, -80}, {10, -80}, {10, -80}}, thickness = 0.5));
  annotation (
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-01 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "DYg11", Icon(graphics = {Text(origin = {-91, -25}, extent = {{-9, 9}, {9, -9}}, textString = "k"), Text(origin = {91, -23}, extent = {{-9, 9}, {9, -9}}, textString = "m"), Text(origin = {-2, 8}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Ellipse(origin = {42, 9}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Ellipse(origin = {-24, 9}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Line(origin = {65.86, 0}, points = {{8.1422, 0}, {26.1422, 0}}, color = {0, 0, 255}), Line(origin = {-84.863, -0.287671}, points = {{13, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {-63.8444, -0.0016336}, points = {{22, 8}, {36, 0}}, color = {238, 46, 47}, thickness = 1), Line(origin = {-64.1655, -0.964937}, points = {{24, -6}, {36, 0}}, color = {0, 140, 72}, thickness = 1), Line(origin = {-69.6242, -0.964937}, points = {{28, 8}, {28, -6}}, color = {28, 108, 200}, thickness = 1), Line(origin = {69.5652, 0.869563}, points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(origin = {69.5652, 0.869563}, points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Line(origin = {69.5652, 0.869563}, points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Line(origin = {69.5652, 0.869563}, points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(origin = {69.5652, 0.869563}, points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Line(origin = {69.5652, 0.869563}, points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Text(origin = {-31, -25}, extent = {{-9, 9}, {9, -9}}, textString = "1"), Text(origin = {37, -25}, extent = {{-9, 9}, {9, -9}}, textString = "2")}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")),
    Diagram(graphics = {Text(origin = {8, 94}, extent = {{-54, 4}, {36, -8}}, textString = "Delta-Y transformer, +30 on secondary
Dyg11 connection"), Text(origin = {-14, 80}, extent = {{-10, 8}, {36, -8}}, textString = "3 identical non-ideal units")}, coordinateSystem(initialScale = 0.1)));
end DYg11;
