within Dynawo.Electrical.PEIR.Plants.DER;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model GenericIBG "Generic model of inverter-based generation (IBG)"
  extends BaseClasses.BaseIBG;

  Dynawo.Electrical.Controls.PEIR.Protections.DER.LVRTIBG lvrt(ULVRTArmingPu = ULVRTArmingPu, ULVRTIntPu = ULVRTIntPu, ULVRTMinPu = ULVRTMinPu, tLVRTMin = tLVRTMin, tLVRTInt = tLVRTInt, tLVRTMax = tLVRTMax) annotation(
    Placement(visible = true, transformation(origin = {-150, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Controls.Machines.Protections.SpeedProtection frequencyProtection(OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, tLagAction = 0)  annotation(
    Placement(transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.DER.OverFrequencySupportIBG overFrequencySupport(OmegaDeadBandPu = OmegaDeadBandPu, OmegaMaxPu = OmegaMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-270, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  when lvrt.switchOffSignal.value or frequencyProtection.switchOffSignal.value or overVoltageProtection.switchOffSignal.value and not pre(injector.switchOffSignal3.value) then
    injector.switchOffSignal3.value = true;
  end when;

  connect(UFilter.y, lvrt.UMonitoredPu) annotation(
    Line(points = {{-100, 80}, {-180, 80}, {-180, -100}, {-162, -100}}, color = {0, 0, 127}));
  connect(overFrequencySupport.deltaP, add2.u1) annotation(
    Line(points = {{-258, 80}, {-240, 80}, {-240, 66}, {-222, 66}}, color = {0, 0, 127}));
  connect(PextPu, overFrequencySupport.PextPu) annotation(
    Line(points = {{-420, 20}, {-300, 20}, {-300, 72}, {-282, 72}}, color = {0, 0, 127}));
  connect(omegaFilter.y, overFrequencySupport.omegaPu) annotation(
    Line(points = {{-318, 120}, {-300, 120}, {-300, 80}, {-282, 80}}, color = {0, 0, 127}));
  connect(omegaFilter.y, frequencyProtection.omegaMonitoredPu) annotation(
    Line(points = {{-318, 120}, {-282, 120}}, color = {0, 0, 127}));
  connect(iPSlewLimit.y, injector.idPu) annotation(
    Line(points = {{182, 40}, {300, 40}, {300, -48}, {318, -48}}, color = {0, 0, 127}));
  connect(gain.y, injector.iqPu) annotation(
    Line(points = {{222, -160}, {300, -160}, {300, -68}, {318, -68}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> Generic model of inverter-based generation as defined in p28 of Gilles Chaspierre's PhD thesis 'Reduced-order modelling of active distribution networks for large-disturbance simulations'. Available: https://orbi.uliege.be/handle/2268/251602 </p></html>"),
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}})));
end GenericIBG;
