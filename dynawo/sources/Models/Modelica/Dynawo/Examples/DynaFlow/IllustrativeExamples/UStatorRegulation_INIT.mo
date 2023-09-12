within Dynawo.Examples.DynaFlow.IllustrativeExamples;

model UStatorRegulation_INIT "Initialisation model for the test case with stator voltage regulation"
  /*
  * Copyright (c) 2023, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite
  * of simulation tools for power systems.
  */

  import Dynawo;

  extends AdditionalIcons.Init;

  Dynawo.Electrical.Machines.SignalN.GeneratorPVTfo_INIT Generator3(
    P0Pu    = -1.5,
    Q0Pu    = -0.5,
    U0Pu    =  1.05,
    UPhase0 =  0,
    URef0Pu =  1.05,
    PMin    = -1000000,
    PMax    =  1000000,
    SNom    =  200,
    XTfoPu  =  0.1,
    QNomAlt =  200
    );

  Dynawo.Electrical.Machines.SignalN.GeneratorPVTfoDiagramPQ_INIT Generator4(
    P0Pu    = -1.5,
    Q0Pu    = -0.5,
    U0Pu    =  1.05,
    UPhase0 =  0,
    URef0Pu =  1.05,
    PMin    = -1000000,
    PMax    =  1000000,
    SNom    =  200,
    XTfoPu  =  0.1,
    QNomAlt =  200
    );
    annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>Initialisation is done by initialising each of the two generators.</body></html>"));

end UStatorRegulation_INIT;
