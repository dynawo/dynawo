within Dynawo.Electrical.Controls.Converters.BaseControls;

model ActiveCurrentLimiter
  import Modelica;
  import Dynawo;
  //Parameters
  parameter Types.PerUnit InomPu "nominal converter current in pu";
  parameter Types.Time Trlim "Time constant of Id limitting loop";
  parameter Types.PerUnit didt_min "minimum of ramp rate limit of of Id_max limitting loop";
  parameter Types.PerUnit didt_max "maximum of ramp rate limit of of Id_max limitting loop";
  //Initial values
  parameter Types.PerUnit idConv0Pu;
  parameter Types.PerUnit iqConv0Pu;
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = iqConv0Pu) annotation(
    Placement(transformation(origin = {-151, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain2(k = -1) annotation(
    Placement(transformation(origin = {122, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = (InomPu - iqConvPu^2)^0.5) annotation(
    Placement(transformation(origin = {-95, 0}, extent = {{-45, -15}, {45, 15}})));
  Modelica.Blocks.Interfaces.RealOutput Idmax annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Idmin annotation(
    Placement(transformation(origin = {150, -30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -51}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1, outMax = InomPu, y_start = (InomPu - iqConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {85, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = didt_max, uMin = didt_min) annotation(
    Placement(transformation(origin = {47, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-26, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 1/Trlim) annotation(
    Placement(transformation(origin = {7, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(gain2.y, Idmin) annotation(
    Line(points = {{133, -30}, {150, -30}}, color = {0, 0, 127}));
  connect(limiter.y, limIntegrator.u) annotation(
    Line(points = {{58, 0}, {72, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-17, 0}, {-5, 0}}, color = {0, 0, 127}));
  connect(gain.y, limiter.u) annotation(
    Line(points = {{18, 0}, {34, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, Idmax) annotation(
    Line(points = {{96, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, gain2.u) annotation(
    Line(points = {{96, 0}, {102, 0}, {102, -30}, {110, -30}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback.u2) annotation(
    Line(points = {{96, 0}, {97, 0}, {97, -34}, {-26, -34}, {-26, -8}}, color = {0, 0, 127}));
  connect(realExpression.y, feedback.u1) annotation(
    Line(points = {{-45, 0}, {-34, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-0.5, 0}, extent = {{-49.5, 42}, {49.5, -42}}, textString = "Id_Limiter"), Text(origin = {72, 51}, extent = {{54, -11}, {-54, 11}}, textString = "Idmax"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {70, -47.5}, extent = {{57, -12}, {-57, 13}}, textString = "Idmin")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ActiveCurrentLimiter;
