within OpenEMTP.Electrical.Load_Models;
model P_Load "Parallel R Load"

  parameter Real  V( unit = "kV RMSLL") = 25
                                            "Nominal Voltage";
  parameter Real  P[3]( each unit = "MW")        "Active powers {Pa,Pb,Pc}";
  parameter SI.Frequency   f =            60
                                            "Nominal frequency";

  final parameter Real R1=V^2/3/P[1], R2=V^2/3/P[2], R3=V^2/3/P[3];
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R R(R = {R1, R2, R3})  annotation (
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.Ground ground annotation (
    Placement(visible = true, transformation(origin = {90, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Star star annotation (
    Placement(visible = true, transformation(origin = {68, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlug annotation (
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {68, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(star.pin_n, ground.p) annotation (
    Line(points = {{78, 60}, {90, 60}, {90, 40}}, color = {0, 0, 255}));
  connect(positivePlug,R. plug_p) annotation (
    Line(points = {{0, 100}, {0, 100}, {0, 60}, {20, 60}, {20, 60}}, color = {0, 0, 255}));
  connect(R.plug_n, star.plug_p) annotation (
    Line(points = {{40, 60}, {58, 60}, {58, 60}, {58, 60}}, color = {0, 0, 255}));

annotation (Documentation(info= "<html><head></head><body><p><br></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-20 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "P_Load", Icon(graphics={  Line(origin = {67.89, 46.44}, points = {{0, 45}, {0, -69}}, color = {0, 0, 255}, thickness = 0.5), Text(origin = {-62, 20}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-74, 104}, extent = {{-150, -40}, {150, -80}}, textString = "%P"),                                                                                  Polygon(origin = {68, -30}, rotation = 180, lineColor = {0, 0, 255}, fillColor = {0, 0, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points = {{0, 10}, {12, -10}, {-10, -10}, {-12, -10}, {0, 10}})}, coordinateSystem(initialScale = 0.1)));
end P_Load;
