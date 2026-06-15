within Dynawo.Electrical.Controls.WECC.Parameters.REGC;
record ParamsREGC "Common REGC parameters"
  parameter Types.PerUnit IqrMaxPu "Maximum rate-of-change of reactive current after fault in pu (base UNom, SNom) (typical: 1..999)" annotation(
    Dialog(tab="Generator Converter", group = "REGC"));
  parameter Types.PerUnit IqrMinPu "Minimum rate-of-change of reactive current after fault in pu (base UNom, SNom) (typical: -999..-1)" annotation(
  Dialog(tab="Generator Converter", group = "REGC"));
  parameter Types.PerUnit RrpwrPu "Active current (or power if RateFlag = true) recovery rate in pu/s (base UNom, SNom) (typical: 1..20)" annotation(
  Dialog(tab="Generator Converter", group = "REGC"));
  parameter Types.Time tFilterGC "Filter time constant of terminal voltage in s(Cannot be set to zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter", group = "REGC"));

  annotation(preferredView = "text");
end ParamsREGC;
