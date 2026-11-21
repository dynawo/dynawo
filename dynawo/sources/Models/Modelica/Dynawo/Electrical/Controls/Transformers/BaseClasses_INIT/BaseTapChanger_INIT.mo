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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseTapChanger_INIT "Base initialization model for tap-changers"
  extends BaseTapChangerPhaseShifterTarget_INIT(targetValue = UTarget, deadBand = UDeadBand, increaseTapToIncreaseValue = true);

  parameter Types.VoltageModule UTarget "Voltage set-point";
  parameter Types.VoltageModule UDeadBand "Voltage dead-band";

  annotation(preferredView = "text");
end BaseTapChanger_INIT;
