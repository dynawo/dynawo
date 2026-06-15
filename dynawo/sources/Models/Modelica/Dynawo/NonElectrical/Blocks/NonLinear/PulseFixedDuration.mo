within Dynawo.NonElectrical.Blocks.NonLinear;
block PulseFixedDuration "Activates a Boolean signal for a duration tPulse"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BasePulse;

equation
  y = time - tTrigger < tPulse;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>
The Boolean output y depends on the activation of a Boolean input.</p><p>If this Boolean becomes true, y is true for a duration tPulse. Otherwise y is false.</p>
</body></html>"));
end PulseFixedDuration;
