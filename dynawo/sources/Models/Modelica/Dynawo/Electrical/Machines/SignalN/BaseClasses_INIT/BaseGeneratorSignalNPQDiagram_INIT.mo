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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseGeneratorSignalNPQDiagram_INIT "Base initialization model for SignalN generator models with PQ diagram"
  import Dynawo.Electrical.Machines;

  extends Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu PMax "Maximum active power in MW";
  parameter Types.ActivePowerPu PMin "Minimum active power in MW";
  parameter Types.ReactivePowerPu QMax0 "Start value of maximum reactive power in Mvar";
  parameter Types.ReactivePowerPu QMin0 "Start value of minimum reactive power in Mvar";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  Boolean limUQDown0(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  Boolean limUQUp0(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
  Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
  Types.ReactivePowerPu QMax0Pu "Start value of maximum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMin0Pu "Start value of minimum reactive power in pu (base SnRef)";
  QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: standard, absorptionMax or generationMax";

equation
  PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
  QMin0Pu = QMin0 / Dynawo.Electrical.SystemBase.SnRef;
  PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
  QMax0Pu = QMax0 / Dynawo.Electrical.SystemBase.SnRef;

  limUQDown0 = qStatus0 == QStatus.AbsorptionMax;
  limUQUp0 = qStatus0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseGeneratorSignalNPQDiagram_INIT;
