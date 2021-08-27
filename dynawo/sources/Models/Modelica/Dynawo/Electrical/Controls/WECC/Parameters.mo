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
    parameter Boolean RefFlag "Plant level reactive power (0) or voltage control (1)" annotation(Dialog(tab="Plant Control"));
    parameter Boolean VcompFlag "Reactive droop (0) or line drop compensation (1) if RefFlag true" annotation(Dialog(tab="Plant Control"));
    parameter Boolean FreqFlag "Governor response disable (0) or enable (1)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kc "Reactive droop when VcompFlag = 0" annotation(Dialog(tab="Plant Control"));
    parameter Types.Time TFltr "Voltage and reactive power filter time constant (typical: 0.01..0.02)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit dbd "Reactive power deadband when RefFlag = 0; Voltage deadband when RefFlag = 1" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit eMax "Maximum Volt/VAR error" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit eMin "Minimum Volt/VAR error" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit QMax "Maximum plant level reactive power command" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit QMin "Minimum plant level reactive power command" annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tft "Plant controller Q output lead time constant" annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tfv "Plant controller Q output lag time constant (typical: 0.15..5)" annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tp "Active power filter time constant (typical: 0.01..0.02)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit fdbd1 "Overfrequency deadband for governor response (typical: 0.004)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit fdbd2 "Underfrequency deadband for governor response (typical: 0.004)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Ddn "Down regulation droop (typical: 20..33.3)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Dup "Up regulation droop (typical: 0)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit feMax "Maximum power error in droop regulator" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit feMin "Minimum power error in droop regulator" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit PMax "Maximum plant level active power command" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit PMin "Minimum plant level active power command" annotation(Dialog(tab="Plant Control"));
    parameter Types.Time Tlag "Plant controller P output lag time constant (typical: 0.15..5)" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kp "Volt/VAR regulator proportional gain" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Ki "Volt/VAR regulator integral gain" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kpg "Droop regulator proportional gain" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Kig "Droop regulator integral gain" annotation(Dialog(tab="Plant Control"));
    parameter Types.PerUnit Vfrz "Voltage for freezing Volt/VAR regulator integrator (typical: 0..0.9)" annotation(Dialog(tab="Plant Control"));
  annotation(preferredView = "text");
  end Params_PlantControl;

  record Params_ElectricalControl
    parameter Boolean QFlag "Q control flag: const. pf or Q ctrl (0) or voltage/Q (1)" annotation(Dialog(tab="Electrical Control"));
    parameter Boolean VFlag "Voltage control flag: voltage control (0) or Q ctrl (1)" annotation(Dialog(tab="Electrical Control"));
    parameter Boolean PfFlag "Power factor flag: Q control (0) or pf control(1)" annotation(Dialog(tab="Electrical Control"));
    parameter Boolean PPriority "Q/P priority: Q priority (0) or P priority (1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Trv "Filter time constant terminal voltage (typical: 0.01..0.02)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit UMinPu "Low voltage condition trigger voltage for FRT (typical: 0..0.9)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit UMaxPu "High voltage condition trigger voltage for FRT (typical: 1.1..1.3)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Vref0 "Reference voltage for reactive current injection (typical: 0.95..1.05)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dbd1 "Overvoltage deadband for reactive current injection (typical: -0.1..0)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dbd2 "Undervoltage deadband for reactive current injection (typical: 0..0.1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kqv "K-Factor, reactive current injection gain (typical: 0..10)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Iqh1 "Maximum reactive current injection (typical: 1..1.1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Iql1 "Minimum reactive current injection (typical: -1.1..-1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Tp "Filter time constant active power (typical: 0.1..0.2)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Qmax "Reactive power upper limit, when vFlag == 1" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Qmin "Reactive power lower limit, when vFlag == 1" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kqp "Proportional gain local reactive power PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kqi "Integrator gain local reactive power PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Vmax "Maximum voltage at inverter terminal (typical: 1.05..1.15)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Vmin "Minimum voltage at inverter terminal (typical: 0.85..0.95)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kvp "Proportional gain local Voltage PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Kvi "Integrator gain local Voltage PI controller" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Tiq "Filter time constant reactive current (typical: 0.01..0.02)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.Time Tpord "Filter time constant inverter active power" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Pmax "Active power upper limit (typical: 1)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit Pmin "Active power lower limit (typical: 0)" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dPmax "Active power upper rate limit" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit dPmin "Active power lower rate limit" annotation(Dialog(tab="Electrical Control"));
    parameter Types.PerUnit IMax "Maximal apparent current magnitude (typical: 1..1.3)" annotation(Dialog(tab="Electrical Control"));
  annotation(preferredView = "text");
  end Params_ElectricalControl;

  record Params_GeneratorControl
    parameter Types.Time Tg "Emulated delay in converter controls (Cannot be zero, typical: 0.02..0.05)" annotation(Dialog(tab="Generator Control"));
    parameter Types.Time Tfltr "Filter time constant of terminal voltage(Cannot be set to zero, typical: 0.02..0.05)" annotation(Dialog(tab="Generator Control"));
    parameter Types.PerUnit Iqrmin "Minimum rate-of-change of reactive current after fault (typical: -999..-1)" annotation(Dialog(tab="Generator Control"));
    parameter Types.PerUnit Iqrmax "Maximum rate-of-change of reactive current after fault (typical: 1..999)" annotation(Dialog(tab="Generator Control"));
    parameter Types.PerUnit rrpwr "Active power recovery time [pu/s] (typical: 1..20)" annotation(Dialog(tab="Generator Control"));
    parameter Boolean RateFlag "Active current (=false) or active power (=true) ramp (if unkown set to false)" annotation(Dialog(tab="Generator Control"));
  annotation(preferredView = "text");
  end Params_GeneratorControl;

  record Params_PLL
    parameter Types.PerUnit KpPLL "PLL proportional gain" annotation(Dialog(tab="PLL"));
    parameter Types.PerUnit KiPLL "PLL integrator gain" annotation(Dialog(tab="PLL"));
    parameter Types.PerUnit OmegaMinPu "Lower frequency limit (only positive values!)" annotation(Dialog(tab="PLL"));
    parameter Types.PerUnit OmegaMaxPu "Upper frequency limit" annotation(Dialog(tab="PLL"));
  annotation(preferredView = "text");
  end Params_PLL;

end Parameters;
