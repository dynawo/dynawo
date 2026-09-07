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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
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
  Modelica.Blocks.Interfaces.RealOutput P1Pu(start = P10Pu) "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Modelica.Blocks.Interfaces.RealOutput Q1Pu(start = Q10Pu) "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  Modelica.Blocks.Interfaces.RealOutput U1Pu(start = U10Pu) "Voltage amplitude at terminal 1 in pu (base U1Nom)";
  Modelica.Blocks.Interfaces.RealOutput U2Pu(start = U20Pu) "Voltage amplitude at terminal 2 in pu (base U2Nom)";

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the transformer to the grid (terminal 1)" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the transformer to the grid (terminal 2)" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.CurrentModule ISide1 "Current on side 1 in A (receptor convention)";
  Types.CurrentModule ISide2 "Current on side 2 in A (receptor convention)";

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
  if running then
    // Kirchoff law
    rTfoPu * ComplexMath.conj(rTfoPu) * terminal1.V = ComplexMath.conj(rTfoPu) * terminal2.V + ZPu * terminal1.i;
    terminal1.i = ComplexMath.conj(rTfoPu) * (YPu * terminal2.V - terminal2.i);
  else
    terminal1.i = Complex(0);
    terminal2.i = Complex(0);
  end if;

  ISide1 = ComplexMath.'abs'(terminal1.i);
  ISide2 = ComplexMath.'abs'(terminal2.i);

  if running then
  // Variables for display or connection to another model (tap-changer for example)
    P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));

    if ((terminal1.V.re == 0) and (terminal1.V.im == 0)) then
      U1Pu = 0;
    else
      U1Pu = ComplexMath.'abs'(terminal1.V);
    end if;

    if ((terminal2.V.re == 0) and (terminal2.V.im == 0)) then
      U2Pu = 0;
    else
      U2Pu = ComplexMath.'abs'(terminal2.V);
    end if;
  else
    P1Pu = 0;
    Q1Pu = 0;
    U1Pu = 0;
    U2Pu = 0;
  end if;

  annotation(preferredView = "text");
end BaseTransformer;
