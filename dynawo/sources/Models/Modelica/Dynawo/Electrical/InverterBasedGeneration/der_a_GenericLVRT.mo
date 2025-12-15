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

model der_a_GenericLVRT "der_a model with generic LVRT model"
  extends BaseClasses.der_a.base_der_a;

  // Low voltage ride through
  parameter Types.VoltageModulePu ULVRTArmingPu "Voltage threshold under which the automaton is activated after tLVRTMax in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTIntPu "Voltage threshold under which the automaton is activated after tLVRTMin in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTMinPu "Voltage threshold under which the automaton is activated instantaneously in pu (base UNom)";
  parameter Types.Time tLVRTMin "Time delay of trip for severe voltage dips in s";
  parameter Types.Time tLVRTInt "Time delay of trip for intermediate voltage dips in s";
  parameter Types.Time tLVRTMax "Time delay of trip for small voltage dips in s";

  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.GenericIBG.LVRT lvrt(ULVRTArmingPu = ULVRTArmingPu, ULVRTIntPu = ULVRTIntPu, ULVRTMinPu = ULVRTMinPu, tLVRTMin = tLVRTMin, tLVRTInt = tLVRTInt, tLVRTMax = tLVRTMax) annotation(
    Placement(visible = true, transformation(origin = {-370, -190}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(UFilter.y, lvrt.UMonitoredPu) annotation(
    Line(points = {{-298, -214}, {-290, -214}, {-290, -190}, {-358, -190}}, color = {0, 0, 127}));

  der(partialTrippingRatio)*1e-3 = FRT.connectedShare - partialTrippingRatio;

  when (FRT.connectedShare <= 0.001 or lvrt.switchOffSignal.value) and not pre(injector.switchOffSignal3.value) then
    injector.switchOffSignal3.value = true;
  end when;

  annotation(
    Documentation(preferredView = "diagram"),
    Diagram(coordinateSystem(extent = {{-380, 20}, {320, -400}})));
end der_a_GenericLVRT;
