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

record BaseREECParameters "Common parameters for electrical controls"

  //Common parameters
  parameter Types.VoltageModulePu Dbd1Pu "Lower deadband in voltage error in pu (base UNom) (typical: -0.1..0)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.VoltageModulePu Dbd2Pu "Upper deadband in voltage error in pu (base UNom) (typical: 0..0.1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit DPMaxPu "Up ramp rate on power reference in pu/s (base SNom) (typical: > 0.1, set to 99 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit DPMinPu "Down ramp rate on power reference in pu/s (base SNom) (typical: < -0.1, set to -99 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.CurrentModulePu IMaxPu "Maximum current limit of the device in pu (base SNom, UNom) (typical: 1..2)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Iqh1Pu "Maximum limit on reactive current injection during a voltage-dip/rise in pu (base SNom, UNom) (typical: 1..IMaxPu)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Iql1Pu "Minimum limit on reactive current injection during a voltage-dip/rise in pu (base SNom, UNom) (typical: -IMaxPu..-1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Kqi "Local reactive power control integrator gain in pu/s (base SNom, UNom) (typical: 0..999)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Kqp "Local reactive power control proportional gain in pu (base SNom, UNom) (typical: 0..999)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Kqv "Reactive current injection proportional gain in pu (base SNom, UNom), active only during a voltage-dip/rise (typical: 0..20, set to 0 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Kvi "Local voltage control integrator gain in pu/s (base SNom, UNom) (typical: 0..999)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.PerUnit Kvp "Local reactive power control proportional gain in pu/s (base SNom, UNom) (typical: 0..999)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Boolean PfFlag "Power factor flag: Q control (0) or pf control(1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.ActivePowerPu PMaxPu "Maximum active power reference in pu (base SNom) (typical: 1..1.15)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.ActivePowerPu PMinPu "Minimum active power reference in pu (base SNom) (typical: 0..0.05)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Boolean PQFlag "Q/P priority: Q (0) or P (1) priority selection on current limit flag" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Boolean QFlag "Reactive power control flag: constant pf or Q control (0) or voltage/Q control (1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.Time tIq "Controller time-constant in s (typical: 0..0.02)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.Time tP "Electrical power transducer time constant in s (typical: 0..1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.Time tPOrd "Power order time constant in s" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.Time tRv "Voltage measurement transducer time constant in s (typical: 0..0.1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.VoltageModulePu UDipPu "The voltage below which voltage-dip logic is initiated, in pu (base UNom) (typical: 0..0.9, set to -1 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Boolean UFlag "Voltage control flag: voltage control (0) or Q control (1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.VoltageModulePu UMaxPu "Voltage control maximum limit in pu (base UNom) (typical: 1.05..1.1)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.VoltageModulePu UMinPu "Voltage control minimum limit in pu (base UNom) (typical: 0.8..0.95)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.VoltageModulePu UUpPu "The voltage above which voltage-dip/up logic is initiated, in pu (base UNom) (typical: 1.1..1.3, set to 2 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));
  parameter Types.VoltageModulePu VRef0Pu "The reference voltage from which the voltage error is calculated in pu (base UNom) (typical: 0.95..1.05)" annotation(
    Dialog(tab = "Electrical Control", group = "Common"));

  annotation(
    preferredView = "text");
end BaseREECParameters;
