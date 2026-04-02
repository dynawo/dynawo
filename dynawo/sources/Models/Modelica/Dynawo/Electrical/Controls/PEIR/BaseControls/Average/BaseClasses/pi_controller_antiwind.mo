within Dynawo.Electrical.Controls.PEIR.BaseControls.Average.BaseClasses;



model pi_controller_antiwind
  // ==========================================================
  // PI controller with anti-windup on the integral path
  // Computes y = k_p * e + AntiWindupIntegrator(e)
  // The anti-windup integrator limits its output between
  // YMin/YMax and limits its rate of change between DyMin/DyMax
  // ==========================================================

  // Parameters
  parameter Real k_p;        // Proportional gain
  parameter Real tI;         // Integral time constant
  parameter Real y_start;    // Initial value of the integrator output
  parameter Real DyMax;      // Maximum rate of change of the integrator output (DyMin = -DyMax)
  parameter Real YMax;       // Maximum (saturation) value of the integrator output (YMin = -YMax)

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

  // Integral path (with anti-windup) and P+I summation

  // Constant "false" signal used to permanently disable the freeze
  // flags (fMax/fMin) of the anti-windup integrator
  Modelica.Blocks.Sources.BooleanConstant awOn(k = false);

  // Sums the proportional and (anti-windup) integral contributions
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {40, 48},
                             extent = {{-10, -10}, {10, 10}})));

  // Integral path with anti-windup: limits both the output value
  // (YMin/YMax) and its rate of change (DyMin/DyMax) to avoid
  // integrator windup during saturation
  NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = DyMax, DyMin = -DyMax, tI = tI, YMax = YMax, YMin = -YMax, Y0 = y_start, fMax(start = false), fMin(start = false), y(start = y_start))  annotation(
    Placement(transformation(origin = {-22, 24}, extent = {{-10, -10}, {10, 10}})));

equation
  // Connect the error signal to the proportional path
  connect(e, gain.u) annotation(
    Line(points = {{-80, 62}, {-46, 62}}, color = {0, 0, 127}));

  // Freeze flags (fMax/fMin) are permanently disabled (always false)
  connect(awOn.y, antiWindupIntegrator.fMax);
  connect(awOn.y, antiWindupIntegrator.fMin);

  // Sum the proportional (u1) and anti-windup integral (u2) contributions
  connect(gain.y, add.u1) annotation(
    Line(points = {{-22, 62}, {-6, 62}, {-6, 54}, {28, 54}},
         color = {0, 0, 127}));

  // Output the combined PI signal
  connect(add.y, y) annotation(
    Line(points = {{52, 48}, {80, 48}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add.u2) annotation(
    Line(points = {{-10, 24}, {28, 24}, {28, 42}}, color = {0, 0, 127}));

  // Connect the error signal to the anti-windup integrator
  connect(antiWindupIntegrator.u, e) annotation(
    Line(points = {{-34, 24}, {-80, 24}, {-80, 62}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html>
      <p>PI controller with anti-windup on the integral path.</p>
      <p>Author: Gaia Bergamaschi</p>
    </html>"),
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
