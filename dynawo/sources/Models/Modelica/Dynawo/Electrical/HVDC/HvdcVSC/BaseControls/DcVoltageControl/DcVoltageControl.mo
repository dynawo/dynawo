within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.DcVoltageControl;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DcVoltageControl "DC voltage control for the HVDC VSC model"
  import Modelica;
  import Dynawo;

  extends Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.DcVoltageControl.BaseDcVoltageControl(gain.k = 2);

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-280, -140}, {280, 140}})));
end DcVoltageControl;
