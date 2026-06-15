within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model IEEEX2 "IEEE excitation system type 2 model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseIEEEX;

  //Regulation parameter
  parameter Types.Time tF2 "Feedback lag time constant in s";

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tF2, y_start = Va0Pu) annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(limitedFirstOrder.y, firstOrder1.u) annotation(
    Line(points = {{-18, 0}, {0, 0}, {0, -60}, {-18, -60}}, color = {0, 0, 127}));
  connect(firstOrder1.y, derivative.u) annotation(
    Line(points = {{-41, -60}, {-59, -60}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end IEEEX2;
