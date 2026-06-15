within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsActivePowerControl "Parameters of active power control"
  parameter Types.PerUnit KiP "Integral coefficient of the PI controller for the active power control";
  parameter Types.PerUnit KpP "Proportional coefficient of the PI controller for the active power control";
  parameter Types.ActivePowerPu POpMaxPu "Maximum operator value of the active power in pu (base SNom) (DC to AC)";
  parameter Types.ActivePowerPu POpMinPu "Minimum operator value of the active power in pu (base SNom) (DC to AC)";
  parameter Types.Time SlopePRefPu "Slope of the ramp of PRefPu in pu/s (base SNom)";
  parameter Types.PerUnit SlopeRPFault "Slope of the recovery of rpfault after a fault in pu/s";
  parameter Types.Time tMeasureP "Time constant of the active power measurement filter in s";

  annotation(preferredView = "text");
end ParamsActivePowerControl;
