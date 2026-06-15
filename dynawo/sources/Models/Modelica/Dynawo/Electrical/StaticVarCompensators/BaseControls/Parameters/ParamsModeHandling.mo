within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;
record ParamsModeHandling

  parameter Types.Time tThresholdDown "Time duration associated with the condition U < UThresholdDown for the change from standby to running mode, in s";
  parameter Types.Time tThresholdUp "Time duration associated with the condition U > UThresholdUp for the change from standby to running mode, in s";
  parameter Types.VoltageModule URefDown "Voltage reference taken into account when the static var compensator switches from standby mode to running mode by falling under UThresholdDown for more than tThresholdDown seconds, in kV";
  parameter Types.VoltageModule URefUp "Voltage reference taken into account when the static var compensator switches from standby mode to running mode by exceeding UThresholdUp for more than tThresholdUp seconds, in kV";
  parameter Types.VoltageModule UThresholdDown "Voltage value under which the static var compensator automatically switches from standby mode to running mode, in kV";
  parameter Types.VoltageModule UThresholdUp "Voltage value above which the static var compensator automatically switches from standby mode to running mode, in kV";

  annotation(preferredView = "text");
end ParamsModeHandling;
