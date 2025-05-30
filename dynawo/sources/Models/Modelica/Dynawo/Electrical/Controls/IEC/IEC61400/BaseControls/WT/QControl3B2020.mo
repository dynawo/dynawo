within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model QControl3B2020 "Reactive power control module for wind turbines (IEC N°61400-27-1:2020) with slightly different initialization for Type 3B wind turbine model"
  extends QControl2020(
    // change init values
    antiWindupIntegrator1.Y0 = (IGsRe0Pu+UGsIm0Pu/XEqv)*sin(UPhase0) - (IGsIm0Pu-UGsRe0Pu/XEqv)*cos(UPhase0) + (UGsIm0Pu^2+UGsRe0Pu^2)^0.5/XEqv,
    absLimRateLimFirstOrderFreeze.Y0 = (IGsRe0Pu+UGsIm0Pu/XEqv)*sin(UPhase0) - (IGsIm0Pu-UGsRe0Pu/XEqv)*cos(UPhase0) + (UGsIm0Pu^2+UGsRe0Pu^2)^0.5/XEqv,
    absLimRateLimFeedthroughFreeze.Y0 = (IGsRe0Pu+UGsIm0Pu/XEqv)*sin(UPhase0) - (IGsIm0Pu-UGsRe0Pu/XEqv)*cos(UPhase0) + (UGsIm0Pu^2+UGsRe0Pu^2)^0.5/XEqv
  );

  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014 (base UNom, SNom), example value = 0.4 (Type 3A) or = 10 (Type 3B)" annotation(
  Dialog(tab = "genSystem"));

  //Initial parameters
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
      Dialog(tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
      Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
      Dialog(tab = "Initialization"));

end QControl3B2020;
