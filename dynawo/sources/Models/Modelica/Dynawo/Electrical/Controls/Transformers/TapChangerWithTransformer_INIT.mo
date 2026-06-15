within Dynawo.Electrical.Controls.Transformers;
model TapChangerWithTransformer_INIT "Initialisation model for tap-changer used with a transformer"
  extends BaseClasses_INIT.BaseTapChanger_INIT;
  extends AdditionalIcons.Init;

  Integer tap0 "Initial tap";
  Types.VoltageModule U0 "Initial absolute voltage";

equation
  valueToMonitor0 = U0; // It is better to use an equation in case the transformer U0 changes, (otherwise the updated value would not be propagated)

  annotation(preferredView = "text");
end TapChangerWithTransformer_INIT;
