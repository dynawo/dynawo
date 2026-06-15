within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;
record ParamsWTGAa
  parameter Types.PerUnit Ka "Aero-dynamic gain factor" annotation(
  Dialog(tab="Aero-dynamic model"));

  // Initial parameters
  parameter Types.AngleDegree Theta0 = 10 "Initial pitch angle in degree";
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base SNom)";

  annotation(
  preferredView = "text");
end ParamsWTGAa;
