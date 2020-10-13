within OpenEMTP.Electrical.RLC_Branches.MultiPhase;
model Ground "Multi phase ground"
  parameter Integer m(final min=1) = 3 "Number of phases" annotation(HideResult=true);
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Star star1(final m = m)  annotation (
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground1 annotation(HideResult=true,
    Placement(visible = true, transformation(origin = { -8, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Interfaces.MultiPhase.PositivePlug positivePlug1(final m = m)  annotation (
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(star1.plug_p, positivePlug1) annotation (
    Line(points = {{-50, 0}, {-94, 0}, {-94, 0}, {-96, 0}}, color = {0, 0, 255}));
  connect(star1.pin_n, ground1.p) annotation (
    Line(points = {{-30, 0}, {-8, 0}, {-8, -2}, {-8, -2}}, color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html>
<p>Ground of an electrical circuit. The potential at the ground node is zero. Every electrical circuit has to contain at least one ground object.</p>
</html>", revisions = "<html>
<ul>
<li><em> 1998   </em>
     by Christoph Clauss<br> initially implemented<br>
     </li>
</ul>
</html>"),defaultComponentName = "G",
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Line(points = {{-60, 50}, {60, 50}}, color = {0, 0, 255}), Line(points = {{-40, 30}, {40, 30}}, color = {0, 0, 255}), Line(points = {{-20, 10}, {20, 10}}, color = {0, 0, 255}), Line(points = {{0, 90}, {0, 50}}, color = {0, 0, 255}), Text(extent = {{-150, -10}, {150, -50}}, textString = "%name", lineColor = {0, 0, 255})}),
    uses(Modelica(version = "3.2.3")));
end Ground;
