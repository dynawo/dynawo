within Dynawo.NonElectrical.Blocks.NonLinear;

block SwitchInt

  import Modelica;

  Modelica.Blocks.Interfaces.IntegerInput u0 "Connector of second Real input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput u1 "Connector of first Real input signal" annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput M "Connector of switch input signal" annotation(
    Placement(visible = true, transformation(origin = {-120,0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  Modelica.Blocks.Interfaces.IntegerOutput y "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {120, -4.44089e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  y = if M then u1 else u0;

  annotation (
    defaultComponentName="switch1",
    Documentation(info="<html>
<p>The Logical.Switch switches, depending on the
logical connector u2 (the middle connector)
between the two possible input signals
u1 (upper connector) and u3 (lower connector).</p>
<p>If u2 is <strong>true</strong>, the output signal y is set equal to
u1, else it is set equal to u3.</p>
</html>"),
    Icon(coordinateSystem(
        initialScale = 0.1), graphics={Rectangle(fillColor = {186, 189, 182}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-85, 61}, extent = {{-13, 13}, {13, -13}}, textString = "0"), Text(origin = {-85, -59}, extent = {{-13, 13}, {13, -13}}, textString = "1")}));

end SwitchInt;
