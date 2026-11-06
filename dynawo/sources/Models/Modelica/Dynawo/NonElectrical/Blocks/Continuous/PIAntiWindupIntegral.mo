within Dynawo.NonElectrical.Blocks.Continuous;



model PIAntiWindupIntegral
  // ==========================================================
  // PI controller with anti-windup on the integral path
  // Computes y = k_p * e + AntiWindupIntegrator(e)
  // The anti-windup integrator limits its output between
  // YMin/YMax and limits its rate of change between DyMin/DyMax
  // ==========================================================

  // Parameters
  parameter Real Kp;        // Proportional gain
  parameter Real tI;         // Integral time constant
  parameter Real Y0;    // Initial value of the integrator output
  parameter Real DyMax;      // Maximum rate of change of the integrator output (DyMin = -DyMax)
  parameter Real YMax;       // Maximum (saturation) value of the integrator output (YMin = -YMax)

  // Input: error signal fed into the PI controller
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(
      transformation(origin = {-100, 0},
                     extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 0},
                         extent = {{-10, -10}, {10, 10}})));

  // Output: control signal produced by the PI controller
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(
      transformation(origin = {90, 0},
                     extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 0},
                         extent = {{-10, -10}, {10, 10}})));

  // Proportional path: multiplies the error by k_p
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(transformation(origin = {-30, 20},
                             extent = {{-10, -10}, {10, 10}})));

  // Integral path (with anti-windup) and P+I summation

  // Constant "false" signal used to permanently disable the freeze
  // flags (fMax/fMin) of the anti-windup integrator
  Modelica.Blocks.Sources.BooleanConstant awOn(k = false);

  // Sums the proportional and (anti-windup) integral contributions
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {30, 0},
                             extent = {{-10, -10}, {10, 10}})));

  // Integral path with anti-windup: limits both the output value
  // (YMin/YMax) and its rate of change (DyMin/DyMax) to avoid
  // integrator windup during saturation
  NonElectrical.Blocks.Continuous.AntiWindupIntegrator antiWindupIntegrator(DyMax = DyMax, DyMin = -DyMax, tI = tI, YMax = YMax, YMin = -YMax, Y0 = Y0, fMax(start = false), fMin(start = false), y(start = Y0))  annotation(
    Placement(transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}})));

equation
  // Connect the error signal to the proportional path
  connect(u, gain.u) annotation(
    Line(points = {{-100, 0}, {-59, 0}, {-59, 20}, {-42, 20}}, color = {0, 0, 127}));

  // Freeze flags (fMax/fMin) are permanently disabled (always false)
  connect(awOn.y, antiWindupIntegrator.fMax);
  connect(awOn.y, antiWindupIntegrator.fMin);

  // Sum the proportional (u1) and anti-windup integral (u2) contributions
  connect(gain.y, add.u1) annotation(
    Line(points = {{-19, 20}, {0, 20}, {0, 6}, {18, 6}},
         color = {0, 0, 127}));

  // Output the combined PI signal
  connect(add.y, y) annotation(
    Line(points = {{41, 0}, {90, 0}}, color = {0, 0, 127}));
  connect(antiWindupIntegrator.y, add.u2) annotation(
    Line(points = {{-19, -20}, {-19, -21}, {1, -21}, {1, -6}, {18, -6}}, color = {0, 0, 127}));

  // Connect the error signal to the anti-windup integrator
  connect(antiWindupIntegrator.u, u) annotation(
    Line(points = {{-42, -20}, {-59, -20}, {-59, 0}, {-100, 0}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html>
      <p>PI controller with anti-windup on the integral path.</p>
      <p>Author: Gaia Bergamaschi</p>
    </html>"),
    Icon(
      coordinateSystem(extent = {{-80, -60}, {80, 60}}),
      graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(
             origin = {0, -4},extent = {{-60, 20}, {60, -20}}, textString = "PI
Antiwindup")
      }),
    Diagram(coordinateSystem(extent = {{-80, -60}, {80, 60}})));
end PIAntiWindupIntegral;
