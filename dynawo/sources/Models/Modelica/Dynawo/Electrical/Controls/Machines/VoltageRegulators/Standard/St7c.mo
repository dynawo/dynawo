within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St7c "IEEE excitation system type ST7C model (2016 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseSt7;

  //Regulation parameter
  parameter Types.Time tA "Thyristor bridge firing control equivalent time constant in s";

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tA, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter (calculated by the initialization model)
  parameter Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  connect(firstOrder1.y, variableLimiter.u) annotation(
    Line(points = {{261, 0}, {298, 0}}, color = {0, 0, 127}));
  connect(min2.y, firstOrder1.u) annotation(
    Line(points = {{221, 0}, {238, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end St7c;
