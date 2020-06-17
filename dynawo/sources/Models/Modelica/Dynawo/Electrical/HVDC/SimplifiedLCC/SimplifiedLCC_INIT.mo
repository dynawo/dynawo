within Dynawo.Electrical.HVDC.SimplifiedLCC;

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

model SimplifiedLCC_INIT "Initialisation model for LCC HVDC link"

  public
    parameter Types.ActivePowerPu P10Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.ReactivePowerPu Q10Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in p.u (base UNom)";
    parameter Types.Angle U1Phase0  "Start value of voltage angle at terminal 1 in rad";

    parameter Types.ActivePowerPu P20Pu  "Start value of active power at terminal 2 in p.u (base SnRef) (receptor convention)";
    parameter Types.ReactivePowerPu Q20Pu  "Start value of reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
    parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in p.u (base UNom)";
    parameter Types.Angle U2Phase0  "Start value of voltage angle at terminal 2 in rad";

  protected
    Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";

    Types.ComplexVoltagePu u20Pu  "Start value of complex voltage at terminal 2 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i20Pu  "Start value of complex current at terminal 2 in p.u (base UNom, SnRef) (receptor convention)";

equation

  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

  u20Pu = ComplexMath.fromPolar(U20Pu, U2Phase0);
  s20Pu = Complex(P20Pu, Q20Pu);
  s20Pu = u20Pu * ComplexMath.conj(i20Pu);

end SimplifiedLCC_INIT;
