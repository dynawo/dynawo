within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model QControl3B2020 "Reactive power control module for wind turbines (IEC N°61400-27-1:2020) with slightly different initialization for Type 3B wind turbine model"
  extends QControl2020(
    antiWindupIntegrator1.Y0 = (iGs0Pu.re + uGs0Pu.im / XEqv) * sin(UPhase0) - (iGs0Pu.im - uGs0Pu.re / XEqv) * cos(UPhase0) + (uGs0Pu.im ^ 2 + uGs0Pu.re ^ 2) ^ 0.5 / XEqv,
    absLimRateLimFirstOrderFreeze.Y0 = (iGs0Pu.re + uGs0Pu.im/XEqv) * sin(UPhase0) - (iGs0Pu.im - uGs0Pu.re / XEqv) * cos(UPhase0) + (uGs0Pu.im ^ 2 + uGs0Pu.re ^ 2) ^ 0.5 / XEqv,
    absLimRateLimFeedthroughFreeze.Y0 = (iGs0Pu.re + uGs0Pu.im / XEqv) * sin(UPhase0) - (iGs0Pu.im - uGs0Pu.re / XEqv) * cos(UPhase0) + (uGs0Pu.im ^ 2 + uGs0Pu.re ^ 2) ^ 0.5 / XEqv);

  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014) in pu (base SNom, UNom), example value = 0.4 (Type 3A) or = 10 (Type 3B)" annotation(
    Dialog(tab = "genSystem"));

  //Initial parameters
  parameter Types.ComplexCurrentPu iGs0Pu "Complex current at converter output in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.ComplexVoltagePu uGs0Pu "Initial complex voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

  annotation(preferredView = "diagram");
end QControl3B2020;
