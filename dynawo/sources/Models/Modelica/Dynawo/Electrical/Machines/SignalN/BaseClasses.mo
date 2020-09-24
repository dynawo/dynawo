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

  public
    parameter Types.ActivePowerPu PMinPu "Minimum active power in p.u (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in p.u (base SnRef)";
    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePower PNom "Nominal power in MW";
    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the frequency regulation";

    Connectors.ImPin N "Signal to change the active power reference setpoint of all the generators in the system in p.u (base SnRef)";
    Connectors.ZPin alpha "Participation of the considered generator in the frequency regulation. It is equal to Alpha if the generator is not blocked, 0 otherwise.";
    Connectors.ZPin alphaSum "Sum of all the participations of all generators in the frequency regulation";

  protected
    Types.ActivePowerPu PGenRawPu (start = PGen0Pu) "Active power generation without taking limits into account in p.u (base SnRef) (generator convention)";

  equation

    if running.value then
      PGenRawPu = PGen0Pu + (Alpha / alphaSum.value) * N.value;
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
      alpha.value = if (N.value > 0 and PGenRawPu >= PMaxPu) then 0 else if (N.value < 0 and PGenRawPu <= PMinPu) then 0 else Alpha;
    else
      PGenRawPu = 0;
      PGenPu = 0;
      alpha.value = 0;
    end if;

annotation(preferredView = "text");
  end BaseGeneratorSignalN;

  annotation(preferredView = "text");
end BaseClasses;
