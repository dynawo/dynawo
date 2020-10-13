within OpenEMTP.Electrical.Exciters_Governor;
model Governor_IEEEG1
 parameter Real Pref (unit = "PU") =1     "Reference power"
    annotation (Dialog(tab="Governer"));
 parameter Real K (unit = "PU", min=5, max=30)=20        "Gain K"
    annotation (Dialog(tab="Governer"));
 parameter Real T1 (unit = "S", min=Modelica.Constants.eps, max=5) =Modelica.Constants.eps        "Lag time constant T1"
    annotation (Dialog(tab="Governer"));
 parameter Real T2 (unit = "S") =0       "Lead time constant T2"
    annotation (Dialog(tab="Governer"));
 parameter Real T3 (unit = "S") =0.075   "Time constant T3"
    annotation (Dialog(tab="Governer"));
 parameter Real U0 (unit = "PU/S") =0.6786  "Maximum opening velocity U0 "
    annotation (Dialog(tab="Governer"));
 parameter Real UC (unit = "PU/S") =-1      "Maximum closing velocity UC "
    annotation (Dialog(tab="Governer"));
 parameter Real PMAX (unit = "PU") =0.9   "Maximum valve opening PMAX "
    annotation (Dialog(tab="Governer"));
 parameter Real PMIN (unit = "PU") =0.0   "Maximum valve opening PMin "
    annotation (Dialog(tab="Governer"));

 parameter Real T4 (unit = "S") =0.3   "Time constant T4"
    annotation (Dialog(tab="Turbine"));
 parameter Real T5 (unit = "S") =10   "Time constant T5"
    annotation (Dialog(tab="Turbine"));
 parameter Real T6 (unit = "S") =0.6   "Time constant T6"
    annotation (Dialog(tab="Turbine"));
 parameter Real T7 (unit = "S", min=Modelica.Constants.eps, max=10) =Modelica.Constants.eps    "Time constant T7"
    annotation (Dialog(tab="Turbine"));
 parameter Real K1 (unit = "PU") =0.2   "HP power fraction K1"
    annotation (Dialog(tab="Turbine"));
 parameter Real K3 (unit = "PU") =0.4   "HP power fraction K3"
    annotation (Dialog(tab="Turbine"));
 parameter Real K5 (unit = "PU") =0.4   "HP power fraction K5"
    annotation (Dialog(tab="Turbine"));
 parameter Real K7 (unit = "PU") =0.0   "HP power fraction K7"
    annotation (Dialog(tab="Turbine"));
 parameter Real K2 (unit = "PU") =0.0   "LP power fraction K2"
    annotation (Dialog(tab="Turbine"));
 parameter Real K4 (unit = "PU") =0.0   "LP power fraction K4"
    annotation (Dialog(tab="Turbine"));
 parameter Real K6 (unit = "PU") =0.0   "LP power fraction K6"
    annotation (Dialog(tab="Turbine"));
 parameter Real K8 (unit = "PU") =0.0   "LP power fraction K8"
    annotation (Dialog(tab="Turbine"));
 Modelica.Blocks.Interfaces.RealInput W annotation (
    Placement(visible = true, transformation(origin={-122,-60},    extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-120, 74},    extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Math.Feedback feedback annotation (
    Placement(visible = true, transformation(origin = {-138, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant const(k = 1)  annotation (
    Placement(visible = true, transformation(origin = {-192, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {T1, 1}, b = {T2, 1})  annotation (
    Placement(visible = true, transformation(origin = {-58, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain(k = K)  annotation (
    Placement(visible = true, transformation(origin = {-98, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Add3 add3(k3 = -1)  annotation (
    Placement(visible = true, transformation(origin = {-18, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain1(k = 1 / T3) annotation (
    Placement(visible = true, transformation(origin = {22, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = U0, uMin = UC)  annotation (
    Placement(visible = true, transformation(origin = {54, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder(T = T4, k = 1, y_start = Pref)  annotation (
    Placement(visible = true, transformation(origin = {148, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain2(k=K2)       annotation (
    Placement(visible = true, transformation(origin = {180, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Math.Gain gain3(k=K1)       annotation (
    Placement(visible = true, transformation(origin = {180, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = T5, k = 1, y_start = Pref) annotation (
    Placement(visible = true, transformation(origin = {214, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder2(T=T6,   k = 1, y_start = Pref) annotation (
    Placement(visible = true, transformation(origin = {274, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder3(T=T7,   k = 1, y_start = Pref) annotation (
    Placement(visible = true, transformation(origin = {334, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain4(k=K4)       annotation (
    Placement(visible = true, transformation(origin = {240, -92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Math.Gain gain5(k=K3)       annotation (
    Placement(visible = true, transformation(origin = {240, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Math.Gain gain6(k=K6)       annotation (
    Placement(visible = true, transformation(origin = {300, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Math.Gain gain7(k=K5)       annotation (
    Placement(visible = true, transformation(origin = {300, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Math.Gain gain8(k=K8)       annotation (
    Placement(visible = true, transformation(origin = {360, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Blocks.Math.Gain gain9(k=K7)       annotation (
    Placement(visible = true, transformation(origin = {360, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{248,76},{268,96}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{310,76},{330,96}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{368,76},{388,96}})));
  Modelica.Blocks.Math.Add add4
    annotation (Placement(transformation(extent={{248,-144},{268,-124}})));
  Modelica.Blocks.Math.Add add5
    annotation (Placement(transformation(extent={{310,-144},{330,-124}})));
  Modelica.Blocks.Math.Add add6
    annotation (Placement(transformation(extent={{368,-144},{388,-124}})));
  Modelica.Blocks.Math.Add add7
    annotation (Placement(transformation(extent={{416,-32},{436,-12}})));
  Modelica.Blocks.Interfaces.RealOutput Pm annotation (Placement(visible = true,transformation(extent = {{488, -32}, {508, -12}}, rotation = 0), iconTransformation(extent = {{100, 20}, {120, 40}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmHP annotation (Placement(visible = true,transformation(extent = {{504, 12}, {524, 32}}, rotation = 0), iconTransformation(extent = {{100, -20}, {120, 0}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput g_Pos annotation (Placement(visible = true,transformation(extent = {{504, 108}, {524, 128}}, rotation = 0), iconTransformation(extent = {{100, 64}, {120, 84}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmLP annotation (Placement(visible = true,transformation(extent = {{504, -86}, {524, -66}}, rotation = 0), iconTransformation(extent = {{100, -60}, {120, -40}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = PMAX, uMin = PMIN) annotation(
    Placement(visible = true, transformation(origin = {114, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.Integrator integrator(y_start = Pref)  annotation(
    Placement(visible = true, transformation(origin = {84, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant Cons(k = Pref) annotation(
    Placement(visible = true, transformation(origin = {-72, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(const.y, feedback.u1) annotation(
    Line(points = {{-181, -20}, {-148, -20}, {-148, -20}, {-146, -20}}, color = {0, 0, 127}));
  connect(W, feedback.u2) annotation(
    Line(points = {{-122, -60}, {-138, -60}, {-138, -28}, {-138, -28}}, color = {0, 0, 127}));
  connect(gain.u, feedback.y) annotation(
    Line(points = {{-110, -20}, {-129, -20}}, color = {0, 0, 127}));
  connect(gain.y, transferFunction.u) annotation(
    Line(points = {{-87, -20}, {-70, -20}}, color = {0, 0, 127}));
  connect(transferFunction.y, add3.u2) annotation(
    Line(points = {{-47, -20}, {-30, -20}, {-30, -20}, {-30, -20}}, color = {0, 0, 127}));
  connect(add3.y, gain1.u) annotation(
    Line(points = {{-7, -20}, {8, -20}, {8, -20}, {10, -20}}, color = {0, 0, 127}));
  connect(gain1.y, limiter.u) annotation(
    Line(points = {{33, -20}, {40, -20}, {40, -20}, {42, -20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, firstOrder2.u) annotation(
    Line(points = {{225, -20}, {262, -20}}, color = {0, 0, 127}));
  connect(firstOrder1.u, firstOrder.y) annotation(
    Line(points = {{202, -20}, {160, -20}, {160, -20}, {159, -20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, firstOrder3.u) annotation(
    Line(points = {{285, -20}, {320, -20}, {320, -20}, {322, -20}}, color = {0, 0, 127}));
  connect(add.u1, gain3.y) annotation(
    Line(points = {{246, 92}, {180, 92}, {180, 61}}, color = {0, 0, 127}));
  connect(add.u2, gain5.y) annotation(
    Line(points = {{246, 80}, {240, 80}, {240, 59}}, color = {0, 0, 127}));
  connect(add1.u1, add.y) annotation(
    Line(points = {{308, 92}, {286, 92}, {286, 86}, {269, 86}}, color = {0, 0, 127}));
  connect(add1.u2, gain7.y) annotation(
    Line(points = {{308, 80}, {300, 80}, {300, 61}}, color = {0, 0, 127}));
  connect(add2.u2, gain9.y) annotation(
    Line(points = {{366, 80}, {360, 80}, {360, 61}}, color = {0, 0, 127}));
  connect(add2.u1, add1.y) annotation(
    Line(points = {{366, 92}, {344, 92}, {344, 86}, {331, 86}}, color = {0, 0, 127}));
  connect(gain3.u, firstOrder1.u) annotation(
    Line(points = {{180, 38}, {180, -20}, {202, -20}}, color = {0, 0, 127}));
  connect(gain2.u, firstOrder.y) annotation(
    Line(points = {{180, -78}, {180, -20}, {159, -20}}, color = {0, 0, 127}));
  connect(gain2.y, add4.u2) annotation(
    Line(points = {{180, -101}, {180, -140}, {246, -140}}, color = {0, 0, 127}));
  connect(add4.u1, gain4.y) annotation(
    Line(points = {{246, -128}, {240, -128}, {240, -103}}, color = {0, 0, 127}));
  connect(gain6.y, add5.u1) annotation(
    Line(points = {{300, -101}, {300, -128}, {308, -128}}, color = {0, 0, 127}));
  connect(add4.y, add5.u2) annotation(
    Line(points = {{269, -134}, {300, -134}, {300, -140}, {308, -140}}, color = {0, 0, 127}));
  connect(add6.u1, gain8.y) annotation(
    Line(points = {{366, -128}, {360, -128}, {360, -101}}, color = {0, 0, 127}));
  connect(add6.u2, add5.y) annotation(
    Line(points = {{366, -140}, {362, -140}, {362, -134}, {331, -134}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain5.u) annotation(
    Line(points = {{225, -20}, {240, -20}, {240, 36}}, color = {0, 0, 127}));
  connect(gain4.u, firstOrder2.u) annotation(
    Line(points = {{240, -80}, {240, -20}, {262, -20}}, color = {0, 0, 127}));
  connect(gain7.u, firstOrder3.u) annotation(
    Line(points = {{300, 38}, {300, -20}, {322, -20}}, color = {0, 0, 127}));
  connect(gain6.u, firstOrder3.u) annotation(
    Line(points = {{300, -78}, {300, -20}, {322, -20}}, color = {0, 0, 127}));
  connect(gain9.u, firstOrder3.y) annotation(
    Line(points = {{360, 38}, {360, -20}, {345, -20}}, color = {0, 0, 127}));
  connect(gain8.u, firstOrder3.y) annotation(
    Line(points = {{360, -78}, {360, -20}, {345, -20}}, color = {0, 0, 127}));
  connect(add2.y, add7.u1) annotation(
    Line(points = {{389, 86}, {402, 86}, {402, -16}, {414, -16}}, color = {0, 0, 127}));
  connect(add7.u2, add6.y) annotation(
    Line(points = {{414, -28}, {402, -28}, {402, -134}, {389, -134}}, color = {0, 0, 127}));
  connect(add7.y, Pm) annotation(
    Line(points = {{437, -22}, {498, -22}}, color = {0, 0, 127}));
  connect(PmHP, add2.y) annotation(
    Line(points = {{514, 22}, {442, 22}, {442, 86}, {388, 86}, {388, 86}, {390, 86}}, color = {0, 0, 127}));
  connect(PmLP, add6.y) annotation(
    Line(points = {{514, -76}, {442, -76}, {442, -134}, {390, -134}, {390, -134}}, color = {0, 0, 127}));
  connect(g_Pos, firstOrder.u) annotation(
    Line(points = {{514, 118}, {134, 118}, {134, -20}, {136, -20}}, color = {0, 0, 127}));
  connect(integrator.u, limiter.y) annotation(
    Line(points = {{72, -20}, {66, -20}}, color = {0, 0, 127}));
  connect(integrator.y, limiter1.u) annotation(
    Line(points = {{95, -20}, {102, -20}}, color = {0, 0, 127}));
  connect(limiter1.y, firstOrder.u) annotation(
    Line(points = {{125, -20}, {136, -20}}, color = {0, 0, 127}));
  connect(add3.u3, firstOrder.u) annotation(
    Line(points = {{-30, -28}, {-40, -28}, {-40, -60}, {134, -60}, {134, -20}, {136, -20}}, color = {0, 0, 127}));
 connect(Cons.y, add3.u1) annotation(
    Line(points = {{-60, 34}, {-40, 34}, {-40, -12}, {-30, -12}, {-30, -12}}, color = {0, 0, 127}));
protected
 annotation (Diagram(graphics = {Text(lineColor = {28, 108, 200}, extent = {{-46, 202}, {200, 130}}, textString = "Governor-Turbine IEEEG1 (pu)")}, coordinateSystem(initialScale = 0.1)), Icon(graphics = {Rectangle(lineColor = {28, 108, 200}, extent = {{-100, 100}, {100, -100}}), Text(origin = {-6, 8},lineColor = {28, 108, 200}, extent = {{-60, 26}, {38, -36}}, textString = "IEEEG1"), Text(origin = {-14, 24}, extent = {{-90, 62}, {-56, 42}}, textString = "w"), Text(origin = {146, -100}, extent = {{-90, 62}, {-56, 42}}, textString = "PmLP"), Text(origin = {148, -62}, extent = {{-90, 62}, {-56, 42}}, textString = "PmHP"), Text(origin = {152, -20}, extent = {{-90, 62}, {-56, 42}}, textString = "Pm"), Text(origin = {150, 22}, extent = {{-90, 62}, {-56, 42}}, textString = "g pos")}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
 __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ",
 __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
 Documentation(info = "<html><head></head><body><ul><li><em>2020-02-04 &nbsp;&nbsp;</em>&nbsp;by Alireza Masoom initially implemented</li></ul></body></html>"));
end Governor_IEEEG1;
