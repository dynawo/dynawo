within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers;
model Pss_INIT "Initialization model for power system stabilizer"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end Pss_INIT;
