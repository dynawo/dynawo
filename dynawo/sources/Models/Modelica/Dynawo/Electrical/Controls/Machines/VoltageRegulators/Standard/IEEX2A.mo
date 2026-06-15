within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model IEEX2A "IEEE excitation system type 2A model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseIEEEX(EfdMinPu = 0);

equation
  connect(product.y, derivative.u) annotation(
    Line(points = {{40, -80}, {20, -80}, {20, -60}, {-58, -60}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end IEEX2A;
