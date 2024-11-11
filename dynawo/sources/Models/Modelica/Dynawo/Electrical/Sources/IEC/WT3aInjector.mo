within Dynawo.Electrical.Sources.IEC;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT3aInjector "Converter model and grid interface according to IEC N°61400-27-1 standard for type 3A
 wind turbines"
  
  extends Dynawo.Electrical.Sources.IEC.BaseConverters.WTInjector_base(
      redeclare Dynawo.Electrical.Sources.IEC.BaseConverters.GenSystem3a genSystem(DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, KPc = KPc, TIc = TIc, XEqv = XEqv, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0)
      );
  extends BaseConverters.Parameters.GenSystem3;
  extends BaseConverters.Parameters.GenSystem3a;
  annotation(
    Icon(graphics = {Text(origin = {58, 22}, extent = {{-20, -20}, {20, 20}}, textString = "3A")}));
end WT3aInjector;
