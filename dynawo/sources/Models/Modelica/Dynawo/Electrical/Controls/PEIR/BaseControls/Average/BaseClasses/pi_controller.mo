within Dynawo.Electrical.Controls.PEIR.BaseControls.Average.BaseClasses;


model pi_controller
  // ==========================================================
  // Generic PI controller
  // Computes y = k_p * e + k_i * integral(e)
  // ==========================================================

  // Parameters
  parameter Real k_p;        // Proportional gain
  parameter Real k_i;        // Integral gain
  parameter Real y_start;    // Initial value of the integrator output

  // Input: error signal fed into the PI controller
  Modelica.Blocks.Interfaces.RealInput e annotation(
    Placement(
      transformation(origin = {-80, 62},
                     extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 0},
                         extent = {{-10, -10}, {10, 10}},
                         rotation = 0)));

  // Output: control signal produced by the PI controller
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(
      transformation(origin = {80, 48},
                     extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0},
                         extent = {{-10, -10}, {10, 10}},
                         rotation = 0)));

  // Proportional path: multiplies the error by k_p
  Modelica.Blocks.Math.Gain gain(k = k_p) annotation(
    Placement(transformation(origin = {-34, 62},
                             extent = {{-10, -10}, {10, 10}})));

  // Integral path: integrates the error, scaled by k_i, starting from y_start
  Modelica.Blocks.Continuous.Integrator integrator(k = k_i, y_start = y_start) annotation(
    Placement(transformation(origin = {-36, 28},
                             extent = {{-10, -10}, {10, 10}})));

  // Sums the proportional and integral contributions
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {40, 48},
                             extent = {{-10, -10}, {10, 10}})));

equation
  // Connect the error signal to both the proportional and integral paths
  connect(e, gain.u) annotation(
    Line(points = {{-80, 62}, {-46, 62}}, color = {0, 0, 127}));
  connect(e, integrator.u) annotation(
    Line(points = {{-80, 62}, {-56, 62}, {-56, 28}, {-48, 28}},
         color = {0, 0, 127}));

  // Sum the proportional (u1) and integral (u2) contributions
  connect(gain.y, add.u1) annotation(
    Line(points = {{-22, 62}, {-6, 62}, {-6, 54}, {28, 54}},
         color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-24, 28}, {3, 28}, {3, 42}, {28, 42}},
         color = {0, 0, 127}));

  // Output the combined PI signal
  connect(add.y, y) annotation(
    Line(points = {{52, 48}, {80, 48}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html>
      <p>Generic PI (Proportional-Integral) controller block.</p>
      <p>Author: Gaia Bergamaschi</p>
    </html>"),
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
