within Dynawo.Electrical.Controls.Transformers.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

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

  Boolean lookingToIncreaseTap "True if the phase shifter wants to increase tap";
  Boolean lookingToDecreaseTap "True if the phase shifter wants to decrease tap";

  parameter Boolean locked0 = not regulating0 "Whether the phase-shifter is initially locked";
  parameter Boolean regulating0 "Whether the phase-shifter is initially regulating";

  State state0 "Initial state";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifter_INIT;
