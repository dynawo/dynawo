model Model1
  parameter Real a = 1;
  parameter Real b = 2;
  Real u (start = 1);
  Real v;
equation
  a*der(u) = -b*u;
end Model1;
