within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

record OmegaFlag "OmegaFlag parameter"
  parameter Integer OmegaFlag "GFM control type; 0=GFL, 1=droop, 2=VSM, 3=dVOC" annotation(
Dialog(tab = "General"));

  annotation(
  preferredView = "text");
end OmegaFlag;
