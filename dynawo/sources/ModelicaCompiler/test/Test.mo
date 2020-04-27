package Test

model Test
  parameter Real a = 1;
  parameter Real b = 2;
  Real u (start = 1);
  Real x;
  Real y;
equation
  a*der(u) = -b*u;
  x = 2*u;
  y = x;
end Test;

end Test;
