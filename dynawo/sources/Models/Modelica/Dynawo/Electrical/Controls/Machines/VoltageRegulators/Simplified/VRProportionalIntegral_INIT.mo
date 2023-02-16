within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

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

model VRProportionalIntegral_INIT "Proportional integral voltage regulator initialization model"
  import Modelica;
  import Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu EfdMaxPu "Maximum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit Gain "Control gain";

  Modelica.Blocks.Interfaces.RealOutput Efd0Pu "Initial exciter field voltage, i.e. Efd0PuLF if compliant with saturations, in pu (user-selected base voltage)";
  Modelica.Blocks.Interfaces.RealOutput Efd0PuLF "Initial exciter field voltage from LoadFlow in pu (user-selected base voltage)";
  Modelica.Blocks.Interfaces.RealOutput Us0Pu "Initial stator voltage in pu (base UNom)";
  Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";
  Types.VoltageModulePu yIntegrator0 "Initial integrator output in pu (user-selected base voltage)";

  Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag_INIT limiterWithLag(UMax = EfdMaxPu, UMin = EfdMinPu);

equation
  limiterWithLag.y0LF = Efd0PuLF;
  Efd0Pu = limiterWithLag.y0;
  yIntegrator0 = limiterWithLag.u0 - Gain * (UsRef0Pu - Us0Pu);
  UsRef0Pu - Us0Pu = limiterWithLag.u0 - limiterWithLag.y0; // Because init in steadystate

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>Here one of the inputs is Efd0PuLF.<div><br></div><div>This value will initialize the limiter input variable, but since it could be out the saturation bounds, the initial value kept for EfdPu is Efd0Pu which is min(max(Efd0PuLF, EfdMinPu), EfdMaxPu).</div></body></html>"));
end VRProportionalIntegral_INIT;
