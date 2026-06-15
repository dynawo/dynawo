within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BasePVRemote "Base dynamic model for a remote voltage regulation"
  input Types.VoltageModule URef(start = URef0) "Voltage regulation set point in kV";
  input Types.VoltageModule URegulated(start = URegulated0) "Regulated voltage in kV";

  parameter Types.VoltageModule URef0 "Start value of the voltage regulation set point in kV";
  parameter Types.VoltageModule URegulated0 "Start value of the regulated voltage in kV";
  parameter Types.VoltageModulePu UDeadBandPu(min = 0) "Voltage deadband around the target in pu (base UNom)";
  parameter Types.ReactivePowerPu QDeadBandPu(min = 0) "Reactive power deadband around the target in pu (base SnRef)";

  annotation(preferredView = "text");
end BasePVRemote;
