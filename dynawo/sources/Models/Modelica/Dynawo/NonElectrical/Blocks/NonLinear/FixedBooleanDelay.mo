within Dynawo.NonElectrical.Blocks.NonLinear;
block FixedBooleanDelay "Delay block with fixed delay time for boolean input"
  extends Modelica.Blocks.Interfaces.BooleanSISO(y(start = Y0));

  parameter Dynawo.Types.Time tDelay "Delay time in s";

  parameter Boolean Y0 "Initial value of output";

protected
  Real uReal "Boolean input signal converted to real";
  Real yReal "Delayed real signal";

equation
  uReal = if u then 1 else 0;
  yReal = delay(uReal, tDelay);

  when yReal > 0.5 then
    y = true;
  elsewhen yReal < 0.5 then
    y = false;
  end when;

  annotation(
  preferredView = "text",
  Icon(graphics = {Line(points = {{-60, -80}, {10, -80}, {10, 80}, {60, 80}, {60, -80}, {92, -80}}, color = {160, 160, 164}), Line(points = {{-92, -80}, {-60, -80}, {-60, 80}, {-10, 80}, {-10, -80}, {92, -80}}, color = {255, 0, 255})}),
  Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  Documentation(info= "<html><head></head><body>
  <p>The boolean output <b>y</b> is delayed by <b>tDelay</b> compared to the Boolean input <b>u</b>.</p>
  <p>The change in boolean output is triggered when the delayed real signal crosses a threshold halfway between&nbsp;the extreme values of 0 and 1.</p><p>The use of a when structure ensures that this change is instantaneous i.e. there is a rising or falling edge.</p>
  </body></html>"));
end FixedBooleanDelay;
