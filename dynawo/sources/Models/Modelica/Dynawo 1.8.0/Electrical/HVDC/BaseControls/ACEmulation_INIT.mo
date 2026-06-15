within Dynawo.Electrical.HVDC.BaseControls;

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

model ACEmulation_INIT "Initialisation for AC Emulation for HVDC"
  extends AdditionalIcons.Init;

  parameter Types.PerUnit KACEmulation "Inverse of the emulated AC reactance in pu (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0.";

  Types.ActivePowerPu PRefSet0Pu "Raw reference active power in pu (base SnRef or SNom) (receptor or generator convention)";
  Dynawo.Connectors.AngleConnector Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  Dynawo.Connectors.AngleConnector Theta20 "Start value of angle of the voltage at terminal 2 in rad";
  Dynawo.Connectors.ActivePowerPuConnector PRef0Pu "Start value of active power reference in pu (base SnRef or SNom) (receptor or generator convention)";
  Types.Angle DeltaThetaFiltered0 "Start value of filtered angle difference in rad";

equation
  PRefSet0Pu = PRef0Pu - KACEmulation * (Theta10 - Theta20);
  DeltaThetaFiltered0 = Theta10 - Theta20;

  annotation(preferredView = "text");
end ACEmulation_INIT;
