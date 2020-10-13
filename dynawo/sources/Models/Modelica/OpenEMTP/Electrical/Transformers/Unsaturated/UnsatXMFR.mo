within OpenEMTP.Electrical.Transformers.Unsaturated;

model UnsatXMFR "Unsaturated three-phase Transformers, all configurations, parameters in PU"

  import Modelica.Constants.pi;
  parameter Integer Configuration (min=1,max=11) = 1
  annotation(choices(
                choice=1 "YgD01",
                choice=2 "YD01",
                choice=3 "YgD11",
                choice=4 "YD11",
                choice=5 "YgYg",
                choice=6 "YY",
                choice=7 "DD",
                choice=8 "DY11",
                choice=9 "DY01",
                choice=10 "DYg01",
                choice=11 "DYg11"));
  parameter Real S(unit = "MVA")= 20 "Nominal power";
  parameter Modelica.SIunits.Frequency f=60 "Nominal frequency";
  parameter Real v1(unit = "kV RMSLL")=315 "Winding 1 voltage";
  parameter Real v2(unit = "kV RMSLL")=120 "Winding 2 voltage";
  parameter Real R(unit = "PU")= 0.00375 "Winding R";
  parameter Real X(unit = "PU")= 0.015 "Winding X";
  parameter Real D= 0.9 "Winding impedance on winding 1";
  final parameter Integer C1 = if Configuration <= 6 then 1 else 3;
  // Y:C1=1 Delta: C1=3
  final parameter Integer C2 = if Configuration <= 4 then 3 elseif Configuration >= 5 and Configuration <= 6 then 1
   elseif Configuration == 7 then 3 else 1;
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
  final parameter Real Ratio =if Configuration <= 4 then (v2 / v1)*sqrt(3) elseif Configuration >= 5 and Configuration <= 7 then v2 / v1 else v2 /(sqrt(3) * v1) ;
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug m annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_a(k = 1, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-72, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_b(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_c(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_A(k = 1, m = 3) annotation(
    Placement(visible = true, transformation(origin = {60, 66}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_B(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_C(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {60, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(visible = true, transformation(origin = {-40, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.Unsaturated.UnsatNonIdl UnsatNonIdl_A(Lp = L1, Ls = L2, Rp = R1, Rs = R2, t = Ratio) annotation(
    Placement(visible = true, transformation(origin = {0, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.Unsaturated.UnsatNonIdl UnsatNonIdl_B(Lp = L1, Ls = L2, Rp = R1, Rs = R2, t = Ratio) annotation(
    Placement(visible = true, transformation(origin = {0, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.Unsaturated.UnsatNonIdl UnsatNonIdl_C(Lp = L1, Ls = L2, Rp = R1, Rs = R2, t = Ratio) annotation(
    Placement(visible = true, transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {40, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  if Configuration == 1 then //YgD01
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_a.plug_p, k);
    connect(UnsatNonIdl_B.Pin_i, Ph_b.pin_p);
    connect(Ph_b.plug_p, k);
    connect(UnsatNonIdl_C.Pin_i, Ph_c.pin_p);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_C.Pin_j, ground1.p);
    connect(UnsatNonIdl_B.Pin_j, ground1.p);
    connect(UnsatNonIdl_A.Pin_j, ground1.p);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(UnsatNonIdl_C.Pin_m, UnsatNonIdl_A.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_B.Pin_k);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(m, Ph_B.plug_p);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.plug_p, m);
  elseif Configuration == 2 then //YD01
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_a.plug_p, k);
    connect(UnsatNonIdl_B.Pin_i, Ph_b.pin_p);
    connect(Ph_b.plug_p, k);
    connect(UnsatNonIdl_C.Pin_i, Ph_c.pin_p);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(UnsatNonIdl_C.Pin_m, UnsatNonIdl_A.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_B.Pin_k);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(m, Ph_B.plug_p);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_B.Pin_j);
    connect(UnsatNonIdl_C.Pin_j, UnsatNonIdl_B.Pin_j);
  elseif Configuration == 3 then //YgD11
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_a.plug_p, k);
    connect(UnsatNonIdl_B.Pin_i, Ph_b.pin_p);
    connect(Ph_b.plug_p, k);
    connect(UnsatNonIdl_C.Pin_i, Ph_c.pin_p);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_C.Pin_j, ground1.p);
    connect(UnsatNonIdl_B.Pin_j, ground1.p);
    connect(UnsatNonIdl_A.Pin_j, ground1.p);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_A.Pin_k);
    connect(UnsatNonIdl_C.Pin_m, UnsatNonIdl_B.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_C.Pin_k);
  elseif Configuration == 4 then //YD11
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_a.plug_p, k);
    connect(UnsatNonIdl_B.Pin_i, Ph_b.pin_p);
    connect(Ph_b.plug_p, k);
    connect(UnsatNonIdl_C.Pin_i, Ph_c.pin_p);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_A.Pin_k);
    connect(UnsatNonIdl_C.Pin_m, UnsatNonIdl_B.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_C.Pin_k);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_B.Pin_j);
    connect(UnsatNonIdl_C.Pin_j, UnsatNonIdl_B.Pin_j);
  elseif Configuration == 5 then //YgYg
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_a.plug_p, k);
    connect(UnsatNonIdl_B.Pin_i, Ph_b.pin_p);
    connect(Ph_b.plug_p, k);
    connect(UnsatNonIdl_C.Pin_i, Ph_c.pin_p);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_C.Pin_j, ground1.p);
    connect(UnsatNonIdl_B.Pin_j, ground1.p);
    connect(UnsatNonIdl_A.Pin_j, ground1.p);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_m, ground.p);
    connect(UnsatNonIdl_B.Pin_m, ground.p);
    connect(UnsatNonIdl_C.Pin_m, ground.p);
  elseif Configuration == 6 then //YY
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_a.plug_p, k);
    connect(UnsatNonIdl_B.Pin_i, Ph_b.pin_p);
    connect(Ph_b.plug_p, k);
    connect(UnsatNonIdl_C.Pin_i, Ph_c.pin_p);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_B.Pin_j);
    connect(UnsatNonIdl_C.Pin_j, UnsatNonIdl_B.Pin_j);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_B.Pin_m);
    connect(UnsatNonIdl_C.Pin_m, UnsatNonIdl_B.Pin_m);
  elseif Configuration == 7 then //DD
    connect(Ph_a.plug_p, k);
    connect(Ph_b.plug_p, k);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_B.Pin_i);
    connect(Ph_b.pin_p, UnsatNonIdl_B.Pin_i);
    connect(UnsatNonIdl_B.Pin_j, UnsatNonIdl_C.Pin_i);
    connect(Ph_c.pin_p, UnsatNonIdl_C.Pin_i);
    connect(UnsatNonIdl_C.Pin_j, UnsatNonIdl_A.Pin_i);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_B.Pin_k);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_k);
    connect(UnsatNonIdl_C.Pin_m, UnsatNonIdl_A.Pin_k);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
  elseif Configuration == 8 then //DY11
    connect(Ph_a.plug_p, k);
    connect(Ph_b.plug_p, k);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_B.Pin_i);
    connect(Ph_b.pin_p, UnsatNonIdl_B.Pin_i);
    connect(UnsatNonIdl_B.Pin_j, UnsatNonIdl_C.Pin_i);
    connect(Ph_c.pin_p, UnsatNonIdl_C.Pin_i);
    connect(UnsatNonIdl_C.Pin_j, UnsatNonIdl_A.Pin_i);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_m);
  elseif Configuration == 9 then //DY01
    connect(Ph_a.plug_p, k);
    connect(Ph_b.plug_p, k);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_b.pin_p, UnsatNonIdl_B.Pin_i);
    connect(Ph_c.pin_p, UnsatNonIdl_C.Pin_i);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_C.Pin_i);
    connect(UnsatNonIdl_C.Pin_j, Ph_b.pin_p);
    connect(UnsatNonIdl_B.Pin_j, UnsatNonIdl_A.Pin_i);
  elseif Configuration == 10 then
