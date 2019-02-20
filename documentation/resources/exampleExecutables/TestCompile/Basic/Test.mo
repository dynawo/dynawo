model Test
  parameter Real a = 1;
  parameter Real b = 2;
  Real u (start = 1);
equation
  a*der(u) = -b*u;
end Test;
