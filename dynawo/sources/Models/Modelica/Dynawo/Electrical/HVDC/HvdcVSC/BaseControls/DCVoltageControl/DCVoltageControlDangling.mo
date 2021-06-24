within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.DCVoltageControl;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model DCVoltageControlDangling "DC Voltage Control for the HVDC VSC model with terminal2 connected to a switched-off bus (Udc control on terminal 1)"

  extends HVDC.HvdcVSC.BaseControls.DCVoltageControl.BaseDCVoltageControl;

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end DCVoltageControlDangling;
