within Dynawo.Electrical.Loads;
model LoadAuxiliaries_INIT "Initialization for auxiliaries where P0PuVar, Q0PuVar and u0Pu need to be connected"
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";

  Dynawo.Connectors.ActivePowerPuConnector P0PuVar "Start value of active power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ReactivePowerPuConnector Q0PuVar "Start value of reactive power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ComplexVoltagePuConnector u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  P0PuVar = P0Pu;
  Q0PuVar = Q0Pu;
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  annotation(preferredView = "text");
end LoadAuxiliaries_INIT;
