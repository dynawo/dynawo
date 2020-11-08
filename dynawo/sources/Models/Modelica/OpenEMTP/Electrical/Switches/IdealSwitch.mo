within OpenEMTP.Electrical.Switches;

model IdealSwitch "Ideal Switch"
  import Modelica.SIunits.Time;
  import Modelica.SIunits.ElectricCurrent;
  parameter Time Tclosing = 0 "Closing Time";
  parameter Time Topening = 0.1 "Opening Time";
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch1(Goff = 1e-15, Ron = 1e-15) annotation(
    Placement(visible = true, transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Clock clock1(offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-98, 32}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Clock clock2(offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-74, -68}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {78, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold = Tclosing) annotation(
    Placement(visible = true, transformation(origin = {-68, 32}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold = Topening) annotation(
    Placement(visible = true, transformation(origin = {-33, -69}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {44, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(clock2.y, greaterThreshold2.u) annotation(
    Line(points = {{-65.2, -68}, {-42, -68}, {-42, -70}, {-42, -69}, {-41.4, -69}}, color = {0, 0, 127}));
  connect(greaterThreshold1.y, and1.u1) annotation(
    Line(points = {{-59.2, 32}, {42, 32}, {42, -30}, {66, -30}}, color = {255, 0, 255}));
  connect(clock1.y, greaterThreshold1.u) annotation(
    Line(points = {{-89.2, 32}, {-78, 32}, {-78, 32}, {-77.6, 32}}, color = {0, 0, 127}));
//assert(Tclosing < Topening, "Closing time must be less tha opening time.", AssertionLevel.warning);
  connect(pin_p, idealClosingSwitch1.p) annotation(
    Line(points = {{-96, 0}, {-64, 0}, {-64, 0}, {-62, 0}}, color = {0, 0, 255}));
  connect(and1.y, idealClosingSwitch1.control) annotation(
    Line(points = {{90, -30}, {118, -30}, {118, 22}, {-52, 22}, {-52, 8}, {-52, 8}}, color = {255, 0, 255}));
  connect(and1.u2, not1.y) annotation(
    Line(points = {{66, -38}, {58, -38}, {58, -46}, {56, -46}, {56, -46}}, color = {255, 0, 255}));
  connect(not1.u, greaterThreshold2.y) annotation(
    Line(points = {{32, -46}, {-12, -46}, {-12, -66}, {-26, -66}, {-26, -68}, {-26, -68}}, color = {255, 0, 255}));
  connect(idealClosingSwitch1.n, pin_n) annotation(
    Line(points = {{-42, 0}, {90, 0}, {90, 0}, {94, 0}}, color = {0, 0, 255}));
  annotation(
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2018-08-15 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    uses(Modelica(version = "3.2.3")),
    defaultComponentName = "SW",
    Icon(graphics = {Line(origin = {-28.8, 29.2}, points = {{-71.204, -29.204}, {-13.204, -29.204}, {56.796, 28.796}}, color = {0, 0, 255}), Line(origin = {24, -1}, points = {{0, 21}, {0, -19}, {0, -21}}, color = {0, 0, 255}), Line(origin = {54, 0}, points = {{-30, 0}, {30, 0}, {68, 0}}, color = {0, 0, 255}), Text(origin = {-4, 10}, extent = {{-150, -40}, {172, -80}}, textString = "To=%Tclosing"), Text(origin = {4, 18}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-2, -40}, extent = {{-150, -40}, {172, -80}}, textString = "Tc=%Topening")}, coordinateSystem(initialScale = 0.1)));
end IdealSwitch;
