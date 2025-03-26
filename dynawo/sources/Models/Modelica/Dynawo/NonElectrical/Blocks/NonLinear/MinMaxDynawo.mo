within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

block MinMaxDynawo "Output the minimum and the maximum element of the two signals"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealVectorInput u[2];
  Modelica.Blocks.Interfaces.RealOutput yMax;
  Modelica.Blocks.Interfaces.RealOutput yMin;

equation
  if u[1] < u[2] then
    yMin = u[1];
  else
    yMin = u[2];
  end if;

  if u[1] > u[2] then
    yMax = u[1];
  else
    yMax = u[2];
  end if;

  annotation(preferredView = "text");
end MinMaxDynawo;