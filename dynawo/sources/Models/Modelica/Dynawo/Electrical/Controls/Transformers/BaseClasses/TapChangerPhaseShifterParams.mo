within Dynawo.Electrical.Controls.Transformers.BaseClasses;
record TapChangerPhaseShifterParams
  type Automaton = enumeration(TapChanger "1: tap-changer",
                               PhaseShifter "2: phase-shifter");

  type State = enumeration(MoveDownN "1: tap-changer/phase-shifter has decreased the next tap",
                           MoveDown1 "2: tap-changer/phase-shifter has decreased the first tap",
                           WaitingToMoveDown "3: tap-changer/phase-shifter is waiting to decrease the first tap",
                           Standard "4: tap-changer/phase-shifter is in standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                           WaitingToMoveUp "5: tap-changer/phase-shifter is waiting to increase the first tap",
                           MoveUp1 "6: tap-changer/phase-shifter has increased the first tap",
                           MoveUpN "7: tap-changer/phase-shifter has increased the next tap",
                           Locked "8: tap-changer/phase-shifter locked");

  parameter Types.Time t1st(min = 0) "Time lag before changing the first tap in s";
  parameter Types.Time tNext(min = 0) "Time lag before changing subsequent taps in s";
  parameter Integer tapMin "Minimum tap";
  parameter Integer tapMax "Maximum tap";

  parameter Boolean regulating0 "Whether the tap-changer/phase-shifter is initially regulating";
  parameter Boolean locked0 = not regulating0 "Whether the tap-changer/phase-shifter is initially locked";
  parameter Boolean running0 = true "Whether the tap-changer/phase-shifter is initially running";
  parameter Real valueToMonitor0 "Initial monitored value (unit depending on the monitored variable unit)";
  parameter Integer tap0 "Initial tap";
  parameter State state0 "Initial state";
  parameter Real factorValueToDisplay "Multiplying factor for log messages of valueToMonitor (Pu to unit)";
  parameter String unitValueToDisplay "Unit to display for measured value in log messages";

  annotation(preferredView = "text");
end TapChangerPhaseShifterParams;
