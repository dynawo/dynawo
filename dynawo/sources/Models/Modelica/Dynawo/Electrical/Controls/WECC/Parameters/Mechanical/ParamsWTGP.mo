within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;
record ParamsWTGP
  parameter Types.Frequency Kiw "Pitch controller integral gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.PerUnit Kpw "Pitch controller proportional gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.Frequency Kic "Pitch compensation integral gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.PerUnit Kpc "Pitch Compensation proportional gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.PerUnit Kcc "Proportionnal cross-compensation gain" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.Time tTheta "Pitch time constant in s" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaMax "Maximum pitch angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaMin "Minimum pitch angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngularVelocityDegree ThetaRMax "Maximum pitch angle rate limit in degree/s" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngularVelocityDegree ThetaRMin "Minimum pitch angle rate limit in degree/s" annotation(
  Dialog(tab="Pitch Control"));

  // Initial parameters
  parameter Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (generator convention) (base SNom)";
  parameter Types.AngleDegree Theta0 = 10 "Initial pitch angle in degree";
  parameter Types.AngularVelocityPu omegaRefWTGQPu0 "Start value of reference angular frequency of torque control in pu (base omegaNom)";

  annotation(
  preferredView = "text");
end ParamsWTGP;
