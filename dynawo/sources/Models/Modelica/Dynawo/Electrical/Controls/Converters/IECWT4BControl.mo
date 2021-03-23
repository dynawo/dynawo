within Dynawo.Electrical.Controls.Converters;

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

model IECWT4BControl "IEC Wind Turbine type 4A Control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*PLL parameters */
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds";
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in pu (base UNom)";
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen in pu (base UNom)";

  /*P control parameters*/
  parameter Types.Time TpOrdp4A "Time constant in power order lag in seconds" annotation(
  Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.Time Tpaero "Time constant in power order lag in seconds" annotation(
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
  parameter Types.PerUnit IMax "Maximum continuous current at the WT terminals in pu (base UNom, SNom) (generator convention)"  annotation(
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

  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-170, 76}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals n pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-169.5, 39.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-169.5, -0.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-169.5, -39.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Active power reference at the wind turbine terminals in pu (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-169, 140}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {110, 53}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom ) "Reactive power reference at the wind turbine terminals in pu (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-169, -119}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {110, -48}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-169, -70}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omegaRef0Pu) "Imaginary component of the current at the generator system module (converter) terminal in pu (Ubase,SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-169, 110}, extent = {{-19, -19}, {19, 19}}, rotation = 0), iconTransformation(origin = {80, -110}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {170, 95}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {170, -113}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximal d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {169.5, 59.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {169.5, 20.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {170, -22}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {170, -60.5}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput paeroPu(start = -P0Pu*SystemBase.SnRef / SNom) "Phase shift of the converter's rotating frame with respect to the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {169.5, 129.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));

  /*Blocks*/
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AMeasures iECWT4AMeasures(P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, Tffilt = Tffilt, Tpfilt = Tpfilt, Tqfilt = Tqfilt, Tufilt = Tufilt, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-99.5, 9.5}, extent = {{-30.5, -30.5}, {30.5, 30.5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4BPControl iECWT4BPControl(DpMaxp4A = DpMaxp4A, DpRefMax4A = DpRefMax4A, DpRefMin4A = DpRefMin4A,IpMax0Pu = IpMax0Pu, MpUScale = MpUScale, P0Pu = P0Pu, SNom = SNom, TpOrdp4A = TpOrdp4A, TpWTRef4A = TpWTRef4A, Tpaero = Tpaero, U0Pu = U0Pu, UpDip = UpDip) annotation(
    Placement(visible = true, transformation(origin = {43.5, 107.5}, extent = {{-25.5, -25.5}, {25.5, 25.5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4ACurrentLimitation iECWT4ACurrentLimitation( IMax = IMax, IMaxDip = IMaxDip, IMaxHookPu = IMaxHookPu,IpMax0Pu = IpMax0Pu,IqMax0Pu = IqMax0Pu, IqMaxHook = IqMaxHook, IqMin0Pu = IqMin0Pu, Kpqu = Kpqu, Mdfslim = false, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, UpquMax = UpquMax) annotation(
    Placement(visible = true, transformation(origin = {89, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AQControl iECWT4AQControl( IdfHook = IdfHook, IpfHook = IpfHook, IqH1 = IqH1, IqMax = IqMax, IqMin = IqMin, IqPost = IqPost,Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, MqG = MqG, Mqfrt = Mqfrt, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, RWTDrop = RWTDrop, SNom = SNom, Td = Td, TqOrd = TqOrd, Ts = Ts, Tuss = Tuss, U0Pu = U0Pu, UMax = UMax, UMin = UMin, UdbOne = UdbOne, UdbTwo = UdbTwo, UqDip = UqDip, UqRise = UqRise, XWTDrop = XWTDrop) annotation(
    Placement(visible = true, transformation(origin = {9.5, -93.5}, extent = {{-26.5, -26.5}, {26.5, 26.5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AQLimitation iECWT4AQLimitation(P0Pu = P0Pu, QMax = QMax, QMax0Pu = QMax0Pu, QMin = QMin, QMin0Pu = QMin0Pu, QlConst = QlConst, SNom = SNom, Ts = Ts, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, -122}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  BaseControls.IECWT4APll iECWT4APll(Tpll = Tpll, U0Pu = U0Pu, UPhase0 = UPhase0, Upll1 = Upll1, Upll2 = Upll2) annotation(
    Placement(visible = true, transformation(origin = {86.125, -52.7}, extent = {{-17.125, -13.7}, {17.125, 13.7}}, rotation = 0)));

equation
  connect(iECWT4ACurrentLimitation.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{117, 0}, {140.5, 0}, {140.5, 20.5}, {169.5, 20.5}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.iqMinPu, iqMinPu) annotation(
    Line(points = {{117, -17}, {130, -17}, {130, -22}, {170, -22}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{117, 17}, {130, 17}, {130, 59.5}, {170, 59.5}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4ACurrentLimitation.uWTCfiltPu) annotation(
    Line(points = {{-66, 19}, {0, 19}, {0, 11}, {61, 11}}, color = {0, 0, 127}));
  connect(PRefPu, iECWT4BPControl.pWTRefPu) annotation(
    Line(points = {{-169, 140}, {-77, 140}, {-77, 127}, {15, 127}}, color = {0, 0, 127}));
  connect(QRefPu, iECWT4AQControl.xWTRefPu) annotation(
    Line(points = {{-169, -119}, {-130, -119}, {-130, -98}, {-20, -98}}, color = {0, 0, 127}));
  connect(iWtRePu, iECWT4AMeasures.iWtRePu) annotation(
    Line(points = {{-170, 76}, {-144, 76}, {-144, 33}, {-133, 33}}, color = {0, 0, 127}));
  connect(uWtRePu, iECWT4AMeasures.uWtRePu) annotation(
    Line(points = {{-169.5, -0.5}, {-150, -0.5}, {-150, 9.5}, {-133, 9.5}}, color = {0, 0, 127}));
  connect(uWtImPu, iECWT4AMeasures.uWtImPu) annotation(
    Line(points = {{-169.5, -39.5}, {-145, -39.5}, {-145, -3}, {-133, -3}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.qWTCfiltPu, iECWT4AQControl.qWTCfiltPu) annotation(
    Line(points = {{-66, -18}, {-60, -18}, {-60, -89}, {-20, -89}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.Ffrt, iECWT4ACurrentLimitation.Ffrt) annotation(
    Line(points = {{39, -87}, {45, -87}, {45, -11}, {61, -11}}, color = {255, 127, 0}));
  connect(iECWT4AQControl.Ffrt, iECWT4AQLimitation.Ffrt) annotation(
    Line(points = {{39, -87}, {45, -87}, {45, -147}, {-90, -147}, {-90, -134}, {-82, -134}}, color = {255, 127, 0}));
  connect(iECWT4AQLimitation.qWTMaxPu, iECWT4AQControl.qWTMaxPu) annotation(
    Line(points = {{-38, -114}, {-30, -114}, {-30, -107}, {-20, -107}}, color = {0, 0, 127}));
  connect(iECWT4AQLimitation.qWTMinPu, iECWT4AQControl.qWTMinPu) annotation(
    Line(points = {{-38, -130}, {-26, -130}, {-26, -115}, {-20, -115}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCPu, iECWT4BPControl.uWTCPu) annotation(
    Line(points = {{-66, 37}, {-30, 37}, {-30, 114}, {15, 114}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWT4AQLimitation.pWTCfiltPu) annotation(
    Line(points = {{-66, -9}, {-40, -9}, {-40, -80}, {-100, -80}, {-100, -122}, {-82, -122}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4BPControl.uWTCfiltPu) annotation(
    Line(points = {{-66, 19}, {0, 19}, {0, 101}, {15, 101}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.omegaRefFiltPu, iECWT4ACurrentLimitation.OmegaPu) annotation(
    Line(points = {{-66, 9.5}, {-10, 9.5}, {-10, 0}, {61, 0}}, color = {0, 0, 127}));
  connect(iECWT4ACurrentLimitation.ipMaxPu, iECWT4BPControl.ipMaxPu) annotation(
    Line(points = {{117, 17}, {130, 17}, {130, 40}, {10, 40}, {10, 88}, {15, 88}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4AQControl.uWTCfiltPu) annotation(
    Line(points = {{-66, 19}, {-50, 19}, {-50, -72}, {-20, -72}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWT4AQControl.pWTCfiltPu) annotation(
    Line(points = {{-66, -9}, {-40, -9}, {-40, -80}, {-20, -80}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.iqCmdPu, iECWT4ACurrentLimitation.iqCmdPu) annotation(
    Line(points = {{39, -113}, {50, -113}, {50, -22}, {61, -22}}, color = {0, 0, 127}));
  connect(iWtImPu, iECWT4AMeasures.iWtImPu) annotation(
    Line(points = {{-169, 40}, {-150, 40}, {-150, 22}, {-133, 22}}, color = {0, 0, 127}));
  connect(iECWT4BPControl.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{72, 95}, {170, 95}}, color = {0, 0, 127}));
  connect(iECWT4BPControl.ipCmdPu, iECWT4ACurrentLimitation.ipCmdPu) annotation(
    Line(points = {{72, 95}, {110, 95}, {110, 60}, {40, 60}, {40, 22}, {61, 22}}, color = {0, 0, 127}));
  connect(omegaRefPu, iECWT4AMeasures.omegaRefPu) annotation(
    Line(points = {{-169, -70}, {-134, -70}, {-134, -15}, {-133, -15}}, color = {0, 0, 127}));
  connect(iECWT4AQControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{39, -113}, {157, -113}, {157, -113}, {170, -113}}, color = {0, 0, 127}));
  connect(iECWT4APll.y, theta) annotation(
    Line(points = {{105, -53}, {125, -53}, {125, -60}, {170, -60}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.theta, iECWT4APll.theta) annotation(
    Line(points = {{-66, 0}, {-20, 0}, {-20, -46}, {67, -46}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCPu, iECWT4APll.uWTCPu) annotation(
    Line(points = {{-66, 37}, {-30, 37}, {-30, -60}, {67, -60}, {67, -60}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWT4AQLimitation.uWTCfiltPu) annotation(
    Line(points = {{-66, 19}, {-50, 19}, {-50, -72}, {-90, -72}, {-90, -110}, {-82, -110}, {-82, -110}}, color = {0, 0, 127}));
  connect(omegaGenPu, iECWT4BPControl.omegaGenPu) annotation(
    Line(points = {{-169, 110}, {-110, 110}, {-110, 70}, {44, 70}, {44, 79}, {43.5, 79}}, color = {0, 0, 127}));
  connect(iECWT4BPControl.paeroPu, paeroPu) annotation(
    Line(points = {{72, 120}, {110, 120}, {110, 129.5}, {169.5, 129.5}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-150, -150}, {150, 150}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WT4B"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Control")}));

end IECWT4BControl;
