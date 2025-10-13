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

model LoadAlphaBeta "Load with voltage-dependent active and reactive power (alpha-beta model)"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";

equation
  if (running.value) then
    if ((terminal.V.re == 0) and (terminal.V.im == 0)) then
      PPu = 0;
      QPu = 0;
    else
      PPu = PRefPu * (1 + deltaP) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ alpha);
      QPu = QRefPu * (1 + deltaQ) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ beta);
    end if;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end LoadAlphaBeta;
