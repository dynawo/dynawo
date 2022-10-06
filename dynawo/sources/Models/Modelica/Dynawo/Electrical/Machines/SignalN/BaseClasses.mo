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

package BaseClasses
  extends Icons.BasesPackage;

  partial model BaseGeneratorSignalN "Base dynamic model for generators based on SignalN for the frequency handling"
    import Dynawo.Electrical.Machines;

    extends Machines.BaseClasses.BaseGeneratorSimplified;

    parameter Types.ActivePowerPu PRef0Pu "Start value of the active power set point in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePower PNom "Nominal power in MW";
    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the frequency regulation";

    input Types.PerUnit N "Signal to change the active power reference setpoint of all the generators in the system in pu (base SnRef)";

  protected
    Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";

  equation
    if running.value then
      PGenRawPu = - PRef0Pu + Alpha * N;
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
    else
      PGenRawPu = 0;
      terminal.i.re = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGeneratorSignalN;

  annotation(preferredView = "text");
end BaseClasses;
