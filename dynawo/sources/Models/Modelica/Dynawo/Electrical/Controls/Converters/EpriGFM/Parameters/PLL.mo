within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

record PLL
  parameter Types.PerUnit KIPll "PLL integrator gain, example value = 700" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit KPPll "PLL proportional gain, example value = 20" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMaxPu "PLL Upper frequency limit in pu (base OmegaNom), example value = 1.5" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMinPu "PLL Lower frequency limit in pu (base OmegaNom), example value = 0.5" annotation(Dialog(tab = "Pll"));

  annotation(
  preferredView = "text");
end PLL;
