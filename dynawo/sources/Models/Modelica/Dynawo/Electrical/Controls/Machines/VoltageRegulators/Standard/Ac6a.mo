within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model Ac6a "IEEE excitation system type AC6A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc6(
    sum1(
    nin      = 2),
    VeMinPu = 0,
    VfeMaxPu = 999);

equation
  connect(limitedLeadLag.y, feedback.u1) annotation(
    Line(points = {{-38, 0}, {112, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-360, -80}, {-200, -80}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dash));

  annotation(preferredView = "diagram");
end Ac6a;
