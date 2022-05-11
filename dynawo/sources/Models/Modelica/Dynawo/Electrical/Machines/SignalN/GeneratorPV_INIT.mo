within Dynawo.Electrical.Machines.SignalN;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GeneratorPV_INIT "Initialisation model for generator PV based on SignalN for the frequency handling"

  import Dynawo;
  import Dynawo.Electrical.Machines;

  extends Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

    parameter Types.ActivePowerPu PMin "Minimum active power in MW";
    parameter Types.ActivePowerPu PMax "Maximum active power in MW";
    parameter Types.ReactivePowerPu QMin "Minimum reactive power in Mvar";
    parameter Types.ReactivePowerPu QMax "Maximum reactive power in Mvar";

    Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
    Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
    Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef)";
    Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef)";

equation

    PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
    QMinPu = QMin / Dynawo.Electrical.SystemBase.SnRef;
    PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
    QMaxPu = QMax / Dynawo.Electrical.SystemBase.SnRef;

annotation(preferredView = "text");
end GeneratorPV_INIT;
