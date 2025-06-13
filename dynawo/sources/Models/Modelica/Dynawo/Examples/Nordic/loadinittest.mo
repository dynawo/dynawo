within Dynawo.Examples.Nordic;

model loadinittest

  // to be connected with the transformer init model
  Dynawo.Connectors.ComplexVoltagePuConnector u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  flow Dynawo.Connectors.ComplexCurrentPuConnector i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";

equation
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

end loadinittest;
