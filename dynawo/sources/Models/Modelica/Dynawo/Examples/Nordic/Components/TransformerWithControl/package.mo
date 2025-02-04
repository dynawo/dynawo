within Dynawo.Examples.Nordic.Components;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

package TransformerWithControl "Controlled transformer frame of the Nordic 32 test system"
  extends Icons.Package;

  annotation(
    Documentation(info = "<html><head></head><body>This package contains the regulated transformer models used in the Nordic 32 test system. They are implemented as a transformer frame model, where the transformer and its LTC is already connected, parameterized and initialized.<div>The frame model only requires initial load flow values and the transformer preset.</div></body></html>"));
end TransformerWithControl;
