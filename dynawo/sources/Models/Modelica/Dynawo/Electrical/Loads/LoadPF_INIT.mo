within Dynawo.Electrical.Loads;
model LoadPF_INIT "Initialization for load from power factor"
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Real PF "Power factor of the load";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at load terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at load terminal (in rad)";

  Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";

equation
  Q0Pu = P0Pu * tan(acos(PF));
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);

  annotation(preferredView = "text");
end LoadPF_INIT;
