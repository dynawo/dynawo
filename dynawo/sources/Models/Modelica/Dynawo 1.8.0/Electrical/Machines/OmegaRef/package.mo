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

package OmegaRef "Generator models that are based on OmegaRef for the frequency handling"
  extends Icons.Package;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> These generators models need a reference frequency omegaRefPu to work properly. This reference can be set by the user, or it can be handled by the cpp frequency handling model DYNModelOmegaRef, which computes a barycenter of the synchronous machines frequency omegaPu."));
end OmegaRef;
