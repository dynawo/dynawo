within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St1a "IEEE excitation system type ST1A model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt1(sum1(
    nin      = 3)
                );

equation
  max1.u[3] = max1.u[2];
  max2.u[3] = max2.u[2];
  min2.u[3] = min2.u[2];
  sum1.u[2] = 0;

  connect(max1.y, transferFunction1.u) annotation(
    Line(points = {{-78, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(UOelPu, min2.u[2]) annotation(
    Line(points = {{-440, 80}, {280, 80}, {280, 0}, {300, 0}}, color = {0, 0, 127}, pattern = LinePattern.Dot));

  annotation(preferredView = "diagram");
end St1a;
