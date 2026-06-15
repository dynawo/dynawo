within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard;
model Scl2c_INIT "IEEE overexcitation limiter type SCL2C initialization model"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Initial reactive power in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Scl2c_INIT;
