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

partial model BaseGeneratorSignalN_INIT "Base initialization model for SignalN generator models"
  extends Dynawo.Electrical.Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu PMax "Maximum active power in MW";
  parameter Types.ActivePowerPu PMin "Minimum active power in MW";
  parameter Types.ReactivePowerPu QMax "Maximum reactive power in Mvar";
  parameter Types.ReactivePowerPu QMin "Minimum reactive power in Mvar";

  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value",
                             AbsorptionMax "Reactive power is fixed to its absorption limit",
                             GenerationMax "Reactive power is fixed to its generation limit");

  Modelica.Blocks.Interfaces.BooleanOutput limUQDown0(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  Modelica.Blocks.Interfaces.BooleanOutput limUQUp0(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
  Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef)";
  Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
  Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef)";
  QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: Standard, AbsorptionMax, GenerationMax";

equation
  PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
  QMinPu = QMin / Dynawo.Electrical.SystemBase.SnRef;
  PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
  QMaxPu = QMax / Dynawo.Electrical.SystemBase.SnRef;

  limUQDown0 = qStatus0 == QStatus.AbsorptionMax;
  limUQUp0 = qStatus0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseGeneratorSignalN_INIT;
