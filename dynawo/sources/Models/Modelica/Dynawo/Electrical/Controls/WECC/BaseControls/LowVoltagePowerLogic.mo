within Dynawo.Electrical.Controls.WECC.BaseControls;
model LowVoltagePowerLogic "Low Voltage Power Limiter block"

  parameter Types.PerUnit zerox "LVPL zero crossing in pu (base UNom)";
  parameter Types.PerUnit brkpt "LVPL breakpoint in pu (base UNom)";
  parameter Types.PerUnit lvpl1 "LVPL gain breakpoint in pu";

  // Input variable
  Modelica.Blocks.Interfaces.RealInput UPu "Filtered inverter terminal voltage magnitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput LVPL "LVPL output in pu" annotation(
    Placement(visible = true, transformation(origin = {117, -1}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));

  Types.PerUnit mlvpl;

equation
  LVPL = if UPu < zerox then 0 else if UPu > brkpt then 9999 else mlvpl*(UPu - zerox);
  mlvpl = lvpl1/(brkpt-zerox);

annotation(
    Icon(graphics = {Text(origin = {4, 4}, extent = {{-54, 40}, {54, -40}}, textString = "LVPL"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end LowVoltagePowerLogic;
