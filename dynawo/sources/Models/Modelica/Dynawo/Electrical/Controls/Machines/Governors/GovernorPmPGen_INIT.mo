within Dynawo.Electrical.Controls.Machines.Governors;
model GovernorPmPGen_INIT "Initialisation model for governors with generated electric active power input PGenPu"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Initial generated electric active power in pu (base SnRef (system base)) (generator convention)";
  Dynawo.Connectors.ActivePowerPuConnector Pm0Pu "Initial mechanical power in pu (base PNomTurb)";

  annotation(preferredView = "text");
end GovernorPmPGen_INIT;
