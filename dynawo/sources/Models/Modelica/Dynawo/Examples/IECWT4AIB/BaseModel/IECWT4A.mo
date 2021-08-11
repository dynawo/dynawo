within Dynawo.Examples.IECWT4AIB.BaseModel;

model IECWT4A "Wind Turbine Type 4A model from IEC 61400-27-1 standard: assembling the electrical part that includes the electrical and generator module, with the control, that includes the plant and generator control sub-structure, the measurement and grid protection modules"
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
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Res "Electrical system resistance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Les "Electrical system inductance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit PstepHPu "Height of the active power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit QstepHPu "Height of the reactive power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Pstep "Time of the active power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Qstep "Time of the reactive power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));

  /*Control parameters generator module*/
  parameter Types.Time Tpll "Time constant for PLL first order filter model in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Upll1 "Voltage below which the angle of the voltage is filtered/frozen in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Upll2 "Voltage below which the angle of the voltage is frozen in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.Time Tg "Current generation time constant in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Dipmax "Maximun active current ramp rate in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Diqmax "Maximun reactive current ramp rate in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit Diqmin "Minimum reactive current ramp rate in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
/*P control parameters*/
  parameter Types.PerUnit upDip "Voltage dip threshold for P control. Part of WT control, often different from converter thershold" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit Tpordp4A "Time constant in power order lag" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit TpWTref4A "Time constant in reference power order lag" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dprefmax4A "Maximum WT reference power ramp rate" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dprefmin4A "Minimum WT reference power ramp rate" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit dpmaxp4A "Maximum WT power ramp rate" annotation(Dialog(group = "group", tab = "Pcontrol"));
  parameter Types.PerUnit MpUscale "Voltage scaling for power reference during voltage dip (0: no scaling - 1: u scaling)" annotation(Dialog(group = "group", tab = "Pcontrol"));
  /*Q control parameters */
  parameter Types.PerUnit Rdrop "Resistive component of voltage drop impedance" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Xdrop "Inductive component of voltage drop impedance" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uMax "Maximum voltage in voltage PI controller integral term" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uMin "Minimum voltage in voltage PI controller integral term" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uqRise "Voltage threshold for OVRT detection in Q control" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit uqDip "Voltage threshold for UVRT detection in Q control" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit udbOne "Voltage change dead band lower limit (typically negative)" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit udbTwo "Voltage change dead band upper limit (typically positive)" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqMax "Maximum reactive current inyection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqMin "Minimum reactive current inyection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqh1 "Maximum reactive current inyection during dip" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit iqPost "Post fault reactive current injection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit idfHook annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit ipfHook annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Ts "Delay flag time constant, specifies how much time F0 will keep the value 2" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Td "Delay flag exponential time constant" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Tuss "Time constant of steady volatage filter" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Tqord "Time constant in reactive injection" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiu "voltaqge PI conqtroller integration gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kpq "Active power PI controller proportional gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kiq "Reactive power PI controller proportional gain" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Types.PerUnit TanPhi "Constant Tangent Phi" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer Mqfrt "Reactive current inyection for each FRT Q contorl modes (0-3)" annotation(Dialog(group = "group", tab = "Qcontrol"));
  parameter Integer MqG "General Q control mode" annotation(Dialog(group = "group", tab = "Qcontrol"));
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
    /*Parameters for initialization from load flow*/
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
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
  /*Blocks*/
    Modelica.Blocks.Sources.Step PrefPu(height = PstepHPu, offset = -P0Pu * SystemBase.SnRef / SNom, startTime = t_Pstep) annotation(
    Placement(visible = true, transformation(origin = {92, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Step QrefPu(height = QstepHPu, offset = -Q0Pu * SystemBase.SnRef / SNom, startTime = t_Qstep) annotation(
    Placement(visible = true, transformation(origin = {92, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Sources.WT4AIECelec wT4AIECelec(Bes = Bes, Dipmax = Dipmax, Diqmax = Diqmax, Diqmin = Diqmin, Ges = Ges, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Les = Les, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, SNom = SNom, Tg = Tg, Theta0 = Theta0, Tpll = Tpll, Upll1 = Upll1, Upll2 = Upll2, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-45, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.IECWT4AControl iECWT4AControl(IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kiq = Kiq, Kiu = Kiu, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kpufrt = Kpufrt, Kqv = Kqv, Mdfslim = Mdfslim, MpUscale = MpUscale, MqG = MqG, Mqfrt = Mqfrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMin0Pu = QMin0Pu, Rdrop = Rdrop, SNom = SNom, TanPhi = TanPhi, Td = Td, Tffilt = 0.01, Theta0 = Theta0, TpWTref4A = TpWTref4A, Tpfilt = 0.01, Tpordp4A = Tpordp4A, Tqfilt = 0.01, Tqord = Tqord, Ts = Ts, Tufilt = 0.01, Tuss = Tuss, Xdrop = Xdrop, dpmaxp4A = dpmaxp4A, dprefmax4A = dprefmax4A, dprefmin4A = dprefmin4A, i0Pu = i0Pu, iMax = iMax, iMaxDip = iMaxDip, iMaxHookPu = iMaxHookPu, idfHook = idfHook, ipfHook = ipfHook, iqMax = iqMax, iqMaxHook = iqMaxHook, iqMin = iqMin, iqPost = iqPost, iqh1 = iqh1, u0Pu = u0Pu, uMax = uMax, uMin = uMin, udbOne = udbOne, udbTwo = udbTwo, upDip = upDip, upquMax = upquMax, uqDip = uqDip, uqRise = uqRise)  annotation(
    Placement(visible = true, transformation(origin = {45, 0}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(visible = true, transformation(origin = {-95, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
//
equation
  wT4AIECelec.switchOffSignal1.value = false;
  wT4AIECelec.switchOffSignal2.value = false;
  wT4AIECelec.switchOffSignal3.value = false;
/*Connectors*/
  connect(wT4AIECelec.terminal, aCPower) annotation(
    Line(points = {{-72, 0}, {-92, 0}, {-92, 0}, {-94, 0}}, color = {0, 0, 255}));
  connect(wT4AIECelec.ipMaxPu, iECWT4AControl.ipMaxPu) annotation(
    Line(points = {{-18, 20}, {18, 20}, {18, 20}, {18, 20}}, color = {0, 0, 127}));
  connect(wT4AIECelec.iqMaxPu, iECWT4AControl.iqMaxPu) annotation(
    Line(points = {{-18, 10}, {18, 10}, {18, 10}, {18, 10}}, color = {0, 0, 127}));
  connect(wT4AIECelec.iqMinPu, iECWT4AControl.iqMinPu) annotation(
    Line(points = {{-18, 0}, {18, 0}, {18, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(wT4AIECelec.ipCmdPu, iECWT4AControl.ipCmdPu) annotation(
    Line(points = {{-18, -10}, {18, -10}, {18, -10}, {18, -10}}, color = {0, 0, 127}));
  connect(wT4AIECelec.iqCmdPu, iECWT4AControl.iqCmdPu) annotation(
    Line(points = {{-18, -20}, {20, -20}, {20, -20}, {18, -20}}, color = {0, 0, 127}));
  connect(wT4AIECelec.uWtImPu, iECWT4AControl.uWtImPu) annotation(
    Line(points = {{-24, -28}, {-24, -28}, {-24, -36}, {24, -36}, {24, -28}, {26, -28}}, color = {0, 0, 127}));
  connect(wT4AIECelec.uWtRePu, iECWT4AControl.uWtRePu) annotation(
    Line(points = {{-34, -28}, {-34, -28}, {-34, -40}, {34, -40}, {34, -28}, {36, -28}}, color = {0, 0, 127}));
  connect(wT4AIECelec.iWtImPu, iECWT4AControl.iWtImPu) annotation(
    Line(points = {{-54, -28}, {-54, -28}, {-54, -48}, {56, -48}, {56, -28}, {56, -28}}, color = {0, 0, 127}));
  connect(wT4AIECelec.iWtRePu, iECWT4AControl.iWtRePu) annotation(
    Line(points = {{-64, -28}, {-66, -28}, {-66, -54}, {66, -54}, {66, -28}, {66, -28}}, color = {0, 0, 127}));
  connect(iECWT4AControl.theta, wT4AIECelec.theta) annotation(
    Line(points = {{46, 28}, {44, 28}, {44, 38}, {-46, 38}, {-46, 28}, {-44, 28}}, color = {0, 0, 127}));
  connect(PrefPu.y, iECWT4AControl.PrefPu) annotation(
    Line(points = {{82, 16}, {74, 16}, {74, 14}, {72, 14}}, color = {0, 0, 127}));
  connect(iECWT4AControl.QrefPu, QrefPu.y) annotation(
    Line(points = {{72, -12}, {82, -12}, {82, -12}, {82, -12}}, color = {0, 0, 127}));

annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
    This test case represents a 2220 MWA synchronous machine connected to an infinite bus through a transformer and two lines in parallel. <div><br></div><div> The simulated event is a 0.02 p.u. step variation on the generator mechanical power Pm occurring at t=1s.
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
    Icon(coordinateSystem(initialScale = 0.1, grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC")}));
end IECWT4A;
