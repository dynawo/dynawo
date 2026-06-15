within Dynawo.NonElectrical.Blocks.NonLinear;
block FlipFlopS "RS flip flop with priority to set"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseRSFlipFlop;

equation
  when r and not s then
    y = false;
  elsewhen s then
    y = true;
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body><p>
The output <code>y</code>&nbsp; becomes false when r is true and s is false. y remains false as long as s is false.</p>
</body></html>"),
    Icon(graphics = {Ellipse(fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-10, 30}, {-70, 90}}, endAngle = 360)}));
end FlipFlopS;
