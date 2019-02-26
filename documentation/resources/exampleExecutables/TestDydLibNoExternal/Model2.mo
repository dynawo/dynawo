model Model2
  parameter Real a = 1;
  parameter Real b = 2;
  Real v (start = 2);
equation
  a*der(v) = b*v;
end Model2;
