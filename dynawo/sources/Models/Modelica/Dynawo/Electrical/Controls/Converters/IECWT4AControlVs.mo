within Dynawo.Electrical.Controls.Converters;

model IECWT4AControlVs "IEC Wind Turbine type 4A Control"
  /*
  * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Rfilter "Converter filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  /* PLL parameters */
  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen" annotation(
    Dialog(group = "group", tab = "PLL"));
  /*CurrentControl*/
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  /*Ramps*/
  parameter Types.PerUnit DipMax "Maximun active current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DiqMax "Maximun reactive current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DiqMin "Minimum reactive current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  /*P control parameters*/
  parameter Types.Time TpOrdp4A "Time constant in power order lag in seconds" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit DpMaxp4A "Maximum WT power ramp rate" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.Time TpWTRef4A "Time constant in reference power order lag in seconds" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit DpRefMax4A "Maximum WT reference power ramp rate in p.u/s (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit DpRefMin4A "Minimum WT reference power ramp rate in p.u/s (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (0: no scaling, 1: u scaling)" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit UpDip "Voltage dip threshold for P control in pu (base UNom). Part of WT control, often different from converter thersholds" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  /*Q control parameters */
  parameter Types.Time Ts "Integration time step";
  parameter Types.PerUnit RWTDrop "Resistive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit XWTDrop "Reactive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UMax "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UMin "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UqRise "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UqDip "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UdbOne "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit UdbTwo "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqMax "Maximum reactive current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqMin "Minimum reactive current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqH1 "Maximum reactive current injection during voltage dip in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IqPost "Post fault reactive current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IdfHook "User defined fault current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit IpfHook "User defined post fault current injection in pu (base SNom, UNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.Time Td "Delay flag time constant, specifies the duration F0 will keep the value 2" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.Time Tuss "Time constant of steady state volatage filter" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.Time TqOrd "Time constant in reactive power order lag" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiu "Voltage PI controller integration gain in p.u/s (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpq "Active power PI controller proportional gain  in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integration gain in p.u/s (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit TanPhi "Constant Tangent Phi" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer Mqfrt "FRT Q control modes (0-3): Normal operation controller (0), Fault current injection (1)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer MqG "General Q control mode (0-4): Voltage control (0), Reactive power control (1), Power factor control (3)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  /*Current Limiter Parameters*/
  parameter Types.PerUnit IMax "Maximum continuous current at the WT terminals in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit IMaxDip "Maximun current during voltage dip at the WT terlinals in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Boolean Mdfslim "Limitation of type 3 stator current (O: total current limitation, 1: stator current limitation)" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Boolean Mqpri "Priorisation of reactive current during FRT (0: active power priority, 1: reactive power priority" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit IMaxHookPu annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit IqMaxHook annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit UpquMax "WT voltage in the operation point where zero reactive power can be delivered" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limits vs. voltage" annotation(
    Dialog(group = "group", tab = "CurrentLimit"));
  /*Q limitation Parameters*/
  parameter Boolean QlConst "Fixed reactive power limits (1), 0 otherwise" annotation(
    Dialog(group = "group", tab = "Qlimit"));
  parameter Types.PerUnit QMax "Fixed value of the maximum reactive power (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qlimit"));
  parameter Types.PerUnit QMin "Fixed value of the minimum reactive power (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qlimit"));
  /*Grid Measurement Parameters*/
  parameter Types.Time Tpfilt "Time constant in active power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tqfilt "Time constant in reactive power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  //parameter Types.Time Tifilt "Time constant in current measurement filter" annotation(Dialog(group = "group", tab = "GridMeasurement"));
  //parameter Types.PerUnit dphimax "Maximum rate of change of frequency" annotation(Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tufilt "Time constant in voltage measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tffilt "Time constant in frequency measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in rad" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMax0Pu "Start value of the maximum reactive current in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMin0Pu "Start value of the minimum reactive current in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Start value maximum reactive power (Sbase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Start value minimum reactive power (Sbase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsRe0Pu "Starting value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsIm0Pu "Real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit IGsRe0Pu "Initial value of the real component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Initial value of the imaginary component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsp0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UpCdm0Pu "Start value of the d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UqCmd0Pu "Start value q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsp0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsq0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IpConv0Pu "Start value of the d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-220, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-30, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals n pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-219.5, 40.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-79, -160}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-219.5, 0.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-130, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-219.5, -33.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-179, -160}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference at the wind turbine terminals in pu (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-220, 128}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {211, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference at the wind turbine terminals in pu (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-219, -110}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {211, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-219, -69}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {210, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipConvPu(start = IpConv0Pu) "q-axis current reference in the converter" annotation(
    Placement(visible = true, transformation(origin = {186, 170}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {80, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter" annotation(
    Placement(visible = true, transformation(origin = {154, 170}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {30, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uGspPu(start = UGsp0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {89, 170}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {180, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uGsqPu(start = UGsq0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {120, 170}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {130, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {220, -126.5}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {220, -84.5}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-210, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  /*Blocks*/
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AMeasures iECWT4AMeasures(P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, Tffilt = Tffilt, Tpfilt = Tpfilt, Tqfilt = Tqfilt, Tufilt = Tufilt, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-148.5, 11.5}, extent = {{-30.5, -30.5}, {30.5, 30.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4APControl iECWT4APControl(DpMaxp4A = DpMaxp4A, DpRefMax4A = DpRefMax4A, DpRefMin4A = DpRefMin4A, IpMax0Pu = IpMax0Pu, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, TpOrdp4A = TpOrdp4A, TpWTRef4A = TpWTRef4A, U0Pu = U0Pu, UpDip = UpDip) annotation(
    Placement(visible = true, transformation(origin = {31.5, 108.5}, extent = {{-25.5, -25.5}, {25.5, 25.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4ACurrentLimitation iECWT4ACurrentLimitation(IMax = IMax, IMaxDip = IMaxDip, IMaxHookPu = IMaxHookPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMaxHook = IqMaxHook, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, Mdfslim = false, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMax = UpquMax) annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AQControl iECWT4AQControl(IdfHook = IdfHook, IpfHook = IpfHook, IqH1 = IqH1, IqMax = IqMax, IqMin = IqMin, IqPost = IqPost, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RWTDrop = RWTDrop, SNom = SNom, Td = Td, TqOrd = TqOrd, Ts = Ts, Tuss = Tuss, U0Pu = U0Pu, UMax = UMax, UMin = UMin, UdbOne = UdbOne, UdbTwo = UdbTwo, UqDip = UqDip, UqRise = UqRise, XWTDrop = XWTDrop) annotation(
    Placement(visible = true, transformation(origin = {-7.5, -93.5}, extent = {{-26.5, -26.5}, {26.5, 26.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AQLimitation iECWT4AQLimitation(P0Pu = P0Pu, QMax = QMax, QMax0Pu = QMax0Pu, QMin = QMin, QMin0Pu = QMin0Pu, QlConst = QlConst, SNom = SNom, Ts = Ts, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-86, -122}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput upCmdPu(start = UpCdm0Pu) annotation(
    Placement(visible = true, transformation(origin = {220, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4ACurrentControl iECWT4ACurrentControl(Cfilter = Cfilter, IpConv0Pu = IpConv0Pu, IqConv0Pu = IqConv0Pu, Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, P0Pu = P0Pu, Q0Pu = Q0Pu, Rfilter = Rfilter, SNom = SNom, U0Pu = U0Pu, UGsp0Pu = UGsp0Pu, UGsq0Pu = UGsq0Pu, UPhase0 = UPhase0, UpCmd0Pu = UpCdm0Pu, UqCmd0Pu = UqCmd0Pu) annotation(
    Placement(visible = true, transformation(origin = {156.5, 0.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {55, 50}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {135, -35}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimit(DuMax = DipMax, DuMin = -999, GainAW = 100, T = 0.001, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 63}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRampLimit firstOrderRampLimit1(DuMax = DiqMax, DuMin = DiqMin, GainAW = 100, T = 0.001, y_start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) annotation(
    Placement(visible = true, transformation(origin = {80, -113}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqCmdPu(start = UqCmd0Pu) annotation(
    Placement(visible = true, transformation(origin = {220, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-210, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  BaseControls.PLL pll(KiPll = KiPll, KpPll = KpPll, U0Pu = U0Pu, UGsq0Pu = UGsq0Pu, UPhase0 = UPhase0, Upll2 = Upll2) annotation(
    Placement(visible = true, transformation(origin = {140, -73}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4ACurrentLimitation.uWTCfiltPu) annotation(
    Line(points = {{-115, 21}, {0, 21}, {0, 11}, {44, 11}}, color = {0, 0, 127}));
  connect(PRefPu, iECWT4APControl.pWTRefPu) annotation(
    Line(points = {{-220, 128}, {3, 128}}, color = {0, 0, 127}));
  connect(QRefPu, iECWT4AQControl.xWTRefPu) annotation(
    Line(points = {{-219, -110}, {-150, -110}, {-150, -98}, {-37, -98}}, color = {0, 0, 127}));
  connect(iWtRePu, iECWT4AMeasures.iWtRePu) annotation(
    Line(points = {{-220, 80}, {-182, 80}, {-182, 35}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.qWTCfiltPu, iECWT4AQControl.qWTCfiltPu) annotation(
    Line(points = {{-115, -16}, {-75, -16}, {-75, -89}, {-37, -89}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.Ffrt, iECWT4ACurrentLimitation.Ffrt) annotation(
    Line(points = {{22, -87}, {30, -87}, {30, -11}, {44, -11}}, color = {255, 127, 0}));
  connect(iECWT4AQControl.Ffrt, iECWT4AQLimitation.Ffrt) annotation(
    Line(points = {{22, -87}, {30, -87}, {30, -147}, {-108, -147}, {-108, -134}}, color = {255, 127, 0}));
  connect(iECWT4AMeasures.uWTCPu, iECWT4APControl.uWTCPu) annotation(
    Line(points = {{-115, 39}, {-30, 39}, {-30, 115}, {3, 115}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWT4AQLimitation.pWTCfiltPu) annotation(
    Line(points = {{-115, -7}, {-50, -7}, {-50, -80}, {-130, -80}, {-130, -122}, {-108, -122}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4APControl.uWTCfiltPu) annotation(
    Line(points = {{-115, 21}, {-10, 21}, {-10, 102}, {3, 102}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.omegaRefFiltPu, iECWT4ACurrentLimitation.OmegaPu) annotation(
    Line(points = {{-115, 11.5}, {-10, 11.5}, {-10, 0}, {44, 0}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.ipMaxPu, iECWT4APControl.ipMaxPu) annotation(
    Line(points = {{100, 17}, {121, 17}, {121, 40}, {0, 40}, {0, 89}, {3, 89}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4AQControl.uWTCfiltPu) annotation(
    Line(points = {{-115, 21}, {-60, 21}, {-60, -72}, {-37, -72}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWT4AQControl.pWTCfiltPu) annotation(
    Line(points = {{-115, -7}, {-50, -7}, {-50, -80}, {-37, -80}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.iqCmdPu, iECWT4ACurrentLimitation.iqCmdPu) annotation(
    Line(points = {{22, -113}, {40, -113}, {40, -22}, {44, -22}}, color = {0, 0, 127}));
  connect(iECWT4APControl.ipCmdPu, iECWT4ACurrentLimitation.ipCmdPu) annotation(
    Line(points = {{60, 108.5}, {70, 108.5}, {70, 63}, {20, 63}, {20, 22}, {44, 22}}, color = {0, 0, 127}));
  connect(iECWT4APControl.ipCmdPu, firstOrderRampLimit.u) annotation(
    Line(points = {{60, 108.5}, {70, 108.5}, {70, 63}, {79, 63}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.ipMaxPu, firstOrderRampLimit.uMax) annotation(
    Line(points = {{100, 17}, {121, 17}, {121, 40}, {0, 40}, {0, 70}, {79, 70}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.iqCmdPu, firstOrderRampLimit1.u) annotation(
    Line(points = {{22, -113}, {69, -113}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.iqMaxPu, firstOrderRampLimit1.uMax) annotation(
    Line(points = {{100, 0}, {120, 0}, {120, -35}, {60, -35}, {60, -106}, {69, -106}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.iqMinPu, firstOrderRampLimit1.uMin) annotation(
    Line(points = {{100, -17}, {100, -30}, {50, -30}, {50, -120}, {69, -120}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4AQLimitation.uWTCfiltPu) annotation(
    Line(points = {{-115, 21}, {-60, 21}, {-60, -72}, {-120, -72}, {-120, -110}, {-108, -110}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentControl.upCmdPu, upCmdPu) annotation(
    Line(points = {{178, 8}, {190, 8}, {190, 30}, {220, 30}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentControl.uqCmdPu, uqCmdPu) annotation(
    Line(points = {{178, -7}, {190, -7}, {190, -30}, {220, -30}}, color = {0, 0, 127}));
  connect(iECWT4AQLimitation.qWTMaxPu, iECWT4AQControl.qWTMaxPu) annotation(
    Line(points = {{-64, -114}, {-55, -114}, {-55, -106}, {-37, -106}, {-37, -107}}, color = {0, 0, 127}));
  connect(iECWT4AQLimitation.qWTMinPu, iECWT4AQControl.qWTMinPu) annotation(
    Line(points = {{-64, -130}, {-46, -130}, {-46, -116}, {-37, -116}, {-37, -115}}, color = {0, 0, 127}));
  connect(const.y, firstOrderRampLimit.uMin) annotation(
    Line(points = {{60.5, 50}, {70, 50}, {70, 56}, {79, 56}}, color = {0, 0, 127}));
  connect(firstOrderRampLimit.y, iECWT4ACurrentControl.ipCmdPu) annotation(
    Line(points = {{101, 63}, {130, 63}, {130, 14}, {135, 14}}, color = {0, 0, 127}));
  connect(gain.y, iECWT4ACurrentControl.iqCmdPu) annotation(
    Line(points = {{135, -29.5}, {135, -13}}, color = {0, 0, 127}));
  connect(iWtImPu, iECWT4AMeasures.iWtImPu) annotation(
    Line(points = {{-219, 41}, {-200, 41}, {-200, 24}, {-182, 24}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCPu, pll.uWTCPu) annotation(
    Line(points = {{-115, 39}, {-30, 39}, {-30, -45}, {77, -45}, {77, -85}, {118, -85}}, color = {0, 0, 127}));
  connect(pll.omegaPu, iECWT4ACurrentControl.omegaPu) annotation(
    Line(points = {{162, -63}, {180, -63}, {180, -25}, {125, -25}, {125, 0}, {135, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-219, -69}, {-183, -69}, {-183, -61}, {118, -61}}, color = {0, 0, 127}));
  connect(pll.theta, theta) annotation(
    Line(points = {{162, -85}, {170, -85}, {170, -126}, {220, -126}}, color = {0, 0, 127}));
  connect(pll.omegaPu, omegaPu) annotation(
    Line(points = {{162, -63}, {180, -63}, {180, -84.5}, {220, -84.5}}, color = {0, 0, 127}));
  connect(ipConvPu, iECWT4ACurrentControl.ipConvPu) annotation(
    Line(points = {{186, 170}, {186, 70}, {171, 70}, {171, 22}}, color = {0, 0, 127}));
  connect(iqConvPu, iECWT4ACurrentControl.iqConvPu) annotation(
    Line(points = {{154, 170}, {154, 120}, {162, 120}, {162, 22}}, color = {0, 0, 127}));
  connect(uGspPu, iECWT4ACurrentControl.uGspPu) annotation(
    Line(points = {{89, 170}, {89, 81}, {142, 81}, {142, 22}}, color = {0, 0, 127}));
  connect(uGsqPu, pll.uqFilterPu) annotation(
    Line(points = {{120, 170}, {120, 95}, {110, 95}, {110, -73}, {118, -73}}, color = {0, 0, 127}));
  connect(uGsqPu, iECWT4ACurrentControl.uGsqPu) annotation(
    Line(points = {{120, 170}, {120, 170}, {120, 95}, {151, 95}, {151, 22}, {151, 22}}, color = {0, 0, 127}));
  connect(uWtRePu, iECWT4AMeasures.uWtRePu) annotation(
    Line(points = {{-219, 1}, {-200, 1}, {-200, 12}, {-182, 12}, {-182, 12}}, color = {0, 0, 127}));
  connect(uWtImPu, iECWT4AMeasures.uWtImPu) annotation(
    Line(points = {{-219, -33}, {-190, -33}, {-190, -1}, {-182, -1}, {-182, -1}}, color = {0, 0, 127}));
  connect(omegaRefPu, iECWT4AMeasures.omegaRefPu) annotation(
    Line(points = {{-219, -69}, {-183, -69}, {-183, -13}, {-182, -13}}, color = {0, 0, 127}));
  connect(firstOrderRampLimit1.y, gain.u) annotation(
    Line(points = {{91, -113}, {100, -113}, {100, -46}, {135, -46}, {135, -41}, {135, -41}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-200, -150}, {200, 150}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, extent = {{-200, -150}, {200, 150}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-200, 150}, {200, -150}}), Text(origin = {-52, 27}, extent = {{-105, -50}, {210, 100}}, textString = "IEC WT4A"), Text(origin = {36, -26}, extent = {{-215, -105}, {148, 49}}, textString = "VSControl")}),
    Dialog(group = "group", tab = "Operating point"));
end IECWT4AControlVs;
