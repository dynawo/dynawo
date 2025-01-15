within Dynawo.Electrical.Controls.Converters.EpriGFM;

package Parameters

record Pll
  extends InitialTerminalU;
  parameter Types.PerUnit Ki "PLL integrator gain" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit Kp "PLL proportional gain" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)" annotation(Dialog(tab = "Pll"));
end Pll;

record VoltageCtrl
  extends OmegaFlag;
  extends LvrtFrz;
  extends CurrentLimiter;
  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit CFilter "Filter capacitance in pu (base UNom, SNom)" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit QDroop "Reactive power droop" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit wDroop "Active power droop" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit Kip "Proportional gain of the power loop" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Types.PerUnit Kpp "Integral gain of the power loop" annotation(Dialog(tab = "VoltageCtrl"));
end VoltageCtrl;

record InitialVoltageCtrl
  extends InitialUFilter;
  extends InitialIdqConv;
  extends InitialIdqPcc;
end InitialVoltageCtrl;

record Gfm
  extends OmegaFlag;
  parameter Types.PerUnit deltawmax "omega max" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit deltawmin "omega min" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit tf "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit tv "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit tr "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit kd "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit k1 "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit k2 "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit k2dvoc "Gain of the active damping" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit mf "VSM inertia constant" annotation(Dialog(tab = "Gfm"));
  parameter Types.PerUnit dd "VSM damping constant" annotation(Dialog(tab = "Gfm"));
end Gfm;

record InitialGfm
  extends InitialUFilter;
  extends InitialIdqPcc;
  parameter Types.ActivePowerPu PRef0Pu "Start value of the active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(Dialog(tab = "Initial"));
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)" annotation(Dialog(tab = "Initial"));
  parameter Types.VoltageModulePu UFilterRef0Pu "Start value of voltage module reference at the converter's capacitor in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialGfm;

record CurrentCtrl
  parameter Types.PerUnit Kpi "Proportional gain of the current loop" annotation(Dialog(tab = "CurrentCtrl"));
  parameter Types.PerUnit Kii "Integral gain of the current loop" annotation(Dialog(tab = "CurrentCtrl"));
  parameter Types.PerUnit LFilter "Filter inductance in pu (base UNom, SNom)" annotation(Dialog(tab = "CurrentCtrl"));
  parameter Types.PerUnit RFilter "Filter resistance in pu (base UNom, SNom)" annotation(Dialog(tab = "CurrentCtrl"));
  parameter Types.PerUnit tE "PT1 constant" annotation(Dialog(tab = "CurrentCtrl"));
end CurrentCtrl;

record InitialCurrentCtrl
  extends InitialUFilter;
  extends InitialIdqConv;
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialCurrentCtrl;

record InitialUFilter
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialUFilter;

record InitialIdqConv
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
end InitialIdqConv;

record InitialIdqPcc
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
end InitialIdqPcc;

record InitialTerminalUi
  extends InitialTerminalU;
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)" annotation(Dialog(tab = "Initial"));
end InitialTerminalUi;
  
record InitialTerminalU
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)" annotation(Dialog(tab = "Initial"));
end InitialTerminalU;

record OmegaFlag
  parameter Integer wflag "Integral gain of the power loop" annotation(Dialog(tab = "General"));
end OmegaFlag;

record SNom
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA" annotation(Dialog(tab = "General"));
end SNom;

record Pref0Pu_
  parameter Types.ActivePowerPu Pref0Pu "initial active power in pu" annotation(Dialog(tab = "General"));
end Pref0Pu_;


record Circuit
  parameter Types.PerUnit RPu "Resistance in pu (base SnRef)" annotation(Dialog(tab = "Circuit"));
  parameter Types.PerUnit XPu "Reactance in pu (base SnRef)" annotation(Dialog(tab = "Circuit"));
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef)" annotation(Dialog(tab = "Circuit"));
  parameter Types.PerUnit BPu "Half-susceptance in pu (base SnRef)" annotation(Dialog(tab = "Circuit"));
end Circuit;

record LvrtFrz
  parameter Types.PerUnit VDipPu "Freeze voltage in pu" annotation(Dialog(tab = "VoltageCtrl"));
end LvrtFrz;

record CurrentLimiter
  parameter Types.PerUnit IMaxPu "max current in pu" annotation(Dialog(tab = "VoltageCtrl"));
  parameter Boolean PQflag "PQflag" annotation(Dialog(tab = "VoltageCtrl"));
end CurrentLimiter;


end Parameters;
