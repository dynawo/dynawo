within Dynawo.Electrical.Controls.PLL;

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

model PLL_INIT ""

  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude at injector terminal in p.u (base UNom)";
  parameter Types.Angle UPhase0  "Start value of voltage angle at injector terminal (in rad)";
  parameter Types.PerUnit Omega0Pu "Start value of angular speed";
  
protected

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in p.u (base UNom)";
  
equation

  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);

end PLL_INIT;
