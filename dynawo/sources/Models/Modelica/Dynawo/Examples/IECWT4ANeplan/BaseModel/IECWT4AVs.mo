within Dynawo.Examples.IECWT4ANeplan.BaseModel;

model IECWT4AVs "Wind Turbine Type 4A model from IEC 61400-27-1 standard: assembling the electrical part that includes the electrical and generator module, with the control, that includes the plant and generator control sub-structure, the measurement and grid protection modules"
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
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Res "Electrical system serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xes "Electrical system serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Rfilter "Converter filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit PstepHPu "Height of the active power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit QstepHPu "Height of the reactive power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit OmegastepHPu "Height of the reactive power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Pstep "Time of the active power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Qstep "Time of the reactive power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Omegastep "Time of the reactive power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  /*Control parameters generator module*/
  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen" annotation(
    Dialog(group = "group", tab = "PLL"));
  parameter Types.Time Tg "Current generation time constant in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
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
  /*Q limitation Parameters*/
  parameter Boolean QlConst "Fixed reactive power limits (1), 0 otherwise" annotation(
    Dialog(group = "group", tab = "Qlimit"));
  parameter Types.PerUnit QMax "Fixed value of the maximum reactive power (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qlimit"));
  parameter Types.PerUnit QMin "Fixed value of the minimum reactive power (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Qlimit"));
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
  /*CurrentControl*/
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
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
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit UGsRe0Pu "Starting value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit UGsIm0Pu "Real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit IGsRe0Pu "Initial value of the real component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention";
  parameter Types.PerUnit IGsIm0Pu "Initial value of the imaginary component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention";
  parameter Types.PerUnit UGsp0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit IGsp0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IGsq0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IpConv0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UpCmd0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit UqCmd0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";
  /*Blocks*/
  Modelica.Blocks.Sources.Step PrefPu(height = PstepHPu, offset = -P0Pu * SystemBase.SnRef / SNom, startTime = t_Pstep) annotation(
    Placement(visible = true, transformation(origin = {88, 50}, extent = {{-11, -11}, {11, 11}}, rotation = 180)));
  Modelica.Blocks.Sources.Step QrefPu(height = QstepHPu, offset = -Q0Pu * SystemBase.SnRef / SNom, startTime = t_Qstep) annotation(
    Placement(visible = true, transformation(origin = {88, -50}, extent = {{-11, -11}, {11, 11}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.IECWT4AControlVs iECWT4AControlVs(Cfilter = Cfilter, DipMax = DipMax, DiqMax = DiqMax, DiqMin = DiqMin, DpMaxp4A = DpMaxp4A, DpRefMax4A = DpRefMax4A, DpRefMin4A = DpRefMin4A, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IGsp0Pu = IGsp0Pu, IGsq0Pu = IGsq0Pu, IMax = IMax, IMaxDip = IMaxDip, IMaxHookPu = IMaxHookPu, IdfHook = IdfHook, IpConv0Pu = IpConv0Pu, IpMax0Pu = IpMax0Pu, IpfHook = IpfHook, IqConv0Pu = IqConv0Pu, IqH1 = IqH1, IqMax = IqMax, IqMax0Pu = IqMax0Pu, IqMaxHook = IqMaxHook, IqMin = IqMin, IqMin0Pu = IqMin0Pu, IqPost = IqPost, KiPll = KiPll, Kic = Kic, Kiq = Kiq, Kiu = Kiu, KpPll = KpPll, Kpc = Kpc, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, Lfilter = Lfilter, Mdfslim = Mdfslim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax = QMax, QMax0Pu = QMax0Pu, QMin = QMin, QMin0Pu = QMin0Pu, QlConst = QlConst, RWTDrop = RWTDrop, Rfilter = Rfilter, SNom = SNom, TanPhi = TanPhi, Td = Td, Tffilt = Tffilt, TpOrdp4A = TpOrdp4A, TpWTRef4A = TpWTRef4A, Tpfilt = Tpfilt, TqOrd = TqOrd, Tqfilt = Tqfilt, Ts = Ts, Tufilt = Tufilt, Tuss = Tuss, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UGsp0Pu = UGsp0Pu, UGsq0Pu = UGsq0Pu, UMax = UMax, UMin = UMin, UPhase0 = UPhase0, UdbOne = UdbOne, UdbTwo = UdbTwo, UpCdm0Pu = UpCmd0Pu, UpDip = UpDip, Upll2 = Upll2, UpquMax = UpquMax, UqCmd0Pu = UqCmd0Pu, UqDip = UqDip, UqRise = UqRise, XWTDrop = XWTDrop, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Connectors.ACPower aCPower(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-93, 0}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step omegaRef(height = OmegastepHPu, offset = SystemBase.omegaRef0Pu, startTime = t_Omegastep) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-11, -11}, {11, 11}}, rotation = 180)));
  Dynawo.Electrical.Sources.WT4AIECelecVs wT4AIECelecVs(Bes = Bes, Cfilter = Cfilter, DipMax = DipMax, DiqMax = DiqMax, DiqMin = DiqMin, Ges = Ges, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IGsp0Pu = IGsp0Pu, IGsq0Pu = IGsq0Pu, IpConv0Pu = IpConv0Pu, IqConv0Pu = IqConv0Pu, Lfilter = Lfilter, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, Rfilter = Rfilter, SNom = SNom, Tg = Tg, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UGsp0Pu = UGsp0Pu, UGsq0Pu = UGsq0Pu, UPhase0 = UPhase0, UpCdm0Pu = UpCmd0Pu, UqCmd0Pu = UqCmd0Pu, Xes = Xes, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-28, -4.44089e-15}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));

