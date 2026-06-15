within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;
record ParamsWTGT
  parameter Types.Time Ht "Turbine Inertia in s (typical: 5 s)" annotation(
  Dialog(tab="Drive train control"));
  parameter Types.Time Hg "Generator Inertia in s (typical: 1 s)" annotation(
  Dialog(tab="Drive train control"));
  parameter Types.PerUnit Dshaft "Damping coefficient in pu (typical: 1.5 pu, base SNom, omegaNom)" annotation(
  Dialog(tab="Drive train control"));
  parameter Types.PerUnit Kshaft "Spring constant in pu (typical: 200 pu, base SNom, omegaNom)" annotation(
  Dialog(tab="Drive train control"));

  // Initial parameter
  parameter Types.AngularVelocityPu omegaRefWTGQPu0 "Start value of reference angular frequency of torque control in pu (base omegaNom)" annotation(
  Dialog(group="Initialization"));
  annotation(
  preferredView = "text");
end ParamsWTGT;
