within Dynawo.Electrical.Controls.WECC.Parameters.REEC;
record ParamsREECb "REEC type B parameter"
  parameter Types.VoltageModulePu VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)" annotation(
  Dialog(tab="Electrical Control", group = "REECb"));

  annotation(preferredView = "text");
end ParamsREECb;
