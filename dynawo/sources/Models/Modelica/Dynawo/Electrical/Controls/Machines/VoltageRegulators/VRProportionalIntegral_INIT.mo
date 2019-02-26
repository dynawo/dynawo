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

model VRProportionalIntegral_INIT "Proportional Integral Voltage Regulator INIT Model. Here one of the inputs is Efd0PuLF. This value will initialize the limiter's input variable, but since it could be out the saturation bounds, the initial value kept for EfdPu is Efd0Pu which is min(max(Efd0PuLF, EfdMinPu), EfdMaxPu)"
  import Modelica.Constants;

  import Dynawo.NonElectrical.Blocks.NonLinear.LimiterWithLag_INIT;

  public

    parameter Types.AC.VoltageModule EfdMinPu "Minimum exciter field voltage";
    parameter Types.AC.VoltageModule EfdMaxPu "Maximum exciter field voltage";
    parameter Real Gain "Control gain";

    Types.AC.VoltageModule Efd0PuLF "Initial Efd from loadflow";
    Types.AC.VoltageModule Efd0Pu "Initial Efd";
    Types.AC.VoltageModule yIntegrator0 "Initial control before saturation";
    Types.AC.VoltageModule UcEfd0Pu "Initial voltage set-point, p.u. = Unom";
    Types.AC.VoltageModule Us0Pu "Initial stator voltage, p.u. = Unom";

  protected

    parameter Types.AC.VoltageComponent Ur0Pu = 1.0;
    parameter Types.AC.VoltageComponent Ui0Pu = 0.0 "Start values for complex voltage";

    discrete SIunits.Time tEfdMaxReached0(start = Constants.inf) "First time when the Efd went above the maximum Efd";
    discrete SIunits.Time tEfdMinReached0(start = Constants.inf) "First time when the Efd went below the maximum Efd";

    Types.AC.Voltage u0 (re (start = Ur0Pu), im (start = Ui0Pu));
    LimiterWithLag_INIT limiterWithLag(UMin = EfdMinPu, UMax = EfdMaxPu);

  equation

    tEfdMaxReached0 = limiterWithLag.tUMaxReached0;
    tEfdMinReached0 = limiterWithLag.tUMinReached0;

    limiterWithLag.y0LF = Efd0PuLF;
    Efd0Pu = limiterWithLag.y0;
    yIntegrator0 =  limiterWithLag.u0 - Gain*(UcEfd0Pu - Us0Pu);
    Us0Pu = ComplexMath.'abs'(u0);
    UcEfd0Pu - Us0Pu = limiterWithLag.u0 - limiterWithLag.y0; // Because init in steadystate

end VRProportionalIntegral_INIT;
