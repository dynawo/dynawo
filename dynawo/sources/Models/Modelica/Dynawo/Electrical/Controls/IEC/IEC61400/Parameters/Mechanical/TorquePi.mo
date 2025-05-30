within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical;

record TorquePi

  parameter Types.PerUnit DTauMaxPu "Torque ramp rate limit, as required by some grid codes, example value = 0.25" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.PerUnit DTauUvrtMaxPu "Torque rise rate limit during UVRT, example value = 0" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.PerUnit KIp  "Integrator time constant of the PI controller, example value = 5" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.PerUnit KPp  "Proportional gain of the PI controller, example value = 8" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Boolean MPUvrt "Mode for UVRT power control (false: reactive power control -- true: voltage control), example value = true" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.PerUnit TauEMinPu  "Minimum torque for the electrical generator, example value = 0.001" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.PerUnit TauUscalePu  "Voltage scaling factor for reset torque, example value = 1" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.Time tDvs  "Time delay following deep a voltage dip, example value = 0.05" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.VoltageModulePu UDvsPu  "Voltage limit for maintaining UVRT status after a deep voltage dip, example value = 0.15" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));
  parameter Types.VoltageModulePu UpDipPu  "Voltage dip threshold for active power control, often different from converter thresholds (e.g., 0.8), example value = 0.9" annotation(
  Dialog(tab = "PControl", group = "WT: TorquePi"));

end TorquePi;
