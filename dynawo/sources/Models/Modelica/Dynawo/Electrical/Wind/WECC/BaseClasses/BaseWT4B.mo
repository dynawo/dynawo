within Dynawo.Electrical.Wind.WECC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseWT4B "Base model for WECC Wind Turbine 4B"
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4;

equation
  connect(OmegaRef.y, wecc_reec.omegaGPu) annotation(
    Line(points = {{-179, 38}, {-175, 38}, {-175, -60}, {-85, -60}, {-85, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram");
end BaseWT4B;
