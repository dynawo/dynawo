within Dynawo.Electrical.Wind.IEC.WT;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model WT4CurrentSource_INIT "Wind Turbine Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseW4CurrentSource_INIT(
    constInit.y = U0Pu,
    const1Init.y = U0Pu,
    const2Init.y = -P0Pu * SystemBase.SnRef / SNom,
    const3Init.y = P0Pu * SystemBase.SnRef / (SNom * U0Pu),
    const5Init.y = U0Pu);

equation
  iGs0Pu = Complex(GesPu, BesPu) * (u0Pu - Complex(ResPu, XesPu) * i0Pu * SystemBase.SnRef / SNom) - i0Pu * SystemBase.SnRef / SNom;
  Ip0Pu = cos(UPhase0) * iGs0Pu.re + sin(UPhase0) * iGs0Pu.im;
  Iq0Pu = cos(UPhase0) * iGs0Pu.im - sin(UPhase0) * iGs0Pu.re;
  UWt0DroppedPu = ((U0Pu + RDropPu * P0Pu * SystemBase.SnRef / (SNom * U0Pu) + XDropPu * Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2 + (-XDropPu * P0Pu * SystemBase.SnRef / (SNom * U0Pu) + RDropPu * Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) ^ 2) ^ 0.5;
  XWT0Pu = if MqG == 0 then UWt0DroppedPu - URef0Pu else -Iq0Pu * U0Pu;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WT4CurrentSource_INIT;
