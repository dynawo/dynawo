within Dynawo.Electrical.Loads;

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

model FrequencyLoad "Load with frequency-dependent active and reactive power"
  extends BaseClasses.BaseLoad;

  public
    parameter Real Gamma "Active load sensitivity to frequency";
    parameter Real Delta "Reactive load sensitivity to voltage";
    parameter Real omegaRef0Pu = 1 "Reference frequency value";

    Connectors.ImPin omegaRefPu "Network angular reference frequency in pu (base OmegaNom)";

  equation
    if (running.value) then
      PPu = PLoadPu.value * ((omegaRefPu/omegaRef0Pu) ^ Gamma);
      QPu = QLoadPu.value * ((omegaRefPu/omegaRef0Pu) ^ Delta);
    else
      terminal.i = Complex(0);
    end if;

end FrequencyLoad;
