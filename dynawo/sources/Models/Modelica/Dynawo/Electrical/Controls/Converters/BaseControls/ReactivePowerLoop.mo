within Dynawo.Electrical.Controls.Converters.BaseControls;

model ReactivePowerLoop
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

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tlpf, k = 1, y_start = UConv0Pu) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  ReactiveCurrentLimiter reactiveCurrentLimiter(InomPu= InomPu, idConv0Pu = idConv0Pu, iqConv0Pu= iqConv0Pu) annotation(
    Placement(transformation(origin = {-94, -102}, extent = {{-31, -31}, {31, 31}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = (InomPu^2 - idConv0Pu^2)^0.5, uMin = -(InomPu^2 - idConv0Pu^2)^0.5)  annotation(
    Placement(transformation(origin = {91, 0}, extent = {{-10, -10}, {10, 10}})));
  //  Modelica.Blocks.Continuous.Integrator integrator(k = Kiv, y_start = iqConv0Pu) annotation(
  //    Placement(transformation(origin = {-10, -19}, extent = {{-10, -10}, {10, 10}})));
  //  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = (InomPu^2 - 0*idConv0Pu^2)^0.5) annotation(
  //    Placement(transformation(origin = {19, -18}, extent = {{-10, -10}, {10, 10}})));
  //  Modelica.Blocks.Math.Add add1 annotation(
  //    Placement(transformation(origin = {-36, -40}, extent = {{-10, -10}, {10, 10}})));
  //  Modelica.Blocks.Math.Feedback feedback1 annotation(
  //    Placement(transformation(origin = {1, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kiv, outMax = (InomPu^2 - idConv0Pu^2)^0.5, y_start = iqConv0Pu) annotation(
    Placement(transformation(origin = {2, -13}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(gain.y, add.u1) annotation(
    Line(points = {{12, 20}, {21, 20}, {21, 6}, {31, 6}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-63, 0}, {-30, 0}, {-30, 20}, {-11, 20}}, color = {0, 0, 127}));
  connect(UConvPu, firstOrder.u) annotation(
    Line(points = {{-150, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u1) annotation(
    Line(points = {{-99, 0}, {-80, 0}}, color = {0, 0, 127}));
  connect(UConvRefPu, feedback.u2) annotation(
    Line(points = {{-150, -39}, {-72, -39}, {-72, -8}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{54, 0}, {79, 0}}, color = {0, 0, 127}));
  connect(limiter.y, iqRefPu) annotation(
    Line(points = {{102, 0}, {150, 0}}, color = {0, 0, 127}));
//  connect(integrator.y, limiter1.u) annotation(
//    Line(points = {{1, -19}, {7, -19}, {7, -18}}, color = {0, 0, 127}));
//  connect(limiter1.y, add.u2) annotation(
//    Line(points = {{30, -18}, {31, -18}, {31, -6}}, color = {0, 0, 127}));
//  connect(feedback.y, add1.u1) annotation(
//    Line(points = {{-63, 0}, {-57, 0}, {-57, -34}, {-48, -34}}, color = {0, 0, 127}));
//  connect(feedback1.y, add1.u2) annotation(
//    Line(points = {{-8, -56}, {-60, -56}, {-60, -46}, {-48, -46}}, color = {0, 0, 127}));
//  connect(add1.y, integrator.u) annotation(
//    Line(points = {{-25, -40}, {-22, -40}, {-22, -19}}, color = {0, 0, 127}));
//  connect(integrator.y, feedback1.u2) annotation(
//    Line(points = {{1, -19}, {1, -48}}, color = {0, 0, 127}));
//  connect(limiter1.y, feedback1.u1) annotation(
//    Line(points = {{30, -18}, {31, -18}, {31, -56}, {9, -56}}, color = {0, 0, 127}));
  connect(feedback.y, limIntegrator.u) annotation(
    Line(points = {{-63, 0}, {-30, 0}, {-30, -13}, {-10, -13}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{13, -13}, {18, -13}, {18, -6}, {31, -6}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ReactivePowerLoop;
