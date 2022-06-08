within Dynawo.Electrical.HVDC.BaseControls;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ACEmulationSet_INIT "Initialisation for AC Emulation for HVDC with PRefSet0Pu set by the user"
  extends AdditionalIcons.Init;

  import Dynawo.Types;

  parameter Types.PerUnit KACEmulation "Inverse of the emulated AC reactance";

  Types.Angle Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  Types.Angle Theta20 "Start value of angle of the voltage at terminal 2 in rad";
  Types.ActivePowerPu PRef0Pu "Start value of active power reference in pu (base SnRef) (receptor convention)";

  annotation(preferredView = "text");
end ACEmulationSet_INIT;
