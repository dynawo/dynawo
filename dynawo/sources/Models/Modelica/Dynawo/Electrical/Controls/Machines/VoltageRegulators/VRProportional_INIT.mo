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

model VRProportional_INIT "Simple Proportional Voltage Regulator INIT Model. Here one of the inputs is Efd0PuLF. This value will initialize the limiter's input variable, but since it could be out the saturation bounds, the initial value kept for EfdPu is Efd0Pu which is min(max(Efd0PuLF, EfdMinPu), EfdMaxPu)"

  import Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag_INIT;

  extends AdditionalIcons.Init;

public

  parameter Types.VoltageModulePu EfdMinPu "Minimum exciter field voltage";
  parameter Types.VoltageModulePu EfdMaxPu "Maximum exciter field voltage";
  parameter Real Gain "Control gain";

  Types.VoltageModulePu Efd0PuLF "Initial Efd from LoadFlow";
  Types.VoltageModulePu Efd0Pu "Computed initial Efd";
  Types.VoltageModulePu UsRef0Pu "Initial voltage set-point, p.u. = Unom";
  Types.VoltageModulePu Us0Pu "Initial stator voltage, p.u. = Unom";

protected

  LimiterWithLag_INIT limiterWithLag(UMin = EfdMinPu, UMax = EfdMaxPu);

equation

  limiterWithLag.y0LF = Efd0PuLF;
  Efd0Pu = limiterWithLag.y0;
  limiterWithLag.u0 = (UsRef0Pu - Us0Pu)*Gain;

annotation(preferredView = "text");
end VRProportional_INIT;
