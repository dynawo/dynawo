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
  extends Dynawo.Electrical.Wind.IEC.Parameters.XEqv_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUPhaseGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  
end QControl3B2020;
