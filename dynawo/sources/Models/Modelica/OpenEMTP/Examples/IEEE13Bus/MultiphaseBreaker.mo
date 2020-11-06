within OpenEMTP.Examples.IEEE13Bus;
model MultiphaseBreaker
  parameter Real Tclosing[3] "Closing Time {a,b,c}";
  parameter Real Topening[3] "Opening Time {a,b,c}";
  IdealBreaker idealBreaker1(Tclosing = Tclosing[1], Topening = Topening[1])  annotation(
    Placement(visible = true, transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlug1 annotation(
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.NegativePlug negativePlug1 annotation(
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p1(k = 1, m = 3)  annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p2(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p3(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-68, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IdealBreaker idealBreaker2(Tclosing = Tclosing[2], Topening = Topening[2])  annotation(
    Placement(visible = true, transformation(origin = {-28, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IdealBreaker idealBreaker3(Tclosing = Tclosing[3], Topening = Topening[3])  annotation(
    Placement(visible = true, transformation(origin = {-32, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_n plugToPin_n1(k = 1, m = 3)  annotation(
    Placement(visible = true, transformation(origin = {46, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_n plugToPin_n2(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {44, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_n plugToPin_n3(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {46, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(idealBreaker2.pin_p, plugToPin_p2.pin_p) annotation(
    Line(points = {{-38, 0}, {-68, 0}}, color = {0, 0, 255}));
  connect(idealBreaker1.pin_p, plugToPin_p1.pin_p) annotation(
    Line(points = {{-40, 60}, {-68, 60}}, color = {0, 0, 255}));
  connect(idealBreaker3.pin_p, plugToPin_p3.pin_p) annotation(
    Line(points = {{-42, -80}, {-66, -80}}, color = {0, 0, 255}));
  connect(plugToPin_p3.plug_p, positivePlug1) annotation(
    Line(points = {{-70, -80}, {-98, -80}, {-98, 0}}, color = {0, 0, 255}));
  connect(plugToPin_n3.plug_n, negativePlug1) annotation(
    Line(points = {{48, -80}, {96, -80}, {96, 0}}, color = {0, 0, 255}));
  connect(plugToPin_n2.plug_n, negativePlug1) annotation(
    Line(points = {{46, 0}, {96, 0}}, color = {0, 0, 255}));
  connect(plugToPin_p2.plug_p, positivePlug1) annotation(
    Line(points = {{-72, 0}, {-98, 0}}, color = {0, 0, 255}));
  connect(plugToPin_n1.plug_n, negativePlug1) annotation(
    Line(points = {{48, 60}, {96, 60}, {96, 0}, {96, 0}}, color = {0, 0, 255}));
  connect(plugToPin_p1.plug_p, positivePlug1) annotation(
    Line(points = {{-72, 60}, {-96, 60}, {-96, 0}, {-98, 0}}, color = {0, 0, 255}));
  connect(plugToPin_n1.pin_n, idealBreaker1.pin_n) annotation(
    Line(points = {{44, 60}, {-20, 60}, {-20, 62}, {-22, 62}}, color = {0, 0, 255}));
  connect(plugToPin_n2.pin_n, idealBreaker2.pin_n) annotation(
    Line(points = {{42, 0}, {-20, 0}, {-20, 2}, {-20, 2}}, color = {0, 0, 255}));
  connect(plugToPin_n3.pin_n, idealBreaker3.pin_n) annotation(
    Line(points = {{44, -80}, {-24, -80}, {-24, -78}, {-24, -78}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.2")),
    Icon(graphics = {Line(origin = {-35.1196, 20.1934}, points = {{-54.8804, -20.1934}, {-4.88041, -20.1934}, {55.1196, 19.8066}, {55.1196, 19.8066}}), Line(origin = {20, 0}, points = {{0, 20}, {0, -20}, {0, -20}}), Line(origin = {54, 0}, points = {{-34, 0}, {32, 0}, {32, 0}})}));
end MultiphaseBreaker;
