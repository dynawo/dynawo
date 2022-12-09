within Dynawo.Electrical.Machines.Simplified;

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

model GeneratorPVFixed "Generator with fixed active power and voltage"
  extends BaseClasses.BaseGeneratorSimplified;
  extends AdditionalIcons.Machine;

  Types.Angle UPhase(start = UPhase0) "Voltage angle at terminal in rad";

  final parameter Types.Angle UPhase0 = ComplexMath.arg(u0Pu) "Initial voltage angle at terminal in rad";

equation
  UPhase = ComplexMath.arg(terminal.V);

  if running.value then
    PGenPu = PGen0Pu;
    UPu = U0Pu;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end GeneratorPVFixed;
