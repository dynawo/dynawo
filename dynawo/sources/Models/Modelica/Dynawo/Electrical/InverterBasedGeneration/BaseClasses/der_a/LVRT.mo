within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.der_a;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model LVRT "Low-voltage ride-through model for the der_a"
  import Modelica;
  import Modelica.Constants;
  import Dynawo.Connectors;

  parameter Types.VoltageModulePu Ul0Pu "Voltage threshold under which all inverters are disconnected in pu (base UNom)";
  parameter Types.VoltageModulePu Ul1Pu "Voltage threshold under which inverters start to disconnect in pu (base UNom)";
  parameter Types.Time tvl0 "Time after which inverters stay definitively disconnected if V < Ul0Pu in s";
  parameter Types.Time tvl1 "Time after which non-recovering inverters stay disconnected if V < Ul1Pu in s";
  parameter Real RecoveringShare(min=0, max=1) "Share of inverters that reconnect when V > Ul1Pu";

  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Monitored voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Real connectedShare(start = 1);

  Types.VoltageModulePu UMinPu(start = 1) "Voltage when V has been lower than Ul0Pu for tvl0 seconds in pu (base UNom)";
  Types.Time tUl0Reached(start = Constants.inf) "Time when UMonitoredPu dropped below Ul0Pu in s";
  Types.Time tUl1Reached(start = Constants.inf) "Time when UMonitoredPu dropped below Ul1Pu in s";
  Boolean Ul0Reached(start = false) "True if UMonitoredPu stayed below Ul0Pu for tvl0";
  Boolean Ul1Reached(start = false) "True if UMonitoredPu stayed below Ul1Pu for tvl1";

equation
  // Vl0 comparison
  when UMonitoredPu <= Ul0Pu and not(pre(Ul0Reached)) then
    tUl0Reached = time;
  elsewhen UMonitoredPu > Ul0Pu and pre(tUl0Reached) <> Constants.inf and not(pre(Ul0Reached)) then
    tUl0Reached = Constants.inf;
  end when;

  when time - tUl0Reached >= tvl0 then
    Ul0Reached = true;
  end when;

  // Vl1 comparison
  when UMonitoredPu <= Ul1Pu and not(pre(Ul1Reached)) then
    tUl1Reached = time;
  elsewhen UMonitoredPu > Ul1Pu and pre(tUl1Reached) <> Constants.inf and not(pre(Ul1Reached)) then
    tUl1Reached = Constants.inf;
  end when;

  when time - tUl1Reached >= tvl1 then
    Ul1Reached = true;
    UMinPu = UMonitoredPu;
  end when;

  if UMonitoredPu > Ul1Pu and not Ul1Reached then
    connectedShare = 1;
  elseif UMonitoredPu < Ul0Pu or Ul0Reached then
    connectedShare = 0;
  elseif UMonitoredPu < Ul1Pu and not Ul1Reached then
    connectedShare = (UMonitoredPu - Ul0Pu) / (Ul1Pu - Ul0Pu);
  elseif pre(UMonitoredPu) < Ul1Pu and Ul1Reached then  // Not clear why the pre is needed to get the expected behaviour
    connectedShare = (UMinPu - Ul0Pu + RecoveringShare * (UMonitoredPu - UMinPu)) / (Ul1Pu - Ul0Pu);
  else  // UMonitoredPu > Ul1Pu and Ul1Reached
    connectedShare = RecoveringShare * (Ul1Pu - UMinPu) / (Ul1Pu - Ul0Pu) + (UMinPu - Ul0Pu) / (Ul1Pu - Ul0Pu);
  end if;

  annotation(Documentation(preferredView = "text"));
end LVRT;
