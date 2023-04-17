within Dynawo.Electrical.Machines.BaseClasses_INIT;

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

partial model BaseGeneratorVariables_INIT "Base initialization model for simplified generator models"
  parameter Types.ComplexCurrentPu iStart0Pu = Complex(0, 0) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";

  Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu(re(start=iStart0Pu.re)) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  // Convention change
  PGen0Pu = -P0Pu;
  QGen0Pu = -Q0Pu;

  annotation(preferredView = "text");
end BaseGeneratorVariables_INIT;
