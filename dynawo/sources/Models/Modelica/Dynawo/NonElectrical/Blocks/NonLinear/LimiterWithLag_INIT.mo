within Dynawo.NonElectrical.Blocks.NonLinear;
model LimiterWithLag_INIT "Initialization model of LimiterWithLag"
  extends Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses.BaseLimiterWithLag_INIT;

equation
  y0 = if u0 < UMin then UMin elseif u0 > UMax then UMax else u0;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>In this model, <i>y0</i> complies with both <b>UMax</b> and <b>UMin</b>.</body></html>"));
end LimiterWithLag_INIT;
