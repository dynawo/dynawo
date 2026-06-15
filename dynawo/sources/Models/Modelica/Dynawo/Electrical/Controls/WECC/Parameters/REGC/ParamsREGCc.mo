within Dynawo.Electrical.Controls.WECC.Parameters.REGC;
record ParamsREGCc "REGC type C parameters"
  parameter Types.CurrentModulePu IMaxPu "Maximum current rating of the converter in pu (base SNom, UNom)" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));
  parameter Types.PerUnit Kii "Integrator gain of the inner current loop" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));
  parameter Types.PerUnit Kip "Proportional gain of the inner current loop" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(
  Dialog(tab="Generator Converter", group = "REGCc"));

  annotation(preferredView = "text");
end ParamsREGCc;
