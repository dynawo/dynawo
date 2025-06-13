within Dynawo.Examples.Nordic;

model tfoinittest
// Transformer parameters
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";
  parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in pu (base U2Nom, SnRef)";
  parameter Types.ComplexImpedancePu ZPu(re(start = R / 100 * rTfoPu ^ 2 * SystemBase.SnRef / SNom), im(start = X / 100 * rTfoPu ^ 2 * SystemBase.SnRef / SNom)) "Transformer impedance in pu (base U2Nom, SnRef)";

  parameter Types.PerUnit rTfoPu "Start value of transformer ratio";

  // Point de fonctionnement
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";


  // Terminal 2 to be connected with the load init model
  Dynawo.Connectors.ComplexVoltagePuConnector u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  flow Dynawo.Connectors.ComplexCurrentPuConnector i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";


  // Terminal 1 calculated in the equations
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";



equation
  // Transformer equations
  i10Pu = rTfoPu * (YPu * u20Pu - i20Pu);
  rTfoPu * rTfoPu * u10Pu = rTfoPu * u20Pu + ZPu * i10Pu;

  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

end tfoinittest;
