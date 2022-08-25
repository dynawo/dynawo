within Dynawo.Electrical.HVDC.HvdcPQProp;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPQProp_INIT "Initialisation model of HVDC link with a proportional reactive power regulation"

  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  P1Ref0Pu = P1RefSetPu;

  annotation(preferredView = "text");
end HvdcPQProp_INIT;
