within Dynawo.Electrical.Controls.PLL;
model PLL_INIT "Initial model of phase-locked loop"
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at PLL terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at PLL terminal in rad";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at PLL terminal in pu (base UNom)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);

  annotation(
    preferredView = "text");
end PLL_INIT;
