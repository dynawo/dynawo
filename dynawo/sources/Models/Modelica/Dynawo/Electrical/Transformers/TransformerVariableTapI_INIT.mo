within Dynawo.Electrical.Transformers;

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

model TransformerVariableTapI_INIT "Initialization for transformer based on the network voltage and current"

  extends BaseClasses_INIT.BaseTransformerVariableTap_INIT;

  protected
    Types.AC.Voltage u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    flow Types.AC.Current i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";

    Types.AC.VoltageModule U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base U1Nom)";
    Types.AC.ActivePower P10Pu "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.AC.ReactivePower Q10Pu "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";

equation

  U10Pu = ComplexMath.'abs' (u10Pu);
  P10Pu = ComplexMath.real(u10Pu * ComplexMath.conj(i10Pu));
  Q10Pu = ComplexMath.imag(u10Pu * ComplexMath.conj(i10Pu));

end TransformerVariableTapI_INIT;
