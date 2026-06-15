within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsLimitsCalculation "Parameters of active and reactive current limits calculation"
  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom) (DC to AC)";
  parameter Types.PerUnit IpMaxPu "Maximum active current in pu (base SNom, UNom) (DC to AC)";

  annotation(preferredView = "text");
end ParamsLimitsCalculation;
