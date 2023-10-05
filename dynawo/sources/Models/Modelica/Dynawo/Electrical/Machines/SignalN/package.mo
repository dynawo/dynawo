within Dynawo.Electrical.Machines;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package SignalN "Generator models that are based on SignalN for the frequency handling"
  extends Icons.Package;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> These generators models provide an active power PGenPu that depends on their setpoint PGen0Pu and their participation in an emulated frequency regulation that calculates the signal N, that is common to all the generators in a connected component and which increases or decreases the generation of each generator.<div>This model is used with the frequency handling model SignalN and cannot be used with DYNModelOmegaRef as the frequency is not explicitly expressed.</div></body></html>"));
end SignalN;
