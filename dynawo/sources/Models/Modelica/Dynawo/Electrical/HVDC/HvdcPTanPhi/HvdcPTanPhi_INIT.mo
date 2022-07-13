within Dynawo.Electrical.HVDC.HvdcPTanPhi;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcPTanPhi_INIT "Initialisation model for P/tan(Phi) HVDC link"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;

  parameter Real CosPhi1Ref0 "Start value of cos(Phi) regulation set point at terminal 1";
  parameter Real CosPhi2Ref0 "Start value of cos(Phi) regulation set point at terminal 2";
  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

  Real TanPhi1Ref0 "Start value of tan(Phi) regulation set point at terminal 1";
  Real TanPhi2Ref0 "Start value of tan(Phi) regulation set point at terminal 2";

equation
  TanPhi1Ref0 = if sign(P10Pu) == sign(Q10Pu) then abs(tan(acos(CosPhi1Ref0))) else - abs(tan(acos(CosPhi1Ref0)));
  TanPhi2Ref0 = if sign(P20Pu) == sign(Q20Pu) then abs(tan(acos(CosPhi2Ref0))) else - abs(tan(acos(CosPhi2Ref0)));
  P1Ref0Pu = P1RefSetPu;

  annotation(preferredView = "text");
end HvdcPTanPhi_INIT;
