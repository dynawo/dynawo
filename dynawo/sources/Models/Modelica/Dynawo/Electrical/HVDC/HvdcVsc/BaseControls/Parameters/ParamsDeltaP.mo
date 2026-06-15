within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsDeltaP "Parameters of DeltaP calculation"
  parameter Types.PerUnit KiDeltaP "Integral coefficient of the PI controller for the calculation of DeltaP";
  parameter Types.PerUnit KpDeltaP "Proportional coefficient of the PI controller for the calculation of DeltaP";
  parameter Types.VoltageModulePu UDcMaxPu "Maximum value of the DC voltage in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcMinPu "Minimum value of the DC voltage in pu (base UDcNom)";

  annotation(preferredView = "text");
end ParamsDeltaP;
