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

model LoadAuxiliaries_INIT "Initialization for auxiliaries where P0PuVar, Q0PuVar and u0Pu need to be connected"
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";

  Dynawo.Connectors.ActivePowerPuConnector P0PuVar "Start value of active power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ReactivePowerPuConnector Q0PuVar "Start value of reactive power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ComplexVoltagePuConnector u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  P0PuVar = P0Pu;
  Q0PuVar = Q0Pu;
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  annotation(preferredView = "text");
end LoadAuxiliaries_INIT;
