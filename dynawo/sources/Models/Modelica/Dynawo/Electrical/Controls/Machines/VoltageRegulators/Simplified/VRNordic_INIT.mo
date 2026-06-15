within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;
model VRNordic_INIT "Voltage regulator initialization model for the Nordic 32 test system used for voltage stability studies"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  Dynawo.Connectors.CurrentModulePuConnector Ir0Pu "Initial rotor current in pu (base SNom, UNom)";

  annotation(preferredView = "text");
end VRNordic_INIT;
