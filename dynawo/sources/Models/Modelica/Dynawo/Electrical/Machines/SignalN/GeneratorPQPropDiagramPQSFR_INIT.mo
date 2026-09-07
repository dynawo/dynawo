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

model GeneratorPQPropDiagramPQSFR_INIT "Initialisation model for generator PQ with a PQ diagram, based on SignalN for the frequency handling, with a proportional reactive power regulation and that participates in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses_INIT.BaseGeneratorSignalNPQDiagram_INIT;
  extends AdditionalIcons.Init;

equation
  if QGenRaw0Pu <= QMin0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMin0Pu;
  elseif QGenRaw0Pu >= QMax0Pu then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMax0Pu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  annotation(preferredView = "text");
end GeneratorPQPropDiagramPQSFR_INIT;
