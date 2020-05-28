package TestSilentZ

model TestSilentZ
  Real u (start = 1);
  Real x;
  Integer z1(start = 1), z2(start = 1), z3(start = 1);
  Boolean b;
equation
  der(u) = 5;
  if (time > 2) then
    z1 = 2;
    z3 = 2;
  else
    z1 = 1;
    z3 = 1;
  end if;
  z2 = z1;
  b = (z2 == 2);
  if (b) then
    x = u;
  else
    x = z3*u;
  end if;
end TestSilentZ;

end TestSilentZ;