//DYg01
    connect(Ph_a.plug_p, k);
    connect(Ph_b.plug_p, k);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(Ph_b.pin_p, UnsatNonIdl_B.Pin_i);
    connect(Ph_c.pin_p, UnsatNonIdl_C.Pin_i);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_C.Pin_i);
    connect(UnsatNonIdl_C.Pin_j, Ph_b.pin_p);
    connect(UnsatNonIdl_B.Pin_j, UnsatNonIdl_A.Pin_i);
    connect(ground.p, UnsatNonIdl_C.Pin_m);
  elseif Configuration == 11 then
//DYg11
    connect(Ph_a.plug_p, k);
    connect(Ph_b.plug_p, k);
    connect(Ph_c.plug_p, k);
    connect(UnsatNonIdl_A.Pin_k, Ph_A.pin_p);
    connect(Ph_A.plug_p, m);
    connect(m, Ph_B.plug_p);
    connect(Ph_C.plug_p, m);
    connect(UnsatNonIdl_A.Pin_i, Ph_a.pin_p);
    connect(UnsatNonIdl_A.Pin_j, UnsatNonIdl_B.Pin_i);
    connect(Ph_b.pin_p, UnsatNonIdl_B.Pin_i);
    connect(UnsatNonIdl_B.Pin_j, UnsatNonIdl_C.Pin_i);
    connect(Ph_c.pin_p, UnsatNonIdl_C.Pin_i);
    connect(UnsatNonIdl_C.Pin_j, UnsatNonIdl_A.Pin_i);
    connect(Ph_B.pin_p, UnsatNonIdl_B.Pin_k);
    connect(Ph_C.pin_p, UnsatNonIdl_C.Pin_k);
    connect(UnsatNonIdl_A.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(UnsatNonIdl_B.Pin_m, UnsatNonIdl_C.Pin_m);
    connect(ground.p, UnsatNonIdl_C.Pin_m);
 end if;
  annotation(
    Documentation(info = "<html><head></head><body><p>Configuration type:</p><p>&nbsp; &nbsp;choice=1 &nbsp;\"YgD01\",</p><p>&nbsp; &nbsp;choice=2 &nbsp;\"YD01\",</p><p>&nbsp; &nbsp;choice=3 &nbsp;\"YgD11\",</p><p>&nbsp; &nbsp;choice=4 &nbsp;\"YD11\",</p><p>&nbsp; &nbsp;choice=5 &nbsp;\"YgYg\",</p><p>&nbsp; &nbsp;choice=6 &nbsp;\"YY\",</p><p>&nbsp; &nbsp;choice=7 &nbsp;\"DD\",</p><p>&nbsp; &nbsp;choice=8 &nbsp;\"DY11\",</p><p>&nbsp; &nbsp;choice=9 &nbsp;\"DY01\",</p><p>&nbsp; &nbsp;choice=10 \"DYg01\",</p><p>&nbsp; &nbsp;choice=11 \"DYg11\"</p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-09-17 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "XMFR",
    Icon(graphics = {Text(origin = {-93, -23}, extent = {{-9, 9}, {17, -15}}, textString = "k"), Text(origin = {87, -23}, extent = {{-9, 9}, {13, -15}}, textString = "m"), Ellipse(origin = {42, 7}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Line(origin = {65.86, 0}, points = {{8.1422, 0}, {26.1422, 0}}, color = {0, 0, 255}), Ellipse(origin = {-24, 9}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Text(origin = {-2, 8}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-27, -11}, extent = {{-37, 35}, {9, -9}}, textString = "1"), Text(origin = {25, 13}, extent = {{-9, 9}, {35, -33}}, textString = "2"), Line(origin = {-98.8672, -0.136111}, points = {{8.1422, 0}, {26.1422, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")),
    Diagram(graphics = {Text(origin = {-12, 92}, extent = {{-10, 8}, {36, -8}}, textString = "XMFR")}, coordinateSystem(initialScale = 0.1)));
end UnsatXMFR;
