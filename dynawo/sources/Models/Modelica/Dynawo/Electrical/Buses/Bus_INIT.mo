within Dynawo.Electrical.Buses;
model Bus_INIT
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);

  annotation(preferredView = "text");
end Bus_INIT;
