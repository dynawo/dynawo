within Dynawo.Electrical.Controls.Converters.BaseControls;

model ReactivePowerLoop
  import Modelica;
  import Dynawo;
  //General parameters
  parameter Types.PerUnit Kpv;
  parameter Types.PerUnit Kiv;
  parameter Types.Time Tlpf "Time constant of low pass filter";
  parameter Types.PerUnit InomPu;
  parameter Boolean VQControlFlag;
  //Initial values
  parameter Types.PerUnit UConvRef0Pu;
  parameter Types.PerUnit UConv0Pu;
  parameter Types.PerUnit QGenRef0Pu;
  parameter Types.PerUnit QGen0Pu;
  parameter Types.PerUnit iqConv0Pu;
  parameter Types.PerUnit idConv0Pu;
  Modelica.Blocks.Interfaces.RealInput UConvPu(start = UConv0Pu) annotation(
    Placement(transformation(origin = {-150, 90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput UConvRefPu(start = UConvRef0Pu) annotation(
    Placement(transformation(origin = {-150, 51}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-71, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tlpf, k = 1, y_start = UConv0Pu) annotation(
    Placement(transformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}})));
  ReactiveCurrentLimiter reactiveCurrentLimiter(InomPu = InomPu, idConv0Pu = idConv0Pu, iqConv0Pu = iqConv0Pu) annotation(
    Placement(transformation(origin = {8, -102}, extent = {{-31, -31}, {31, 31}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = InomPu, uMin = -InomPu) annotation(
    Placement(transformation(origin = {101, 27}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = Kpv) annotation(
    Placement(transformation(origin = {11, 47}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = iqConv0Pu) annotation(
    Placement(transformation(origin = {150, 27}, extent = {{-10, 10}, {10, -10}}), iconTransformation(origin = {110, -1}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Kiv, outMax = InomPu, y_start = iqConv0Pu) annotation(
    Placement(transformation(origin = {12, 14}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {54, 27}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QGenRefPu(start = QGenRef0Pu) annotation(
    Placement(transformation(origin = {-150, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(transformation(origin = {-70, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QGenPu(start = QGen0Pu) annotation(
    Placement(transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Tlpf, k = 1, y_start = QGen0Pu) annotation(
    Placement(transformation(origin = {-109, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant VQswitch(k=VQControlFlag) annotation(
    Placement(transformation(origin = {-87, 30}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(UConvPu, firstOrder.u) annotation(
    Line(points = {{-150, 90}, {-122, 90}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u1) annotation(
    Line(points = {{-99, 90}, {-79, 90}}, color = {0, 0, 127}));
  connect(UConvRefPu, feedback.u2) annotation(
    Line(points = {{-150, 51}, {-72, 51}, {-71, 82}}, color = {0, 0, 127}));
  connect(limiter.y, iqRefPu) annotation(
    Line(points = {{112, 27}, {150, 27}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add.u2) annotation(
    Line(points = {{23, 14}, {36, 14}, {36, 21}, {42, 21}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{22, 47}, {33, 47}, {33, 33}, {42, 33}}, color = {0, 0, 127}));
  connect(add.y, limiter.u) annotation(
    Line(points = {{65, 27}, {89, 27}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{-29, 30}, {-20, 30}, {-20, 47}, {-1, 47}}, color = {0, 0, 127}));
  connect(switch1.y, limIntegrator.u) annotation(
    Line(points = {{-29, 30}, {-20, 30}, {-20, 14}, {0, 14}}, color = {0, 0, 127}));
  connect(feedback.y, switch1.u1) annotation(
    Line(points = {{-62, 90}, {-62, 91}, {-52, 91}, {-52, 38}}, color = {0, 0, 127}));
  connect(feedback1.y, switch1.u3) annotation(
    Line(points = {{-61, -20}, {-52, -20}, {-52, 22}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback1.u2) annotation(
    Line(points = {{-98, -50}, {-70, -50}, {-70, -28}}, color = {0, 0, 127}));
  connect(QGenPu, feedback1.u1) annotation(
    Line(points = {{-150, -20}, {-78, -20}}, color = {0, 0, 127}));
  connect(QGenRefPu, firstOrder1.u) annotation(
    Line(points = {{-150, -50}, {-121, -50}}, color = {0, 0, 127}));
  connect(VQswitch.y, switch1.u2) annotation(
    Line(points = {{-76, 30}, {-52, 30}}, color = {255, 0, 255}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));
end ReactivePowerLoop;
