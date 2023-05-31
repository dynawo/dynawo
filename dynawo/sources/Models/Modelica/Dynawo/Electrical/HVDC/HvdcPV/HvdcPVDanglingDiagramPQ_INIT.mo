within Dynawo.Electrical.HVDC.HvdcPV;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPVDanglingDiagramPQ_INIT "Initialisation model of PV HVDC link with a PQ diagram and with terminal 1 only"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;
  extends BaseClasses_INIT.BaseDiagramPQDangling_INIT;
  extends BaseClasses_INIT.BasePV_INIT;

equation
  P1Ref0Pu = P1RefSetPu;
  QInj10PuQNom = - s10Pu.im * SystemBase.SnRef / Q1Nom;

  if - Q10Pu <= QInj1Min0Pu then
    q1Status0 = QStatus.AbsorptionMax;
  elseif - Q10Pu >= QInj1Max0Pu then
    q1Status0 = QStatus.GenerationMax;
  else
    q1Status0 = QStatus.Standard;
  end if;

  annotation(preferredView = "text");
end HvdcPVDanglingDiagramPQ_INIT;
