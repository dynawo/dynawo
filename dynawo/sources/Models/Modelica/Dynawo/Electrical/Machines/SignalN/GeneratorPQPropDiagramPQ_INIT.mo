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

model GeneratorPQPropDiagramPQ_INIT "Initialisation model for generator PQ with a PQ diagram, based on SignalN for the frequency handling and with a proportional reactive power regulation"
  import Dynawo;
  import Dynawo.Electrical.Machines;

  extends BaseClasses_INIT.BaseGeneratorSignalNPQDiagram_INIT;
  extends AdditionalIcons.Init;

  annotation(preferredView = "text");
end GeneratorPQPropDiagramPQ_INIT;
