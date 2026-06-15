within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard;
model Oel4c_INIT "IEEE overexcitation limiter type OEL4C initialization model"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Initial reactive power in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end Oel4c_INIT;
