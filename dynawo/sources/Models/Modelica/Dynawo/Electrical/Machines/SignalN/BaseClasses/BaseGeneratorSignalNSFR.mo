within Dynawo.Electrical.Machines.SignalN.BaseClasses;

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

partial model BaseGeneratorSignalNSFR "Base dynamic model for generators based on SignalN for the frequency handling and that participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGenerator;

  parameter Types.PerUnit KSFR "Coefficient of participation in the secondary frequency regulation";

  final parameter Real AlphaSFR = PNom * KSFR "Participation of the considered generator in the secondary frequency regulation";

  input Types.PerUnit NSFR "Signal to change the active power reference setpoint of the generators participating in the secondary frequency regulation in pu (base SnRef)";

equation
  if running.value then
    PGenRawPu = - PRefPu + Alpha * N + AlphaSFR * NSFR;
  else
    PGenRawPu = 0;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSignalNSFR;
