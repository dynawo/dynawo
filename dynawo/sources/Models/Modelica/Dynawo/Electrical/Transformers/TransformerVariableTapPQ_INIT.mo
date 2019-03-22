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

model TransformerVariableTapPQ_INIT "Initialization for transformer based on the network voltage, active and reactive power"
  extends BaseClasses_INIT.BaseTransformerVariableTap_INIT;

  public
    parameter Types.AC.ActivePower P10Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.AC.ReactivePower Q10Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.AC.VoltageModule U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base UNom)";
    parameter SIunits.Angle U1Phase0  "Start value of voltage angle at terminal 1 in rad";

  protected
    Types.AC.Voltage u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    Types.AC.ApparentPower s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    flow Types.AC.Current i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";

equation

  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

end TransformerVariableTapPQ_INIT;
