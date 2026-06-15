within Dynawo.Electrical.Controls.Transformers.BaseClasses_INIT;
partial model BaseTapChangerPhaseShifterTarget_INIT "Base initialization model for tap-changers and phase-shifters ensuring that the monitored value remains close to a target value"
  extends BaseTapChangerPhaseShifterInterval_INIT(valueMax = targetValue + deadBand, valueMin = targetValue - deadBand);

  parameter Real targetValue "Target value";
  parameter Real deadBand(min = 0) "Acceptable dead-band next to the target value";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterTarget_INIT;
