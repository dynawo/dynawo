within Dynawo.Electrical.Controls.WECC.BaseControls;
model VoltageCheck "This block generates a signal to freeze the control when the voltage is too low or too high"

  parameter Types.PerUnit UMinPu "Lower voltage limit for freeze in pu (base UNom)";
  parameter Types.PerUnit UMaxPu "Upper voltage limit for freeze in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput UPu "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput freeze "Boolean to freeze the regulation" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  freeze = UPu < UMinPu or UPu > UMaxPu;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {18, -4}, extent = {{-98, 84}, {62, -76}}, textString = "Voltage Check"), Text(origin = {-121.5, 18}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "UPu"), Text(origin = {112.5, 20}, extent = {{-10.5, 7}, {31.5, -20}}, textString = "freeze")}, coordinateSystem(initialScale = 0.1)));
end VoltageCheck;
