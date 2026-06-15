within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseQStator "Base dynamic model for the calculation of QStatorPu in pu (base QNomAlt)"
  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";

  Dynawo.Connectors.ReactivePowerPuConnector QStatorPu "Stator reactive power in pu (base QNomAlt) (generator convention)";
  Types.ReactivePower QStator "Stator reactive power in MVar (generator convention)";

equation
  QStator = QStatorPu * QNomAlt;

  annotation(preferredView = "text");
end BaseQStator;
