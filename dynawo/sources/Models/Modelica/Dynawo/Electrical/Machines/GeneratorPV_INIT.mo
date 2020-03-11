within Dynawo.Electrical.Machines;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GeneratorPV_INIT "Initialisation model for generator PV"

  extends BaseClasses_INIT.BaseGeneratorSimplified_INIT;
  extends AdditionalIcons.Init;

  parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in p.u (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";

  Types.VoltageModulePu URef0Pu "Initial voltage regulation set point";

protected

  final parameter Types.PerUnit LambdaPu = LambdaPuSNom * SNom / SystemBase.SnRef "Reactive power sensitivity of the voltage regulation in p.u. (base UNom, SnRef)";

equation

  URef0Pu = U0Pu + LambdaPu * QGen0Pu;

annotation(preferredView = "text");
end GeneratorPV_INIT;
