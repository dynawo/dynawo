within Dynawo.NonElectrical.Blocks.NonLinear;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model Limiter
  import Modelica;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real uMax "Upper limit of input signal";
  parameter Real uMin= -uMax "Lower limit of input signal";

equation
  y = smooth(0, min(uMax, max(uMin, u)));

end Limiter;
