within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard;
model Oel5c_INIT "IEEE overexcitation limiter type OEL5C initialization model"
  extends AdditionalIcons.Init;

  Types.PerUnit Input0Pu "Initial input signal";
  Types.VoltageModulePu Vfe0Pu "Initial field current signal in pu (user-selected base voltage)";

  annotation(preferredView = "text");
end Oel5c_INIT;
