within Dynawo.Electrical.Controls.Converters.BaseControls;

model ReactivePowerLoopWithLimiters
  import Modelica;
  import Dynawo;
  //General parameters
  parameter Types.PerUnit Kpv;
  parameter Types.PerUnit Kiv;
  parameter Types.Time Tlpf "Time constant of low pass filter";
  parameter Types.PerUnit InomPu;
  //Initial values
  parameter Types.PerUnit UConvRef0Pu;
  parameter Types.PerUnit UConv0Pu;
  parameter Types.PerUnit iqConv0Pu;
  parameter Types.PerUnit idConv0Pu;
  
  Modelica.Blocks.Interfaces.RealInput UConvPu(start = UConv0Pu) annotation(
    Placement(transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput UConvRefPu(start = UConvRef0Pu) annotation(
    Placement(transformation(origin = {-150, -39}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = iqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpv) annotation(
    Placement(visible = true, transformation(origin = {1, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {43, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kiv, y_start = iqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-1, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tlpf, k = 1, y_start = UConv0Pu) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.NonLinear.VariableLimiter variableLimiter annotation(
    Placement(transformation(origin = {99, 0}, extent = {{-10, -10}, {10, 10}})));
  ReactiveCurrentLimiter reactiveCurrentLimiter(InomPu= InomPu, idConv0Pu = idConv0Pu, iqConv0Pu= iqConv0Pu) annotation(
    Placement(transformation(origin = {-85, -89}, extent = {{-31, -31}, {31, 31}})));
equation
  connect(gain.y, add.u1) annotation(
    Line(points = {{12, 20}, {21, 20}, {21, 6}, {31, 6}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{10, -19}, {10, -20}, {21, -20}, {21, -5}, {31, -5}, {31, -6}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-63, 0}, {-30, 0}, {-30, 20}, {-11, 20}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{-63, 0}, {-30, 0}, {-30, -19}, {-13, -19}}, color = {0, 0, 127}));
  connect(UConvPu, firstOrder.u) annotation(
    Line(points = {{-150, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 127}));
  connect(UConvRefPu, feedback.u2) annotation(
    Line(points = {{-150, -39}, {-72, -39}, {-72, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.y, iqRefPu) annotation(
    Line(points = {{110, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{54, 0}, {87, 0}}, color = {0, 0, 127}));
  connect(reactiveCurrentLimiter.Iqmax, variableLimiter.limit1) annotation(
    Line(points = {{-51, -73.5}, {70, -73.5}, {70, 8}, {87, 8}}, color = {0, 0, 127}));
  connect(reactiveCurrentLimiter.Iqmin, variableLimiter.limit2) annotation(
    Line(points = {{-51, -105}, {80, -105}, {80, -8}, {87, -8}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ReactivePowerLoopWithLimiters;
