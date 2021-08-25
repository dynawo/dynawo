within Dynawo.Electrical.Controls.WECC;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record Parameters "Parameters of the PV WECC model"
  import Dynawo.Types;
  extends Icons.RecordsPackage;

  record Params_PlantControl
    parameter Boolean RefFlag = true "Plant level reactive power (0) or voltage control (1)" annotation(Dialog(tab="Plant Control"));
    parameter Boolean VcompFlag = false "Reactive droop (0) or line drop compensation (1) if RefFlag true"annotation(Dialog(tab="Plant Control"));
    parameter Boolean FreqFlag = true "Governor response disable (0) or enable (1)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kc = 0.1769 "Reactive droop when VcompFlag = 0"annotation(Dialog(tab="Plant Control"));
    parameter Types.Time TFltr = 0.04 "Voltage and reactive power filter time constant (typical: 0.01..0.02)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit dbd = 0.01 "Reactive power deadband when RefFlag = 0; Voltage deadband when RefFlag = 1"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit eMax = 999 "Maximum Volt/VAR error"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit eMin = -999 "Minimum Volt/VAR error"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit QMax = 0.4 "Maximum plant level reactive power command"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit QMin = -0.4 "Minimum plant level reactive power command"annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tft = 0 "Plant controller Q output lead time constant"annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tfv = 0.1 "Plant controller Q output lag time constant (typical: 0.15..5)"annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tp = 0.04 "Active power filter time constant (typical: 0.01..0.02)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit fdbd1 = 0.004 "Overfrequency deadband for governor response (typical: 0.004)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit fdbd2 = 1 "Underfrequency deadband for governor response (typical: 0.004)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Ddn = 20 "Down regulation droop (typical: 20..33.3)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Dup = 0.001 "Up regulation droop (typical: 0)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit feMax = 999 "Maximum power error in droop regulator"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit feMin = -999 "Minimum power error in droop regulator"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit PMax = 1 "Maximum plant level active power command"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit PMin = 0 "Minimum plant level active power command"annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tlag = 0.1 "Plant controller P output lag time constant (typical: 0.15..5)"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kp = 0.1 "Volt/VAR regulator proportional gain"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Ki = 1.5 "Volt/VAR regulator integral gain"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kpg = 0.05 "Droop regulator proportional gain"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kig = 2.36 "Droop regulator integral gain"annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Vfrz = 0 "Voltage for freezing Volt/VAR regulator integrator (typical: 0..0.9)"annotation(Dialog(tab="Plant Control"));
  annotation(preferredView = "text");
  end Params_PlantControl;

  record Params_ElectricalControl
    parameter Boolean QFlag = true "Q control flag: const. pf or Q ctrl (0) or voltage/Q (1)" annotation(Dialog(tab="Electrical Control"));
    parameter Boolean VFlag = true "Voltage control flag: voltage control (0) or Q ctrl (1)" annotation(Dialog(tab="Electrical Control"));
    parameter Boolean PfFlag = false "Power factor flag: Q control (0) or pf control(1)" annotation(Dialog(tab="Electrical Control"));
    parameter Boolean PPriority = false "Q/P priority: Q priority (0) or P priority (1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Trv = 0.02 "Filter time constant terminal voltage (typical: 0.01..0.02)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit UMinPu = 0.9 "Low voltage condition trigger voltage for FRT (typical: 0..0.9)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit UMaxPu = 1.1 "High voltage condition trigger voltage for FRT (typical: 1.1..1.3)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Vref0 = 1 "Reference voltage for reactive current injection (typical: 0.95..1.05)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dbd1 = -0.1 "Overvoltage deadband for reactive current injection (typical: -0.1..0)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dbd2 = 0.1 "Undervoltage deadband for reactive current injection (typical: 0..0.1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kqv = 2 "K-Factor, reactive current injection gain (typical: 0..10)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Iqh1 = 2 "Maximum reactive current injection (typical: 1..1.1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Iql1 = -2 "Minimum reactive current injection (typical: -1.1..-1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Tp = 0.04 "Filter time constant active power (typical: 0.1..0.2)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Qmax = 0.4 "Reactive power upper limit, when vFlag == 1" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Qmin = -0.4 "Reactive power lower limit, when vFlag == 1" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kqp = 1 "Proportional gain local reactive power PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kqi = 0.5 "Integrator gain local reactive power PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Vmax = 1.1 "Maximum voltage at inverter terminal (typical: 1.05..1.15)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Vmin = 0.9 "Minimum voltage at inverter terminal (typical: 0.85..0.95)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kvp = 1 "Proportional gain local Voltage PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kvi = 1 "Integrator gain local Voltage PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Tiq = 0.02 "Filter time constant reactive current (typical: 0.01..0.02)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Tpord = 0.02 "Filter time constant inverter active power" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Pmax = 1 "Active power upper limit (typical: 1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Pmin = 0 "Active power lower limit (typical: 0)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dPmax = 999 "Active power upper rate limit" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dPmin = -999 "Active power lower rate limit" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Imax = 1.05 "Maximal apparent current magnitude (typical: 1..1.3)" annotation(Dialog(tab="Electrical Control"));
  annotation(preferredView = "text");
  end Params_ElectricalControl;

  record Params_GeneratorControl
    parameter Types.Time Tg = 0.02 "Emulated delay in converter controls (Cannot be zero, typical: 0.02..0.05)" annotation(Dialog(tab="Generator Control"));
    parameter Types.Time Tfltr = 0.02 "Filter time constant of terminal voltage(Cannot be set to zero, typical: 0.02..0.05)" annotation(Dialog(tab="Generator Control"));
    parameter Types.PerUnit Iqrmin = -20 "Minimum rate-of-change of reactive current after fault (typical: -999..-1)" annotation(Dialog(tab="Generator Control"));
    parameter Types.PerUnit Iqrmax = 20 "Maximum rate-of-change of reactive current after fault (typical: 1..999)" annotation(Dialog(tab="Generator Control"));
    parameter Types.PerUnit rrpwr = 10 "Active power recovery time [pu/s] (typical: 1..20)" annotation(Dialog(tab="Generator Control"));
    parameter Boolean RateFlag = false "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(Dialog(tab="Generator Control"));
  annotation(preferredView = "text");
  end Params_GeneratorControl;

end Parameters;
