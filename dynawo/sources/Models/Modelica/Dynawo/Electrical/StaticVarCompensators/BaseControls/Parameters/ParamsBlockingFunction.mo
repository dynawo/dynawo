within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;
record ParamsBlockingFunction

  parameter Types.VoltageModule UBlock "Voltage value under which the static var compensator is blocked, in kV";
  parameter Types.VoltageModule UUnblockDown "Lower voltage value defining the voltage interval in which the static var compensator is unblocked, in kV";
  parameter Types.VoltageModule UUnblockUp "Upper voltage value defining the voltage interval in which the static var compensator is unblocked, in kV";

  annotation(preferredView = "text");
end ParamsBlockingFunction;
