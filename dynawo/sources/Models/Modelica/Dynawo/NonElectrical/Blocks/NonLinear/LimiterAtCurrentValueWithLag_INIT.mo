within Dynawo.NonElectrical.Blocks.NonLinear;
model LimiterAtCurrentValueWithLag_INIT "Initialization model of LimiterAtCurrentValueWithLag"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag_INIT;

equation
  y0 = if u0 > UMax then UMax else u0;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>In this model, <i>y0</i> complies only with <b>UMax</b>.</body></html>"));
end LimiterAtCurrentValueWithLag_INIT;
