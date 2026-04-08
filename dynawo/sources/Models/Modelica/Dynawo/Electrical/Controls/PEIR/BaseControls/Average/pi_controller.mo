within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model pi_controller
  // Parameters
  parameter Real k_p;
  parameter Real k_i;
  parameter Real y_start; 

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
  Modelica.Blocks.Continuous.Integrator integrator(k = k_i, y_start = y_start) annotation(
    Placement(transformation(origin = {-36, 28},
                             extent = {{-10, -10}, {10, 10}})));

  // Sum P + I
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {40, 48},
                             extent = {{-10, -10}, {10, 10}})));
equation
  connect(e, gain.u) annotation(
    Line(points = {{-80, 62}, {-46, 62}}, color = {0, 0, 127}));
  connect(e, integrator.u) annotation(
    Line(points = {{-80, 62}, {-56, 62}, {-56, 28}, {-48, 28}},
         color = {0, 0, 127}));

  connect(gain.y, add.u1) annotation(
    Line(points = {{-22, 62}, {-6, 62}, {-6, 54}, {28, 54}},
         color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-24, 28}, {3, 28}, {3, 42}, {28, 42}},
         color = {0, 0, 127}));

  connect(add.y, y) annotation(
    Line(points = {{52, 48}, {80, 48}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(
      coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(origin = {0, 0},
             extent = {{-60, 20}, {60, -20}},
             textString = "PI")
      }),
    Diagram);
end pi_controller;