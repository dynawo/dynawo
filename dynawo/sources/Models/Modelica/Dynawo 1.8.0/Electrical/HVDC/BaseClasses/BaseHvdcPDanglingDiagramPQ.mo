within Dynawo.Electrical.HVDC.BaseClasses;

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

partial model BaseHvdcPDanglingDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus. The reactive power limits are given by a PQ diagram."
  extends BaseHvdcPDangling;
  extends BaseDiagramPQTerminal1;

equation
  PInj1Pu = tableQInj1Min.u[1];
  PInj1Pu = tableQInj1Max.u[1];

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus. This partial model also implements the PQ diagram at terminal1.</div></body></html>"));
end BaseHvdcPDanglingDiagramPQ;
