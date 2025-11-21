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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseHvdcPDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with a PQ Diagram at each terminal"
  extends BaseHvdcP;
  extends BaseDiagramPQTerminal1;
  extends BaseDiagramPQTerminal2;

equation
  PInj1Pu = tableQInj1Min.u[1];
  PInj1Pu = tableQInj1Max.u[1];
  PInj2Pu = tableQInj2Min.u[1];
  PInj2Pu = tableQInj2Max.u[1];

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. This partial model also implements PQ diagrams at each terminal of the HVDC link.</div></body></html>"));
end BaseHvdcPDiagramPQ;
