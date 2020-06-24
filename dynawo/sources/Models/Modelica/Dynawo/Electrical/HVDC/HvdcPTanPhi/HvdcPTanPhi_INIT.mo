within Dynawo.Electrical.HVDC.HvdcPTanPhi;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcPTanPhi_INIT "Initialisation model for P/tan(Phi) HVDC link"

  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;

annotation(preferredView = "text");
end HvdcPTanPhi_INIT;
