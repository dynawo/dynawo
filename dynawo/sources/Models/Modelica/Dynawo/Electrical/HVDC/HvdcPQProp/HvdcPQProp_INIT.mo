within Dynawo.Electrical.HVDC.HvdcPQProp;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPQProp_INIT "Initialisation model of HVDC link with a proportional reactive power control"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatus_INIT;
  extends BaseClasses.BaseFixedReactiveLimits;

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  P1Ref0Pu = P1RefSetPu;

  if - Q10Pu <= Q1MinPu then
    q1Status0 = QStatus.AbsorptionMax;
  elseif - Q10Pu >= Q1MaxPu then
    q1Status0 = QStatus.GenerationMax;
  else
    q1Status0 = QStatus.Standard;
  end if;

  if - Q20Pu <= Q2MinPu then
    q2Status0 = QStatus.AbsorptionMax;
  elseif - Q20Pu >= Q2MaxPu then
    q2Status0 = QStatus.GenerationMax;
  else
    q2Status0 = QStatus.Standard;
  end if;

  annotation(preferredView = "text");
end HvdcPQProp_INIT;
