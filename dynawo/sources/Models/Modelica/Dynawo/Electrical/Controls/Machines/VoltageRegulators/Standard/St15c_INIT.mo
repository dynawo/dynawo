within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St15c_INIT "IEEE excitation system types ST1C and ST5C initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  Dynawo.Connectors.CurrentModulePuConnector Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";

  annotation(preferredView = "text");
end St15c_INIT;
