within Dynawo.Electrical.StaticVarCompensators;

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

model SVarCPVNoLimits "PV static var compensator model without mode handling and with no limits on susceptance"
  extends BaseClasses.BaseSVarC(BMaxPu = 99, BMinPu = -99);

equation
  if running.value then
    BPu = BVarPu + BShuntPu;
  else
    BPu = 0;
  end if;

  bStatus = BStatus.Standard;
  UPu = URefPu;

  annotation(preferredView = "text");
end SVarCPVNoLimits;
