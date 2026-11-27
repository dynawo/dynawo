within Dynawo.Electrical.StaticVarCompensators;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model SVarCStandard_INIT "Initialization for standard static var compensator model"
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at injector terminal (in rad)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SnRef) (receptor convention)";

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";
  parameter Types.ApparentPowerModule SNom "Static var compensator nominal apparent power in MVA";
  parameter Types.PerUnit Lambda "Statism of the regulation law URefPu = UPu - Lambda*QPu";

  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

  Types.PerUnit G0Pu "Start value of the conductance in pu (base SNom)";
  Types.PerUnit B0Pu "Start value of the susceptance in pu (base SNom)";
  Types.VoltageModule URef0 "Start value of voltage reference in kV";

  Dynawo.Electrical.Sources.InjectorBG_INIT injector(SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, P0Pu = P0Pu, Q0Pu = Q0Pu);

equation
  URef0 = (U0Pu - Lambda*Q0Pu*SystemBase.SnRef/SNom) * UNom;

  u0Pu = injector.u0Pu;
  s0Pu = injector.s0Pu;
  i0Pu = injector.i0Pu;

  G0Pu = injector.G0Pu;
  B0Pu = injector.B0Pu;

  annotation(preferredView = "text");
end SVarCStandard_INIT;
