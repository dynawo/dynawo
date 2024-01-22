within Dynawo.Electrical.Controls.Converters.BaseControls;

model ReactiveCurrentLimiter
  import Modelica;
  import Dynawo;
  //Parameters
  parameter Types.PerUnit InomPu "nominal converter current in pu";
  //Initial values
  parameter Types.PerUnit idConv0Pu;
  parameter Types.PerUnit iqConv0Pu;

//  Modelica.Blocks.Interfaces.RealInput idConvPu(start = idConv0Pu) annotation(
//    Placement(transformation(origin = {-151, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(transformation(origin = {119, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = (InomPu^2 - idConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {-95, 0}, extent = {{-45, -15}, {45, 15}})));
  Modelica.Blocks.Interfaces.RealOutput Iqmax(start = (InomPu^2 - idConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Iqmin(start = -(InomPu^2 - idConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {150, -30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -51}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(gain1.y, Iqmin) annotation(
    Line(points = {{130, -30}, {150, -30}}, color = {0, 0, 127}));
  connect(realExpression.y, Iqmax) annotation(
    Line(points = {{-45.5, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(realExpression.y, gain1.u) annotation(
    Line(points = {{-45.5, 0}, {73, 0}, {73, -30}, {107, -30}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-0.5, 0}, extent = {{-49.5, 42}, {49.5, -42}}, textString = "Iq_Limiter"), Text(origin = {72, 51}, extent = {{54, -11}, {-54, 11}}, textString = "Iqmax"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {70, -47.5}, extent = {{57, -12}, {-57, 13}}, textString = "Iqmin")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ReactiveCurrentLimiter;
