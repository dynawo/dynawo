within Dynawo.NonElectrical.Blocks.Continuous;
block PIAntiWindup "Anti-windup proportional integral controller"
  extends Dynawo.NonElectrical.Blocks.Continuous.BaseClasses.BasePIAntiWindup;

  parameter Types.PerUnit YMax "Maximum output of controller";
  parameter Types.PerUnit YMin "Minimum output of controller";

  Modelica.Blocks.Nonlinear.Limiter limiter(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(add.y, limiter.u) annotation(
    Line(points = {{22, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(limiter.y, y) annotation(
    Line(points = {{102, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(limiter.y, feedback1.u1) annotation(
    Line(points = {{102, 0}, {120, 0}, {120, -60}, {48, -60}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-2, 2}, extent = {{-64, 38}, {64, -38}}, textString = "PI Anti Windup")}));
end PIAntiWindup;
