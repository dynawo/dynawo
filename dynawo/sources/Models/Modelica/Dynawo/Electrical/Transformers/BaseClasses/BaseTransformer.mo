within Dynawo.Electrical.Transformers.BaseClasses;

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

partial model BaseTransformer "Base model for a general two winding transformer (fixed or variable phase and/or ratio)"


/* Equivalent circuit and conventions:

               I1  r,alpha         I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffTransformer;
  extends Dynawo.Electrical.Transformers.BaseClasses.TransformerParameters;

  // Output connectors
  Dynawo.Connectors.ImPin P1Pu(value(start = P10Pu)) "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ImPin Q1Pu(value(start = Q10Pu)) "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ImPin U1Pu(value(start = U10Pu)) "Voltage amplitude at terminal 1 in pu (base U1Nom)";
  Dynawo.Connectors.ImPin U2Pu(value(start = U20Pu)) "Voltage amplitude at terminal 2 in pu (base U2Nom)";

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the transformer to the grid (terminal 1)" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the transformer to the grid (terminal 2)" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Types.ComplexPerUnit rTfoPu(re(start = RatioTfo0Pu * Modelica.Math.cos(AlphaTfo0)), im(start = RatioTfo0Pu * Modelica.Math.sin(AlphaTfo0))) "Transformation complex ratio in complex pu";

  // Initial parameters
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.PerUnit RatioTfo0Pu "Start value of transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.Angle AlphaTfo0 "Start value of transformation phase shift in rad";

  // Initial parameters from initialisation model
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

equation
  if (running.value) then
    // Kirchoff law
    rTfoPu * ComplexMath.conj(rTfoPu) * terminal1.V = ComplexMath.conj(rTfoPu) * terminal2.V + ZPu * terminal1.i;
    terminal1.i = ComplexMath.conj(rTfoPu) * (YPu * terminal2.V - terminal2.i);
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

  if (running.value) then
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
end BaseTransformer;
