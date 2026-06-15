within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsBlockingFunction "Parameters of blocking function"
  parameter Types.Time tBlock "Minimum duration of blocking in s";
  parameter Types.Time tBlockUnderV "Duration of undervoltage that triggers the blocking, in s";
  parameter Types.Time tUnblock "Duration of voltage within ]UMinDbPu, UMaxDbPu[ that deactivates the blocking, in s";
  parameter Types.Time tMeasureUBlock "Time constant of the measurement filter for voltage (blocking function) in s";
  parameter Types.VoltageModulePu UBlockUnderVPu "Undervoltage threshold that triggers the blocking, in pu (base UNom)";
  parameter Types.VoltageModulePu UMaxDbPu "Maximum voltage for blocking deactivation in pu (base UNom)";
  parameter Types.VoltageModulePu UMinDbPu "Minimum voltage for blocking deactivation in pu (base UNom)";

  annotation(preferredView = "text");
end ParamsBlockingFunction;
