within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St5b "IEEE exciter type ST5B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt5;

equation
  if min1.y < max1.y then
    limiter.u = limitedLeadLag2.y;
  elseif max1.y > add3.y then
    limiter.u = limitedLeadLag1.y;
  else
    limiter.u = limitedLeadLag.y;
  end if;

  max1.u[3] = max1.u[2];
  min1.u[3] = min1.u[2];

  connect(add3.y, max1.u[1]) annotation(
    Line(points = {{-239, -20}, {-160, -20}}, color = {0, 0, 127}));
  connect(UUelPu, max1.u[2]) annotation(
    Line(points = {{-380, -80}, {-180, -80}, {-180, -20}, {-160, -20}}, color = {0, 0, 127}));
  connect(UOelPu, min1.u[2]) annotation(
    Line(points = {{-380, 80}, {-120, 80}, {-120, -14}, {-100, -14}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(preferredView = "diagram");
end St5b;
