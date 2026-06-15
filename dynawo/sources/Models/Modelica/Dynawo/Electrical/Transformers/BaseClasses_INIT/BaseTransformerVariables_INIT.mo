within Dynawo.Electrical.Transformers.BaseClasses_INIT;
partial model BaseTransformerVariables_INIT "Base model for initialization of transformers"
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";

  // Terminal for init connections
  Dynawo.Connectors.ACPower terminal10 "Connector on side 1 at initialization";

  Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  u10Pu = terminal10.V;
  i10Pu = terminal10.i;
  U10Pu =Modelica.ComplexMath.abs(u10Pu);
  P10Pu = ComplexMath.real(u10Pu * ComplexMath.conj(i10Pu));
  Q10Pu = ComplexMath.imag(u10Pu * ComplexMath.conj(i10Pu));

  annotation(preferredView = "text");
end BaseTransformerVariables_INIT;
