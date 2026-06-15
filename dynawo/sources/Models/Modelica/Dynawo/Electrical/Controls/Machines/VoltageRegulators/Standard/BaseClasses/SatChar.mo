within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses;
block SatChar "Saturation characteristic of exciter"

  parameter Types.PerUnit Asq "Threshold below which saturation function output is zero";
  parameter Types.PerUnit Bsq "Proportional coefficient of saturation characteristic";
  parameter Types.PerUnit Sq "Ratio of saturation characteristic";
  parameter Types.PerUnit UHigh "Higher abscissa of saturation characteristic";
  parameter Types.PerUnit ULow "Lower abscissa of saturation characteristic";
  parameter Types.PerUnit YHigh "Higher ordinate of saturation characteristic";
  parameter Types.PerUnit YLow "Lower ordinate of saturation characteristic";

  Modelica.Blocks.Interfaces.RealInput u "Input of saturation function" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y "Output of saturation function" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if u  > Asq then
    y = Bsq * (u - Asq) ^ 2;
  else
    y = 0;
  end if;

  annotation(preferredView = "text",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 2},extent = {{-40, 40}, {40, -40}}, textString = "S(E)"), Text(lineColor = {0, 0, 255}, extent = {{-150, 140}, {150, 100}}, textString = "%name")}));
end SatChar;
