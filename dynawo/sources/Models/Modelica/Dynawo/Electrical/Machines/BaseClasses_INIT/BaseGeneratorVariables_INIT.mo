within Dynawo.Electrical.Machines.BaseClasses_INIT;
partial model BaseGeneratorVariables_INIT "Base initialization model for simplified generator models"
  parameter Types.ComplexCurrentPu iStart0Pu = Complex(0, 0) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  Dynawo.Connectors.ActivePowerPuConnector P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ReactivePowerPuConnector Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.VoltageModulePuConnector U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  Dynawo.Connectors.AngleConnector UPhase0 "Start value of voltage angle at terminal in rad";

  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";

  Dynawo.Connectors.ComplexVoltagePuConnector u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ComplexCurrentPuConnector i0Pu(re(start = iStart0Pu.re)) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  // Convention change
  PGen0Pu = -P0Pu;
  QGen0Pu = -Q0Pu;

  annotation(preferredView = "text");
end BaseGeneratorVariables_INIT;
