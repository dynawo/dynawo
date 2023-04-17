within Dynawo.Electrical.Controls.Transformers.BaseClasses;

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

partial model BaseTapChangerPhaseShifterTarget "Base model for tap-changers and phase-shifters ensuring that the monitored value remains close to a target value"
  extends BaseTapChangerPhaseShifterInterval(valueMax = targetValue + deadBand, valueMin = targetValue - deadBand);

  parameter Real targetValue "Target value (unit depending on the monitored variable unit)";
  parameter Real deadBand(min = 0) "Acceptable dead-band next to the target value (unit depending on the monitored variable unit)";

  annotation(preferredView = "text");
end BaseTapChangerPhaseShifterTarget;
