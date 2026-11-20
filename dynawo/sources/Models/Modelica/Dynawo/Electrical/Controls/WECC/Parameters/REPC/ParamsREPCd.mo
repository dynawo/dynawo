within Dynawo.Electrical.Controls.WECC.Parameters.REPC;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

record ParamsREPCd
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPCc;

  parameter Types.PerUnit[NbConv] Kw "Gain of reactive power control branch for each converter" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.PerUnit[NbConv] Kz "Gain of active power control branch for each converter" annotation(
    Dialog(tab = "Plant Control"));
  parameter Integer NbConv = 10 "Number of connected converters" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ApparentPowerModule[NbConv] PMaxPu "Maximum active power for each converter in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ApparentPowerModule[NbConv] PMinPu "Minimum active power for each converter in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ApparentPowerModule[NbConv] QMaxPu "Maximum reactive power for each converter in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ApparentPowerModule[NbConv] QMinPu "Minimum reactive power for each converter in pu (base SNom)" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.ApparentPowerModule[NbConv] SNomConv "Nominal apparent power of each converter in MVA" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time[NbConv] tW "Reactive power control branch time constant for each converter in s" annotation(
    Dialog(tab = "Plant Control"));
  parameter Types.Time[NbConv] tZ "Active power control branch time constant for each converter in s" annotation(
    Dialog(tab = "Plant Control"));

  parameter Types.VoltageModulePu VFrzHighPu "Voltage for freezing Volt/VAR regulator integrator in pu (base UNom) (typical: 0..0.9)" annotation(
    Dialog(tab = "Plant Control"));

  annotation(preferredView = "text");
end ParamsREPCd;
