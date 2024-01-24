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
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(origin = {-25, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain2(k = -1) annotation(
    Placement(transformation(origin = {119, -30}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter standAloneRampRateLimiter(DuMax = didt_max, DuMin = didt_min, tS = Trlim, Y0 = (InomPu^2 - iqConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {25, 0}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.LimitedIntegrator limitedIntegrator(K = 1, Y0 = (InomPu^2 - iqConv0Pu^2)^0.5, YMax = InomPu, YMin = -InomPu) annotation(
    Placement(transformation(origin = {68, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = (InomPu^2 - iqConvPu^2)^0.5) annotation(
    Placement(transformation(origin = {-94, 0}, extent = {{-45, -15}, {45, 15}})));
  Modelica.Blocks.Interfaces.RealOutput Idmax(start = (InomPu^2 - iqConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Idmin(start = -(InomPu^2 - iqConv0Pu^2)^0.5) annotation(
    Placement(transformation(origin = {150, -30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -51}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(standAloneRampRateLimiter.y, limitedIntegrator.u) annotation(
    Line(points = {{36, 0}, {56, 0}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, feedback1.u2) annotation(
    Line(points = {{61, 0}, {83, 0}, {83, -30}, {-25, -30}, {-25, -8}}, color = {0, 0, 127}));
  connect(realExpression.y, feedback1.u1) annotation(
    Line(points = {{-44.5, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, Idmax) annotation(
    Line(points = {{79, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(limitedIntegrator.y, gain2.u) annotation(
    Line(points = {{79, 0}, {100, 0}, {100, -30}, {107, -30}}, color = {0, 0, 127}));
  connect(gain2.y, Idmin) annotation(
    Line(points = {{130, -30}, {150, -30}}, color = {0, 0, 127}));
  connect(feedback1.y, standAloneRampRateLimiter.u) annotation(
    Line(points = {{-16, 0}, {13, 0}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-0.5, 0}, extent = {{-49.5, 42}, {49.5, -42}}, textString = "Id_Limiter"), Text(origin = {72, 51}, extent = {{54, -11}, {-54, 11}}, textString = "Idmax"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {70, -47.5}, extent = {{57, -12}, {-57, 13}}, textString = "Idmin")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ActiveCurrentLimiter;
