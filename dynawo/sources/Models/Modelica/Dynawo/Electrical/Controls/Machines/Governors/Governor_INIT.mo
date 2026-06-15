within Dynawo.Electrical.Controls.Machines.Governors;
model Governor_INIT "Initialisation model for governor"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ActivePowerPuConnector Pm0Pu(start = 1) "Initial mechanical power in pu (base PNomTurb)";

  annotation(preferredView = "text");
end Governor_INIT;
