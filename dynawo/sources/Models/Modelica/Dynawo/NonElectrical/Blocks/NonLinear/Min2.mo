within Dynawo.NonElectrical.Blocks.NonLinear;
block Min2 "Pass through the smaller signal, with an event generated when a switch occurs"
  extends Modelica.Blocks.Interfaces.SI2SO;

equation
  if u1 < u2 then
    y = u1;
  else
    y = u2;
  end if;

  annotation(preferredView = "text");
end Min2;
