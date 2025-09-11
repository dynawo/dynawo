within Dynawo.Electrical.StaticVarCompensators;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCPV "PV static var compensator model without mode handling"
  extends BaseClasses.BaseSVarC;

equation
  when BVarPu >= BMaxPu and UPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and UPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or UPu > URefPu) and (BVarPu > BMinPu or UPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if (running.value) then
    BPu = BVarPu + BShuntPu;
    if bStatus == BStatus.Standard then
      UPu = URefPu;
    elseif bStatus == BStatus.SusceptanceMax then
      BVarPu = BMaxPu;
    else
      BVarPu = BMinPu;
    end if;
  else
    BVarPu = 0;
    BPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPV;
