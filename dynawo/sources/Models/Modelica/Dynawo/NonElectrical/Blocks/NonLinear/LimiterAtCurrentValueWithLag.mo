within Dynawo.NonElectrical.Blocks.NonLinear;
block LimiterAtCurrentValueWithLag "Limiter that enforces saturations only after they were violated without interruption during a given amount of time, the lower saturation value being its current value"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag;

equation
  if (time - tUMinReached >= LagMin) then
    der(y) = 0;
  elseif (time - tUMaxReached >= LagMax) then
    y= UMax;
  else
    y = u;
  end if;

  annotation(preferredView = "text");
end LimiterAtCurrentValueWithLag;
