within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package Parameters "Parameters of the HVDC VSC model"
  import Dynawo.Types;
  extends Icons.RecordsPackage;

  record Params_ACEmulation
    parameter Types.Time tFilter "Time constant of the angle measurement filter";
    parameter Types.PerUnit KACEmulation "Inverse of the emulated AC reactance (base SnRef or SNom) (receptor or generator convention). If in generator convention, KACEmulation should be < 0.";
  annotation(preferredView = "text");
  end Params_ACEmulation;

  record Params_RPFaultFunction
    parameter Types.PerUnit SlopeRPFault "Slope of the recovery of rpfault after a fault in pu/s";
  annotation(preferredView = "text");
  end Params_RPFaultFunction;

  record Params_DeltaP
    parameter Types.VoltageModulePu UdcMinPu "Minimum value of the DC voltage in pu (base UNom)";
    parameter Types.VoltageModulePu UdcMaxPu "Maximum value of the DC voltage in pu (base UNom)";
    parameter Types.PerUnit KpDeltaP "Proportional coefficient of the PI controller for the calculation of DeltaP";
    parameter Types.PerUnit KiDeltaP "Integral coefficient of the PI controller for the calculation of DeltaP";
  annotation(preferredView = "text");
  end Params_DeltaP;

  record Params_ActivePowerControl
    extends Params_DeltaP;
    extends Params_BaseActivePowerControl;
  annotation(preferredView = "text");
  end Params_ActivePowerControl;

  record Params_BaseActivePowerControl
    extends Params_RPFaultFunction;
    parameter Types.PerUnit KpPControl "Proportional coefficient of the PI controller for the active power control";
    parameter Types.PerUnit KiPControl "Integral coefficient of the PI controller for the active power control";
    parameter Types.ActivePowerPu PMaxOPPu "Maximum operator value of the active power in pu (base SNom)";
    parameter Types.ActivePowerPu PMinOPPu "Minimum operator value of the active power in pu (base SNom)";
    parameter Types.Time SlopePRefPu "Slope of the ramp of PRefPu";
  annotation(preferredView = "text");
  end Params_BaseActivePowerControl;

  record Params_ActivateDeltaP
    parameter Types.CurrentModulePu DUDC "Deadband for the activate DeltaP function";
  annotation(preferredView = "text");
  end Params_ActivateDeltaP;

  record Params_DCVoltageControl
    extends Params_ActivateDeltaP;
    extends Params_BaseDCVoltageControl;
  annotation(preferredView = "text");
  end Params_DCVoltageControl;

  record Params_BaseDCVoltageControl
    parameter Types.VoltageModulePu UdcRefMaxPu "Maximum value of the DC voltage reference in pu (base UNom)";
    parameter Types.VoltageModulePu UdcRefMinPu "Minimum value of the DC voltage reference in pu (base UNom)";
    parameter Types.PerUnit Kpdc "Proportional coefficient of the PI controller for the dc voltage control";
    parameter Types.PerUnit Kidc "Integral coefficient of the PI controller for the dc voltage control";
  annotation(preferredView = "text");
  end Params_BaseDCVoltageControl;

  record Params_BlockingFunction
    parameter Types.VoltageModulePu UBlockUVPu "Minimum voltage that triggers the blocking function in pu (base UNom)";
    parameter Types.Time TBlockUV "If UPu < UBlockUVPu during TBlockUV then the blocking is activated";
    parameter Types.Time TBlock "The blocking is activated during at least TBlock";
    parameter Types.Time TDeblockU "When UPu goes back between UMindbPu and UMaxdbPu for TDeblockU then the blocking is deactivated";
    parameter Types.VoltageModulePu UMindbPu "Minimum voltage that deactivates the blocking function in pu (base UNom)";
    parameter Types.VoltageModulePu UMaxdbPu "Maximum voltage that deactivates the blocking function in pu (base UNom)";
    parameter Types.Time tFilter = 0.01 "Time constant of the measurement filter in s";
  annotation(preferredView = "text");
  end Params_BlockingFunction;

  record Params_DCLine
    parameter Types.PerUnit RdcPu "DC line resistance in pu (base UdcNom, SnRef)";
    parameter Types.PerUnit CdcPu "DC line capacitance in pu (base UdcNom, SnRef)";
  annotation(preferredView = "text");
  end Params_DCLine;

  record Params_QRefQU
    parameter Types.PerUnit SlopeURefPu "Slope of the ramp of URefPu";
    parameter Types.PerUnit SlopeQRefPu "Slope of the ramp of QRefPu";
    parameter Types.PerUnit Lambda "Lambda coefficient for the QRefUPu calculation";
    parameter Types.PerUnit KiACVoltageControl "Integral coefficient of the PI controller for the ac voltage control";
    parameter Types.PerUnit KpACVoltageControl "Proportional coefficient of the PI controller for the ac voltage control";
    parameter Types.ReactivePowerPu QMinCombPu "Minimum combined reactive power in pu (base SNom)";
    parameter Types.ReactivePowerPu QMaxCombPu "Maximum combined reactive power in pu (base SNom)";
    parameter Types.PerUnit DeadBandU "Deadband for the QRefUPu calculation";
  annotation(preferredView = "text");
  end Params_QRefQU;

  record Params_QRefLim
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
  end Params_QRefLim;

  record Params_ACVoltageControl
    extends Params_QRefQU;
    extends Params_QRefLim;
    parameter Real tableiqMod11 = 0;
    parameter Real tableiqMod12 = 1;
    parameter Real tableiqMod21 = 0.736842;
    parameter Real tableiqMod22 = 1;
    parameter Real tableiqMod31 = 0.894737;
    parameter Real tableiqMod32 = 0;
    parameter Real tableiqMod41 = 1.157895;
    parameter Real tableiqMod42 = 0;
    parameter Real tableiqMod51 = 1.315789;
    parameter Real tableiqMod52 = -1;
    parameter Real tableiqMod61 = 2;
    parameter Real tableiqMod62 = -1;
    parameter Real tableiqMod[:,:] = [tableiqMod11,tableiqMod12;tableiqMod21,tableiqMod22;tableiqMod31,tableiqMod32;tableiqMod41,tableiqMod42;tableiqMod51,tableiqMod52;tableiqMod61,tableiqMod62] "iqMod diagram";
    parameter Types.Time TQ "Time constant of the first order filter for the ac voltage control";
  annotation(preferredView = "text");
  end Params_ACVoltageControl;

annotation(preferredView = "text");
end Parameters;
