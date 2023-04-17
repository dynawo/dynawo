within Dynawo.Electrical.Transformers.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseTransformerVariables_INIT "Base model for initialization of transformers"
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";

  Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  U10Pu = ComplexMath.'abs' (u10Pu);
  P10Pu = ComplexMath.real(u10Pu * ComplexMath.conj(i10Pu));
  Q10Pu = ComplexMath.imag(u10Pu * ComplexMath.conj(i10Pu));

  annotation(preferredView = "text");
end BaseTransformerVariables_INIT;
