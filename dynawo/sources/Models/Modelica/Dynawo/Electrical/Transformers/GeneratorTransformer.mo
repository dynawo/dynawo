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
*/

  import Dynawo.Connectors;

  extends BaseClasses.TransformerParameters;
  extends BaseClasses.BaseTransformer;

  Connectors.ACPower terminal1 (V (re (start = u10Pu.re), im (start = u10Pu.im)),i (re (start = i10Pu.re), im (start = i10Pu.im)));
  Connectors.ACPower terminal2 (V (re (start = u20Pu.re), im (start = u20Pu.im)),i (re (start = i20Pu.re), im (start = i20Pu.im)));

  parameter Types.PerUnit rTfoPu "Transformation ratio in p.u: U2/U1 in no load conditions";

  // Transformer variables for display
  Types.ActivePowerPu P1Pu "Active power on side 1 in p.u (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in p.u (base SnRef) (receptor convention)";
  Types.ActivePowerPu P1GenPu "Active power on side 1 in p.u (base SnRef) (generator convention)";
  Types.ReactivePowerPu Q1GenPu "Reactive power on side 1 in p.u (base SnRef) (generator convention)";
  Types.VoltageModulePu U1Pu "Voltage on side 1 in p.u (base U1Nom)";

  Types.ActivePowerPu P2Pu "Active power on side 2 in p.u (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in p.u (base SnRef) (receptor convention)";
  Types.VoltageModulePu U2Pu "Voltage on side 2 in p.u (base U2Nom)";

protected

  // Transformer start values
  parameter Types.ActivePowerPu P10Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base U1Nom)";

  parameter Types.ActivePowerPu P20Pu  "Start value of active power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q20Pu  "Start value of reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in p.u (base U2Nom)";

  parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 (base U1Nom)";
  parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (base U1Nom, SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 (base U2Nom)";
  parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (base U2Nom, SnRef) (receptor convention)";

equation

  if (running.value) then
    U1Pu = ComplexMath.'abs' (terminal1.V);
    P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
    P1GenPu = - P1Pu;
    Q1GenPu = - Q1Pu;
    U2Pu = ComplexMath.'abs' (terminal2.V);
    P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
    Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));
  else
    U1Pu = 0;
    P1Pu = 0;
    Q1Pu = 0;
    P1GenPu = 0;
    Q1GenPu = 0;
    U2Pu = 0;
    P2Pu = 0;
    Q2Pu = 0;
  end if;

end GeneratorTransformer;
