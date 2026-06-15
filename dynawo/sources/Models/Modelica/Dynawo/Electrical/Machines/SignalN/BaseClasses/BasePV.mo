within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BasePV "Base dynamic model for a voltage regulation"
  input Dynawo.Connectors.VoltageModulePuConnector URefPu(start = URef0Pu) "Voltage regulation set point in pu (base UNom)";

  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";
  parameter Types.VoltageModulePu UDeadBandPu(min = 0) "Voltage deadband around the target in pu (base UNom)";
  parameter Types.ReactivePowerPu QDeadBandPu(min = 0) "Reactive power deadband around the target in pu (base SnRef)";

  annotation(preferredView = "text");
end BasePV;
