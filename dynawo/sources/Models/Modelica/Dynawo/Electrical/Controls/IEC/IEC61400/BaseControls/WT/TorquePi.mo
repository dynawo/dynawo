within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

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

model TorquePi "Sub module for torque control inside active power control module for type 3 wind turbines (IEC N°61400-27-1:2020)"

  parameter Boolean WT3Type "if true : type a, if false type b";

  //Torque Pi parameters
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical.TorquePiParameters;

  // P Control parameters
  parameter Real TableOmegaPPu[:, :] = [0, 0.76; 0.3, 0.76; 0.31, 0.86; 0.4, 0.94; 0.5, 1; 1, 1] "Lookup table for power as a function of speed, example value = [0, 0.76; 0.3, 0.76; 0.31, 0.86; 0.4, 0.94; 0.5, 1; 1, 1]" annotation(
    Dialog(tab = "PControl", group = "WT"));
  parameter Types.Time tOmegafiltp3 "Filter time constant for measuring generator speed, example value = 0.005" annotation(
    Dialog(tab = "PControl", group = "WT"));
  parameter Boolean MOmegaTMax "Mode for source of rotational speed for maximum torque calculation (false: OmegaWtr -- true: OmegaRef), example value = true" annotation(
    Dialog(tab = "PControl", group = "WT"));

  // Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";
  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014 (base UNom, SNom), example value = 0.4 (Type 3A) or = 10 (Type 3B)" annotation(
    Dialog(tab = "genSystem"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaErrPu(start = 0) "Speed error in pu (base omegaRef)" annotation(
    Placement(transformation(origin = {-410, 140}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-426, 60}, extent = {{-25, -25}, {25, 25}})));
  Modelica.Blocks.Interfaces.RealInput tauEMaxPu(start = TauEMax0Pu) "Maximum electrical torque in pu (base SNom/omegaRef)" annotation(
    Placement(visible = true, transformation(origin = {-410, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-426, 150}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uTcHookPu(start = 0) "Optional voltage input (TC = turbine control) in pu (base UNom)" annotation(
    Placement(transformation(origin = {-410, -200}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-426, -200}, extent = {{-25, -25}, {25, 25}})));
  Modelica.Blocks.Interfaces.RealInput uWtcPu(start = U0Pu) "Measured (=filtered) current for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(transformation(origin = {-410, -180}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-426, -100}, extent = {{-25, -25}, {25, 25}})));

  // Output variable
  Modelica.Blocks.Interfaces.RealOutput tauOutPu(start = PiIntegrator0Pu) "Output torque of torque PI controller in pu (base SNom/omegaRef)" annotation(
    Placement(transformation(origin = {220, 140}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {236, -24}, extent = {{-25, -25}, {25, 25}})));

  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {130, 180}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addKIpKPp(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-76, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addTauOut annotation(
    Placement(transformation(origin = {110, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addUTcHook annotation(
    Placement(transformation(origin = {-350, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.MathBoolean.And andResetKIpKPp(nu = 2) annotation(
    Placement(transformation(origin = {-130, -120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constant1(k = -0.001) annotation(
    Placement(transformation(origin = {90, 160}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constDTauMax(k = DTauMaxPu) annotation(
    Placement(transformation(origin = {-190, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constDTauUvrtMax(k = DTauUvrtMaxPu) annotation(
    Placement(transformation(origin = {-310, -150}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constInf(k = 99) annotation(
    Placement(transformation(origin = {-310, -110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constInfNeg(k = -99) annotation(
    Placement(transformation(origin = {-270, -210}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant constMPUvrt(k = MPUvrt) annotation(
    Placement(transformation(origin = {-210, -140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(transformation(origin = {-390, -240}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constTauEMin(k = TauEMinPu - 0.001) annotation(
    Placement(transformation(origin = {130, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constTauEMin1(k = TauEMinPu - 0.001) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constTauEMin11(k = TauEMinPu - 0.001) annotation(
    Placement(transformation(origin = {-30, -140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constUDvsPu(k = UDvsPu) annotation(
    Placement(transformation(origin = {-350, 1.77636e-15}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constUpDipPu(k = UpDipPu) annotation(
    Placement(transformation(origin = {-350, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constZero(k = 0) annotation(
    Placement(transformation(origin = {-190, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant constZero1(k = 0) annotation(
    Placement(transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.DelayFlag delayFlag(FI0 = false, FO0 = 0, tD = tDvs, tS = tS) annotation(
    Placement(transformation(origin = {-350, -60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze freeze(T = tS, UseFreeze = true, UseRateLim = false, Y0 = PiIntegrator0Pu) annotation(
    Placement(transformation(origin = {-90, -240}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Gain gainKPp(k = KPp) annotation(
    Placement(transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gainTauUscale(k = TauUscalePu) annotation(
    Placement(transformation(origin = {-350, -180}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(transformation(origin = {-54, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation(
    Placement(transformation(origin = {-310, -60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.IntegratorVariableLimitsContinuousSetFreeze integratorDTauMax(LimitMax0 = TauEMax0Pu, LimitMin0 = TauEMinPu, UseFreeze = false, UseReset = true, UseSet = true, Y0 = TauEMax0Pu) annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.IntegratorVariableLimitsContinuousSetFreeze integratorKIpKPp(K = if KPp > 1e-6 then KIp/KPp else 1/Modelica.Constants.eps, LimitMax0 = TauEMax0Pu, LimitMin0 = TauEMinPu, UseFreeze = true, UseReset = true, UseSet = true, Y0 = PiIntegrator0Pu) annotation(
    Placement(transformation(origin = {4, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less lessUDvs annotation(
    Placement(transformation(origin = {-310, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Less lessUPdip annotation(
    Placement(transformation(origin = {-310, 80}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimLimDetection limitTauOut annotation(
    Placement(transformation(origin = {170, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Min minDTauMaxTauOut annotation(
    Placement(transformation(origin = {50, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.MinMax minResetvalue(nu = 3) annotation(
    Placement(transformation(origin = {-270, -180}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.MathBoolean.Or orKIpKPp(nu = 2) annotation(
    Placement(transformation(origin = {-70, 1.77636e-15}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.MathBoolean.Or orLimDetect(nu = 2) annotation(
    Placement(transformation(origin = {190, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.MathBoolean.Or OrReset(nu = 2) annotation(
    Placement(transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze ratelimResetvalue(T = tS, UseRateLim = true, Y0 = ratelimResetvalue0) annotation(
    Placement(transformation(origin = {-230, -180}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(transformation(origin = {-270, -140}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.Switch switchKIpKPp annotation(
    Placement(transformation(origin = {-30, -60}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.Switch switchOmegaErr annotation(
    Placement(transformation(origin = {-148, 140}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterZero(threshold = 0.1) annotation(
    Placement(transformation(origin = {-270, -60}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePower PWTRef0Pu "Initial upper power limit of the wind turbine (if less than PAvail then the turbine will be derated) in pu (base SNom), example value = 1.1" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));

  // Initialization helpers
  parameter Types.PerUnit OmegaRef0Pu "Initial value for omegaRef (output of omega(p) characteristic) in pu (base SystemBase.omegaRef0Pu)" annotation(
    Dialog(tab = "Initialization"));
  final parameter Types.PerUnit PiIntegrator0Pu = if Torque0Pu > TauEMax0Pu then TauEMax0Pu elseif Torque0Pu < TauEMinPu then TauEMinPu else Torque0Pu "Initial value of the integral part of the PI controller in pu (base SNom/OmegaNom)";
  final parameter Types.PerUnit TauEMax0Pu = PWTRef0Pu/(if MOmegaTMax then OmegaRef0Pu else SystemBase.omega0Pu) "Initial value of maximum torque signal tauEMaxPu in pu (base SNom/OmegaNom)" annotation(
    Dialog(tab = "Initialization"));
  final parameter Types.PerUnit Torque0Type3bPu = ((IGsRe0Pu + UGsIm0Pu/XEqv)*cos(UPhase0) + (IGsIm0Pu - UGsRe0Pu/XEqv)*sin(UPhase0))*U0Pu/SystemBase.omega0Pu;
  final parameter Types.PerUnit Torque0Type3aPu = -P0Pu*SystemBase.SnRef/SNom/SystemBase.omega0Pu "Initialization value of torque PI controller output in pu (base SNom/OmegaNom)";
  final parameter Types.PerUnit Torque0Pu = if WT3Type then Torque0Type3aPu else Torque0Type3bPu;
  final parameter Types.PerUnit ratelimResetvalue0 = if U0Pu*TauUscalePu < PiIntegrator0Pu and U0Pu*TauUscalePu < 1 then U0Pu*TauUscalePu elseif U0Pu*TauUscalePu > PiIntegrator0Pu and PiIntegrator0Pu < 1 then PiIntegrator0Pu else 1;

equation
  connect(gainKPp.y, addTauOut.u1) annotation(
    Line(points = {{61, 140}, {80.5, 140}, {80.5, 126}, {98, 126}}, color = {0, 0, 127}));
  connect(minDTauMaxTauOut.y, addTauOut.u2) annotation(
    Line(points = {{61, 74}, {80, 74}, {80, 114}, {98, 114}}, color = {0, 0, 127}));
  connect(addTauOut.y, limitTauOut.u) annotation(
    Line(points = {{121, 120}, {134.5, 120}, {134.5, 140}, {158, 140}}, color = {0, 0, 127}));
  connect(limitTauOut.y, tauOutPu) annotation(
    Line(points = {{181, 140}, {220, 140}}, color = {0, 0, 127}));
  connect(limitTauOut.fMax, orLimDetect.u[1]) annotation(
    Line(points = {{181, 146}, {181, 145}, {190, 145}, {190, 100}}, color = {255, 0, 255}));
  connect(limitTauOut.fMin, orLimDetect.u[2]) annotation(
    Line(points = {{181, 134}, {181, 133}, {190, 133}, {190, 100}}, color = {255, 0, 255}));
  connect(constInfNeg.y, ratelimResetvalue.dyMin) annotation(
    Line(points = {{-259, -210}, {-259, -209}, {-246, -209}, {-246, -186.5}, {-242, -186.5}, {-242, -186}}, color = {0, 0, 127}));
  connect(constMPUvrt.y, andResetKIpKPp.u[1]) annotation(
    Line(points = {{-199, -140}, {-160.9, -140}, {-160.9, -120}, {-140, -120}}, color = {255, 0, 255}));
  connect(OrReset.y, andResetKIpKPp.u[2]) annotation(
    Line(points = {{-218.5, -20}, {-199.95, -20}, {-199.95, -120}, {-140, -120}}, color = {255, 0, 255}));
  connect(lessUPdip.y, OrReset.u[1]) annotation(
    Line(points = {{-299, 80}, {-281, 80}, {-281, -20}, {-240, -20}}, color = {255, 0, 255}));
  connect(lessUPdip.y, orKIpKPp.u[1]) annotation(
    Line(points = {{-299, 80}, {-281, 80}, {-281, 0}, {-80, 0}}, color = {255, 0, 255}));
  connect(constZero.y, switchOmegaErr.u1) annotation(
    Line(points = {{-179, 120}, {-170.5, 120}, {-170.5, 132}, {-160, 132}}, color = {0, 0, 127}));
  connect(omegaErrPu, switchOmegaErr.u3) annotation(
    Line(points = {{-410, 140}, {-280, 140}, {-280, 148}, {-160, 148}}, color = {0, 0, 127}));
  connect(switchOmegaErr.y, gainKPp.u) annotation(
    Line(points = {{-137, 140}, {38, 140}}, color = {0, 0, 127}));
  connect(OrReset.y, switchOmegaErr.u2) annotation(
    Line(points = {{-218.5, -20}, {-208.95, -20}, {-208.95, 140}, {-160, 140}}, color = {255, 0, 255}));
  connect(orKIpKPp.y, switchKIpKPp.u2) annotation(
    Line(points = {{-58.5, 0}, {-50.475, 0}, {-50.475, -60}, {-42, -60}}, color = {255, 0, 255}));
  connect(addKIpKPp.y, switchKIpKPp.u3) annotation(
    Line(points = {{-65, -52}, {-42, -52}}, color = {0, 0, 127}));
  connect(constTauEMin.y, limitTauOut.yMin) annotation(
    Line(points = {{141, 80}, {149.5, 80}, {149.5, 132}, {158, 132}}, color = {0, 0, 127}));
  connect(minResetvalue.yMin, ratelimResetvalue.u) annotation(
    Line(points = {{-259, -186}, {-249.5, -186}, {-249.5, -180}, {-242, -180}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(constUpDipPu.y, lessUPdip.u2) annotation(
    Line(points = {{-339, 60}, {-332.5, 60}, {-332.5, 72}, {-322, 72}}, color = {0, 0, 127}));
  connect(constUDvsPu.y, lessUDvs.u2) annotation(
    Line(points = {{-339, 0}, {-332.5, 0}, {-332.5, 12}, {-322, 12}}, color = {0, 0, 127}));
  connect(uWtcPu, lessUPdip.u1) annotation(
    Line(points = {{-410, -180}, {-380, -180}, {-380, 80}, {-322, 80}}, color = {0, 0, 127}));
  connect(uWtcPu, lessUDvs.u1) annotation(
    Line(points = {{-410, -180}, {-380, -180}, {-380, 20}, {-322, 20}}, color = {0, 0, 127}));
  connect(lessUDvs.y, delayFlag.fI) annotation(
    Line(points = {{-299, 20}, {-293, 20}, {-293, -20}, {-373, -20}, {-373, -60}, {-362, -60}}, color = {255, 0, 255}));
  connect(delayFlag.fO, integerToReal.u) annotation(
    Line(points = {{-339, -60}, {-322, -60}}, color = {255, 127, 0}));
  connect(OrReset.y, switch.u2) annotation(
    Line(points = {{-218.5, -20}, {-208.95, -20}, {-208.95, -81}, {-292.95, -81}, {-292.95, -140}, {-282, -140}}, color = {255, 0, 255}));
  connect(constInf.y, switch.u3) annotation(
    Line(points = {{-299, -110}, {-285.5, -110}, {-285.5, -132}, {-282, -132}}, color = {0, 0, 127}));
  connect(constDTauUvrtMax.y, switch.u1) annotation(
    Line(points = {{-299, -150}, {-290.5, -150}, {-290.5, -148}, {-282, -148}}, color = {0, 0, 127}));
  connect(switch.y, ratelimResetvalue.dyMax) annotation(
    Line(points = {{-259, -140}, {-247, -140}, {-247, -173}, {-242, -173}}, color = {0, 0, 127}));
  connect(uWtcPu, gainTauUscale.u) annotation(
    Line(points = {{-410, -180}, {-362, -180}}, color = {0, 0, 127}));
  connect(constOne.y, addUTcHook.u2) annotation(
    Line(points = {{-379, -240}, {-371.8, -240}, {-371.8, -226}, {-362, -226}}, color = {0, 0, 127}));
  connect(uTcHookPu, addUTcHook.u1) annotation(
    Line(points = {{-410, -200}, {-380, -200}, {-380, -214}, {-362, -214}}, color = {0, 0, 127}));
  connect(addKIpKPp.u1, limitTauOut.y) annotation(
    Line(points = {{-88, -46}, {-102, -46}, {-102, -112}, {200, -112}, {200, 140}, {181, 140}}, color = {0, 0, 127}));
  connect(constDTauMax.y, integratorDTauMax.u) annotation(
    Line(points = {{-179, 80}, {-122, 80}}, color = {0, 0, 127}));
  connect(orLimDetect.y, integratorKIpKPp.freeze) annotation(
    Line(points = {{190, 78.5}, {190, -90}, {-2, -90}, {-2, -72}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(switchKIpKPp.y, integratorKIpKPp.u) annotation(
    Line(points = {{-19, -60}, {-8, -60}}, color = {0, 0, 127}));
  connect(greaterEqual.y, orKIpKPp.u[2]) annotation(
    Line(points = {{-43, 42}, {-50, 42}, {-50, 24}, {-94, 24}, {-94, 0}, {-80, 0}}, color = {255, 0, 255}));
  connect(andResetKIpKPp.y, freeze.freeze) annotation(
    Line(points = {{-118.5, -120}, {-114.5, -120}, {-114.5, -256}, {-83.25, -256}, {-83.25, -252}, {-84, -252}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(tauEMaxPu, integratorDTauMax.limitMax) annotation(
    Line(points = {{-410, 180}, {-134, 180}, {-134, 88}, {-122, 88}}, color = {0, 0, 127}));
  connect(integratorDTauMax.y, minDTauMaxTauOut.u1) annotation(
    Line(points = {{-99, 80}, {38, 80}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.y, minDTauMaxTauOut.u2) annotation(
    Line(points = {{15, -60}, {16, -60}, {16, 68}, {38, 68}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.y, addKIpKPp.u2) annotation(
    Line(points = {{15, -60}, {20, -60}, {20, -102}, {-94, -102}, {-94, -58}, {-88, -58}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.y, freeze.u) annotation(
    Line(points = {{15, -60}, {20, -60}, {20, -240}, {-78, -240}}, color = {0, 0, 127}));
  connect(gainTauUscale.y, minResetvalue.u[1]) annotation(
    Line(points = {{-339, -180}, {-280, -180}}, color = {0, 0, 127}));
  connect(addUTcHook.y, minResetvalue.u[2]) annotation(
    Line(points = {{-339, -220}, {-320, -220}, {-320, -180}, {-280, -180}}, color = {0, 0, 127}));
  connect(freeze.y, minResetvalue.u[3]) annotation(
    Line(points = {{-101, -240}, {-300, -240}, {-300, -180}, {-280, -180}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.limitMax, tauEMaxPu) annotation(
    Line(points = {{-8, -52}, {-14, -52}, {-14, 180}, {-410, 180}}, color = {0, 0, 127}));
  connect(greaterEqual.u1, integratorKIpKPp.y) annotation(
    Line(points = {{-66, 42}, {-88, 42}, {-88, 72}, {20, 72}, {20, -60}, {15, -60}}, color = {0, 0, 127}));
  connect(andResetKIpKPp.y, integratorKIpKPp.reset) annotation(
    Line(points = {{-118.5, -120}, {-114.5, -120}, {-114.5, -98}, {8.75, -98}, {8.75, -72}, {10, -72}}, color = {255, 0, 255}));
  connect(ratelimResetvalue.y, integratorKIpKPp.set) annotation(
    Line(points = {{-219, -180}, {13, -180}, {13, -34}, {12, -34}, {12, -48}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(integratorDTauMax.y, greaterEqual.u2) annotation(
    Line(points = {{-99, 80}, {-96, 80}, {-96, 34}, {-66, 34}}, color = {0, 0, 127}));
  connect(add.u1, tauEMaxPu) annotation(
    Line(points = {{118, 186}, {-133, 186}, {-133, 180}, {-410, 180}}, color = {0, 0, 127}));
  connect(add.y, limitTauOut.yMax) annotation(
    Line(points = {{141, 180}, {148, 180}, {148, 148}, {158, 148}}, color = {0, 0, 127}));
  connect(constant1.y, add.u2) annotation(
    Line(points = {{101, 160}, {108.5, 160}, {108.5, 174}, {118, 174}}, color = {0, 0, 127}));
  connect(integerToReal.y, greaterZero.u) annotation(
    Line(points = {{-299, -60}, {-282, -60}}, color = {0, 0, 127}));
  connect(greaterZero.y, OrReset.u[2]) annotation(
    Line(points = {{-259, -60}, {-249.5, -60}, {-249.5, -20}, {-240, -20}, {-240, -20}}, color = {255, 0, 255}));
  connect(OrReset.y, integratorDTauMax.reset) annotation(
    Line(points = {{-218.5, -20}, {-104, -20}, {-104, 68}}, color = {255, 0, 255}));
  connect(ratelimResetvalue.y, integratorDTauMax.set) annotation(
    Line(points = {{-218, -180}, {-108, -180}, {-108, 92}, {-102, 92}, {-102, 92}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(constTauEMin1.y, integratorDTauMax.limitMin) annotation(
    Line(points = {{-139, 40}, {-132, 40}, {-132, 72}, {-122, 72}}, color = {0, 0, 127}));
  connect(constTauEMin11.y, integratorKIpKPp.limitMin) annotation(
    Line(points = {{-18, -140}, {-16, -140}, {-16, -68}, {-8, -68}}, color = {0, 0, 127}));
  connect(constZero1.y, switchKIpKPp.u1) annotation(
    Line(points = {{-58, -80}, {-50, -80}, {-50, -68}, {-42, -68}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -250}, {210, 200}})),
    Icon(coordinateSystem(extent = {{-400, -250}, {210, 200}}), graphics = {Rectangle(origin = {-95, -26}, extent = {{-304, 225}, {304, -225}}), Text(origin = {-76, -14}, extent = {{-146, 46}, {146, -46}}, textString = "torque PI")}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end TorquePi;
