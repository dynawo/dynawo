within Dynawo.Electrical.Controls.WECC.Parameters.REEC;

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

record ParamsREEC "Common REEC parameters"
  parameter Boolean PfFlag "Power factor flag: Q control (0) or pf control(1)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Boolean PQFlag "Q/P priority: Q priority (0) or P priority (1)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Integer QFlag "Q control flag: constant pf or Q ctrl (0) or voltage/Q (1) or (only for REEC-E) disable PI control of constant pf or Q ctrl (2)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Boolean VFlag "Voltage control flag: voltage control (0) or Q ctrl (1)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));

  parameter Types.VoltageModulePu Dbd1Pu "Overvoltage deadband for reactive current injection in pu (base UNom) (typical: -0.1..0)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.VoltageModulePu Dbd2Pu "Undervoltage deadband for reactive current injection in pu (base UNom) (typical: 0..0.1)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit DPMaxPu "Active power upper rate limit in pu/s (base SNom) (typical: > 0.1, set to 99 to disable)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit DPMinPu "Active power lower rate limit in pu/s (base SNom) (typical: < -0.1, set to -99 to disable)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.CurrentModulePu IMaxPu "Maximal apparent current magnitude in pu (base UNom, SNom) (typical: 1..2)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Iqh1Pu "Maximum reactive current injection (typical: 1..1.1) in pu (base UNom, SNom)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Iql1Pu "Minimum reactive current injection (typical: -1.1..-1) in pu (base UNom, SNom)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Kqi "Integrator gain local reactive power PI controller" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Kqp "Proportional gain local reactive power PI controller" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Kqv "K-Factor, reactive current injection gain (typical: 0..10)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Kvi "Integrator gain local voltage PI controller" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.PerUnit Kvp "Proportional gain local voltage PI controller" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.ActivePowerPu PMaxPu "Active power upper limit in pu (base SNom) (typical: 1)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.ActivePowerPu PMinPu "Active power lower limit in pu (base SNom) (typical: 0)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.ReactivePowerPu QMaxPu "Reactive power upper limit, when vFlag == 1 in pu (base SNom)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.ReactivePowerPu QMinPu "Reactive power lower limit, when vFlag == 1 in pu (base SNom)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.Time tIq "Filter time constant reactive current in s (typical: 0.01..0.02)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.Time tRv "Filter time constant terminal voltage in s (typical: 0.01..0.02)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.Time tP "Filter time constant active power in s (typical: 0.1..0.2)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.Time tPord "Filter time constant inverter active power in s" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.VoltageModulePu VDipPu "Low voltage condition trigger voltage for FRT in pu (base UNom) (typical: 0..0.9)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.VoltageModulePu VMaxPu "Maximum voltage at inverter terminal in pu (base UNom) (typical: 1.05..1.15)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.VoltageModulePu VMinPu "Minimum voltage at inverter terminal in pu (base UNom) (typical: 0.85..0.95)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.VoltageModulePu VRef0Pu "Reference voltage for reactive current injection in pu (base UNom) (typical: 0.95..1.05)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));
  parameter Types.VoltageModulePu VUpPu "High voltage condition trigger voltage for FRT in pu (base UNom) (typical: 1.1..1.3)" annotation(
    Dialog(tab="Electrical Control", group = "REEC"));

  // Initial parameters
  parameter Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Types.PerUnit PF0 "Start value of power factor";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage magnitude at injector terminal in pu (base UNom)";

  annotation(preferredView = "text");
end ParamsREEC;
