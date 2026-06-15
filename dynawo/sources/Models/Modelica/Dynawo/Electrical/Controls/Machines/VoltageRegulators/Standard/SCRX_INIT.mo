within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model SCRX_INIT "Initialization model of SCRX"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.VoltageModulePuConnector Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  Dynawo.Connectors.CurrentModulePuConnector IRotor0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  Dynawo.Connectors.VoltageModulePuConnector UStator0Pu "Initial stator voltage in pu (base UNom)";
  Dynawo.Connectors.VoltageModulePuConnector Ut0Pu "Generator terminal initial voltage in pu (base UNom)";

  annotation(preferredView = "text");
end SCRX_INIT;
