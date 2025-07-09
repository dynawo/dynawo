within Dynawo.Electrical.Controls.WECC.Parameters.REPC;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
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

record ParamsREPCc
  parameter Types.AngularVelocityPu DfMaxPu "Maximum limit on frequency deviation in pu (base omegaNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.AngularVelocityPu DfMinPu "Minimum limit on frequency deviation in pu (base omegaNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DPrMax "Maximum rate of increase of plant Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DPrMin "Maximum rate of decrease of plant Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DQRefMax "Maximum rate of increase of Q reference in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit DQRefMin "Maximum rate of decrease of Q reference in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Boolean FfwrdFlag "Enable or disable feedforward path" annotation(
    Dialog(tab = "Plant Control"));
  parameter Boolean PefdFlag "Enable or disable electrical power feedback" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PfMax "Maximum limit on power factor" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PfMin "Minimum limit on power factor" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu PiMaxPu "Maximum limit of the active power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ActivePowerPu PiMinPu "Minimum limit of the active power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PrMaxPu "Maximum rate of increase of Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit PrMinPu "Maximum rate of decrease of Pref in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ReactivePowerPu QRefMaxPu "Maximum limit on Qref in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ReactivePowerPu QRefMinPu "Minimum limit on Qref in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Boolean QVFlag "Disable volt/var control completely, or  enable volt/var control" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit QvrMax "Maximum rate of increase of Qext in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit QvrMin "Maximum rate of decrease of Qext in pu/s (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tC "Time constant associated with reactive power measurement/filtering for the reactive droop function, in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tFrq "Frequency transducer/filter time constant in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time tFrz "Time delay during which the states are kept frozen after the filtered voltage recovers above Ufrz, in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.VoltageModulePu UFreqPu "If the voltage at the bus where frequency is monitored < UFreqPu then measured frequency is set to 1 pu, in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.VoltageModulePu URefMaxPu "Maximum limit on Uref in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.VoltageModulePu URefMinPu "Minimum limit on Uref in pu (base UNom)" annotation(
    Dialog(tab = "Plant Control"));

end ParamsREPCc;
