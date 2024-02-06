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

model OVRT "Over-voltage ride-through model for the der_a"
  import Modelica;
  import Modelica.Constants;
  import Dynawo.Connectors;

  parameter Types.VoltageModulePu Uh0Pu "Voltage threshold over which all inverters are disconnected in pu (base UNom)";
  parameter Types.VoltageModulePu Uh1Pu "Voltage threshold over which inverters start to disconnect in pu (base UNom)";
  parameter Types.Time tvh0 "Time after which inverters stay definitively disconnected if V > Uh0Pu in s";
  parameter Types.Time tvh1 "Time after which non-recovering inverters stay disconnected if V > Uh1Pu in s";
  parameter Real RecoveringShare(min=0, max=1) "Share of inverters that reconnect when V < Uh1Pu";

  Modelica.Blocks.Interfaces.RealInput UMonitoredPu "Monitored voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Real connectedShare(start = 1);

  Types.VoltageModulePu UMaxPu(start = 1) "Voltage when V has been higher than Uh0Pu for tvh0 seconds in pu (base UNom)";
  Types.Time tUh0Reached(start = Constants.inf) "Time when UMonitoredPu rised above Uh0Pu in s";
  Types.Time tUh1Reached(start = Constants.inf) "Time when UMonitoredPu rised above Uh1Pu in s";
  Boolean Uh0Reached(start = false) "True if UMonitoredPu stayed above Uh0Pu for tvh0";
  Boolean Uh1Reached(start = false) "True if UMonitoredPu stayed above Uh1Pu for tvh1";

equation
  // Vl0 comparison
  when UMonitoredPu >= Uh0Pu and not(pre(Uh0Reached)) then
    tUh0Reached = time;
  elsewhen UMonitoredPu < Uh0Pu and pre(tUh0Reached) <> Constants.inf and not(pre(Uh0Reached)) then
    tUh0Reached = Constants.inf;
  end when;

  when time - tUh0Reached >= tvh0 then
    Uh0Reached = true;
  end when;

  // Vl1 comparison
  when UMonitoredPu >= Uh1Pu and not(pre(Uh1Reached)) then
    tUh1Reached = time;
    UMaxPu = pre(UMaxPu);
  elsewhen UMonitoredPu < Uh1Pu and pre(tUh1Reached) <> Constants.inf and not(pre(Uh1Reached)) then
    tUh1Reached = Constants.inf;
    UMaxPu = UMonitoredPu;
  end when;

  when time - tUh1Reached >= tvh1 then
    Uh1Reached = true;
  end when;

  if UMonitoredPu < Uh1Pu and not Uh1Reached then
    connectedShare = 1;
  elseif UMonitoredPu > Uh0Pu or Uh0Reached then
    connectedShare = 0;
  elseif UMonitoredPu > Uh1Pu and not Uh1Reached then
    connectedShare = (Uh0Pu - UMonitoredPu) / (Uh0Pu - Uh1Pu);
  elseif UMonitoredPu > Uh1Pu and Uh1Reached then
    connectedShare = (Uh0Pu - UMaxPu + RecoveringShare * (UMaxPu - UMonitoredPu)) / (Uh0Pu - Uh1Pu);
  else  // UMonitoredPu < Uh1Pu and Uh1Reached
    connectedShare = RecoveringShare * (UMaxPu - Uh1Pu) / (Uh0Pu - Uh1Pu) + (Uh0Pu - UMaxPu) / (Uh0Pu - Uh1Pu);
  end if;

  annotation(preferredView = "text");
end OVRT;
