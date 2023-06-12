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

record ParamsQRefLim
  parameter Types.ReactivePowerPu DeadBand0 = 0.1 "Deadband for the initialization of the reactive limits in pu (base SNom)";
  parameter Types.Time tFilterLim = 1 "Time constant for the limits filter in s";
  parameter Types.ReactivePowerPu QMinOPPu "Minimum operator value of the reactive power in pu (base SNom)";
  parameter Types.ReactivePowerPu QMaxOPPu "Maximum operator value of the reactive power in pu (base SNom)";
  parameter Real tableQMaxPPu11 = 0;
  parameter Real tableQMaxPPu12 = 0.4;
  parameter Real tableQMaxPPu21 = 1.018;
  parameter Real tableQMaxPPu22 = 0.301;
  parameter Real tableQMaxPPu31 = 1.049;
  parameter Real tableQMaxPPu32 = 0;
  parameter Real tableQMaxPPu41 = 1.049009;
  parameter Real tableQMaxPPu42 = 0;
  parameter Real tableQMaxPPu[:,:] = [-tableQMaxPPu41,tableQMaxPPu42;-tableQMaxPPu31,tableQMaxPPu32;-tableQMaxPPu21,tableQMaxPPu22;tableQMaxPPu11,tableQMaxPPu12;tableQMaxPPu21,tableQMaxPPu22;tableQMaxPPu31,tableQMaxPPu32;tableQMaxPPu41,tableQMaxPPu42] "PQ diagram for Q>0";
  parameter Real tableQMaxUPu11 = 0;
  parameter Real tableQMaxUPu12 = 0.401;
  parameter Real tableQMaxUPu21 = 1.105263;
  parameter Real tableQMaxUPu22 = 0.401;
  parameter Real tableQMaxUPu31 = 1.131579;
  parameter Real tableQMaxUPu32 = 0;
  parameter Real tableQMaxUPu41 = 2;
  parameter Real tableQMaxUPu42 = 0;
  parameter Real tableQMaxUPu[:,:] = [tableQMaxUPu11,tableQMaxUPu12;tableQMaxUPu21,tableQMaxUPu22;tableQMaxUPu31,tableQMaxUPu32;tableQMaxUPu41,tableQMaxUPu42] "UQ diagram for Q>0";
  parameter Real tableQMinPPu11 = 0;
  parameter Real tableQMinPPu12 = - 0.6;
  parameter Real tableQMinPPu21 = 0.911;
  parameter Real tableQMinPPu22 = - 0.6;
  parameter Real tableQMinPPu31 = 1.018;
  parameter Real tableQMinPPu32 = - 0.288;
  parameter Real tableQMinPPu41 = 1.049;
  parameter Real tableQMinPPu42 = 0;
  parameter Real tableQMinPPu51 = 1.049009;
  parameter Real tableQMinPPu52 = 0;
  parameter Real tableQMinPPu[:,:] = [-tableQMinPPu51,tableQMinPPu52;-tableQMinPPu41,tableQMinPPu42;-tableQMinPPu31,tableQMinPPu32;-tableQMinPPu21,tableQMinPPu22;tableQMinPPu11,tableQMinPPu12;tableQMinPPu21,tableQMinPPu22;tableQMinPPu31,tableQMinPPu32;tableQMinPPu41,tableQMinPPu42;tableQMinPPu51,tableQMinPPu52] "PQ diagram for Q<0";
  parameter Real tableQMinUPu11 = 0;
  parameter Real tableQMinUPu12 = 0;
  parameter Real tableQMinUPu21 = 0.986842;
  parameter Real tableQMinUPu22 = 0;
  parameter Real tableQMinUPu31 = 1.052632;
  parameter Real tableQMinUPu32 = -0.601;
  parameter Real tableQMinUPu41 = 2;
  parameter Real tableQMinUPu42 = -0.601;
  parameter Real tableQMinUPu[:,:] = [tableQMinUPu11,tableQMinUPu12;tableQMinUPu21,tableQMinUPu22;tableQMinUPu31,tableQMinUPu32;tableQMinUPu41,tableQMinUPu42] "UQ diagram for Q<0";

  annotation(preferredView = "text");
end ParamsQRefLim;
