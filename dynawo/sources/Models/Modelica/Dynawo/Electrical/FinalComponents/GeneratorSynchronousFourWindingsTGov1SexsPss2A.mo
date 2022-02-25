within Dynawo.Electrical.FinalComponents;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorSynchronousFourWindingsTGov1SexsPss2A "Machine with four windings and standard IEEE regulations - TGOV1, SEXS and PSS2A"
  import Dynawo;

  Dynawo.Electrical.Controls.Basics.SetPoint Pm();
  Dynawo.Electrical.Controls.Basics.SetPoint URef();
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous generator();
  Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam.TGOV1 governor();
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PSS2A pss();
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS voltageRegulator();

equation
  governor.PmRefPu = Pm.setPoint.value;
  voltageRegulator.UsRefPu = URef.setPoint.value;
  generator.PGenPu = pss.PGenPu;
  generator.PmPu.value = governor.PmPu;
  generator.UStatorPu.value = voltageRegulator.UsPu;
  generator.efdPu.value = voltageRegulator.EfdPu;
  generator.omegaPu.value = governor.omegaPu;
  generator.omegaPu.value = pss.omegaPu;
  voltageRegulator.UpssPu = pss.UpssPu;

  annotation(preferredView = "text");
end GeneratorSynchronousFourWindingsTGov1SexsPss2A;
