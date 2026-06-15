within Dynawo.Electrical.Controls.WECC.Parameters;
record ParamsVSourceRef
  parameter Types.Time tE "Emulated delay in converter controls in s (cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit RSourcePu "Source resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base UNom, SNom)";

  annotation(preferredView = "text");
end ParamsVSourceRef;
