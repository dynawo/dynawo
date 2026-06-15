within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model MAXEX2_INIT "Initialization model of MAXEX2"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.CurrentModulePuConnector Ifd0Pu "Initial generator field current in pu (base SNom, user-selected base voltage)";

  annotation(preferredView = "text");
end MAXEX2_INIT;
