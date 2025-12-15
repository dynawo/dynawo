within Dynawo.Electrical.InverterBasedGeneration;

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

model der_a "Aggregated model of inverter-based generation (IBG) as defined in https://www.epri.com/research/products/000000003002015320"
  extends BaseClasses.der_a.base_der_a;

  // Low voltage ride through
  parameter Types.VoltageModulePu Ul0Pu "Voltage threshold under which all inverters are disconnected in pu (base UNom)";
  parameter Types.VoltageModulePu Ul1Pu "Voltage threshold under which inverters start to disconnect in pu (base UNom)";
  parameter Types.Time tvl0 "Time after which inverters stay definitively disconnected if V < Ul0Pu in s";
  parameter Types.Time tvl1 "Time after which non-recovering inverters stay disconnected if V < Ul1Pu in s";
  parameter Types.VoltageModulePu Uh0Pu "Voltage threshold over which all inverters are disconnected in pu (base UNom)";
  parameter Types.VoltageModulePu Uh1Pu "Voltage threshold over which inverters start to disconnect in pu (base UNom)";
  parameter Types.Time tvh0 "Time after which inverters stay definitively disconnected if V > Uh0Pu in s";
  parameter Types.Time tvh1 "Time after which non-recovering inverters stay disconnected if V > Uh1Pu in s";
  parameter Real RecoveringShare(min=0, max=1) "Share of inverters that reconnect after mild voltage deviations";

  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.der_a.LVRT lvrt(RecoveringShare = RecoveringShare, Ul0Pu = Ul0Pu, Ul1Pu = Ul1Pu, tvl0 = tvl0, tvl1 = tvl1) annotation(
    Placement(visible = true, transformation(origin = {-370, -190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.der_a.OVRT ovrt(RecoveringShare = RecoveringShare, Uh0Pu = Uh0Pu, Uh1Pu = Uh1Pu, tvh0 = tvh0, tvh1 = tvh1) annotation(
    Placement(visible = true, transformation(origin = {-370, -150}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(UFilter.y, lvrt.UMonitoredPu) annotation(
    Line(points = {{-298, -214}, {-290, -214}, {-290, -190}, {-358, -190}}, color = {0, 0, 127}));
  connect(UFilter.y, ovrt.UMonitoredPu) annotation(
    Line(points = {{-298, -214}, {-290, -214}, {-290, -190}, {-340, -190}, {-340, -150}, {-358, -150}}, color = {0, 0, 127}));

  der(partialTrippingRatio)*1e-3 = (FRT.connectedShare * lvrt.connectedShare * ovrt.connectedShare) - partialTrippingRatio;

  when (FRT.connectedShare <= 0.001 or lvrt.Ul0Reached or ovrt.Uh0Reached) and not pre(injector.switchOffSignal3.value) then
    injector.switchOffSignal3.value = true;
  end when;

  annotation(
    Documentation(preferredView = "diagram"),
    Diagram(coordinateSystem(extent = {{-380, 20}, {320, -400}})));
end der_a;
