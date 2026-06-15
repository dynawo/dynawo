within Dynawo.NonElectrical.Blocks.NonLinear.BaseClasses;
partial block BaseRSFlipFlop "Base block of RS flip flop"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  parameter Boolean Y0 = false "Start value of y";

  Modelica.Blocks.Interfaces.BooleanInput r annotation(
      Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.BooleanInput s annotation(
      Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.BooleanOutput y(start = Y0) annotation(
      Placement(transformation(extent={{100,-10},{120,10}})));

  annotation(
   preferredView = "text",
   Icon(graphics={
      Text(
        extent={{-60,-30},{-20,-90}},
        textString="r"),
      Text(extent = {{-60, 90}, {-20, 30}}, textString = "s"),
      Ellipse(lineColor = {235, 235, 235}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-73, 54}, {-87, 68}}, endAngle = 360),
      Ellipse(lineColor = {235, 235, 235}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{-71, -52}, {-85, -66}}, endAngle = 360),
      Ellipse(lineColor = {235, 235, 235}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, extent = {{71, 7}, {85, -7}}, endAngle = 360)}));
end BaseRSFlipFlop;
