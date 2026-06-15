within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;
record ParamsWTGTb
  parameter Types.Time tpWTGTb "Lag time constant in WTGTb in s" annotation(
    Dialog(tab="Drive train control"));

  annotation(
  preferredView = "text");
end ParamsWTGTb;
