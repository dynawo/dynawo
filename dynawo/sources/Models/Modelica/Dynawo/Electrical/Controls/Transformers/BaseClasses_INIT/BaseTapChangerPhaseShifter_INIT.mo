within Dynawo.Electrical.Controls.Transformers.BaseClasses_INIT;
partial model BaseTapChangerPhaseShifter_INIT "Base initialization model for tap-changers and phase-shifters"
  type State = enumeration(MoveDownN "1: phase shifter has decreased the next tap",
                           MoveDown1 "2: phase shifter has decreased the first tap",
                           WaitingToMoveDown "3: phase shifter is waiting to decrease the first tap",
                           Standard "4:phase shifter is in Standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                           WaitingToMoveUp "5: phase shifter is waiting to increase the first tap",
                           MoveUp1 "6: phase shifter has increased the first tap",
                           MoveUpN "7: phase shifter has increased the next tap",
                           Locked "8: phase shifter locked");

  parameter Real valueMax "Threshold above which the phase-shifter will take action";

  Boolean lookingToIncreaseTap "True if the phase shifter wants to increase tap";
  Boolean lookingToDecreaseTap "True if the phase shifter wants to decrease tap";

  parameter Boolean locked0 = not regulating0 "Whether the phase-shifter is initially locked";
  parameter Boolean regulating0 "Whether the phase-shifter is initially regulating";

  State state0 "Initial state";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_INIT;
