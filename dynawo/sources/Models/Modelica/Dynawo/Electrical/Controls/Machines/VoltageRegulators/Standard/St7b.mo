within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St7b "IEEE excitation system type ST7B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt7;

equation
  connect(min2.y, variableLimiter.u) annotation(
    Line(points = {{222, 0}, {298, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St7b;
