within Dynawo.NonElectrical.Blocks.NonLinear;
block FlipFlopR "RS flip flop with priority to reset"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseRSFlipFlop;

equation
  when s and not r then
    y = true;
  elsewhen r then
    y = false;
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>
The output <code>y</code>&nbsp; becomes true when s is true and r is false. y remains true as long as r is false.</p>
</body></html>"),
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-10, -90}, {-70, -30}}, endAngle = 360)}));
end FlipFlopR;
