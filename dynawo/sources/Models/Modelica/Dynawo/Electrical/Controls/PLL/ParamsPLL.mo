within Dynawo.Electrical.Controls.PLL;

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

record ParamsPLL
  parameter Types.PerUnit KiPLL "PLL integrator gain" annotation(
    Dialog(tab="PLL"));
  parameter Types.PerUnit KpPLL "PLL proportional gain" annotation(
    Dialog(tab="PLL"));
  parameter Types.AngularVelocityPu OmegaMaxPu "Upper frequency limit in pu (base omegaNom)" annotation(
    Dialog(tab="PLL"));
  parameter Types.AngularVelocityPu OmegaMinPu "Lower frequency limit in pu (base omegaNom)" annotation(
    Dialog(tab="PLL"));

  annotation(
    preferredView = "text");
end ParamsPLL;
