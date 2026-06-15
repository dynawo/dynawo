within Dynawo.Electrical.Controls.WECC.Parameters.REGC;
record ParamsREGCb "REGC type B parameters"
  parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(
  Dialog(tab="Generator Converter", group = "REGCb"));
  parameter Types.Time tG "Emulated delay in converter controls in s(Cannot be zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter", group = "REGCb"));

  annotation(preferredView = "text");
end ParamsREGCb;
