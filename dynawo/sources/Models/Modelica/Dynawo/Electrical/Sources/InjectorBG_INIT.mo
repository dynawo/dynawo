within Dynawo.Electrical.Sources;
model InjectorBG_INIT "Initialization model for injector controlled by a the susceptance B and the conductance G"
  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at injector terminal (in rad)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

  Types.ComplexAdmittancePu Y0PuSnRef "Start value of admittance in pu (base SnRef)";
  Types.PerUnit G0Pu "Start value of conductance in pu (base Sn)";
  Types.PerUnit B0Pu "Start value of susceptance in pu (base Sn)";

equation
  s0Pu = Complex(P0Pu, Q0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  Y0PuSnRef = i0Pu / u0Pu;
  G0Pu = ComplexMath.real(Y0PuSnRef) * SystemBase.SnRef / SNom;
  B0Pu = ComplexMath.imag(Y0PuSnRef) * SystemBase.SnRef / SNom;

  annotation(preferredView = "text");
end InjectorBG_INIT;
