within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.Parameters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsACVoltageControl
  extends ParamsQRefQU;
  extends ParamsQRefLim;

  parameter Real tableiqMod11 = 0;
  parameter Real tableiqMod12 = 1;
  parameter Real tableiqMod21 = 0.736842;
  parameter Real tableiqMod22 = 1;
  parameter Real tableiqMod31 = 0.894737;
  parameter Real tableiqMod32 = 0;
  parameter Real tableiqMod41 = 1.157895;
  parameter Real tableiqMod42 = 0;
  parameter Real tableiqMod51 = 1.315789;
  parameter Real tableiqMod52 = -1;
  parameter Real tableiqMod61 = 2;
  parameter Real tableiqMod62 = -1;
  parameter Real tableiqMod[:,:] = [tableiqMod11,tableiqMod12;tableiqMod21,tableiqMod22;tableiqMod31,tableiqMod32;tableiqMod41,tableiqMod42;tableiqMod51,tableiqMod52;tableiqMod61,tableiqMod62] "iqMod diagram";
  parameter Types.Time TQ "Time constant of the first order filter for the ac voltage control";

  annotation(preferredView = "text");
end ParamsACVoltageControl;
