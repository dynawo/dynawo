within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model Ac16c_INIT "IEEE excitation system types AC1C and AC6C initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  //Regulation parameters
  parameter Types.PerUnit AEx "Gain of saturation function";
  parameter Types.PerUnit BEx "Exponential coefficient of saturation function";
  parameter Types.PerUnit Kc "Rectifier loading factor proportional to commutating reactance";
  parameter Types.PerUnit Kd "Demagnetizing factor, function of exciter alternator reactances";
  parameter Types.PerUnit Ke "Exciter field resistance constant";
  parameter Types.VoltageModulePu VfeMaxPu "Maximum exciter field current signal in pu (user-selected base voltage)";

  Types.VoltageModulePu Efe0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";
  Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  Types.VoltageModulePu Ve0Pu "Initial exciter output voltage in pu (user-selected base voltage)";
  Types.VoltageModulePu VeMax0Pu "Maximum exciter output voltage in pu (user-selected base voltage)";

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses_INIT.AcRotatingExciter_INIT acRotatingExciter_INIT(
    AEx = AEx,
    BEx = BEx,
    Kc = Kc,
    Kd = Kd,
    Ke = Ke,
    VfeMaxPu = VfeMaxPu);

equation
  acRotatingExciter_INIT.Efd0Pu = Efd0Pu;
  acRotatingExciter_INIT.Ir0Pu = Ir0Pu;
  Efe0Pu = acRotatingExciter_INIT.Efe0Pu;
  Ve0Pu = acRotatingExciter_INIT.Ve0Pu;
  VeMax0Pu = acRotatingExciter_INIT.VeMax0Pu;

  annotation(preferredView = "text");
end Ac16c_INIT;
