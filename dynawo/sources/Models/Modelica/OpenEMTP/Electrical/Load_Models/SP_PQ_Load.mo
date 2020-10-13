within OpenEMTP.Electrical.Load_Models;

model SP_PQ_Load "Single phase PQ load"
parameter Boolean Series=false "Use RL series model" annotation(Evaluate=true, HideResult=true, choices(checkBox=true)) ;
parameter Boolean Ground=false "Show ground Pin" annotation(Evaluate=true, HideResult=true, choices(checkBox=true)) ;
parameter Real V (unit = "kV RMSLL")= 25 "Nominal voltage";
parameter Real P (unit = "kW")= 100 "Single Phase active power";
parameter Real QL(unit = "kVAR")= 50 "Single Phase reactive power";
parameter Real f=60"Nominal frequency";
final parameter Real w=2*Modelica.Constants.pi*f;
final parameter Real Rp=V^2*1e3/3/P;
final parameter Real Lp=V^2*1e3/3/w/QL;
final parameter Real Rs=V^2*1e3/3*P/(P^2+QL^2);
final parameter Real Ls=V^2*1e3/3*QL/(P^2+QL^2)/w;
  Modelica.Electrical.Analog.Basic.Resistor R(R = if Series and not Ground  then Rs elseif Series and Ground then 3*Rs elseif not Series and not Ground  then Rp else 3*Rp )  annotation(
    Placement(visible = true, transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor L(L = if Series and not Ground  then Ls elseif Series and Ground then 3*Ls elseif not Series and not Ground  then Lp else 3*Lp)  annotation(
    Placement(visible = true, transformation(origin = {-48, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground G annotation(
    Placement(visible = true, transformation(origin = {86, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n annotation(
    Placement(visible = true, transformation(origin = {56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = { 0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
     if Series then
        if Ground then
           connect(R.p, pin_p);
           connect(R.n, L.p);
           connect(L.n, pin_n);
        else
           connect(R.p, pin_p);
           connect(R.n, L.p);
           connect(L.n, pin_n);
           connect(pin_n, G.p);
        end if;
     else
        if Ground then
           connect(R.p, pin_p);
           connect(R.p, L.p);
           connect(R.n, pin_n);
           connect(L.n, pin_n);
        else
           connect(R.p, pin_p);
           connect(R.p, L.p);
           connect(R.n, pin_n);
           connect(L.n, pin_n);
           connect(pin_n, G.p);
        end if;
     end if;

  annotation(
    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-09-10 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    defaultComponentName = "PQ_Load",
    Icon(graphics = {Line(origin = {0.67481, 35.4273}, points = {{0, 45}, {0, -93}}, color = {0, 0, 255}, thickness = 0.5), Text(origin = {-88, 22}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-100, 100}, extent = {{-150, -40}, {150, -80}}, textString = "%P [kW]"), Text(origin = {-102, 58}, extent = {{-150, -40}, {152, -78}}, textString = "%Q [kVar]"), Polygon(origin = {0, -68}, rotation = 180, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{0, 10}, {12, -10}, {-10, -10}, {-12, -10}, {0, 10}}), Text(origin = {-86, 18}, extent = {{-150, -40}, {152, -78}}, textString = "%V [kV]")}, coordinateSystem(initialScale = 0.1)));
end SP_PQ_Load;
