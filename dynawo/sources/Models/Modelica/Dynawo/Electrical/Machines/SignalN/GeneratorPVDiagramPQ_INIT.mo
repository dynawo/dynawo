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

model GeneratorPVDiagramPQ_INIT "Initialisation model for generator PV based on SignalN for the frequency handling and with a diagram for handling the reactive power limits. In this model, QNomAlt is calculated using QMax0."
  extends BaseClasses_INIT.BaseGeneratorSignalNPQDiagram_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

  Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";

equation
  if QGen0Pu <= QMin0Pu and U0Pu >= URef0Pu then
    qStatus0 = QStatus.AbsorptionMax;
  elseif QGen0Pu >= QMax0Pu and U0Pu <= URef0Pu then
    qStatus0 = QStatus.GenerationMax;
  else
    qStatus0 = QStatus.Standard;
  end if;

  QNomAlt = QMax0;

  annotation(preferredView = "text");
end GeneratorPVDiagramPQ_INIT;
