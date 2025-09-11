within Dynawo.Electrical.Sources;

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

model InjectorIDQ_INIT "Initialisation model for the injector controlled by d and q current components idPu and iqPu"
  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";

  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at injector terminal (in rad)";

  Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.CurrentComponentPu Id0Pu "Start value of id in pu (base SNom) (generator convention)";
  Types.CurrentComponentPu Iq0Pu "Start value of iq in pu (base SNom) (generator convention)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at injector terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";

equation
  s0Pu = Complex(P0Pu, Q0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  // Park's transformations dq-currents in generator convention, -> receptor convention for terminal
  i0Pu.re = -(cos(UPhase0) * Id0Pu - sin(UPhase0) * Iq0Pu) * SNom / SystemBase.SnRef;
  i0Pu.im = -(sin(UPhase0) * Id0Pu + cos(UPhase0) * Iq0Pu) * SNom / SystemBase.SnRef;

  annotation(
    preferredView = "text");
end InjectorIDQ_INIT;
