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

model GeneratorTransformer "Two winding transformer with a fixed ratio"

/*
  This transformer model is supposed to be used with its initialisation model GeneratorTransformer_INIT.
  It enables to initialize the generator model when the load-flow inputs are not known at the generator terminal but at the generator transformer terminal.

  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/

  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffTransformer;

  Connectors.ACPower terminal1 (V (re (start = u10Pu.re), im (start = u10Pu.im)),i (re (start = i10Pu.re), im (start = i10Pu.im)));
  Connectors.ACPower terminal2 (V (re (start = u20Pu.re), im (start = u20Pu.im)),i (re (start = i20Pu.re), im (start = i20Pu.im)));

  parameter Types.PerUnit rTfoPu "Transformation ratio in p.u: U2/U1 in no load conditions";
  parameter Types.PerUnit RPu "Resistance of the generator transformer in p.u (base U2Nom, SnRef)";
  parameter Types.PerUnit BPu "Susceptance of the generator transformer in p.u (base U2Nom, SnRef)";
  parameter Types.PerUnit XPu "Reactance of the generator transformer in p.u (base U2Nom, SnRef)";
  parameter Types.PerUnit GPu "Conductance of the generator transformer in p.u (base U2Nom, SnRef)";

  // Transformer variables for display
  Types.ActivePowerPu P1Pu (start = P10Pu) "Active power on side 1 in p.u (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu (start = Q10Pu) "Reactive power on side 1 in p.u (base SnRef) (receptor convention)";
  Types.VoltageModulePu U1Pu (start = U10Pu) "Voltage on side 1 in p.u (base U1Nom)";

  Types.ActivePowerPu P2Pu (start = -P20Pu) "Active power on side 1 in p.u (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu (start = -Q20Pu) "Reactive power on side 1 in p.u (base SnRef) (receptor convention)";
  Types.VoltageModulePu U2Pu (start = U20Pu) "Voltage on side 1 in p.u (base U2Nom)";

protected
  parameter Types.ComplexImpedancePu ZPu = Complex(RPu, XPu) "Impedance in p.u (base U2Nom, SnRef)";
  parameter Types.ComplexAdmittancePu YPu = Complex(GPu, BPu) "Admittance in p.u (base U2Nom, SnRef)";

  // Transformer start values
  parameter Types.ActivePowerPu P10Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base U1Nom)";

  parameter Types.ActivePowerPu P20Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q20Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 1 in p.u (base U2Nom)";

  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 (base U1Nom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 (base U2Nom)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (base U2Nom, SnRef) (receptor convention)";

equation

  if (running.value) then
    rTfoPu * rTfoPu * terminal1.V = rTfoPu * terminal2.V + ZPu * terminal1.i;
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);

    U1Pu = ComplexMath.'abs' (terminal1.V);
    P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));

    U2Pu = ComplexMath.'abs' (terminal2.V);
    P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
    Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));
  else
    terminal1.i = Complex (0);
    terminal2.i = Complex (0);
    U1Pu = 0;
    P1Pu = 0;
    Q1Pu = 0;
    U2Pu = 0;
    P2Pu = 0;
    Q2Pu = 0;
  end if;

end GeneratorTransformer;
