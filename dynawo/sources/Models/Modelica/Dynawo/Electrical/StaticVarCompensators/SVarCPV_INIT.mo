within Dynawo.Electrical.StaticVarCompensators;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCPV_INIT "Initialization for PV static var compensator model"

  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu U0Pu  "Start value of voltage amplitude at terminal in p.u (base UNom)";
  parameter Types.Angle UPhase0  "Start value of voltage angle at terminal (in rad)";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";
  parameter Types.PerUnit LambdaPu "Statism of the regulation law URefPu = UPu + LambdaPu*QPu in p.u (base UNom, SnRef)";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in p.u (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in p.u (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in p.u (base UNom, SnRef) (receptor convention)";
  Types.PerUnit B0Pu "Start value of the susceptance in p.u (base SnRef)";
  Types.VoltageModule URef0  "Start value of voltage reference in kV";

equation

  URef0 = (U0Pu + LambdaPu * B0Pu * U0Pu ^ 2) * UNom;
  s0Pu = Complex(P0Pu, Q0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);
  B0Pu = ComplexMath.imag(i0Pu / u0Pu);

annotation(preferredView = "text");
end SVarCPV_INIT;
