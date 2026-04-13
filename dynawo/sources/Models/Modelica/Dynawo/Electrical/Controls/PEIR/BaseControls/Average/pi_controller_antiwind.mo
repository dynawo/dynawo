within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model pi_controller_antiwind

  // Parameters
  parameter Real k_p;
  parameter Real tI;
  parameter Real y_start; 
  parameter Real DyMax;
  parameter Real YMax;

  // Input: error signal
  Modelica.Blocks.Interfaces.RealInput e annotation(
    Placement(
      transformation(origin = {-80, 62},
                     extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 0},
                         extent = {{-10, -10}, {10, 10}},
                         rotation = 0)));

  // Output: controller signal
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(
      transformation(origin = {80, 48},
                     extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0},
                         extent = {{-10, -10}, {10, 10}},
                         rotation = 0)));

  // Proportional path
  Modelica.Blocks.Math.Gain gain(k = k_p) annotation(
    Placement(transformation(origin = {-34, 62},
                             extent = {{-10, -10}, {10, 10}})));

// Integral path
  // Sum P + I
    Modelica.Blocks.Sources.BooleanConstant awOn(k = true);
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {40, 48},
                             extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = DyMax, DyMin = -DyMax, tI = tI, YMax = YMax, YMin = -YMax, Y0 = y_start, fMax(start = true), fMin(start = true), y(start = y_start))  annotation(
    Placement(transformation(origin = {-22, 24}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(e, gain.u) annotation(
    Line(points = {{-80, 62}, {-46, 62}}, color = {0, 0, 127}));
  connect(awOn.y, antiWindupIntegrator.fMax);
  connect(awOn.y, antiWindupIntegrator.fMin);
  connect(gain.y, add.u1) annotation(
    Line(points = {{-22, 62}, {-6, 62}, {-6, 54}, {28, 54}},
         color = {0, 0, 127}));

  connect(add.y, y) annotation(
    Line(points = {{52, 48}, {80, 48}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add.u2) annotation(
    Line(points = {{-10, 24}, {28, 24}, {28, 42}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.u, e) annotation(
    Line(points = {{-34, 24}, {-80, 24}, {-80, 62}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(
      coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(
             origin = {0, -4},extent = {{-60, 20}, {60, -20}}, textString = "PI 
Antiwindup")
      }),
    Diagram);

end pi_controller_antiwind;