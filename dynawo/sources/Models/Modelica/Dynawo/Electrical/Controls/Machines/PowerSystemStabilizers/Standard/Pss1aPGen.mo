within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;
model Pss1aPGen "IEEE power system stabilizer type 1A, with active power input"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss1a(firstOrder(
    y_start            = PGen0Pu * SystemBase.SnRef / SNom), washout(
    U0         = Ks * PGen0Pu * SystemBase.SnRef / SNom)
                                                       );

  //Generator parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain1(k = SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameter
  parameter Types.ActivePowerPu PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

equation
  connect(PGenPu, gain1.u) annotation(
    Line(points = {{-200, 0}, {-162, 0}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder.u) annotation(
    Line(points = {{-138, 0}, {-122, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss1aPGen;
