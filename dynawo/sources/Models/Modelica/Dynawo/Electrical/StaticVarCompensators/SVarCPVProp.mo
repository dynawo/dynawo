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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCPVProp "PV static var compensator model with slope without mode handling"
  extends BaseClasses.BaseSVarC;

  parameter Types.PerUnit LambdaPu "Statism of the regulation law URefPu = UPu + LambdaPu*QPu in pu (base UNom, SnRef)";

  Types.PerUnit BVarRawPu(start = BVar0Pu) "Raw variable susceptance of the static var compensator in pu (base UNom, SnRef)";

equation
  when BVarRawPu >= BMaxPu and pre(bStatus) <> BStatus.SusceptanceMax then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarRawPu <= BMinPu and pre(bStatus) <> BStatus.SusceptanceMin then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarRawPu < BMaxPu and BVarRawPu > BMinPu) and pre(bStatus) <> BStatus.Standard then
    bStatus = BStatus.Standard;
  end when;

  URefPu = UPu + LambdaPu * (BVarRawPu + BShuntPu) * UPu ^ 2;
  BVarPu = if BVarRawPu > BMaxPu then BMaxPu elseif BVarRawPu < BMinPu then BMinPu else BVarRawPu;

  if (running.value) then
    BPu = BVarPu + BShuntPu;
  else
    BPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPVProp;
