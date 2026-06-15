within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;
model VRProportionalIntegral_INIT "Proportional integral voltage regulator initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  parameter Types.VoltageModulePu EfdMaxPu "Maximum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit Gain "Control gain";

  Dynawo.Connectors.VoltageModulePuConnector Efd0PuLF "Initial exciter field voltage from LoadFlow in pu (user-selected base voltage)";
  Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";
  Types.VoltageModulePu yIntegrator0 "Initial integrator output in pu (user-selected base voltage)";

  Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag_INIT limiterWithLag(UMax = EfdMaxPu, UMin = EfdMinPu);

equation
  limiterWithLag.y0LF = Efd0PuLF;
  Efd0Pu = limiterWithLag.y0;
  yIntegrator0 = limiterWithLag.u0 - Gain * (UsRef0Pu - Us0Pu);
  UsRef0Pu - Us0Pu = limiterWithLag.u0 - limiterWithLag.y0; // Because init in steadystate

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>Here one of the inputs is Efd0PuLF.<div><br></div><div>This value will initialize the limiter input variable, but since it could be out the saturation bounds, the initial value kept for EfdPu is Efd0Pu which is min(max(Efd0PuLF, EfdMinPu), EfdMaxPu).</div></body></html>"));
end VRProportionalIntegral_INIT;
