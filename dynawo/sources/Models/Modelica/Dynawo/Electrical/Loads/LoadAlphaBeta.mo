within Dynawo.Electrical.Loads;

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

model LoadAlphaBeta "Load with voltage dependant active and reactive power (alpha-beta model)"
  extends BaseClasses.BaseLoad;

  public
    parameter Real alpha "Active load sensitivity to voltage";
    parameter Real beta "Reactive load sensitivity to voltage";

    // in order to change the load set-point, connect an event to PRefPu or QRefPu
    Connectors.ZPin PRefPu (value (start = s0Pu.re)) "Active power request";
    Connectors.ZPin QRefPu (value (start = s0Pu.im)) "Reactive power request";

  equation
    if (running.value) then
      PPu = PRefPu.value * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ alpha);
      QPu = QRefPu.value * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ beta);
    else
      terminal.i = Complex(0);
    end if;

end LoadAlphaBeta;
