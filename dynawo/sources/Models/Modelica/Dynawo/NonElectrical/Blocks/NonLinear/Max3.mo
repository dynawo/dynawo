within Dynawo.NonElectrical.Blocks.NonLinear;
block Max3 "Pass through the largest of three signals, with an event generated when a switch occurs"
  extends Modelica.Blocks.Interfaces.MISO(nin = 3);

equation
  if u[1] > u[2] and u[1] > u[3] then
    y = u[1];
  elseif u[2] > u[1] and u[2] > u[3] then
    y = u[2];
  else
    y = u[3];
  end if;

  annotation(preferredView = "text");
end Max3;
