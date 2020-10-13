within OpenEMTP.Electrical.Switches;
model IdealSwitch "Ideal Switch"
  import Modelica.SIunits.Time;
  import Modelica.SIunits.ElectricCurrent;
  parameter Time Tclosing=0 "Closing Time";
  parameter Time Topening=0.1 "Opening Time";

  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch1(Goff = 1e-15, Ron = 1e-15)  annotation (
    Placement(visible = true, transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1 annotation (
    Placement(visible = true, transformation(origin = {-12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Clock clock1(offset = 0, startTime = 0)  annotation (
    Placement(visible = true, transformation(origin = {-98, 32}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Clock clock2(offset = 0, startTime = 0) annotation (
    Placement(visible = true, transformation(origin = {-74, -68}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation (
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation (
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.ZeroCrossing zeroCrossing1 annotation (
    Placement(visible = true, transformation(origin = {10, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.RSFlipFlop rSFlipFlop1 annotation (
    Placement(visible = true, transformation(origin = {46, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = false)  annotation (
    Placement(visible = true, transformation(origin = {8, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.And and1 annotation (
    Placement(visible = true, transformation(origin = {78, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold = Tclosing)  annotation (
    Placement(visible = true, transformation(origin = {-68, 32}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold = Topening)  annotation (
    Placement(visible = true, transformation(origin = {-33, -69}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
equation
  connect(idealClosingSwitch1.n, currentSensor1.p) annotation (
    Line(points = {{-42, 0}, {-22, 0}}, color = {0, 0, 255}));
  connect(currentSensor1.n, pin_n) annotation (
    Line(points = {{-2, 0}, {94, 0}}, color = {0, 0, 255}));
  connect(currentSensor1.i, zeroCrossing1.u) annotation (
    Line(points={{-12,-11},{-2,-11},{-2,-32}},        color = {0, 0, 127}));
  connect(greaterThreshold2.y, zeroCrossing1.enable) annotation (
    Line(points={{-25.3,-69},{10,-69},{10,-44},{10,-44}},        color = {255, 0, 255}));
  connect(clock2.y, greaterThreshold2.u) annotation (
    Line(points={{-65.2,-68},{-42,-68},{-42,-70},{-42,-69},{-41.4,-69}},        color = {0, 0, 127}));
  connect(greaterThreshold1.y, and1.u1) annotation (
    Line(points={{-59.2,32},{66,32},{66,-30},{66,-30}},        color = {255, 0, 255}));
  connect(clock1.y, greaterThreshold1.u) annotation (
    Line(points={{-89.2,32},{-78,32},{-78,32},{-77.6,32}},      color = {0, 0, 127}));
  connect(and1.y, idealClosingSwitch1.control) annotation (
    Line(points={{89,-30},{112,-30},{112,20},{-52,20},{-52,12},{-52,12}},            color = {255, 0, 255}));
  connect(and1.y, idealClosingSwitch1.control) annotation (
    Line(points={{89,-30},{-52,-30},{-52,12},{-52,12}},        color = {255, 0, 255}));
  connect(rSFlipFlop1.QI, and1.u2) annotation (
    Line(points={{57,-70},{66,-70},{66,-38},{66,-38}},          color = {255, 0, 255}));
  connect(booleanConstant1.y, rSFlipFlop1.R) annotation (
    Line(points={{19,-96},{34,-96},{34,-70},{34,-70}},          color = {255, 0, 255}));
  connect(rSFlipFlop1.S, zeroCrossing1.y) annotation (
    Line(points={{34,-58},{28,-58},{28,-32},{21,-32},{21,-32}},            color = {255, 0, 255}));
  assert(Tclosing < Topening, "Closing time must be less tha opening time.", AssertionLevel.warning);
  connect(pin_p, idealClosingSwitch1.p) annotation (
    Line(points = {{-96, 0}, {-64, 0}, {-64, 0}, {-62, 0}}, color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2018-08-15 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"), uses(Modelica(version="3.2.3")),defaultComponentName = "SW",
    Icon(graphics={  Line(origin = {-28.8, 29.2}, points = {{-71.204, -29.204}, {-13.204, -29.204}, {56.796, 28.796}}, color = {0, 0, 255}), Line(origin = {24, -1}, points = {{0, 21}, {0, -19}, {0, -21}}, color = {0, 0, 255}), Line(origin = {54, 0}, points = {{-30, 0}, {30, 0}, {68, 0}}, color = {0, 0, 255}),  Text(origin = {-4, 10},extent = {{-150, -40}, {172, -80}}, textString = "To=%Tclosing"), Text(origin = {4, 18},lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-2, -40}, extent = {{-150, -40}, {172, -80}}, textString = "Tc=%Topening")}, coordinateSystem(initialScale = 0.1)));
end IdealSwitch;
