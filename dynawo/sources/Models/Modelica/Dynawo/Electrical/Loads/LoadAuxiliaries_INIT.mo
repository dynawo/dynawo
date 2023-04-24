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

model LoadAuxiliaries_INIT "Initialization for auxiliaries where u0Pu and i0Pu need to be connected"
  import Modelica;
  extends AdditionalIcons.Init;

  parameter Modelica.Blocks.Interfaces.RealInput P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Modelica.Blocks.Interfaces.RealInput Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";

  Modelica.ComplexBlocks.Interfaces.ComplexOutput u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  annotation(preferredView = "text");
end LoadAuxiliaries_INIT;
