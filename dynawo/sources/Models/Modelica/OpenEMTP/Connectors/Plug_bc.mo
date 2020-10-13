within OpenEMTP.Connectors;

model Plug_bc
  parameter Integer m(final min = 1) = 3 "Number of phases in input";
  parameter Integer k(final min = 1) = 2 "Number of phases in output";
  parameter Integer n[k] = {2, 3} "Selecte the index phases";
  // Real C[m,k];
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlugIn(m = m) annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.NegativePlug positivePlugOut(m = k) annotation(
    Placement(visible = true, transformation(origin = {16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  for q in 1:k loop
    positivePlugOut.pin[q].v = positivePlugIn.pin[n[q]].v;
  end for;
  positivePlugIn.pin[1].i = 0;
  positivePlugIn.pin[2].i = -positivePlugOut.pin[1].i;
  positivePlugIn.pin[3].i = -positivePlugOut.pin[2].i;
  annotation(
    uses(Modelica(version = "3.2.2")),
    Icon(graphics = {Rectangle(origin = {-18, 14}, extent = {{-12, 2}, {48, -32}}), Text(origin = {32, -26}, extent = {{-12, 6}, {12, -6}}, textString = "out[k]"), Text(origin = {-32, -24}, extent = {{-10, 6}, {10, -6}}, textString = "in[m]")}, coordinateSystem(initialScale = 0.1)));

end Plug_bc;
