within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard;
model Scl1c_INIT "IEEE overexcitation limiter type SCL1C initialization model"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Initial reactive power in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Scl1c_INIT;
