within Dynawo.Examples.IECWT4ANeplan.BaseModel;

model IECWT4B "Wind Turbine Type 4A model from IEC 61400-27-1 standard: assembling the electrical part that includes the electrical and generator module, with the control, that includes the plant and generator control sub-structure, the measurement and grid protection modules"
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

  /*Mechanical parameters*/
  parameter Types.PerUnit Cdrt "Drive train damping";
  parameter Types.PerUnit Kdrt "Drive train stiffness";
  parameter Types.PerUnit Hwtr "Inertia time constant of WT rotor";
  parameter Types.PerUnit Hgen "Inertia time constant of generator";

  /*Control parameters generator module*/
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds";
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in pu (base UNom)";
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen in pu (base UNom)";
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
  parameter Types.Time Tpaero "Time constant in aerodynamic power response" annotation(
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
  parameter Types.PerUnit UGsRe0Pu "Start value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsIm0Pu "Start value of the imaginary component of the voltage at the converter's terminals (generator system) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsRe0Pu "Start value of the real component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Start value of the imaginary component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Blocks*/
  Modelica.Blocks.Sources.Step PrefPu(height = PstepHPu, offset = -P0Pu * SystemBase.SnRef / SNom, startTime = t_Pstep) annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));

  Modelica.Blocks.Sources.Step QrefPu(height = QstepHPu, offset = -Q0Pu * SystemBase.SnRef / SNom, startTime = t_Qstep) annotation(
    Placement(visible = true, transformation(origin = {90, -50}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));

  Dynawo.Electrical.Sources.WT4BIECelec wT4BIECelec(Bes = Bes, Cdrt = Cdrt, DipMax = DipMax, DiqMax = DiqMax, DiqMin = DiqMin, Ges = Ges, Hgen = Hgen, Hwtr = Hwtr, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kdrt = Kdrt, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, SNom = SNom, Tg = Tg, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, Xes = Xes, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.IECWT4BControl iECWT4BControl(DpMaxp4A = DpMaxp4A, DpRefMax4A = DpRefMax4A, DpRefMin4A = DpRefMin4A, IMax = IMax, IMaxDip = IMaxDip, IMaxHookPu = IMaxHookPu, IdfHook = IdfHook, IpMax0Pu = IpMax0Pu, IpfHook = IpfHook, IqH1 = IqH1, IqMax = IqMax, IqMax0Pu = IqMax0Pu, IqMaxHook = IqMaxHook, IqMin = IqMin, IqMin0Pu = IqMin0Pu, IqPost = IqPost, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, Mdfslim = Mdfslim, MpUScale = MpUScale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax = QMax, QMax0Pu = QMax0Pu, QMin = QMin, QMin0Pu = QMin0Pu, QlConst = QlConst, RWTDrop = RWTDrop, SNom = SNom, TanPhi = TanPhi, Td = Td, Tffilt = Tffilt, TpOrdp4A = TpOrdp4A, TpWTRef4A = TpWTRef4A, Tpaero = Tpaero, Tpfilt = Tpfilt, Tpll = Tpll, TqOrd = TqOrd, Tqfilt = Tqfilt, Ts = Ts, Tufilt = Tufilt, Tuss = Tuss, U0Pu = U0Pu, UMax = UMax, UMin = UMin, UPhase0 = UPhase0, UdbOne = UdbOne, UdbTwo = UdbTwo, UpDip = UpDip, Upll1 = Upll1, Upll2 = Upll2, UpquMax = UpquMax, UqDip = UqDip, UqRise = UqRise, XWTDrop = XWTDrop, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));

  Dynawo.Connectors.ACPower aCPower(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-93, 0}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Modelica.Blocks.Sources.Step omegaRef(height = OmegastepHPu, offset = SystemBase.omegaRef0Pu, startTime = t_Omegastep) annotation(
    Placement(visible = true, transformation(origin = {90, 3.33067e-16}, extent = {{-9, -9}, {9, 9}}, rotation = 180)));

equation

  wT4BIECelec.switchOffSignal1.value = false;
  wT4BIECelec.switchOffSignal2.value = false;
  wT4BIECelec.switchOffSignal3.value = false;
/*Connectors*/
  connect(iECWT4BControl.PRefPu, PrefPu.y) annotation(
    Line(points = {{57.5, 13}, {69, 13}, {69, 50}, {80, 50}}, color = {0, 0, 127}));
  connect(iECWT4BControl.QRefPu, QrefPu.y) annotation(
    Line(points = {{57.5, -12}, {69, -12}, {69, -50}, {80, -50}}, color = {0, 0, 127}));
  connect(iECWT4BControl.ipMaxPu, wT4BIECelec.ipMaxPu) annotation(
    Line(points = {{2.5, 20}, {-22.5, 20}}, color = {0, 0, 127}));
  connect(iECWT4BControl.iqMaxPu, wT4BIECelec.iqMaxPu) annotation(
    Line(points = {{2.5, 10}, {-22.5, 10}}, color = {0, 0, 127}));
  connect(iECWT4BControl.iqMinPu, wT4BIECelec.iqMinPu) annotation(
    Line(points = {{2.5, 0}, {-22.5, 0}}, color = {0, 0, 127}));
  connect(iECWT4BControl.ipCmdPu, wT4BIECelec.ipCmdPu) annotation(
    Line(points = {{2.5, -10}, {-22.5, -10}}, color = {0, 0, 127}));
  connect(iECWT4BControl.iqCmdPu, wT4BIECelec.iqCmdPu) annotation(
    Line(points = {{2.5, -20}, {-22.5, -20}}, color = {0, 0, 127}));
  connect(iECWT4BControl.theta, wT4BIECelec.theta) annotation(
    Line(points = {{17.5, 27.5}, {17.5, 36}, {-37.5, 36}, {-37.5, 27.5}}, color = {0, 0, 127}));
  connect(wT4BIECelec.uWtImPu, iECWT4BControl.uWtImPu) annotation(
    Line(points = {{-30, -27.5}, {-30, -34}, {10, -34}, {10, -27.5}}, color = {0, 0, 127}));
  connect(wT4BIECelec.uWtRePu, iECWT4BControl.uWtRePu) annotation(
    Line(points = {{-40, -27.5}, {-40, -40}, {20, -40}, {20, -27.5}}, color = {0, 0, 127}));
  connect(wT4BIECelec.iWtImPu, iECWT4BControl.iWtImPu) annotation(
    Line(points = {{-50, -27.5}, {-50, -46}, {30, -46}, {30, -27.5}}, color = {0, 0, 127}));
  connect(wT4BIECelec.iWtRePu, iECWT4BControl.iWtRePu) annotation(
    Line(points = {{-60, -27.5}, {-60, -52}, {40, -52}, {40, -27.5}}, color = {0, 0, 127}));
  connect(wT4BIECelec.terminal, aCPower) annotation(
    Line(points = {{-77.5, 0}, {-93, 0}}, color = {0, 0, 255}));
  connect(omegaRef.y, iECWT4BControl.omegaRefPu) annotation(
    Line(points = {{80, 0}, {57.5, 0}}, color = {0, 0, 127}));
  connect(wT4BIECelec.omegaGenPu, iECWT4BControl.omegaGenPu) annotation(
    Line(points = {{-70, -27.5}, {-70, -60}, {50, -60}, {50, -27.5}}, color = {0, 0, 127}));
  connect(iECWT4BControl.paeroPu, wT4BIECelec.paeroPu) annotation(
    Line(points = {{42.5, 27.5}, {42.5, 50}, {-62, 50}, {-62, 28}}, color = {0, 0, 127}));
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
    Icon(coordinateSystem(initialScale = 0.1, grid = {1, 1}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WT4B")}));

end IECWT4B;
