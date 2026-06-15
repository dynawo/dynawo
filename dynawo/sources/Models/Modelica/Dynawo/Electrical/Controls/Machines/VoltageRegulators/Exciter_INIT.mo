within Dynawo.Electrical.Controls.Machines.VoltageRegulators;
model Exciter_INIT "Initialization model for exciter"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.VoltageModulePuConnector Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  Dynawo.Connectors.VoltageModulePuConnector Us0Pu "Initial stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Exciter_INIT;
