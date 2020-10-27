within OpenEMTP.Examples.IEEE13Bus;
model IdealBreaker
  import Modelica.SIunits.Time;
  import Modelica.SIunits.ElectricCurrent;
  parameter Time Tclosing=0 "Closing Time";
  parameter Time Topening=0.1 "Opening Time";
  parameter ElectricCurrent Imarg=0.05  "Marginal Current";

  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch1(Goff = 0, Ron = 0)  annotation(
    Placement(visible = true, transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1 annotation(
    Placement(visible = true, transformation(origin = {-12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold1(threshold = Tclosing)  annotation(
    Placement(visible = true, transformation(origin = {-80, -26}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Clock clock1(offset = 0, startTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {-110, -26}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Clock clock2(offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-76, -94}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold2(threshold = Topening)  annotation(
    Placement(visible = true, transformation(origin = {-28, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-136, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-136, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {134, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {134, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.ZeroCrossing zeroCrossing1 annotation(
    Placement(visible = true, transformation(origin = {8, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.RSFlipFlop rSFlipFlop1 annotation(
    Placement(visible = true, transformation(origin = {44, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = false)  annotation(
    Placement(visible = true, transformation(origin = {6, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {94, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(pin_p, idealClosingSwitch1.p) annotation(
    Line(points = {{-136, 0}, {-62, 0}}, color = {0, 0, 255}));
  connect(currentSensor1.i, zeroCrossing1.u) annotation(
    Line(points = {{-12, -10}, {-12, -10}, {-12, -54}, {-4, -54}, {-4, -54}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold2.y, zeroCrossing1.enable) annotation(
    Line(points = {{-17, -94}, {8, -94}, {8, -66}}, color = {255, 0, 255}));
  connect(rSFlipFlop1.S, zeroCrossing1.y) annotation(
    Line(points = {{32, -84}, {26, -84}, {26, -54}, {19, -54}}, color = {255, 0, 255}));
  connect(and1.y, idealClosingSwitch1.control) annotation(
    Line(points = {{105, -26}, {110, -26}, {110, 40}, {-52, 40}, {-52, 8}}, color = {255, 0, 255}));
  connect(clock1.y, greaterEqualThreshold1.u) annotation(
    Line(points = {{-101.2, -26}, {-90.2, -26}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold1.y, and1.u1) annotation(
    Line(points = {{-71, -26}, {82, -26}}, color = {255, 0, 255}));
  connect(booleanConstant1.y, rSFlipFlop1.R) annotation(
    Line(points = {{17, -122}, {24, -122}, {24, -120}, {25, -120}, {25, -96}, {28, -96}, {28, -96}, {31, -96}}, color = {255, 0, 255}));
  connect(rSFlipFlop1.QI, and1.u2) annotation(
    Line(points = {{55, -96}, {62, -96}, {62, -34}, {82, -34}}, color = {255, 0, 255}));
  connect(greaterEqualThreshold2.u, clock2.y) annotation(
    Line(points = {{-40, -94}, {-67, -94}}, color = {0, 0, 127}));
  connect(currentSensor1.n, pin_n) annotation(
    Line(points = {{-2, 0}, {134, 0}}, color = {0, 0, 255}));
  connect(idealClosingSwitch1.n, currentSensor1.p) annotation(
    Line(points = {{-42, 0}, {-22, 0}}, color = {0, 0, 255}));

  annotation(
    uses(Modelica(version = "3.2.2")),
 Icon(graphics = {Line(origin = {-28.8, 29.2}, points = {{-57.204, -29.204}, {-13.204, -29.204}, {56.796, 28.796}}, color = {0, 0, 255}), Line(origin = {24, -1}, points = {{0, 21}, {0, -19}, {0, -21}}, color = {0, 0, 255}), Line(origin = {54, 0}, points = {{-30, 0}, {30, 0}, {30, 0}}, color = {0, 0, 255})}, coordinateSystem(extent = {{-150, -150}, {150, 100}}, grid = {0, 0})),
 Diagram(coordinateSystem(extent = {{-150, -150}, {150, 100}}, grid = {0, 0})),
 version = "",
 __OpenModelica_commandLineOptions = "");
end IdealBreaker;
