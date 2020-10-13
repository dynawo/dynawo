within OpenEMTP.Interfaces.MultiPhase;
partial model OnePort "Component with two electrical plugs and currents from plug_p to plug_n for three-phae system"
  parameter Integer m(min=1) = 3 "Number of phases" annotation(HideResult=true);
  Modelica.SIunits.Voltage v[m] "Voltage drops of the two three phase plugs";
  Modelica.SIunits.Current i[m] "Currents flowing into positive three phase plugs";
  PositivePlug plug_p annotation (
    Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NegativePlug plug_n annotation (
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  v = plug_p.pin.v - plug_n.pin.v;
  i = plug_p.pin.i;
  plug_p.pin.i + plug_n.pin.i = zeros(m);
  annotation (
    Documentation(info = "<html>
<p>
Superclass of elements which have <strong>two</strong> electrical plugs:
the positive plug connector <em>plug_p</em>, and the negative plug connector <em>plug_n</em>.
The currents flowing into plug_p are provided explicitly as currents i[m].
It is assumed that the currents flowing into plug_p are identical to the currents flowing out of plug_n.
</p>
</html>"));
end OnePort;
