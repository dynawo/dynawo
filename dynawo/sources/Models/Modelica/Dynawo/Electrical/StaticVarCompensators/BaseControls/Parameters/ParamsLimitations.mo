within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;
record ParamsLimitations

  parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNom, SNom)";
  parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum value for the current in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMinPu "Minimum value for the current in pu (base UNom, SNom)";
  parameter Types.PerUnit KCurrentLimiter "Integral gain of current limiter";

  annotation(preferredView = "text");
end ParamsLimitations;
