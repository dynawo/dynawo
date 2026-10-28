within Dynawo.Electrical.Controls.Utilities;

model Derivative

  Modelica.ComplexBlocks.Interfaces.ComplexInput u;
  Modelica.ComplexBlocks.Interfaces.ComplexOutput dudt;

equation
  dudt = Complex(der(u.re), der(u.im));

end Derivative;
