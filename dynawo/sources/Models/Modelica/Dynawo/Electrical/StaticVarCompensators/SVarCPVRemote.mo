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

model SVarCPVRemote "PV static var compensator model with remote voltage regulation without mode handling"
  extends BaseClasses.BaseSVarC;

  input Types.VoltageModulePu URegulatedPu "Regulated voltage in pu (base UNomRemote)";

equation
  when BVarPu >= BMaxPu and URegulatedPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and URegulatedPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or URegulatedPu > URefPu) and (BVarPu > BMinPu or URegulatedPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if (running.value) then
    BPu = BVarPu + BShuntPu;
    if bStatus == BStatus.Standard then
      URegulatedPu = URefPu;
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
end SVarCPVRemote;
