within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;
record ParamsWTGQa
  parameter Types.Frequency Kip "Integral gain" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Kpp "Proportional gain" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P1 "1st power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd1 "1st speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P2 "2nd power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd2 "2nd speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P3 "3rd power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd3 "3rd speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit P4 "4th power point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit Spd4 "4th speed point for extrapolation table" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit TeMaxPu "Maximum torque" annotation(
  Dialog(tab="Torque control"));
  parameter Types.PerUnit TeMinPu "Minimum torque" annotation(
  Dialog(tab="Torque control"));
  parameter Boolean TFlag "Flag to specify PI controller input, if true : power control, if false : speed control" annotation(
  Dialog(tab="Torque control"));
  parameter Types.Time tpWTGQa "Power measurement lag time constant in WTGQa in s" annotation(
  Dialog(tab="Torque control"));
  parameter Types.Time tOmegaRef "Speed reference time constant ins s" annotation(
  Dialog(tab="Torque control"));

  // Initial parameter
  parameter Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (generator convention) (base SNom)" annotation(
  Dialog(group="Initialization"));
  parameter Types.AngularVelocityPu omegaRefWTGQPu0 "Start value of reference angular frequency of torque control in pu (base omegaNom)" annotation(
  Dialog(group="Initialization"));

  annotation(preferredView = "text");
end ParamsWTGQa;
