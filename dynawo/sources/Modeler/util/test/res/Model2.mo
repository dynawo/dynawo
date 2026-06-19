model Model2
  parameter Real a = 1;
  parameter Real b = 2;
  Modelica.Blocks.Interfaces.RealOutput v (start = 2);
  Real w;
equation
  a*der(v) = b*v;
end Model2;
