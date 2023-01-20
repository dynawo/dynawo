within Dynawo.Electrical.Machines.SignalN;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPQPropSFR_INIT "Initialisation model for generator PQ based on SignalN for the frequency handling, with a proportional reactive power regulation and that participates in the Secondary Frequency Regulation (SFR)"
  import Dynawo;
  import Dynawo.Electrical.Machines;

  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: standard, absorptionMax or generationMax";
  Boolean limUQUp0(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Boolean limUQDown0(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";

equation
  if QGen0Pu <= QMinPu then
    qStatus0 = QStatus.AbsorptionMax;
    limUQUp0 = false;
    limUQDown0 = true;
  elseif QGen0Pu >= QMaxPu then
    qStatus0 = QStatus.GenerationMax;
    limUQUp0 = true;
    limUQDown0 = false;
  else
    qStatus0 = QStatus.Standard;
    limUQUp0 = false;
    limUQDown0 = false;
  end if;

  annotation(preferredView = "text");
end GeneratorPQPropSFR_INIT;
