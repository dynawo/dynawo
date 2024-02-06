within Dynawo.Electrical.Controls.Converters.BaseControls;

model ActivePowerLoop
  import Modelica;
  import Dynawo;
  //General parameters
  parameter Types.PerUnit Kpp "Proportional gain of the active power loop";
  parameter Types.PerUnit Kip "Integral gain of the active power loop";
  parameter Types.Time Tlpf "Time constant of low pass filter";
  //Initial values
  parameter Types.PerUnit PGenRef0Pu;
  parameter Types.PerUnit PGen0Pu;
  parameter Types.PerUnit idConv0Pu;
  //Parameters of Limiter
  parameter Types.PerUnit InomPu "nominal converter current in pu";
  parameter Types.Time Trlim "Time constant of Id limitting loop";
  parameter Types.PerUnit didt_min "minimum of ramp rate limit of of Id_max limitting loop";
  parameter Types.PerUnit didt_max "maximum of ramp rate limit of of Id_max limitting loop";
  //Initial values
//  parameter Types.PerUnit idConv0Pu;
  parameter Types.PerUnit iqConv0Pu;

  Modelica.Blocks.Interfaces.RealInput PGenRefPu(start = PGenRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start=idConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpp)  annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {72, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-90, 80}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tlpf, k = 1, y_start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = iqConv0Pu) annotation(
    Placement(transformation(origin = {-151, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  ActiveCurrentLimiter activeCurrentLimiter(InomPu= InomPu, Trlim=Trlim, didt_min=didt_min, didt_max=didt_max, idConv0Pu = idConv0Pu, iqConv0Pu= iqConv0Pu)  annotation(
    Placement(transformation(origin = {-80, -40}, extent = {{-28, -28}, {28, 28}})));
  NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(transformation(origin = {114, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kip, y_start = idConv0Pu)  annotation(
    Placement(transformation(origin = {0, 61}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(gain.y, add.u1) annotation(
    Line(points = {{11, 100}, {40, 100}, {40, 86}, {60, 86}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-81, 80}, {-50.75, 80}, {-50.75, 100}, {-12, 100}}, color = {0, 0, 127}));
  connect(feedback.u1, PGenRefPu) annotation(
    Line(points = {{-98, 80}, {-150, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u2) annotation(
    Line(points = {{-99, 40}, {-89.531, 40}, {-89.531, 72}, {-90, 72}}, color = {0, 0, 127}));
  connect(firstOrder.u, PGenPu) annotation(
    Line(points = {{-122, 40}, {-150, 40}}, color = {0, 0, 127}));
  connect(iqConvPu, activeCurrentLimiter.iqConvPu) annotation(
    Line(points = {{-151, -40}, {-111, -40}}, color = {0, 0, 127}));
  connect(variableLimiter.y, idRefPu) annotation(
    Line(points = {{125, 80}, {150, 80}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{83, 80}, {102, 80}}, color = {0, 0, 127}));
  connect(activeCurrentLimiter.Idmax, variableLimiter.limit1) annotation(
    Line(points = {{-49, -26}, {90, -26}, {90, 88}, {102, 88}}, color = {0, 0, 127}));
  connect(activeCurrentLimiter.Idmin, variableLimiter.limit2) annotation(
    Line(points = {{-49, -54}, {23, -54}, {23, -55}, {94, -55}, {94, 72}, {102, 72}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{-81, 80}, {-50, 80}, {-50, 61}, {-12, 61}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{11, 61}, {40, 61}, {40, 74}, {60, 74}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ActivePowerLoop;
