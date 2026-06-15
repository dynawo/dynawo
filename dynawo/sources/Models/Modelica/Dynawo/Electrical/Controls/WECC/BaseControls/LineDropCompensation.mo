within Dynawo.Electrical.Controls.WECC.BaseControls;
model LineDropCompensation "This block calculates the voltage drop in an RcPu, XcPu line knowing the current and the voltage on one side"

  parameter Types.PerUnit RcPu "Line drop compensation resistance in pu (base UNom, SnRef)";
  parameter Types.PerUnit XcPu "Line drop compentation reactance in pu (base UNom, SnRef)";

  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu "Line complex current in pu (base UNom, SnRef)" annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput u2Pu "Complex voltage at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput U1Pu "Voltage module at terminal 1 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput U2Pu "Voltage module at terminal 2 in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  U1Pu =Modelica.ComplexMath.abs(u2Pu + iPu*Complex(RcPu, XcPu));
  U2Pu =Modelica.ComplexMath.abs(u2Pu);

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 2}, extent = {{-76, 78}, {84, -82}}, textString = "|V-Z*I|"), Text(origin = {-141, 89}, extent = {{3, -3}, {37, -19}}, textString = "iPu"), Text(origin = {-141, -31}, extent = {{3, -3}, {37, -19}}, textString = "u2Pu"), Text(origin = {89, -33}, extent = {{9, -7}, {37, -19}}, textString = "U2Pu"), Text(origin = {89, 87}, extent = {{9, -7}, {37, -19}}, textString = "U1Pu")}, coordinateSystem(initialScale = 0.1)));
end LineDropCompensation;
