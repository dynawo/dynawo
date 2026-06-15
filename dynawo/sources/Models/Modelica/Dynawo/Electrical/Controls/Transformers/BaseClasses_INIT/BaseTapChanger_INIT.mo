within Dynawo.Electrical.Controls.Transformers.BaseClasses_INIT;
partial model BaseTapChanger_INIT "Base initialization model for tap-changers"
  extends BaseTapChangerPhaseShifterTarget_INIT(targetValue = UTarget, deadBand = UDeadBand, increaseTapToIncreaseValue = true);

  parameter Types.VoltageModule UTarget "Voltage set-point";
  parameter Types.VoltageModule UDeadBand "Voltage dead-band";

  annotation(preferredView = "text");
end BaseTapChanger_INIT;
