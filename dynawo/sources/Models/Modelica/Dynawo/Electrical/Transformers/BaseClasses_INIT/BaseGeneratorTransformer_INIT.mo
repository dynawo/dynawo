within Dynawo.Electrical.Transformers.BaseClasses_INIT;

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

partial model BaseGeneratorTransformer_INIT "Base model for initialization of GeneratorTransformer"

/*
  This model enables to initialize the generator model when the load-flow inputs are not known at the generator terminal but at the generator transformer terminal.
  Usually, terminal 1 in the network terminal and terminal 2 in the generator terminal.

  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/

  // Start values at terminal (network terminal side)
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 (base U1Nom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 (base U1Nom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 (base U2Nom)";
  Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 (base U2Nom, SnRef) (receptor convention)";
  Dynawo.Connectors.VoltageModulePuConnector U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";
  Dynawo.Connectors.ActivePowerPuConnector P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector Q20Pu "Start value of reactive power at terminal 2 in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.AngleConnector U2Phase0 "Start value of voltage angle in rad";

  Dynawo.Connectors.ReactivePowerPuConnector Q10PuVar "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.AngleConnector U10PuVar "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";

equation
  Q10PuVar = Q10Pu;
  U10PuVar = U10Pu;
  s10Pu = Complex(P10Pu, Q10Pu);
  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

  P20Pu = - ComplexMath.real(u20Pu * ComplexMath.conj(i20Pu));
  Q20Pu = - ComplexMath.imag(u20Pu * ComplexMath.conj(i20Pu));
  U20Pu = ComplexMath.'abs'(u20Pu);
  U2Phase0 = ComplexMath.arg(u20Pu);

  annotation(preferredView = "text");
end BaseGeneratorTransformer_INIT;
