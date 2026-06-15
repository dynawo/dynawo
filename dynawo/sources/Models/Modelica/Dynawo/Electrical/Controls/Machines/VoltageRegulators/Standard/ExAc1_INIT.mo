within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model ExAc1_INIT "Initialization model of ExAc1"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  Dynawo.Connectors.CurrentModulePuConnector Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";

  annotation(preferredView = "true");
end ExAc1_INIT;
