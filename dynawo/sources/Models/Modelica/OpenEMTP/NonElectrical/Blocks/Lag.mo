within OpenEMTP.NonElectrical.Blocks;

block Lag
 parameter Real Ka "Voltage regulator gain Ka:";
 parameter Real Ta "Voltage regulator time constant Ta(s):";
 parameter Real VL[2] "Voltage regulator internal limits {VAmin(pu), VAmax(pu)}:";
 parameter Real Vint "Initial conditions:";
  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ka)  annotation(
    Placement(visible = true, transformation(origin = {-76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / Ta)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1, outMax = VL[2], outMin = VL[1], y_start = Vint)  annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(feedback.y, gain1.u) annotation(
    Line(points = {{-38, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(gain1.y, limIntegrator.u) annotation(
    Line(points = {{11, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, y) annotation(
    Line(points = {{61, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(gain.u, u) annotation(
    Line(points = {{-88, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback.u2) annotation(
    Line(points = {{61, 0}, {80, 0}, {80, -40}, {-48, -40}, {-48, -8}}, color = {0, 0, 127}));
  connect(gain.y, feedback.u1) annotation(
    Line(points = {{-65, 0}, {-56, 0}}, color = {0, 0, 127}));
  annotation (Documentation(info="<html>
<table cellspacing=\"1\" cellpadding=\"1\" border=\"1\">
<tr>
<td><p>Reference</p></td>
<td>IEEE Std. 421.5-2005, Annex E</td>
</tr>
<tr>
<td><p>Last update</p></td>
<td>2015-11-25</td>
</tr>
<tr>
<td><p>Author</p></td>
<td><p>Tin Rabuzin,SmarTS Lab, KTH Royal Institute of Technology</p></td>
</tr>
<tr>
<td><p>Contact</p></td>
<td><p><a href=\"mailto:luigiv@kth.se\">luigiv@kth.se</a></p></td>
</tr>
</table>
</html>"),
    Icon(graphics = {Line(points = {{40, 100}, {60, 140}, {100, 140}}, color = {0, 0, 255}), Text(lineColor = {0, 0, 255}, extent = {{-20, 68}, {20, 8}}, textString = "K"), Line(points = {{-80, 0}, {78, 0}}, color = {0, 0, 255}, thickness = 0.5, smooth = Smooth.Bezier), Text(origin = {4, 4}, lineColor = {0, 0, 255}, extent = {{-70, -20}, {70, -80}}, textString = "Ta*s+1"), Line(points = {{-100, -140}, {-60, -140}, {-40, -100}}, color = {0, 0, 255}), Rectangle(lineColor = {0, 0, 255}, extent = {{-100, 100}, {100, -100}})}),
    Diagram);
end Lag;
