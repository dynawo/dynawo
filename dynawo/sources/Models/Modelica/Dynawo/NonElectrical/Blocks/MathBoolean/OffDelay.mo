within Dynawo.NonElectrical.Blocks.MathBoolean;
model OffDelay "Delay a falling edge of the input, but do not delay a rising edge."
  extends Modelica.Blocks.Interfaces.PartialBooleanSISO_small;

  parameter Modelica.Units.SI.Time tDelay "Delay time in s";

protected
  Boolean delaySignal(start = false);
  discrete Modelica.Units.SI.Time tNext(start=-1);

equation
  if delaySignal then
    y = time <= tNext;
  else
    y = false;
  end if;

  when u then
    delaySignal = false;
    tNext = time - 1;
  elsewhen not u and pre(u) == true then
    delaySignal = true;
    tNext = time + tDelay;
  end when;

  annotation(preferredView = "text");
end OffDelay;
