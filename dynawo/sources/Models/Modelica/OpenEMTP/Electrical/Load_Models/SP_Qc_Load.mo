within OpenEMTP.Electrical.Load_Models;

model SP_Qc_Load "Single phase pure capaitive reactive power"

parameter Boolean Ground=false "Show ground Pin" annotation(Evaluate=true, HideResult=true, choices(checkBox=true)) ;
parameter Real V (unit = "kV RMSLL")= 25 "Nominal voltage";
parameter Real Qc(unit = "kVAR")    = 50  "Single Phase reactive power";
parameter Real f=60"Nominal frequency";
final parameter Real w=2*Modelica.Constants.pi*f;
final parameter Real Cp=1/(V^2*1e3/3/w/Qc);

  Modelica.Electrical.Analog.Basic.Capacitor C(C = Cp)   annotation(
    Placement(visible = true, transformation(origin = {-48, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground G annotation(
    Placement(visible = true, transformation(origin = {86, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

        if Ground then
           connect(C.p, pin_p);
           connect(C.n, pin_n);
        else
           connect(C.p, pin_p);
           connect(C.n, pin_n);
           connect(pin_n, G.p);
        end if;

  annotation(
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-09-10 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "Qc_Load",
    Icon(graphics = {Line(origin = {0.67481, 35.4273}, points = {{0, 45}, {0, -93}}, color = {0, 0, 255}, thickness = 0.5), Text(origin = {-88, 22}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-104, 104}, extent = {{-150, -40}, {152, -78}}, textString = "%Qc [kVar]"), Polygon(origin = {0, -68}, rotation = 180, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{0, 10}, {12, -10}, {-10, -10}, {-12, -10}, {0, 10}}), Text(origin = {-116, 58}, extent = {{-150, -40}, {152, -78}}, textString = "%V [kV]")}, coordinateSystem(initialScale = 0.1)));


end SP_Qc_Load;
