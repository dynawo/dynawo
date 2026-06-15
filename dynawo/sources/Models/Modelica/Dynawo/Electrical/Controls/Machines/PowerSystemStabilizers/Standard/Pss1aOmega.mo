within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;
model Pss1aOmega "IEEE power system stabilizer type 1A, with angular frequency input"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss1a(firstOrder(
    y_start            = SystemBase.omega0Pu), washout(
    U0         = Ks * SystemBase.omega0Pu)
                                         );

  //Input variable
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  connect(omegaPu, firstOrder.u) annotation(
    Line(points = {{-200, 0}, {-122, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss1aOmega;
