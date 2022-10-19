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

package BaseClasses_INIT
  extends Icons.BasesPackage;

  partial model BaseGeneratorSignalN_INIT "Base initialization model for SignalN generator models"
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
  end BaseGeneratorSignalN_INIT;

  partial model BaseGeneratorSignalNPQDiagram_INIT "Base initialization model for SignalN generator models with PQ diagram"
    import Dynawo;
    import Dynawo.Electrical.Machines;

    extends Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
    extends AdditionalIcons.Init;

    parameter Types.ActivePowerPu PMin "Minimum active power in MW";
    parameter Types.ActivePowerPu PMax "Maximum active power in MW";
    parameter Types.ReactivePowerPu QMin0 "Start value of minimum reactive power in Mvar";
    parameter Types.ReactivePowerPu QMax0 "Start value of maximum reactive power in Mvar";

    Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
    Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
    Types.ReactivePowerPu QMin0Pu "Start value of minimum reactive power in pu (base SnRef)";
    Types.ReactivePowerPu QMax0Pu "Start value of maximum reactive power in pu (base SnRef)";

  equation
    PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
    QMin0Pu = QMin0 / Dynawo.Electrical.SystemBase.SnRef;
    PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
    QMax0Pu = QMax0 / Dynawo.Electrical.SystemBase.SnRef;

    annotation(preferredView = "text");
  end BaseGeneratorSignalNPQDiagram_INIT;
end BaseClasses_INIT;
