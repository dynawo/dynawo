within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model IEEET1 "IEEE type 1 Exciter (IEEET1)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Dc1c(
    EfdMinPu = -999,
    PositionOel = 1,
    PositionScl = 0,
    PositionUel = 1,
    tB = 1e-5,
    tC = 1e-5);

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model implements the IEEE Type 1 Exciter as shown in the&nbsp;<!--StartFragment-->I. C. Report, \"Computer representation of excitation systems,\" in <em>IEEE Transactions on Power Apparatus and Systems</em>, vol. PAS-87, no. 6, pp. 1460-1464, June 1968, doi: 10.1109/TPAS.1968.292114.<!--EndFragment--></body></html>"));
end IEEET1;
