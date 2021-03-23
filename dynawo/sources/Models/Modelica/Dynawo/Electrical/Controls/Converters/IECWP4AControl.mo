within Dynawo.Electrical.Controls.Converters;

model IECWP4AControl "IEC Wind Turbine type 4A Control"
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

  /* PLL parameters */
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds";
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in pu (base UNom)";
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen in pu (base UNom)";

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
  parameter Types.Time Tufilt "Time constant in voltage measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tffilt "Time constant in frequency measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time dfMax "Maximum rate of change of frequency" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time dfMin "Mmum rate of change of frequency" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));

   //Grid Protection parameters
  parameter Types.PerUnit uOver "WT over voltage protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));
  parameter Types.PerUnit uUnder "WT under voltage protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));
  parameter Types.PerUnit fOver "WT over frequency protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));
  parameter Types.PerUnit fUnder "WT under frequency protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));

  /*Linear Communication Parameters*/
  parameter Types.PerUnit Tlead "Communication lead time constant" annotation(
    Dialog(group = "group", tab = "LinearCommunication"));
  parameter Types.PerUnit Tlag "Communication lag time constant" annotation(
    Dialog(group = "group", tab = "LinearCommunication"));

  /*WP PControl Parameters*/
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit Kwppref "Active power reference gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpWPRefMax "Maximum posite ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpWPRefMin "Minimum negative ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pRefMax "Maximum PD power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pRefMin "Minimum PD power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pErrMax "Maximum control error for power PI controller" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pErrMin "Minimum control error for power PI controller" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pKIWPpMax "Maximum active power reference from integration" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pKIWPpMin "Minimum active power reference from integration" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pWPHookPu "WP hook active power" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpRefMax "Maximum posite ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpRefMin "Minimum negative ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));

  /*WP QControl*/
  parameter Types.PerUnit RWPDrop "Resistive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit XWPDrop "Reactive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit uWPqdip "Voltage threshold for UVRT detection" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit uWPqrise "Voltage threshold for OVRT detection" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xRefMax "Maximum WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xRefMin "Minimum WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xKIWPxMax "Maximum WT reactive power/voltage reference  from integretion" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xKIWPxMin "Minimum WT reactive power/voltage reference from integretion" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xerrmax "Maximum reactive power error (or voltage error if Mwpmode=2) input to PI controller" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xerrmin "Minimum reactive power error (or voltage error if Mwpmode=2) input to PI controller" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit dxRefMax "Maximum positive ramp rate for WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit dxRefMin "Minimum negative ramp rate for WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Tuqfilt "Time constant for the UQ static mode" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power/voltage PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power/voltage PI controller integral gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kwpqref "Reactive power reference gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Integer Mwpqmode "Reactive power/voltage control mode (0 reactive power reference, 1 power factor reference, 2 UQ static, 3 voltage control)" annotation(
    Dialog(group = "group", tab = "QControlWP"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0  "Start value of voltage angle at plan terminal (PCC) in rad" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit X0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
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
    Placement(visible = true, transformation(origin = {40, -170}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals n pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {0.5, -169.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 90), iconTransformation(origin = {40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-40.5, -169.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 90), iconTransformation(origin = {-40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine (electrical system) terminals in pu (base UNom) " annotation(
    Placement(visible = true, transformation(origin = {-80.5, -169.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 90), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Active power reference at the wind turbine terminals in pu (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {169, 40}, extent = {{-19, 19}, {19, -19}}, rotation = 180), iconTransformation(origin = {110, 53}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xRefPu(start = X0Pu) "Reactive power reference at the wind turbine terminals in pu (SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {169, -40}, extent = {{-19, -19}, {19, 19}}, rotation = 180), iconTransformation(origin = {110, -48}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, -169}, extent = {{-19, -19}, {19, 19}}, rotation = 90), iconTransformation(origin = {110, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-170, -51}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqCmdPu(start = -Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-170, -110}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipMaxPu(start = IpMax0Pu) "Maximal d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-169.5, 90.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 180), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = IqMax0Pu) "Maximal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-169.5, 49.5}, extent = {{-19.5, -19.5}, {19.5, 19.5}}, rotation = 180), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = IqMin0Pu) "Minimal q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {-170, 129.5}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.Converters.IECWT4AControl iECWT4AControl(DpMaxp4A = DpMaxp4A, DpRefMax4A = DpRefMax4A, DpRefMin4A = DpRefMin4A, IMax = IMax, IMaxDip = IMaxDip, IMaxHookPu = IMaxHookPu, IdfHook = IdfHook, IpMax0Pu = IpMax0Pu, IpfHook = IpfHook, IqH1 = IqH1, IqMax = IqMax, IqMax0Pu = IqMax0Pu, IqMaxHook = IqMaxHook, IqMin = IqMin, IqMin0Pu = IqMin0Pu, IqPost = IqPost, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, Mdfslim = Mdfslim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax = QMax, QMax0Pu = QMax0Pu, QMin = QMin, QMin0Pu = QMin0Pu, QlConst = QlConst, RWTDrop = RWTDrop, SNom = SNom, Td = Td, Tffilt = Tffilt, TpOrdp4A = TpOrdp4A, TpWTRef4A = TpWTRef4A, Tpfilt = Tpfilt, Tpll = Tpll, TqOrd = TqOrd, Tqfilt = Tqfilt, Ts = Ts, Tufilt = Tufilt, Tuss = Tuss, U0Pu = U0Pu, UMax = UMax, UMin = UMin, UPhase0 = UPhase0, UdbOne = UdbOne, UdbTwo = UdbTwo, UpDip = UpDip, Upll1 = Upll1, Upll2 = Upll2, UpquMax = UpquMax, UqDip = UqDip, UqRise = UqRise, XWT0Pu = XWT0Pu, XWTDrop = XWTDrop, dfMax = dfMax, dfMin = dfMin, fOver = fOver, fUnder = fUnder, i0Pu = i0Pu, u0Pu = u0Pu, uOver = uOver, uUnder = uUnder) annotation(
    Placement(visible = true, transformation(origin = {-72.5, -0.5}, extent = {{-45.5, -45.5}, {45.5, 45.5}}, rotation = 0)));

  BaseControls.IECWP4AControlModel iECWP4AControlModel(Kiwpp = Kiwpp, Kiwpx = Kiwpx, Kpwpp = Kpwpp, Kpwpx = Kpwpx, Kwppref = Kwppref, Kwpqref = Kwpqref, Kwpqu = Kwpqu, Mwpqmode = Mwpqmode, P0Pu = P0Pu, Q0Pu = Q0Pu, RWPDrop = RWPDrop, SNom = SNom, Tffilt = Tffilt, Tlag = Tlag, Tlead = Tlead, Tpfilt = Tpfilt, Tqfilt = Tqfilt, Tufilt = Tufilt, Tuqfilt = Tuqfilt, U0Pu = U0Pu, UPhase0 = UPhase0, X0Pu = X0Pu, XWPDrop = XWPDrop, XWT0Pu = XWT0Pu, dfMax = dfMax, dfMin = dfMin, dpRefMax = dpRefMax, dpRefMin = dpRefMin, dpWPRefMax = dpWPRefMax, dpWPRefMin = dpWPRefMin, dxRefMax = dxRefMax, dxRefMin = dxRefMin, i0Pu = i0Pu, pErrMax = pErrMax, pErrMin = pErrMin, pKIWPpMax = pKIWPpMax, pKIWPpMin = pKIWPpMin, pRefMax = pRefMax, pRefMin = pRefMin, pWPHookPu = pWPHookPu, u0Pu = u0Pu, uWPqdip = uWPqdip, uWPqrise = uWPqrise, xKIWPxMax = xKIWPxMax, xKIWPxMin = xKIWPxMin, xRefMax = xRefMax, xRefMin = xRefMin, xerrmax = xerrmax, xerrmin = xerrmin) annotation(
    Placement(visible = true, transformation(origin = {64.3, -0.5625}, extent = {{-64.3, -40.1875}, {64.3, 40.1875}}, rotation = 0)));

equation
  connect(iECWT4AControl.theta, theta) annotation(
    Line(points = {{-91, 50}, {-91, 129.5}, {-170, 129.5}}, color = {0, 0, 127}));
  connect(iECWT4AControl.iqMinPu, iqMinPu) annotation(
    Line(points = {{-123, -0.5}, {-147.5, -0.5}, {-147.5, 0}, {-170, 0}}, color = {0, 0, 127}));
  connect(iECWT4AControl.ipCmdPu, ipCmdPu) annotation(
    Line(points = {{-123, -19}, {-140, -19}, {-140, -51}, {-170, -51}}, color = {0, 0, 127}));
  connect(iECWT4AControl.iqCmdPu, iqCmdPu) annotation(
    Line(points = {{-123, -37}, {-130, -37}, {-130, -110}, {-170, -110}}, color = {0, 0, 127}));
  connect(uWtImPu, iECWT4AControl.uWtImPu) annotation(
    Line(points = {{-80, -169}, {-81, -169}, {-81, -120}, {-109, -120}, {-109, -51}}, color = {0, 0, 127}));
  connect(uWtRePu, iECWT4AControl.uWtRePu) annotation(
    Line(points = {{-40, -169}, {-40, -100}, {-91, -100}, {-91, -51}}, color = {0, 0, 127}));
  connect(iWtImPu, iECWT4AControl.iWtImPu) annotation(
    Line(points = {{1, -169}, {0, -169}, {0, -80}, {-55, -80}, {-55, -51}, {-54, -51}}, color = {0, 0, 127}));
  connect(iWtRePu, iECWT4AControl.iWtRePu) annotation(
    Line(points = {{40, -170}, {40, -140}, {-20, -140}, {-20, -66}, {-36, -66}, {-36, -51}}, color = {0, 0, 127}));
  connect(omegaRefPu, iECWT4AControl.omegaRefPu) annotation(
    Line(points = {{80, -169}, {80, -60}, {-10, -60}, {-10, -0.5}, {-22, -0.5}}, color = {0, 0, 127}));
  connect(xRefPu, iECWP4AControlModel.xWPRefPu) annotation(
    Line(points = {{169, -40}, {134, -40}, {134, -17}, {133, -17}}, color = {0, 0, 127}));
  connect(PRefPu, iECWP4AControlModel.pWPRefPu) annotation(
    Line(points = {{169, 40}, {134, 40}, {134, 16}, {133, 16}}, color = {0, 0, 127}));
  connect(omegaRefPu, iECWP4AControlModel.omegaRefPu) annotation(
    Line(points = {{80, -169}, {80, -169}, {80, -60}, {113, -60}, {113, -45}, {113, -45}}, color = {0, 0, 127}));
  connect(iWtRePu, iECWP4AControlModel.iWTRePu) annotation(
    Line(points = {{40, -170}, {40, -170}, {40, -140}, {88, -140}, {88, -45}, {88, -45}}, color = {0, 0, 127}));
  connect(iWtImPu, iECWP4AControlModel.iWTImPu) annotation(
    Line(points = {{1, -169}, {0, -169}, {0, -80}, {65, -80}, {65, -45}, {64, -45}}, color = {0, 0, 127}));
  connect(uWtRePu, iECWP4AControlModel.uWTRePu) annotation(
    Line(points = {{-40, -169}, {-40, -100}, {40, -100}, {40, -45}}, color = {0, 0, 127}));
  connect(uWtImPu, iECWP4AControlModel.uWTImPu) annotation(
    Line(points = {{-80, -169}, {-81, -169}, {-81, -120}, {16, -120}, {16, -45}}, color = {0, 0, 127}));
  connect(iECWP4AControlModel.xPDRefComPu, iECWT4AControl.xRefPu) annotation(
    Line(points = {{-4, -17}, {-13, -17}, {-13, -22}, {-22, -22}}, color = {0, 0, 127}));
  connect(iECWP4AControlModel.pPDRefComPu, iECWT4AControl.PRefPu) annotation(
    Line(points = {{-4, 16}, {-13, 16}, {-13, 23}, {-22, 23}, {-22, 24}}, color = {0, 0, 127}));
  connect(iECWT4AControl.ipMaxPu, ipMaxPu) annotation(
    Line(points = {{-123, 36}, {-130, 36}, {-130, 90}, {-169, 90}, {-169, 91}}, color = {0, 0, 127}));
  connect(iECWT4AControl.iqMaxPu, iqMaxPu) annotation(
    Line(points = {{-123, 18}, {-140, 18}, {-140, 50}, {-169, 50}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-150, -150}, {150, 150}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WP4A"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Control")}));
end IECWP4AControl;
