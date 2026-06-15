within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsDcVoltageControl "Parameters of DC voltage control"
  parameter Types.PerUnit KiDc "Integral coefficient of the PI controller for the DC voltage control";
  parameter Types.PerUnit KpDc "Proportional coefficient of the PI controller for the DC voltage control";
  parameter Types.Time tMeasureU "Time constant of the voltage measurement filter in s";
  parameter Types.VoltageModulePu UDcRefMaxPu "Maximum value of the DC voltage reference in pu (base UDcNom)";
  parameter Types.VoltageModulePu UDcRefMinPu "Minimum value of the DC voltage reference in pu (base UDcNom)";

  annotation(preferredView = "text");
end ParamsDcVoltageControl;
