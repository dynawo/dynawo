within Dynawo.Electrical.Wind.IEC.WPP;

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

model WPP3BCurrentSource_INIT "Wind Power Plant Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends Electrical.Wind.IEC.WT.WT3CurrentSource_INIT;

  //QControl parameter
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)";
  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014 (base UNom, SNom), example value = 0.4 (Type 3A) or = 10 (Type 3B)" annotation(
    Dialog(tab = "Control"));

  Types.PerUnit X0Pu "Initial reactive power or voltage reference in pu (base SNom or UNom) (generator convention)";

equation
  X0Pu = if MwpqMode == 3 then U0Pu else -Q0Pu*SystemBase.SnRef/SNom;
  XWT0Pu = if MqG == 0 then U0Pu else (IGsRe0Pu+UGsIm0Pu/XEqv)*sin(UPhase0) - (IGsIm0Pu-UGsRe0Pu/XEqv)*cos(UPhase0) + (UGsIm0Pu^2+UGsRe0Pu^2)^0.5/XEqv;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WPP3BCurrentSource_INIT;
