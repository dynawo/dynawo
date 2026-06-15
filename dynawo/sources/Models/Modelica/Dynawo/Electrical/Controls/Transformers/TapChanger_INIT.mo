within Dynawo.Electrical.Controls.Transformers;
model TapChanger_INIT "Initialisation model for standalone tap-changer"
  extends BaseClasses_INIT.BaseTapChanger_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModule U0 "Initial absolute voltage";

equation
  valueToMonitor0 = U0;

  annotation(preferredView = "text");
end TapChanger_INIT;
