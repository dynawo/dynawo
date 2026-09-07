within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation;

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

model LimitsCalculationUDcDangling "Reactive and active currents limits calculation model for the DC voltage control of the HVDC VSC model with terminal2 connected to a switched-off bus"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation.BaseLimitsCalculation;

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = InPu) "Maximum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 85}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMinPu(start = -InPu) "Minimum active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, 69}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  if iqModPu == 0 then
    ipMaxPu = InPu;
  else
    ipMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, iqRefPu ^ 2)));
  end if;

  ipMinPu = -ipMaxPu;

  annotation(preferredView = "text");
end LimitsCalculationUDcDangling;
