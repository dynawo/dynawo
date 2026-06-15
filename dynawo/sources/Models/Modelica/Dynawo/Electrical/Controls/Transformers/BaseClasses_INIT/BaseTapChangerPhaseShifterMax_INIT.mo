within Dynawo.Electrical.Controls.Transformers.BaseClasses_INIT;
partial model BaseTapChangerPhaseShifterMax_INIT "Base initialization model for tap-changers and phase-shifters which takes a maximum and stop value, and tries to bring the value back to the stop value when the maximum value is reached"
  extends BaseTapChangerPhaseShifter_INIT;

  parameter Real valueStop(max = valueMax) "Value below which the phase-shifter will stop";
  parameter Boolean increaseTapToIncreaseValue "Whether a tap increase will lead to an increase in the monitored value";

  parameter Real valueToMonitor0 "Initial monitored value";

equation
  lookingToDecreaseTap = valueToMonitor0 > valueMax and increaseTapToIncreaseValue;
  lookingToIncreaseTap = valueToMonitor0 > valueMax and not
                                                           (increaseTapToIncreaseValue);

  when locked0 then
    state0 = State.Locked;
  elsewhen not
              (locked0) and valueToMonitor0 <= valueMax then
    state0 = State.Standard;
  elsewhen not
              (locked0) and lookingToIncreaseTap then
    state0 = State.WaitingToMoveUp;
  elsewhen not
              (locked0) and lookingToDecreaseTap then
    state0 = State.WaitingToMoveDown;
  end when;

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterMax_INIT;
