within Dynawo.Electrical.Controls.Converters.EpriGFM;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

package Parameters "Parameters of EPRI Grid Forming model"

record Circuit
  extends CircuitRPuXPu;
  parameter Types.PerUnit GPu "Half-conductance in pu (base SNom, UNom), example value = 0" annotation(Dialog(tab = "Circuit"));
  parameter Types.PerUnit BPu "Half-susceptance in pu (base SNom, UNom), example value = 0" annotation(Dialog(tab = "Circuit"));
end Circuit;

record CircuitRPuXPu
  parameter Types.PerUnit RPu "Resistance in pu (base SNom, UNom), example value = 0.0015" annotation(Dialog(tab = "Circuit"));
  parameter Types.PerUnit XPu "Reactance in pu (base SNom, UNom), example value = 0.15" annotation(Dialog(tab = "Circuit"));
end CircuitRPuXPu;

record CurrentCtrl
  extends CircuitRPuXPu;
  parameter Types.PerUnit KPi "Proportional gain of the current loop, example value = 0.5" annotation(Dialog(tab = "CurrentCtrl"));
  parameter Types.PerUnit KIi "Integral gain of the current loop, example value = 5" annotation(Dialog(tab = "CurrentCtrl"));
  parameter Types.PerUnit tE "PT1 constant for voltage output in s, example value = 0.01" annotation(Dialog(tab = "CurrentCtrl"));
  protected
    parameter Types.PerUnit LFilterPu = XPu "Filter inductance in pu (base UNom, SNom), example value = 0.15" annotation(Dialog(tab = "CurrentCtrl"));
    parameter Types.PerUnit RFilterPu = RPu "Filter resistance in pu (base UNom, SNom), example value = 0.00015" annotation(Dialog(tab = "CurrentCtrl"));
  
end CurrentCtrl;

record CurrentLimiter
  parameter Types.PerUnit IMaxPu "Max current in pu (base UNom, SNom), example value = 1.05" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Boolean PQflag "Active or active power priority flag: false = P priority, true = Q priority" annotation(Dialog(tab = "VoltageCtrl"));
end CurrentLimiter;

record Gfm
  extends OmegaFlag_;
  parameter Types.PerUnit DeltaOmegaMaxPu "Frequency deviation maximum in pu/s (base omegaNom), example value = 75(rad/s)/omegaNom" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit DeltaOmegaMinPu "Frequency deviation minimum in pu/s (base omegaNom), example value = -75(rad/s)/omegaNom" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit tF "Time constant in s, set according to OmegaFlag" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit tV "Time constant in s, set according to OmegaFlag" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit tR "Transducer time constant in s, example value = 0.005" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit KD "Gain of the active damping, Set according to OmegaFlag" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit K1 "Gain, set according to OmegaFlag" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit K2 "Gain, set according to OmegaFlag" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit K2Dvoc "Gain, set according to OmegaFlag" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit MF "VSM inertia constant, example value = 0.15" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit DD "VSM damping factor, example value = 0.11" annotation(Dialog(tab = "Gfm"));
end Gfm;

record InitialCurrentCtrl
  extends InitialUFilter;
  extends InitialIdqConv;
  extends InitialUdqConv;
end InitialCurrentCtrl;

record InitialGfm
  extends InitialPRefQRef;
  extends InitialIdqConv;
  extends InitialTheta;
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's terminal in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's terminal in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.VoltageModulePu UFilterRef0Pu "Start value of voltage reference at the converter's terminal in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialGfm;

record InitialIdqConv
  extends InitialTheta;
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
end InitialIdqConv;

record InitialPRefQRef
  extends Pref0Pu_;
  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power reference at the converter's terminal in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
end InitialPRefQRef;

record InitialTerminalU
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at converter's terminal in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialTerminalU;

record InitialTerminalUi
  extends InitialTerminalU;
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at converter's terminal in pu (base UNom, SnRef) (receptor convention)" annotation(Dialog(tab = "Initial"));
end InitialTerminalUi;

record InitialTheta
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(Dialog(tab = "Initial"));
end InitialTheta;

record InitialUdqConv
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialUdqConv;

record InitialUFilter
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialUFilter;

record InitialVoltageCtrl
  extends InitialUFilter;
  extends InitialIdqConv;
  extends InitialPRefQRef;
end InitialVoltageCtrl;

record LvrtFrz
  parameter Types.PerUnit UDipPu "Freeze voltage in pu (base UNom), example value = 0.85" annotation(Dialog(tab = "VoltageCtrl"));
end LvrtFrz;

record OmegaFlag_
  parameter Integer OmegaFlag "GFM control type; 0=GFL, 1=droop, 2=VSM, 3=dVOC" annotation(Dialog(tab = "General"));
end OmegaFlag_;

record Pll
  extends InitialTerminalU;
  parameter Types.PerUnit KIPll "PLL integrator gain, example value = 700" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit KPPll "PLL proportional gain, example value = 20" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMaxPu "PLL Upper frequency limit in pu (base OmegaNom), example value = 1.5" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMinPu "PLL Lower frequency limit in pu (base OmegaNom), example value = 0.5" annotation(Dialog(tab = "Pll"));
end Pll;

record Pref0Pu_
  parameter Types.ActivePowerPu PRef0Pu "Start value of the active power reference at the converter's terminal in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
end Pref0Pu_;

record SNom
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA" annotation(Dialog(tab = "General"));
end SNom;

record VoltageCtrl
  extends OmegaFlag_;
  extends LvrtFrz;
  extends CurrentLimiter;
  parameter Types.PerUnit KPv "Proportional gain of the voltage loop, example value = 0.5 if OmegaFlag=0 else 2.0" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit KIv "Integral gain of the voltage loop, example value = 150 if OmegaFlag=0 else 10" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit QDroopPu "Voltage droop in pu, example value = 0.2" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit OmegaDroopPu "Frequency droop in pu, example value = 0.05" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit KIp "Integral gain of the power loop, example value = 10" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit KPp "Proportional gain of the power loop, example value = 2" annotation(Dialog(tab = "VoltageCtrl"));
end VoltageCtrl;

end Parameters;
