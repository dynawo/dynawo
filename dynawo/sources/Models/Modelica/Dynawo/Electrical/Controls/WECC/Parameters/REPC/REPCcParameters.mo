within Dynawo.Electrical.Controls.WECC.Parameters.REPC;

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

record REPCcParameters "Parameters for REPCc"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.BaseREPCParameters;

  //REPCc parameters
  parameter Types.PerUnit DfMaxPu "Maximum frequency error in pu/s (base OmegaNom) (typical: 0.01..999)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit DfMinPu "Minimum frequency error in pu/s (base OmegaNom) (typical: -999..-0.01)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit DPrMaxPu "Maximum rate of increase of plant active power reference in pu/s (base SNom) (set to 9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit DPrMinPu "Maximum rate of decrease of plant active power reference in pu/s (base SNom) (set to -9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit DQRefMaxPu "Maximum rate of increase of reactive power reference in pu/s (base SNom) (set to 9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit DQRefMinPu "Maximum rate of decrease of reactive power reference in pu/s (base SNom) (set to -9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Boolean FfwrdFlag "Enable (1) or disable (0) feedforward" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Boolean PefdFlag "Enable (1) or disable (0) electrical power feedback" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Real PfMax "Maximum power factor limit (typical: 0.9..0.95)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Real PfMin "Minimum power factor limit (typical: -0.95..-0.9)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.ActivePowerPu PiMaxPu "Maximum output of the active power PI controller in pu (base SNom) (generator convention) (typical: 1.0)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.ActivePowerPu PiMinPu "Minimum output of the active power PI controller in pu (base SNom) (generator convention) (typical: 0.0)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.ActivePowerPu PrMaxPu "Maximum rate of increase of active power reference in pu/s (base SNom) (generator convention) (set to 9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.ActivePowerPu PrMinPu "Maximum rate of decrease of active power reference in pu/s (base SNom) (generator convention) (set to -9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.ReactivePowerPu QRefMaxPu "Maximum reactive power reference in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.ReactivePowerPu QRefMinPu "Minimum reactive power reference in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit QUMaxPu "Maximum reactive power or voltage in pu (base SNom or UNom) (generator convention) (set to 9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit QUMinPu "Minimum reactive power or voltage in pu (base SNom or UNom) (generator convention) (set to -9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit QUrMaxPu "Maximum rate of increase of reactive power or voltage in pu/s (base SNom or UNom) (set to 9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.PerUnit QUrMinPu "Maximum rate of decrease of reactive power or voltage in pu/s (base SNom or UNom) (set to -9999 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.Time tC "Reactive current compensation time constant in s (typical: 0..2)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.Time tFreq "Frequency time constant in s" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.Time tFrz "A time delay in s, during which the states (s2, s3, s5 and s6) are kept frozen even after the filtered voltage recovers above Vfrz. This can be used to ensure the plant controller does not interact with the inverter-level LVRT. (typical: 0..2)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.VoltageModulePu URefMaxPu "Maximum voltage reference in pu (base UNom) (typical: 1.05..1.08)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));
  parameter Types.VoltageModulePu URefMinPu "Minimum voltage reference in pu (base UNom) (typical: 0.95..1.0)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCc"));

  //MSS switching logic parameters
  parameter Types.PerUnit QDn1Pu "First stage of capacitor (reactor) switching out (in) in pu (base SNom) (Qdn1 < 0)" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.PerUnit QDn2Pu "Second stage of capacitor (reactor) switching out (in) in pu (base SNom) (Qdn2 < Qdn1)" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.PerUnit QUp1Pu "First stage of capacitor (reactor) switching in (out) in pu (base SNom) (Qup1 > 0)" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.PerUnit QUp2Pu "Second stage of capacitor (reactor) switching in (out) in pu (base SNom) (Qup2 > Qup1)" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.Time tDelay1 "Time delay after which if Q < Qdn1 (or Q > Qup1) a capacitor (reactor) is switched in s" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.Time tDelay2 "Time delay after which if Q < Qdn2 (or Q > Qup2) a capacitor (reactor) is switched in s (typical: Tdelay2 < Tdelay1 )" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.Time tMssBrk "Time it takes to switch in (out) a mechanically switched shunt in s (typical: 0.05..0.1, set to 0 to disable)" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));
  parameter Types.Time tOut "Time for discharging of a capacitor that has just been switched out in s; the same capacitor cannot be switched back in until tOut seconds has elapsed (typical: 120..300)" annotation(
    Dialog(tab = "Plant Controller", group = "MSS"));

  annotation(
    preferredView = "text");
end REPCcParameters;
