within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

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

model ExciterIEEET1_INIT "Initialisation model for voltage regulator"
  extends AdditionalIcons.Init;

  Types.VoltageModulePu UsRef0Pu "Initial voltage reference";
  Types.VoltageModulePu Efd0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";
  Types.VoltageModulePu Efd0PuLF "Initial Efd from LoadFlow";
  Types.VoltageModulePu Us0Pu "Initial stator voltage, p.u. = Unom";

  parameter Types.Time Ka "Regulator gain";
  parameter Types.Time Ke "Exciter constant related to self-excited field";

  parameter Real E1  "Exciter alternator output voltages back of commutating reactance at which saturation is defined";
  parameter Real E2  "Exciter alternator output voltages back of commutating reactance at which saturation is defined";
  parameter Real SE1 "Exciter saturation function value at the corresponding exciter voltage, E1, back of commutating reactance";
  parameter Real SE2 "Exciter saturation function value at the corresponding exciter voltage, E2, back of commutating reactance";

  ExciterIEEET1.Saturation saturation(E1 = E1, E2 = E2, SE1 = SE1, SE2 = SE2);

  equation

    Efd0PuLF = (UsRef0Pu - Us0Pu)*Ka * (1/Ke)/(1+1/Ke * saturation.y/saturation.u);
    Efd0Pu = Efd0PuLF;

    connect(saturation.u, Efd0Pu);

annotation(preferredView = "text");
end ExciterIEEET1_INIT;
