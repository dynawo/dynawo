within Dynawo.Electrical.Controls.Transformers.BaseClasses;
partial model BaseTapChangerPhaseShifterTarget "Base model for tap-changers and phase-shifters ensuring that the monitored value remains close to a target value"
  extends BaseTapChangerPhaseShifterInterval(valueMax = targetValue + deadBand, valueMin = targetValue - deadBand);

  parameter Real targetValue "Target value (unit depending on the monitored variable unit)";
  parameter Real deadBand(min = 0) "Acceptable dead-band next to the target value (unit depending on the monitored variable unit)";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterTarget;
