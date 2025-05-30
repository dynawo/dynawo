within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record MechanicalParameters
  parameter Types.PerUnit CdrtPu "Drive train damping in pu (base SNom, omegaNom), example value = 2.344" annotation(Dialog(tab = "Mechanical"));
  parameter Types.Time Hgen "Generator inertia time constant in s, example value = 3.395" annotation(Dialog(tab = "Mechanical"));
  parameter Types.Time Hwtr "WT rotor inertia time constant in s, example value = 0.962" annotation(Dialog(tab = "Mechanical"));
  parameter Types.PerUnit KdrtPu "Drive train stiffness in pu (base SNom, omegaNom), example value = 1.378" annotation(Dialog(tab = "Mechanical"));

  annotation(
    preferredView = "text");
end MechanicalParameters;
