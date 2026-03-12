within Dynawo.Electrical.Machines.SignalN.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseGeneratorSignalNPQDiagram_INIT "Base initialization model for SignalN generator models with PQ diagram"
  extends AdditionalIcons.Init;

  parameter Types.ComplexCurrentPu iStart0Pu = Complex(0, 0) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";

  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGenRaw0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) with limits (generator convention)";
  Dynawo.Connectors.VoltageModulePuConnector U0PuVar "Start value of voltage amplitude at terminal in pu (base UNom)";

  Dynawo.Connectors.ComplexVoltagePuConnector u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ComplexCurrentPuConnector i0Pu(re(start = iStart0Pu.re)) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  parameter Types.ActivePowerPu PMax "Maximum active power in MW";
  parameter Types.ActivePowerPu PMin "Minimum active power in MW";
  parameter Types.ReactivePowerPu QMax0 "Start value of maximum reactive power in Mvar";
  parameter Types.ReactivePowerPu QMin0 "Start value of minimum reactive power in Mvar";

  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value",
                             AbsorptionMax "Reactive power is fixed to its absorption limit",
                             GenerationMax "Reactive power is fixed to its generation limit");

  Modelica.Blocks.Interfaces.BooleanOutput limUQDown0(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  Modelica.Blocks.Interfaces.BooleanOutput limUQUp0(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
  Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
  Types.ReactivePowerPu QMax0Pu "Start value of maximum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMin0Pu "Start value of minimum reactive power in pu (base SnRef)";
  QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: standard, absorptionMax or generationMax";

equation
  U0PuVar = U0Pu;
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  // Convention change
  PGen0Pu = -P0Pu;
  QGenRaw0Pu = -Q0Pu;

  PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
  QMin0Pu = QMin0 / Dynawo.Electrical.SystemBase.SnRef;
  PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
  QMax0Pu = QMax0 / Dynawo.Electrical.SystemBase.SnRef;

  limUQDown0 = qStatus0 == QStatus.AbsorptionMax;
  limUQUp0 = qStatus0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseGeneratorSignalNPQDiagram_INIT;
