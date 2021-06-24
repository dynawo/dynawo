within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction;

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

model LimitsCalculationFunctionDangling "Reactive and active currents limits calculation function for the HVDC VSC model with terminal2 connected to a switched-off bus"

  import Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction;

  extends LimitsCalculationFunction.BaseLimitsCalculationFunction;

equation
  if iqModPu == 0 then
    IpMaxPu = IpMaxCstPu;
    IpMinPu = - IpMaxPu;
    IqMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, ipRefPu ^ 2)));
    IqMinPu = - IqMaxPu;
  else
    IpMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, iqRefPu ^ 2)));
    IpMinPu = - IpMaxPu;
    IqMaxPu = InPu;
    IqMinPu = - IqMaxPu;
  end if;

  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end LimitsCalculationFunctionDangling;
