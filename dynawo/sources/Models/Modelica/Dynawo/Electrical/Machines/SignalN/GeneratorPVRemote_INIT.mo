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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPVRemote_INIT "Initialisation model for generator PV based on SignalN for the frequency handling and a remote voltage regulation"
  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModule URef0 "Start value of the voltage regulation set point in kV";
  parameter Types.VoltageModule URegulated0 "Start value of the regulated voltage in kV";

equation
  if QGenRaw0Pu <= QMinPu and URegulated0 >= URef0 then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMinPu;
  elseif QGenRaw0Pu >= QMaxPu and URegulated0 <= URef0 then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMaxPu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  annotation(preferredView = "text");
end GeneratorPVRemote_INIT;
