within Dynawo.Electrical.Controls.WECC.Mechanical;

model WTGAa "WECC Aero-Dynamic model"
extends Electrical.Controls.WECC.Parameters.ParamsWTGAA;
//Input Variables
  Modelica.Blocks.Interfaces.RealInput Theta(start=thetaInit) annotation(
    Placement(transformation(origin = {-90, -4}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PmRef(start=PmRef0) annotation(
    Placement(transformation(origin = {52, 88}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {49, -109}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
//Output Variables
  Modelica.Blocks.Interfaces.RealOutput Pm annotation(
    Placement(transformation(origin = {104, -10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
 
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-50, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant Theta0(k = theta0)  annotation(
    Placement(transformation(origin = {-50, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-14, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = Ka)  annotation(
    Placement(transformation(origin = {24, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(origin = {52, 2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  
equation
  connect(Theta0.y, feedback.u2) annotation(
    Line(points = {{-50, -47}, {-50, -12}}, color = {0, 0, 127}));
  connect(Theta, feedback.u1) annotation(
    Line(points = {{-90, -4}, {-58, -4}}, color = {0, 0, 127}));
  connect(feedback.y, product.u2) annotation(
    Line(points = {{-40, -4}, {-26, -4}}, color = {0, 0, 127}));
  connect(Theta, product.u1) annotation(
    Line(points = {{-90, -4}, {-70, -4}, {-70, 8}, {-26, 8}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{-2, 2}, {12, 2}}, color = {0, 0, 127}));
  connect(feedback1.y, Pm) annotation(
    Line(points = {{52, -7}, {52.625, -7}, {52.625, -11}, {76.5, -11}, {76.5, -10}, {104, -10}}, color = {0, 0, 127}));
  connect(gain.y, feedback1.u2) annotation(
    Line(points = {{36, 2}, {44, 2}}, color = {0, 0, 127}));
  connect(PmRef, feedback1.u1) annotation(
    Line(points = {{52, 88}, {52, 10}}, color = {0, 0, 127}));

annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the Aero-Dynamic Model for a WindTurbineGenerator Type 3 according to <br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p><p>This simple model will give you a value for the mechaniquel power developed by the wind turbine depending on the blade pitch angle.</p>
<p>
 </p><p></p></body></html>"),
    uses(Modelica(version = "3.2.3")),
  Diagram(coordinateSystem(extent = {{-120, 80}, {120, -80}})),
  version = "",
  Icon(graphics = {Text(origin = {77, -109}, extent = {{-17, 9}, {17, -9}}, textString = "PmRef"), Text(origin = {-111, 23}, extent = {{-15, 7}, {15, -7}}, textString = "theta"), Text(origin = {108, 21}, extent = {{-14, 9}, {14, -9}}, textString = "Pm"), Text(origin = {2, 3}, extent = {{-64, 41}, {64, -41}}, textString = "WTGA_A"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGAa;
