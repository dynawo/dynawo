within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;
record ParamsRegulation

  parameter Types.PerUnit Kp "Proportional gain of the PI controller";
  parameter Types.PerUnit Lambda "Statism of the regulation law URefPu = UPu + Lambda * QPu in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Static var compensator nominal apparent power in MVA";
  parameter Types.Time Ti "Integral time constant of the PI controller in s";

  annotation(preferredView = "text");
end ParamsRegulation;
