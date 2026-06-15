within Dynawo.NonElectrical.Blocks.NonLinear;
block LimiterWithLag "Limiter that enforces saturations only after they were violated without interruption during a given amount of time"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag;

equation
  y = if (time - tUMinReached >= LagMin) then UMin elseif (time - tUMaxReached >= LagMax) then UMax else u;

  annotation(preferredView = "text");
end LimiterWithLag;
