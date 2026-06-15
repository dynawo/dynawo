within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model Ac1a "IEEE exciter type AC1A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc1(
    VeMinPu = 0,
    VfeMaxPu = 999);

equation
  max1.u[3] = max1.u[2];
  min1.u[3] = min1.u[2];

  connect(add3.y, feedback.u1) annotation(
    Line(points = {{-178, -20}, {-88, -20}}, color = {0, 0, 127}));
  connect(UOelPu, min1.u[2]) annotation(
    Line(points = {{-300, 60}, {100, 60}, {100, -20}, {120, -20}}, color = {0, 0, 127}));
  connect(UUelPu, max1.u[2]) annotation(
    Line(points = {{-300, -100}, {40, -100}, {40, -20}, {60, -20}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(preferredView = "diagram");
end Ac1a;
