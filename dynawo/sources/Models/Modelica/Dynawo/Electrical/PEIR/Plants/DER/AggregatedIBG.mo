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

model AggregatedIBG "Aggregated model of inverter-based generation (IBG)"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseIBG;

  // Frequency support
  parameter Types.AngularVelocityPu pOmegaPu "Additional frequency drop compared that leads to full trip of units in pu (base omegaNom)";
  parameter Types.PerUnit rOmega(min = 0, max = 1) "Share of units that trip at OmegaMinPu";
  parameter Types.PerUnit sOmega(min = 0, max = 1) "Share of units that trip at OmegaDeadBandPu";

  // Parameters of the partial tripping curves
  parameter Types.PerUnit LVRTc "Share of units that disconnect at ULVRTMinPu";
  parameter Types.PerUnit LVRTd "Fraction of ULVRTMinPu at which all units are disconnected";
  parameter Types.PerUnit LVRTe "Share of units that disconnect at ULVRTIntPu";
  parameter Types.PerUnit LVRTf "Fraction of ULVRTIntPu at which all units are disconnected";
  parameter Types.PerUnit LVRTg "Share of units that disconnect at ULVRTArmingPu";
  parameter Types.PerUnit LVRTh "Fraction of ULVRTArmingPu at which all units are disconnected";

  Types.PerUnit partialTrippingRatio(start = 1) "Coefficient for partial tripping of generators, equals 1 if no trips, 0 if all units are tripped";

  Dynawo.Electrical.Controls.PEIR.Protections.DER.LVRTIBGa lvrt(ULVRTArmingPu = ULVRTArmingPu, ULVRTIntPu = ULVRTIntPu, ULVRTMinPu = ULVRTMinPu, tLVRTMin = tLVRTMin, tLVRTInt = tLVRTInt, tLVRTMax = tLVRTMax, c = LVRTc, d = LVRTd, e = LVRTe, f = LVRTf, g = LVRTg, h = LVRTh) annotation(
    Placement(visible = true, transformation(origin = {-150, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.Protections.DER.FrequencyProtectionIBGa frequencyProtection(OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, p = pOmegaPu, r = rOmega) annotation(
    Placement(visible = true, transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.DER.OverFrequencySupportIBGa overFrequencySupport(OmegaDeadBandPu = OmegaDeadBandPu, OmegaMaxPu = OmegaMaxPu, s = sOmega) annotation(
    Placement(visible = true, transformation(origin = {-270, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression Pext(y = PextPu) annotation(
    Placement(visible = true, transformation(origin = {-90, -386}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product IpPartialTripping annotation(
    Placement(visible = true, transformation(origin = {270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product IqPartialTripping annotation(
    Placement(visible = true, transformation(origin = {270, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PartialTripping1(y = partialTrippingRatio) annotation(
    Placement(visible = true, transformation(origin = {210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PartialTripping2(y = partialTrippingRatio) annotation(
    Placement(visible = true, transformation(origin = {210, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  der(partialTrippingRatio)*1e-3 = lvrt.fLVRT*frequencyProtection.fFrequency - partialTrippingRatio;// Continuous tripping to help KINSOL

  when partialTrippingRatio < 0.99 then
    Timeline.logEvent1(TimelineKeys.PartialTripping);
  end when;

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
  connect(omegaFilter.y, frequencyProtection.omegaPu) annotation(
    Line(points = {{-318, 120}, {-282, 120}}, color = {0, 0, 127}));
  connect(iPSlewLimit.y, IpPartialTripping.u1) annotation(
    Line(points = {{182, 40}, {240, 40}, {240, 6}, {258, 6}}, color = {0, 0, 127}));
  connect(PartialTripping1.y, IpPartialTripping.u2) annotation(
    Line(points = {{221, -40}, {240, -40}, {240, -6}, {258, -6}}, color = {0, 0, 127}));
  connect(PartialTripping2.y, IqPartialTripping.u1) annotation(
    Line(points = {{221, -100}, {240, -100}, {240, -134}, {257, -134}}, color = {0, 0, 127}));
  connect(IpPartialTripping.y, injector.idPu) annotation(
    Line(points = {{281, 0}, {300, 0}, {300, -48}, {318, -48}}, color = {0, 0, 127}));
  connect(IqPartialTripping.y, injector.iqPu) annotation(
    Line(points = {{281, -140}, {300, -140}, {300, -68}, {318, -68}}, color = {0, 0, 127}));
  connect(gain.y, IqPartialTripping.u2) annotation(
    Line(points = {{222, -160}, {240, -160}, {240, -146}, {258, -146}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> Aggregated model of inverter-based generation as defined in p28,74-76 of Gilles Chaspierre's PhD thesis 'Reduced-order modelling of active distribution networks for large-disturbance simulations' with slightly modified frequency trips. Available: https://orbi.uliege.be/handle/2268/251602 </p></html>"),
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}})));
end AggregatedIBG;
