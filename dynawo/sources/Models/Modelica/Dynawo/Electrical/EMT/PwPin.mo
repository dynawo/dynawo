within Dynawo.Electrical.EMT;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

connector PwPin "Three-phase electromagnetic-transient (EMT) connector: instantaneous voltages and currents of the three phases"
  Modelica.SIunits.Voltage v[3] "Instantaneous three-phase voltages";
  flow Modelica.SIunits.Current i[3] "Instantaneous three-phase currents (positive when entering the device)";

  annotation(preferredView = "text");
end PwPin;
