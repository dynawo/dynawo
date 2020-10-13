within OpenEMTP.NonElectrical.Blocks;

block Hold_t0
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-106, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  when { initial()} then
    y = u;
  end when;
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -1}, lineColor = {0, 0, 255}, extent = {{-100, 61}, {100, -61}}), Text(origin = {-15, 1}, extent = {{-75, 27}, {107, -23}}, textString = "Hold t0")}, coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><i>This function holds the value of input &nbsp;\"u\" at inital time (i.e. t=0s)</i></body></html>", revisions = "<html><head></head><body><ul style=\"font-size: 12px;\"><li><em>20120-06-01 &nbsp;&nbsp;</em>&nbsp;by Alireza Masoom initially implemented</li></ul></body></html>"));
end Hold_t0;
