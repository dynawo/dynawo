within Dynawo.Electrical.Transformers.BaseClasses;

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

partial model BaseTransformerVariableTap "Base class for ideal and classical transformers with variable tap"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffTransformer;

  parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer NbTap "Number of taps";

  // Connection to the grid
  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Input connectors
  Dynawo.Connectors.ZPin tap(value(start = Tap0)) "Current transformer tap (between 0 and NbTap - 1)";

  // Output connectors
  Dynawo.Connectors.ImPin U1Pu(value(start = U10Pu)) "Absolute voltage on side 1";
  Dynawo.Connectors.ImPin P1Pu(value(start = P10Pu)) "Active power on side 1";
  Dynawo.Connectors.ImPin Q1Pu(value(start = Q10Pu)) "Reactive power on side 1";
  Dynawo.Connectors.ImPin U2Pu(value(start = U20Pu)) "Voltage amplitude at terminal 2 in pu (base U2Nom)";

  // Parameters coming from the initialization process
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";

  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";

  parameter Integer Tap0 "Start value of transformer tap";
  parameter Types.PerUnit rTfo0Pu "Start value of transformer ratio";

  // Internal variables
  discrete Types.PerUnit rTfoPu(start = rTfo0Pu) "Transformation ratio in pu: U2/U1 in no load conditions";

equation
  when (tap.value <> pre(tap.value)) then
    // Transformer ratio calculation
    if (NbTap == 1) then
      rTfoPu = rTfoMinPu;
    else
      rTfoPu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (tap.value / (NbTap - 1));
    end if;
  end when;

  if running.value then
    // Variables for display or connection to another model (tap-changer for example)
    P1Pu.value = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu.value = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
    U1Pu.value = ComplexMath.'abs'(terminal1.V);
    U2Pu.value = ComplexMath.'abs'(terminal2.V);
  else
    P1Pu.value = 0;
    Q1Pu.value = 0;
    U1Pu.value = 0;
    U2Pu.value = 0;
  end if;

  annotation(preferredView = "text");
end BaseTransformerVariableTap;
