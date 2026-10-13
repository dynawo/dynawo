within Dynawo.Examples.PEIR.Plants.Simplified;

model test_control
  Modelica.Blocks.Interfaces.RealOutput QInjPu "Reactive power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {168, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {334, -232}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(transformation(origin = {-130, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add QVCtrlErr(k1 = -1) annotation(
    Placement(transformation(origin = {-8, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 1/0.21) annotation(
    Placement(transformation(origin = {-68, 40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = 10, Kp = 5, Tol = 1e-4, Y0 = -0.293293, YMax = 99, YMin = -99) annotation(
    Placement(transformation(origin = {92, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QConvRefPu "Reactive power setpoint at converter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {320, -294}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add UCtrlErr1(k2 = -1) annotation(
    Placement(transformation(origin = {-8, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add QVCtrlErr1 annotation(
    Placement(transformation(origin = {-130, -90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = 0.21) annotation(
    Placement(transformation(origin = {-246, -96}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Pulse QRegPu(amplitude = 0.2, nperiod = 1, offset = -0.30561333, period = 2, startTime = 2) annotation(
    Placement(transformation(origin = {-290, 102}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Pulse URegPu( nperiod = 1, offset = 1.06648, period = 2, startTime = 2, amplitude = -0.1) annotation(
    Placement(transformation(origin = {-284, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step URefStep(height = 0.05, offset = 1.0023, startTime = 100) annotation(
    Placement(transformation(origin = {-290, 46}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI1(Ki = 10, Kp = 5, Tol = 1e-4, Y0 = -0.293293, YMax = 99, YMin = -99) annotation(
    Placement(transformation(origin = {92, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain11(k = 0.21) annotation(
    Placement(transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(UCtrlErr.y, gain.u) annotation(
    Line(points = {{-119, 40}, {-80, 40}}, color = {0, 0, 127}));
  connect(gain1.y, QVCtrlErr1.u2) annotation(
    Line(points = {{-235, -96}, {-142, -96}}, color = {0, 0, 127}));
  connect(QVCtrlErr1.y, UCtrlErr1.u2) annotation(
    Line(points = {{-119, -90}, {-46, -90}, {-46, -46}, {-20, -46}}, color = {0, 0, 127}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-57, 40}, {-38.5, 40}, {-38.5, 34}, {-20, 34}}, color = {0, 0, 127}));
  connect(limitedPI.y, QInjPu) annotation(
    Line(points = {{103, 40}, {168, 40}}, color = {0, 0, 127}));
  connect(URegPu.y, UCtrlErr.u2) annotation(
    Line(points = {{-272, -60}, {-230, -60}, {-230, 34}, {-142, 34}}, color = {0, 0, 127}));
  connect(URegPu.y, QVCtrlErr1.u1) annotation(
    Line(points = {{-272, -60}, {-230, -60}, {-230, -84}, {-142, -84}}, color = {0, 0, 127}));
  connect(URefStep.y, UCtrlErr.u1) annotation(
    Line(points = {{-279, 46}, {-142, 46}}, color = {0, 0, 127}));
  connect(URefStep.y, UCtrlErr1.u1) annotation(
    Line(points = {{-279, 46}, {-164, 46}, {-164, -64}, {-97, -64}, {-97, -34}, {-20, -34}}, color = {0, 0, 127}));
  connect(limitedPI1.y, QConvRefPu) annotation(
    Line(points = {{103, -40}, {170, -40}}, color = {0, 0, 127}));
  connect(UCtrlErr1.y, limitedPI1.u) annotation(
    Line(points = {{3, -40}, {80, -40}}, color = {0, 0, 127}));
  connect(QRegPu.y, QVCtrlErr.u1) annotation(
    Line(points = {{-279, 102}, {-28, 102}, {-28, 46}, {-20, 46}}, color = {0, 0, 127}));
  connect(QRegPu.y, gain1.u) annotation(
    Line(points = {{-278, 102}, {-258, 102}, {-258, -96}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, gain11.u) annotation(
    Line(points = {{4, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(gain11.y, limitedPI.u) annotation(
    Line(points = {{42, 40}, {80, 40}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 25, Tolerance = 1e-06, Interval = 0.05),
  Diagram(coordinateSystem(extent = {{-300, 160}, {160, -120}})));
end test_control;
