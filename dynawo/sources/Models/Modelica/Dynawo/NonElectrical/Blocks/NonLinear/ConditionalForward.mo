within Dynawo.NonElectrical.Blocks.NonLinear;
block ConditionalForward "Forwards the first input if it is positive or if the second input is negative and returns a third (optional) one if neither one of the conditions is valid."

  discrete Modelica.Blocks.Interfaces.RealInput u1 "The first input" annotation(Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  discrete Modelica.Blocks.Interfaces.RealInput u2 "The second input" annotation(Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  discrete Modelica.Blocks.Interfaces.RealInput u3(start = u30) "The failing case input" annotation(Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y "Output signal connector" annotation(Placement(
        transformation(extent={{100,-10},{120,10}})));

  parameter Real u30;

equation
  if (u1 > 0) or (u2 <= 0) then
    y = u1;
  else
    y = u3;
  end if;

  annotation(preferredView = "diagram");
end ConditionalForward;
