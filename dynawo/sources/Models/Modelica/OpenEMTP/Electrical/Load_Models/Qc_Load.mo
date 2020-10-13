within OpenEMTP.Electrical.Load_Models;
model Qc_Load "Capacitive reactive power load"
  import  Modelica.Constants;
  parameter Real V(unit = "kV RMSLL") = 345 "Nominal Voltage";
  parameter Real Qc[3](each unit = "MVAR")=(92/3)*{1,1,1} "Capacitive reactive powers {Qa,Qb,Qc}";
  parameter SI.Frequency f = 60 "Nominal frequency";

  final parameter Real C1 = 3 * Qc[1] / (2*Constants.pi*f* V ^ 2), C2 = 3 * Qc[2] / (2*Constants.pi*f* V ^ 2), C3 = 3 * Qc[3] / (2*Constants.pi*f * V ^ 2);
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.C C(C = {C1, C2, C3}) annotation (
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlug annotation (
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {68, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  RLC_Branches.Ground ground annotation (
    Placement(visible = true, transformation(origin = {90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Star star annotation (
    Placement(visible = true, transformation(origin = {68, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(star.pin_n, ground.p) annotation (
    Line(points = {{78, 60}, {90, 60}, {90, 40}, {90, 40}}, color = {0, 0, 255}));
  connect(C.plug_n, star.plug_p) annotation (
    Line(points = {{40, 60}, {58, 60}, {58, 60}, {58, 60}}, color = {0, 0, 255}));
  connect(positivePlug, C.plug_p) annotation (
    Line(points = {{0, 100}, {0, 100}, {0, 60}, {20, 60}, {20, 60}}, color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-27 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "Qc_Load",
    Icon(graphics = {Line(origin = {67.89, 46.44}, points = {{0, 45}, {0, -69}}, color = {0, 0, 255}, thickness = 0.5), Text(origin = {-62, 20}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-74, 104}, extent = {{-150, -40}, {150, -80}}, textString = "%Qc"), Polygon(origin = {68, -30}, rotation = 180, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{0, 10}, {12, -10}, {-10, -10}, {-12, -10}, {0, 10}})}, coordinateSystem(initialScale = 0.1)));
end Qc_Load;
