within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction;

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

model LimitsCalculationFunction "Reactive and active currents limits calculation function for the HVDC VSC model"

  import Modelica;
  import Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction;

  extends LimitsCalculationFunction.BaseLimitsCalculationFunction;

  Modelica.Blocks.Interfaces.RealInput iqMod1Pu(start = 0) "Additional reactive current in case of fault or overvoltage in pu for the other HVDC terminal (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-30,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {111, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqRef1Pu(start = Iq0Pu) "Reactive current reference in pu for the other HVDC terminal (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {30,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation

  if iqModPu == 0 and iqMod1Pu == 0 then
    IpMaxPu = IpMaxCstPu;
    IpMinPu = - IpMaxPu;
  else
    IpMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, max(iqRefPu ^ 2, iqRef1Pu ^ 2))));
    IpMinPu = - IpMaxPu;
  end if;

  if iqModPu == 0 then
    IqMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, ipRefPu ^ 2)));
    IqMinPu = - IqMaxPu;
  else
    IqMaxPu = InPu;
    IqMinPu = - IqMaxPu;
  end if;

  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));

end LimitsCalculationFunction;
