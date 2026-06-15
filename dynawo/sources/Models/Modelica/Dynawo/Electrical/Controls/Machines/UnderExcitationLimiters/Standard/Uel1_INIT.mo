within Dynawo.Electrical.Controls.Machines.UnderExcitationLimiters.Standard;
model Uel1_INIT "IEEE overexcitation limiter type UEL1 initialization model"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex stator voltage in pu (base UNom)";

  annotation(preferredView = "text");
end Uel1_INIT;
