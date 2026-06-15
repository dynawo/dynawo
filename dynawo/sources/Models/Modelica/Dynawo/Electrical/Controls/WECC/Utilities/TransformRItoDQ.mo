within Dynawo.Electrical.Controls.WECC.Utilities;
block TransformRItoDQ "Transformation from real/imaginary in stationary reference frame to d/q rotating reference frame with rotation angle phi"

  Modelica.Blocks.Interfaces.RealInput phi "Angle of the dq transform in rad" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u "Complex input" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput ud "d-axis output" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uq "q-axis output" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  ud = ComplexMath.real(u) * cos(phi) + ComplexMath.imag(u) * sin(phi);
  uq = (-ComplexMath.real(u) * sin(phi)) + ComplexMath.imag(u) * cos(phi);

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Text(origin = {-114, -38}, extent = {{-25, 14}, {14, -7}}, textString = "phi"), Text(origin = {135, 63}, extent = {{-14, 7}, {14, -7}}, textString = "ydPu"), Text(origin = {134, -58}, extent = {{-14, 7}, {14, -7}}, textString = "yqPu"), Text(origin = {-130, 85}, extent = {{-14, 7}, {14, -7}}, textString = "uPu"), Text(origin = {-20, 14}, extent = {{-60, 66}, {100, -94}}, textString = "RI/DQ"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end TransformRItoDQ;
