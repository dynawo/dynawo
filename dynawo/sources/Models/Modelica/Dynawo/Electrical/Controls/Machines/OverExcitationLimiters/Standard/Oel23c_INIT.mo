within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model Oel23c_INIT "IEEE overexcitation limiter types OEL2C and OEL3C initialization model"
  extends AdditionalIcons.Init;

  Types.PerUnit Input0Pu "Initial input signal";

  annotation(preferredView = "text");
end Oel23c_INIT;
