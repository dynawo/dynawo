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

model GeneratorPVQNomAltPar_INIT "Initialisation model for generator PV based on SignalN for the frequency handling. In this model, QNomAlt is a parameter."
  import Dynawo;
  import Dynawo.Electrical.Machines;

  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";
  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: standard, absorptionMax or generationMax";
  Boolean limUQUp0(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Boolean limUQDown0(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  Types.VoltageModulePu URef0PuVar "Start value of the voltage regulation set point in pu (base UNom)";
  Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power in pu (base QNomAlt) (generator convention)";

equation
  if QGen0Pu <= QMinPu and U0Pu >= URef0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    limUQUp0 = false;
    limUQDown0 = true;
  elseif QGen0Pu >= QMaxPu and U0Pu <= URef0Pu then
    qStatus0 = QStatus.GenerationMax;
    limUQUp0 = true;
    limUQDown0 = false;
  else
    qStatus0 = QStatus.Standard;
    limUQUp0 = false;
    limUQDown0 = false;
  end if;
  URef0PuVar = URef0Pu;
  QStator0Pu = QGen0Pu * SystemBase.SnRef / QNomAlt;

  annotation(preferredView = "text");
end GeneratorPVQNomAltPar_INIT;
