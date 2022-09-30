within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculation;

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

model LimitsCalculationPDangling "Reactive and active currents limits calculation model for the active power control of the HVDC VSC model with terminal2 connected to a switched-off bus"
  import Modelica;
  import Dynawo;

  extends Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculation.BaseLimitsCalculation;

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMaxPu) "Maximum active current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 85}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = -IpMaxPu) "Minimum active current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 69}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  if iqModPu == 0 then
    ipMaxPu = IpMaxPu;
  else
    ipMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, iqRefPu ^ 2)));
  end if;

  ipMinPu = -ipMaxPu;

  annotation(preferredView = "text");
end LimitsCalculationPDangling;
