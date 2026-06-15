within Dynawo.Electrical.Controls.Transformers.BaseClasses_INIT;
partial model BaseTapChangerPhaseShifterInterval_INIT "Base initialisation model for tap-changers and phase-shifters which tries to keep a value within a given interval"
  extends BaseTapChangerPhaseShifter_INIT;

  parameter Real valueMin(max = valueMax) "Minimum allowed value of the monitored value";
  parameter Boolean increaseTapToIncreaseValue "Whether a tap increase will lead to an increase in the monitored value";

  Real valueToMonitor0 "Initial monitored value";

equation
  lookingToDecreaseTap = (valueToMonitor0 > valueMax and increaseTapToIncreaseValue) or (valueToMonitor0 < valueMin and not
                                                                                                                           (increaseTapToIncreaseValue));
  lookingToIncreaseTap = (valueToMonitor0 < valueMin and increaseTapToIncreaseValue) or (valueToMonitor0 > valueMax and not
                                                                                                                           (increaseTapToIncreaseValue));

  when locked0 then
    state0 = State.Locked;
  elsewhen not
              (locked0) and valueToMonitor0 <= valueMax and valueToMonitor0 >= valueMin then
    state0 = State.Standard;
  elsewhen not
              (locked0) and lookingToIncreaseTap then
    state0 = State.WaitingToMoveUp;
  elsewhen not
              (locked0) and lookingToDecreaseTap then
    state0 = State.WaitingToMoveDown;
  end when;

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterInterval_INIT;