equation
  wT4AIECelecVs.switchOffSignal1.value = false;
  wT4AIECelecVs.switchOffSignal2.value = false;
  wT4AIECelecVs.switchOffSignal3.value = false;
/*Connectors*/
  connect(iECWT4AControlVs.upCmdPu, wT4AIECelecVs.upCmdPu) annotation(
    Line(points = {{10, 10}, {5, 10}, {5, 14}, {-2, 14}}, color = {0, 0, 127}));
  connect(iECWT4AControlVs.uqCmdPu, wT4AIECelecVs.uqCmdPu) annotation(
    Line(points = {{10, -10}, {5, -10}, {5, -14}, {-2, -14}}, color = {0, 0, 127}));
  connect(PrefPu.y, iECWT4AControlVs.PRefPu) annotation(
    Line(points = {{76, 50}, {70, 50}, {70, 10}, {62, 10}}, color = {0, 0, 127}));
  connect(QrefPu.y, iECWT4AControlVs.QRefPu) annotation(
    Line(points = {{76, -50}, {70, -50}, {70, -10}, {62, -10}}, color = {0, 0, 127}));
  connect(omegaRef.y, iECWT4AControlVs.omegaRefPu) annotation(
    Line(points = {{78, 0}, {62, 0}}, color = {0, 0, 127}));
  connect(iECWT4AControlVs.theta, wT4AIECelecVs.theta) annotation(
    Line(points = {{36, 27}, {36, 50}, {-28, 50}, {-28, 26}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.terminal, aCPower) annotation(
    Line(points = {{-54, 0}, {-92, 0}}, color = {0, 0, 255}));
  connect(wT4AIECelecVs.uWtRePu, iECWT4AControlVs.uWtRePu) annotation(
    Line(points = {{-21, -26}, {-21, -40}, {20, -40}, {20, -27}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.uWtImPu, iECWT4AControlVs.uWtImPu) annotation(
    Line(points = {{-11, -26}, {-11, -34}, {14, -34}, {14, -27}}, color = {0, 0, 127}));
  connect(iECWT4AControlVs.omegaPu, wT4AIECelecVs.omegaPu) annotation(
    Line(points = {{10, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.iWtImPu, iECWT4AControlVs.iWtImPu) annotation(
    Line(points = {{-35, -26}, {-35, -46}, {26, -46}, {26, -27}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.iWtRePu, iECWT4AControlVs.iWtRePu) annotation(
    Line(points = {{-45, -26}, {-48, -26}, {-48, -52}, {32, -52}, {32, -27}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.iqConvPu, iECWT4AControlVs.iqConvPu) annotation(
    Line(points = {{-54, -19}, {-54, -58}, {40, -58}, {40, -27}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.ipConvPu, iECWT4AControlVs.ipConvPu) annotation(
    Line(points = {{-54, -10}, {-64, -10}, {-64, -64}, {46, -64}, {46, -27}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.uGsqPu, iECWT4AControlVs.uGsqPu) annotation(
    Line(points = {{-54, 10}, {-72, 10}, {-72, -70}, {52, -70}, {52, -27}}, color = {0, 0, 127}));
  connect(wT4AIECelecVs.uGspPu, iECWT4AControlVs.uGspPu) annotation(
    Line(points = {{-54, 19}, {-80, 19}, {-80, -76}, {58.5, -76}, {58.5, -27}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MWA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 pu step variation on the generator mechanical power Pm occurring at t=1s.
    </div><div><br></div><div>The two following figures show the expected evolution of the generator's voltage and active power during the simulation.
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/PGen.png\">
    </figure>
    <figure>
    <img width=\"450\" src=\"modelica://Dynawo/Examples/SMIB/Resources/Images/UStatorPu.png\">
    </figure>
    We observe that the active power is increased by 44.05 MW. The voltage drop between the infinite bus and the machine terminal is consequently increased, resulting in a decrease of the machine terminal voltage.
    </div><div><br></div><div>Initial equation are provided on the generator's differential variables to ensure a steady state initialisation by the Modelica tool. It had to be written here and not directly in Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous because the Dynawo simulator applies a different initialisation strategy that does not involve the initial equation section.
    </div><div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div></div></body></html>
    "),
    Icon(coordinateSystem(initialScale = 0.1, grid = {1, 1}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-37.5, 33}, extent = {{-49.5, 18}, {128.5, -84}}, textString = "IEC WT VS")}),
  Diagram);
end IECWT4AVs;
