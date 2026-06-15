within Dynawo.Electrical.Controls.Transformers;
model PhaseShifterP_INIT "Initialisation model for a phase-shifter monitoring the active power"
  extends BaseClasses_INIT.BaseTapChangerPhaseShifterTarget_INIT(targetValue = PTarget, deadBand = PDeadBand, increaseTapToIncreaseValue = (increasePhase > 0));
  extends AdditionalIcons.Init;

  parameter Types.ActivePower PTarget "Target active power";
  parameter Types.ActivePower PDeadBand(min = 0) "Active-power dead-band around the target";
  parameter Types.ActivePower P0 "Initial active power";
  parameter Integer increasePhase;

equation
  valueToMonitor0 = P0;

  annotation(preferredView = "text");
end PhaseShifterP_INIT;
