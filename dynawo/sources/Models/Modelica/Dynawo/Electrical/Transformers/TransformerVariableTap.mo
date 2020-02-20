within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model TransformerVariableTap "Transformer with variable tap to be connected to a tap changer"

/*
  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---

  The transformer ratio is variable.
*/

  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffTransformer;
  extends AdditionalIcons.Transformer;

  public

    Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)),i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the transformer to the grid" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 (V(re(start = u20Pu.re), im(start = u20Pu.im)),i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the transformer to the grid";

    // Input connectors
    Connectors.ImPin tap (value (start = Tap0)) "Current transformer tap (between 0 and NbTap - 1)";

    // Output connectors
    Connectors.ImPin U1Pu (value (start = U10Pu)) "Absolute voltage on side 1";
    Connectors.ImPin P1Pu (value (start = P10Pu)) "Active power on side 1";
    Connectors.ImPin Q1Pu (value (start = Q10Pu)) "Reactive power on side 1";
    Connectors.ImPin U2Pu (value (start = U20Pu)) "Voltage amplitude at terminal 2 in p.u (base U2Nom)";

    // Transformer's parameters
    parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
    parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
    parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
    parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
    parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";
    parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in p.u: U2/U1 in no load conditions";
    parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in p.u: U2/U1 in no load conditions";
    parameter Integer NbTap "Number of taps";

  protected
    parameter Types.ComplexImpedancePu ZPu(re = R / 100 * SystemBase.SnRef/ SNom , im  = X / 100 * SystemBase.SnRef/ SNom ) "Transformer impedance in p.u (base U2Nom, SnRef)";
    parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im  = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in p.u (base U2Nom, SnRef)";

    // Parameters comming from the initialization process
    parameter Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base U1Nom)";
    parameter Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base U1Nom, SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u20Pu  "Start value of complex voltage at terminal 2 in p.u (base U2Nom)";
    parameter Types.ComplexCurrentPu i20Pu  "Start value of complex current at terminal 2 in p.u (base U2Nom, SnRef) (receptor convention)";

    parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base U1Nom)";
    parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in p.u (base U2Nom)";
    parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";

    parameter Integer Tap0 "Start value of transformer tap";
    parameter Types.PerUnit rTfo0Pu "Start value of transformer ratio";

    // Internal variables
    Types.PerUnit rTfoPu (start = rTfo0Pu) "Transformation ratio in p.u: U2/U1 in no load conditions";

equation

  // Transformer ratio calculation
  if (NbTap == 1) then
    rTfoPu = rTfoMinPu;
  else
    rTfoPu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (tap.value / (NbTap - 1));
  end if;

  if (running.value) then
    // Transformer equations
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);
    ZPu * terminal1.i = rTfoPu * rTfoPu * terminal1.V - rTfoPu * terminal2.V;

    // Variables for display or connection to another model (tap-changer for example)
    P1Pu.value = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu.value = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
    U1Pu.value = ComplexMath.'abs' (terminal1.V);
    U2Pu.value = ComplexMath.'abs' (terminal2.V);

  else
    terminal1.i = terminal2.i;
    terminal2.V = Complex (0);
    P1Pu.value = 0;
    Q1Pu.value = 0;
    U1Pu.value = 0;
    U2Pu.value = 0;
  end if;

annotation(preferredView = "text");
end TransformerVariableTap;
