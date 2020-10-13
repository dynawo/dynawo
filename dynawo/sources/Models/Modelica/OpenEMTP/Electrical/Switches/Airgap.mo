within OpenEMTP.Electrical.Switches;

model Airgap
  parameter Real v0 (unit="kV RMS")=343 "minimum voltage: V_LN";
  parameter Real K=0.92;
  parameter Real D =1.4e-1"level parameter";
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch annotation(
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real EQ;
  final parameter Real V0=v0*1e3;
  Modelica.Blocks.Interfaces.BooleanInput u annotation(
    Placement(visible = true, transformation(origin = {-18, -58}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  OpenEMTP.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
 if switch.v<=V0 or u then
 switch.control=false;
 elseif EQ>D then
  switch.control=true;
 end if;
 if switch.v>=V0 then
  der(EQ)=(abs(switch.v) - V0 )^K;
 end if;
  connect(switch.p, pin_p) annotation(
    Line(points = {{-12, 0}, {-94, 0}, {-94, 0}, {-96, 0}}, color = {0, 0, 255}));
 connect(switch.n, pin_n) annotation(
    Line(points = {{8, 0}, {94, 0}, {94, 0}, {96, 0}}, color = {0, 0, 255}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>

<p><!--StartFragment-->t<sub>0</sub> is the time-point from which v<sub>gap</sub> became greater than
V<sub>0</sub>. When the voltage v<sub>gap</sub> goes below V<sub>0</sub> the
integral is reset.<br>The gap is an ideal open switch before flashover and
becomes an ideal closed switch after flashover. The gap stays closed after
flashover until the control signal becomes greater than 0, in which case it will
reset (open) the gap.&nbsp;<!--EndFragment--></p></body></html>"),
  Icon(graphics = {Ellipse(origin = {-37, -5}, lineColor = {0, 0, 255}, extent = {{-23, -15}, {17, 25}}, endAngle = 360), Line(origin = {-81, 0}, points = {{-19, 0}, {21, 0}}, color = {0, 0, 255}), Line(origin = {80.8987, -0.253165}, points = {{-21, 0}, {19, 0}}, color = {0, 0, 255}), Ellipse(origin = {43, -5}, lineColor = {0, 0, 255}, extent = {{-23, -15}, {17, 25}}, endAngle = 360), Text(origin = {45, -52}, extent = {{-23, 16}, {33, -26}}, textString = "%v0"), Text(origin = {-42, 37}, extent = {{-10, 9}, {10, -9}}, textString = "+"), Text(origin = {0, 8}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}));
end Airgap;
