within Dynawo.Electrical.Shunts;
model ShuntBWithSections_INIT "Initialization for shunt with sections models"
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at shunt terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at shunt terminal (in rad)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Real Section0 "Initial section of the shunt";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at shunt terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at shunt terminal in pu (base UNom, SnRef) (receptor convention)";
  Real section0 "Initial section of the shunt. This variable is equal to the section0 of the section control";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);
  s0Pu = Complex(0, Q0Pu);
  Section0 = section0;

  annotation(preferredView = "text");
end ShuntBWithSections_INIT;
