within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model IdealTransformerVariableTapI_INIT "Initialization for ideal transformer based on the network voltage and current"

  extends BaseClasses_INIT.BaseIdealTransformerVariableTap_INIT;
  extends AdditionalIcons.Init;

  protected
    Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    flow Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";

    Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base U1Nom)";
    Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";

equation

  U10Pu = ComplexMath.'abs' (u10Pu);
  P10Pu = ComplexMath.real(u10Pu * ComplexMath.conj(i10Pu));
  Q10Pu = ComplexMath.imag(u10Pu * ComplexMath.conj(i10Pu));

annotation(preferredView = "text");
end IdealTransformerVariableTapI_INIT;
