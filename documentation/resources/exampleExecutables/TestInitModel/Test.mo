model Test
  parameter Real a;
  parameter Real b;
  parameter Real u0;
  Real u (start = u0);
equation
  a * der(u) = -b * u;
end Test;
