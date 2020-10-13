within OpenEMTP.Electrical.Sources;
model YCosineVoltage "m-Phase Y-connected cosine voltage "
 parameter Integer m(min = 1) = 3 "Number of phases" annotation(HideResult=true);
  OpenEMTP.Interfaces.MultiPhase.PositivePlug Pk(final m = m) annotation (
    Placement(visible = true, transformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Real Vm[m](each unit = "kV RMSLL") = {230, 230, 230} "Ampltitude of voltage" annotation(HideResult=true);
  parameter SI.Frequency f[m] = {60, 60, 60} "Frequency" annotation(HideResult=true);
  parameter SI.Angle Phase[m] = -
      Modelica.Electrical.MultiPhase.Functions.symmetricOrientation(m)  "phase angle" annotation(HideResult=true);
  parameter SI.Time StartTime[m] = {0, 0, 0} "start time, if t < t_start, the source is shorted" annotation(HideResult=true);
  parameter SI.Time StopTime[m] = {1, 1, 1} "stop time, if t > t_stop, the source is shorted" annotation(HideResult=true);
  OpenEMTP.Electrical.Sources.mPhaseCosineVoltage ac(final Phase = Phase, final StartTime = StartTime, final StopTime = StopTime, final Vm = Vm, final f = f, final m = m) annotation (
    Placement(visible = true, transformation(origin = {2, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground g(final m = m) annotation (
    Placement(visible = true, transformation(origin = {-42, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ac.plug_n, g.positivePlug1) annotation (
    Line(points = {{-8, 0}, {-42, 0}, {-42, -16}, {-42, -16}}, color = {0, 0, 255}));
  connect(ac.plug_p, Pk) annotation (
    Line(points = {{12, 0}, {92, 0}, {92, 0}, {96, 0}}, color = {0, 0, 255}));
  annotation (
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-29 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "AC",
    Icon(graphics = {Text(origin = {-45, 102}, lineColor = {0, 0, 255}, extent = {{-55, 26}, {87, -44}}, textString = "%name"), Ellipse(origin = {-47, -31}, lineColor = {0, 0, 255}, extent = {{-53, -49}, {107, 103}}, endAngle = 360), Line(origin = {73, 0}, points = {{-13, 0}, {13, 0}, {13, 0}}, color = {0, 0, 255}), Text(origin = {-120, 73}, extent = {{-30, 23}, {232, -149}}, textString = "~")}, coordinateSystem(initialScale = 0.1)));
end YCosineVoltage;
