within Dynawo.Electrical.Controls.Transformers;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package BaseClasses_INIT
  extends Icons.BasesPackage;

partial model BaseTapChangerPhaseShifter_INIT "Base initialization model for tap-changers and phase-shifters"
  type State = enumeration (MoveDownN "1: phase shifter has decreased the next tap",
                            MoveDown1 "2: phase shifter has decreased the first tap",
                            WaitingToMoveDown "3: phase shifter is waiting to decrease the first tap",
                            Standard "4:phase shifter is in Standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                            WaitingToMoveUp "5: phase shifter is waiting to increase the first tap",
                            MoveUp1 "6: phase shifter has increased the first tap",
                            MoveUpN "7: phase shifter has increased the next tap",
                            Locked "8: phase shifter locked");

  parameter Real valueMax "Threshold above which the phase-shifter will take action";
  parameter Boolean regulating0 "Whether the phase-shifter is initially regulating";
  parameter Boolean locked0 = not regulating0 "Whether the phase-shifter is initially locked";
  Boolean lookingToIncreaseTap "True if the phase shifter wants to increase tap";
  Boolean lookingToDecreaseTap "True if the phase shifter wants to decrease tap";
  State state0 "Initial state";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_INIT;


partial model BaseTapChangerPhaseShifter_MAX_INIT "Base initialization model for tap-changers and phase-shifters which takes a maximum and stop value, and tries to bring the value back to the stop value when the maximum value is reached"
  extends BaseTapChangerPhaseShifter_INIT;

  parameter Real valueStop(max = valueMax) "Value below which the phase-shifter will stop";
  parameter Real valueToMonitor0 "Initial monitored value";
  parameter Boolean increaseTapToIncreaseValue "Whether a tap increase will lead to an increase in the monitored value";

equation
  lookingToDecreaseTap = valueToMonitor0 > valueMax and increaseTapToIncreaseValue;
  lookingToIncreaseTap = valueToMonitor0 > valueMax and not(increaseTapToIncreaseValue);

  when locked0 then
    state0 = State.Locked;
  elsewhen not(locked0) and valueToMonitor0 <= valueMax then
    state0 = State.Standard;
  elsewhen not(locked0) and lookingToIncreaseTap then
    state0 = State.WaitingToMoveUp;
  elsewhen not(locked0) and lookingToDecreaseTap then
    state0 = State.WaitingToMoveDown;
  end when;

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_MAX_INIT;


partial model BaseTapChangerPhaseShifter_INTERVAL_INIT "Base initialisation model for tap-changers and phase-shifters which tries to keep a value within a given interval"
  extends BaseTapChangerPhaseShifter_INIT;

  parameter Real valueMin(max = valueMax) "Minimum allowed value of the monitored value";
  parameter Boolean increaseTapToIncreaseValue "Whether a tap increase will lead to an increase in the monitored value";

  Real valueToMonitor0 "Initial monitored value";

equation
  lookingToDecreaseTap = (valueToMonitor0 > valueMax and increaseTapToIncreaseValue) or (valueToMonitor0 < valueMin and not(increaseTapToIncreaseValue));
  lookingToIncreaseTap = (valueToMonitor0 < valueMin and increaseTapToIncreaseValue) or (valueToMonitor0 > valueMax and not(increaseTapToIncreaseValue));

  when locked0 then
    state0 = State.Locked;
  elsewhen not(locked0) and valueToMonitor0 <= valueMax and valueToMonitor0 >= valueMin then
    state0 = State.Standard;
  elsewhen not(locked0) and lookingToIncreaseTap then
    state0 = State.WaitingToMoveUp;
  elsewhen not(locked0) and lookingToDecreaseTap then
    state0 = State.WaitingToMoveDown;
  end when;

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_INTERVAL_INIT;


partial model BaseTapChangerPhaseShifter_TARGET_INIT "Base initialization model for tap-changers and phase-shifters ensuring that the monitored value remains close to a target value"
  extends BaseTapChangerPhaseShifter_INTERVAL_INIT(valueMax = targetValue + deadBand, valueMin = targetValue - deadBand);

  parameter Real targetValue "Target value";
  parameter Real deadBand(min = 0) "Acceptable dead-band next to the target value";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_TARGET_INIT;


partial model BaseTapChanger_INIT "Base initialization model for tap-changers"
  extends BaseTapChangerPhaseShifter_TARGET_INIT(targetValue = UTarget, deadBand = UDeadBand, increaseTapToIncreaseValue = true);

  parameter Types.VoltageModule UTarget "voltage set-point" ;
  parameter Types.VoltageModule UDeadBand "Voltage dead-band";

  annotation(preferredView = "text");
end BaseTapChanger_INIT;

annotation(preferredView = "text");
end BaseClasses_INIT;
