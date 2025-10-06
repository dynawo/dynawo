within Dynawo.Electrical.PEIR.Plant.Simplified;

model GridFollowingPlant_INIT
  parameter Types.ComplexCurrentPu iStart0Pu = Complex(0, 0) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Dynawo.Connectors.VoltageModulePuConnector U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  //Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  //Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";
  Types.PerUnit PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  Types.PerUnit QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";

  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  //Dynawo.Connectors.ComplexVoltagePuConnector u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  //Dynawo.Connectors.ComplexCurrentPuConnector i0Pu(re(start = iStart0Pu.re)) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.ComplexCurrentPu i0Pu(re(start = iStart0Pu.re)) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  //Dynawo.Connectors.ACPower terminal0;
  Types.ComplexPerUnit sInj0Pu "Start value of complex apparent power at injector in pu (base SNom) (generator convention)";
  Types.PerUnit UInj0Pu "Start value of voltage module at injector in pu (base UNom)";


equation
  //terminal0.i = i0Pu;
  //terminal0.V = u0Pu;
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  iInj0Pu = - i0Pu * SystemBase.SnRef / SNom;
  uInj0Pu = u0Pu - Complex(RPu, XPu) * i0Pu;
  sInj0Pu = uInj0Pu * ComplexMath.conj(iInj0Pu);
  PInj0Pu = ComplexMath.real(sInj0Pu);
  QInj0Pu = ComplexMath.imag(sInj0Pu);
  UInj0Pu = ComplexMath.'abs'(uInj0Pu);

  // Convention change
  //PGen0Pu = -P0Pu;
  //QGen0Pu = -Q0Pu;

end GridFollowingPlant_INIT;
