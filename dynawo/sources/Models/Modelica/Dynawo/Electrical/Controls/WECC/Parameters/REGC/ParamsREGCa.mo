within Dynawo.Electrical.Controls.WECC.Parameters.REGC;
record ParamsREGCa "REGC type A parameters"
  parameter Types.Time tG "Emulated delay in converter controls in s(Cannot be zero, typical: 0.02..0.05)" annotation(
  Dialog(tab="Generator Converter", group = "REGCa"));
  parameter Types.PerUnit brkpt "LVPL breakpoint in pu (base UNom)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.PerUnit lvpl1 "LVPL gain breakpoint in pu" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Boolean Lvplsw "Low voltage power logic switch: 1-enabled/0-disabled" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));
  parameter Types.PerUnit zerox "LVPL zero crossing in pu (base UNom)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCa"));

  annotation(preferredView = "text");
end ParamsREGCa;
