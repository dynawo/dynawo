within OpenEMTP.Examples.IEEE13Bus;
model UnsatSTC_XFMR
  import Modelica.SIunits.Resistance;
  import Modelica.SIunits.Inductance;
  parameter Real t "Turns ratio v2/v1";
  parameter Resistance Rp "Resisrance in primary side";
  parameter Inductance Lp "Inductance in primary side";
  parameter Resistance Rs "Resisrance in secondary side";
  parameter Inductance Ls "Inductance in secondary side";

  Modelica.Electrical.Analog.Interfaces.PositivePin Pin_i annotation (
    Placement(visible = true, transformation(origin = {-184, 46}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-98, 98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin Pin_j annotation (
    Placement(visible = true, transformation(origin = {-186, -6}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-98, -98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin Pin_k annotation (
    Placement(visible = true, transformation(origin = {114, 44}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {96, 100}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin Pin_m annotation (
    Placement(visible = true, transformation(origin = {114, -7}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {98, -98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  IdealUnit IdealXFMR(n = t)  annotation (
    Placement(visible = true, transformation(origin = {-12, 20}, extent = {{-32, -26}, {32, 26}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R1(R = Rp)  annotation (
    Placement(visible = true, transformation(origin = {-154, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor L1(L = Lp)  annotation (
    Placement(visible = true, transformation(origin = {-124, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R2(R = Rs)  annotation (
    Placement(visible = true, transformation(origin = {76, 44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor L2(L = Ls)  annotation (
    Placement(visible = true, transformation(origin = {40, 44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(IdealXFMR.Pin_j, Pin_j) annotation (
    Line(points={{-44,-6.52},{-116,-6.52},{-116,-6},{-186,-6}},
                                           color = {0, 0, 255}));
  connect(Pin_i, R1.p) annotation (
    Line(points = {{-184, 46}, {-164, 46}}, color = {0, 0, 255}));
  connect(R1.n, L1.p) annotation (
    Line(points = {{-144, 46}, {-134, 46}}, color = {0, 0, 255}));
  connect(L1.n, IdealXFMR.Pin_i) annotation (
    Line(points = {{-114, 46}, {-44, 46}}, color = {0, 0, 255}));
  connect(IdealXFMR.Pin_m, Pin_m) annotation (
    Line(points={{20,-5.48},{114,-5.48},{114,-7}},  color = {0, 0, 255}));
  connect(IdealXFMR.Pin_k, L2.n) annotation (
    Line(points={{20,45.48},{30,45.48},{30,44},{30,44}},    color = {0, 0, 255}));
  connect(R2.n, L2.p) annotation (
    Line(points = {{66, 44}, {50, 44}, {50, 44}, {50, 44}}, color = {0, 0, 255}));
  connect(R2.p, Pin_k) annotation (
    Line(points = {{86, 44}, {114, 44}}, color = {0, 0, 255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Text(extent = {{-150, -110}, {150, -150}}, textString = "n=%t"), Text(lineColor = {0, 0, 255}, extent = {{-100, 20}, {-60, -20}}, textString = "1"), Text(lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "2"), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Line(points = {{-40, 60}, {-40, 100}, {-90, 100}}, color = {0, 0, 255}), Line(points = {{40, 60}, {40, 100}, {90, 100}}, color = {0, 0, 255}), Line(points = {{-40, -60}, {-40, -100}, {-90, -100}}, color = {0, 0, 255}), Line(points = {{40, -60}, {40, -100}, {90, -100}}, color = {0, 0, 255}), Line(origin = {-33, 45}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, 15}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, -15}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, -45}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, 45}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, 15}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, -15}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, -45}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(origin = {-81, 1}, extent = {{-1, 1}, {1, -1}}, textString = "text"), Text(origin = {-8, 76}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "k"), Text(origin = {-10, -72}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "m"), Text(origin = {-154, 74}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "i"), Text(origin = {-150, -74}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "j")}),
    uses(Modelica(version="3.2.2")));
end UnsatSTC_XFMR;
