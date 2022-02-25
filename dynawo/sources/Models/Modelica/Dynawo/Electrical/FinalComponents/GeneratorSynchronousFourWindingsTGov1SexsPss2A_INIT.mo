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

model GeneratorSynchronousFourWindingsTGov1SexsPss2A_INIT "Initialization model for machine with four windings and standard IEEE regulations - TGOV1, SEXS and PSS2A"
  import Dynawo;

  Dynawo.Electrical.Controls.Basics.SetPoint_INIT Pm();
  Dynawo.Electrical.Controls.Basics.SetPoint_INIT URef();
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousExt_4E_INIT generator();
  Dynawo.Electrical.Controls.Machines.Governors.Governor_INIT governor();
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PSS2A_INIT pss();
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.SEXS_INIT voltageRegulator();

equation
  governor.Pm0Pu = Pm.Value0;
  voltageRegulator.UsRef0Pu = URef.Value0;
  voltageRegulator.Efd0Pu = generator.Efd0Pu;
  pss.PGen0Pu = generator.PGen0Pu;
  governor.Pm0Pu = generator.Pm0Pu;
  voltageRegulator.Us0Pu = generator.UStator0Pu;

  annotation(preferredView = "text");
end GeneratorSynchronousFourWindingsTGov1SexsPss2A_INIT;
