within Dynawo.NonElectrical.Blocks.NonLinear;
block PulseMinimumDuration "Activates a Boolean signal for a duration tPulse or more if input is true"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BasePulse;

equation
  y = u or time - tTrigger < tPulse;

  annotation(
    preferredView = "text",
    Documentation(info= "<html><head></head><body><p>
The Boolean output y depends on the activation of a Boolean input.</p><p>If this Boolean becomes true, y is true at least for a duration tPulse. y becomes false again&nbsp;<span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">if u is false and the duration tPulse has elapsed</span>.</p>
</body></html>"));
end PulseMinimumDuration;
