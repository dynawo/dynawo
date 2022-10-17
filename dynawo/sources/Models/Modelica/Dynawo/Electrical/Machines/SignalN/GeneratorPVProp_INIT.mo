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

model GeneratorPVProp_INIT "Initialisation model for generator PV based on SignalN for the frequency handling"

  import Dynawo;
  import Dynawo.Electrical.Machines;

  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

    type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                                AbsorptionMax "Reactive power is fixed to its absorption limit",
                                GenerationMax "Reactive power is fixed to its generation limit");

    parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

    QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: standard, absorptionMax or generationMax";

equation

    if QGen0Pu <= QMinPu and U0Pu >= URef0Pu then
      qStatus0 = QStatus.AbsorptionMax;
    elseif QGen0Pu >= QMaxPu and U0Pu <= URef0Pu then
      qStatus0 = QStatus.GenerationMax;
    elseif (QGen0Pu > QMinPu or U0Pu < URef0Pu) and (QGen0Pu < QMaxPu or U0Pu > URef0Pu) then
      qStatus0 = QStatus.Standard;
    end if;

annotation(preferredView = "text");
end GeneratorPVProp_INIT;
