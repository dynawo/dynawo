within Dynawo.Electrical.Machines;

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

model GeneratorFictitious "Fictitious generator with voltage dependant active and reactive power (alpha-beta model)"

  extends BaseClasses.BaseGeneratorSimplified;

  public

    parameter Real Alpha "Exponential active power sensitivity to voltage";
    parameter Real Beta  "Exponential reactive power sensitivity to voltage";

equation

  if running.value then
    PGenPu = PGen0Pu * (UPu / U0Pu) ^ Alpha;
    QGenPu = QGen0Pu * (UPu / U0Pu) ^ Beta;
  else
    PGenPu = 0;
    QGenPu = 0;
  end if;

end GeneratorFictitious;
