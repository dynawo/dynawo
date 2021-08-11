within Dynawo.Electrical.Controls.Converters;

model IECWT4AControl "IEC Wind Turbine type 4A Control"
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
  /*P control parameters*/
  parameter Types.PerUnit upDip "Voltage dip threshold for P control. Part of WT control, often different from converter thershold" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit Tpordp4A "Time constant in power order lag" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit TpWTref4A "Time constant in reference power order lag" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dprefmax4A "Maximum WT reference power ramp rate" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dprefmin4A "Minimum WT reference power ramp rate" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dpmaxp4A "Maximum WT power ramp rate" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit MpUscale "Voltage scaling for power reference during voltage dip (0: no scaling - 1: u scaling)" annotation(
    Dialog(group = "group", tab = "Pcontrol"));
  /*Q control parameters */
  parameter Types.PerUnit Rdrop "Resistive component of voltage drop impedance" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Xdrop "Inductive component of voltage drop impedance" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uMax "Maximum voltage in voltage PI controller integral term" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uMin "Minimum voltage in voltage PI controller integral term" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uqRise "Voltage threshold for OVRT detection in Q control" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uqDip "Voltage threshold for UVRT detection in Q control" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit udbOne "Voltage change dead band lower limit (typically negative)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit udbTwo "Voltage change dead band upper limit (typically positive)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqMax "Maximum reactive current inyection" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqMin "Minimum reactive current inyection" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqh1 "Maximum reactive current inyection during dip" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqPost "Post fault reactive current injection" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit idfHook annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit ipfHook annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Ts "Delay flag time constant, specifies how much time F0 will keep the value 2" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Td "Delay flag exponential time constant" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Tuss "Time constant of steady volatage filter" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Tqord "Time constant in reactive injection" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiu "voltaqge PI conqtroller integration gain" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpq "Active power PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiq "Reactive power PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit TanPhi "Constant Tangent Phi" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer Mqfrt "Reactive current inyection for each FRT Q contorl modes (0-3)" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer MqG "General Q control mode" annotation(
    Dialog(group = "group", tab = "Qcontrol"));
  /*Current Limiter Parameters*/
  parameter Types.PerUnit upquMax "WT voltage in the operation point where zero reactive power can be delivered" annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Types.PerUnit iMax "Maximum continuous current at the WTT terminals" annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Types.PerUnit iMaxDip "Maximun current during voltage dip at the WT terlinals" annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Types.PerUnit iMaxHookPu annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Types.PerUnit iqMaxHook annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limits vs. voltage" annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Integer Mqpri "Priorisation of reactive current during FRT (0: active power priority - 1: reactive power priority" annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  parameter Types.PerUnit Mdfslim "Limitation of type 3 stator current (O: total current limitation, 1: stator current limitation)" annotation(
    Dialog(group = "group", tab = "Ilimitation"));
  /*Grid Measurement Parameters*/
  parameter Types.PerUnit Tpfilt "Time constant in active power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tqfilt "Time constant in reactive power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  //parameter Types.PerUnit Tifilt "Time constant in current measurement filter" annotation(Dialog(group = "group", tab = "GridMeasurement"));
  //parameter Types.PerUnit dphimax "Maximum rate of change of frequency" annotation(Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tufilt "Time constant in voltage measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tffilt "Time constant in frequency measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  /*Parameters for initialization from load flow*/
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IpMax0Pu "Start value of the maximum active current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMax0Pu "Start value of the maximum reactive current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqMin0Pu "Start value of the minimum reactive current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMax0Pu "Start value maximum reactive power (Sbase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QMin0Pu "Start value minimum reactive power (Sbase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals n p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-160, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine (electrical system) terminals in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine (electrical system) terminals in p.u (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-160, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput PrefPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Active power reference at the wind turbine terminals in p.u (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-161, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 53}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QrefPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Reactive power reference at the wind turbine terminals in p.u (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-160, -113}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -48}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im))) "d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = -Q0Pu * SystemBase.SnRef / (SNom * sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im))) "q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {160, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximal d-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {160, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimal q-axis reference current at the generator system module (converter) terminal in p.u (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {160, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {160, -60}, extent = {{-10,-10}, {10,10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  /*Blocks*/
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {120, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AMeasures iECWT4AMeasures(SNom = SNom, Tffilt = Tffilt, Theta0 = Theta0, Tpfilt = Tpfilt, Tqfilt = Tqfilt, Tufilt = Tufilt, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-95, 0}, extent = {{-30, -50}, {30, 50}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4APControl iECWT4APControl(IpMax0Pu = IpMax0Pu, MpUscale = MpUscale, P0Pu = P0Pu, SNom = SNom, TpWTref4A = TpWTref4A, Tpordp4A = Tpordp4A, dpmaxp4A = dpmaxp4A, dprefmax4A = dprefmax4A, dprefmin4A = dprefmin4A, u0Pu = u0Pu, upDip = upDip) annotation(
    Placement(visible = true, transformation(origin = {100, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4ACurrentLimitation iECWT4ACurrentLimitation(IpMax0Pu = IpMax0Pu,IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, Mdfslim = Mdfslim, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, iMax = iMax, iMaxDip = iMaxDip, iMaxHookPu = iMaxHookPu, iqMaxHook = iqMaxHook, u0Pu = u0Pu, upquMax = upquMax) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AQControl iECWT4AQControl(Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, Rdrop = Rdrop, SNom = SNom, TanPhi = TanPhi, Td = Td, Tqord = Tqord, Ts = Ts, Tuss = Tuss, Xdrop = Xdrop, idfHook = idfHook, ipfHook = ipfHook, iqMax = iqMax, iqMin = iqMin, iqPost = iqPost, iqh1 = iqh1, u0Pu = u0Pu, uMax = uMax, uMin = uMin, udbOne = udbOne, udbTwo = udbTwo, uqDip = uqDip, uqRise = uqRise) annotation(
    Placement(visible = true, transformation(origin = {24, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AQLimitation iECWT4AQLimitation(P0Pu = P0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, SNom = SNom, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, -125}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1) annotation(
    Placement(visible = true, transformation(origin = {25, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-135, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(iWtRePu, iECWT4AMeasures.iWtRePu) annotation(
    Line(points = {{-160, 40}, {-128, 40}}, color = {0, 0, 127}));
  connect(iWtImPu, iECWT4AMeasures.iWtImPu) annotation(
    Line(points = {{-160, 20}, {-128, 20}}, color = {0, 0, 127}));
  connect(uWtRePu, iECWT4AMeasures.uWtRePu) annotation(
    Line(points = {{-160, 0}, {-129, 0}, {-129, 0}, {-128, 0}}, color = {0, 0, 127}));
  connect(uWtImPu, iECWT4AMeasures.uWtImPu) annotation(
    Line(points = {{-160, -20}, {-131, -20}, {-131, -20}, {-128, -20}}, color = {0, 0, 127}));
  connect(iECWT4APControl.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{122, 100}, {156, 100}, {156, 100}, {160, 100}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{122, 0}, {155, 0}, {155, 0}, {160, 0}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.iqMinPu, iqMinPu) annotation(
    Line(points = {{122, -11}, {137, -11}, {137, -30}, {160, -30}, {160, -30}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{122, 11}, {139, 11}, {139, 30}, {160, 30}, {160, 30}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.ipMaxPu, iECWT4APControl.ipMaxPu) annotation(
    Line(points = {{122, 11}, {139, 11}, {139, 30}, {65, 30}, {65, 85}, {78, 85}, {78, 85}}, color = {0, 0, 127}));
  connect(gain1.y, iqCmdPu) annotation(
    Line(points = {{131, -100}, {154, -100}, {154, -100}, {160, -100}}, color = {0, 0, 127}));
  connect(iECWT4APControl.ipCmdPu, iECWT4ACurrentLimitation.ipCmdPu) annotation(
    Line(points = {{122, 100}, {126, 100}, {126, 45}, {72, 45}, {72, 15}, {78, 15}, {78, 15}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCPu, iECWT4APControl.uWTCPu) annotation(
    Line(points = {{-62, 41}, {28, 41}, {28, 105}, {78, 105}, {78, 105}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4APControl.uWTCfiltPu) annotation(
    Line(points = {{-62, 25}, {43, 25}, {43, 95}, {78, 95}, {78, 95}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4ACurrentLimitation.uWTCfiltPu) annotation(
    Line(points = {{-62, 25}, {43, 25}, {43, 8}, {78, 8}, {78, 7}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.ffiltPu, gain.u) annotation(
    Line(points = {{-62, 9}, {-38, 9}, {-38, 0}, {17, 0}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.theta, theta) annotation(
    Line(points = {{-62, -9}, {11, -9}, {11, -60}, {160, -60}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.Ffrt, iECWT4ACurrentLimitation.Ffrt) annotation(
    Line(points = {{46, -95}, {55, -95}, {55, -7}, {78, -7}}, color = {255, 127, 0}));
  connect(iECWT4AQControl.iqCmdPu, iECWT4ACurrentLimitation.iqCmdPu) annotation(
    Line(points = {{46, -115}, {63, -115}, {63, -14}, {78, -14}, {78, -15}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.iqCmdPu, gain1.u) annotation(
    Line(points = {{46, -115}, {63, -115}, {63, -100}, {108, -100}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4AQControl.uWTCfiltPu) annotation(
    Line(points = {{-62, 25}, {-7, 25}, {-7, -84}, {2, -84}, {2, -83.5}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWT4AQControl.pWTCfiltPu) annotation(
    Line(points = {{-62, -25}, {-13, -25}, {-13, -90}, {2, -90}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.qWTCfiltPu, iECWT4AQControl.qWTCfiltPu) annotation(
    Line(points = {{-62, -41}, {-19, -41}, {-19, -96.5}, {2, -96.5}}, color = {0, 0, 127}));
  connect(gain.y, iECWT4ACurrentLimitation.OmegaPu) annotation(
    Line(points = {{36, 0}, {75, 0}, {75, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(iECWT4AQLimitation.qWTMaxPu, iECWT4AQControl.qWTMaxPu) annotation(
    Line(points = {{-28, -117}, {-22, -117}, {-22, -111}, {2, -111}, {2, -110}}, color = {0, 0, 127}));
  connect(iECWT4AQLimitation.qWTMinPu, iECWT4AQControl.qWTMinPu) annotation(
    Line(points = {{-28, -133}, {-18, -133}, {-18, -117}, {2, -117}, {2, -116.5}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4AQLimitation.uWTCfiltPu) annotation(
    Line(points = {{-62, 25}, {-50, 25}, {-50, -56}, {-83, -56}, {-83, -113}, {-72, -113}, {-72, -113}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWT4AQLimitation.pWTCfiltPu) annotation(
    Line(points = {{-62, -25}, {-55, -25}, {-55, -54}, {-91, -54}, {-91, -125}, {-72, -125}, {-72, -125}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.Ffrt, iECWT4AQLimitation.Ffrt) annotation(
    Line(points = {{46, -95}, {55, -95}, {55, -148}, {-87, -148}, {-87, -137}, {-72, -137}}, color = {255, 127, 0}));
  connect(const.y, iECWT4AMeasures.fsysPu) annotation(
    Line(points = {{-124, -86}, {-115, -86}, {-115, -55}, {-140, -55}, {-140, -43}, {-128, -43}, {-128, -40}}, color = {0, 0, 127}));
  connect(PrefPu, iECWT4APControl.pWTRefPu) annotation(
    Line(points = {{-161, 114}, {77, 114}, {77, 115}, {78, 115}}, color = {0, 0, 127}));
  connect(QrefPu, iECWT4AQControl.xWTRefPu) annotation(
    Line(points = {{-160, -113}, {-105, -113}, {-105, -103}, {2, -103}, {2, -103}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-150, -150}, {150, 150}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WT4A"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Control")}));
end IECWT4AControl;
