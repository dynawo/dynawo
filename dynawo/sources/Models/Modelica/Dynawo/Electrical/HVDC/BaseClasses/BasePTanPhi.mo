within Dynawo.Electrical.HVDC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BasePTanPhi "Base dynamic model for P/tan(Phi) control"
  extends BaseClasses.BasePTanPhiDangling;

  input Real tanPhi2Ref(start = TanPhi2Ref0) "tan(Phi) regulation set point at terminal 2";

  parameter Real TanPhi2Ref0 "Start value of tan(Phi) regulation set point at terminal 2";

protected
  Types.ReactivePowerPu QInj2RawPu "Raw reactive power at terminal 2 in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePTanPhi;
