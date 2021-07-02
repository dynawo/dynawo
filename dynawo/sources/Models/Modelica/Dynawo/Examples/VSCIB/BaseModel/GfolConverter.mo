within Dynawo.Examples.VSCIB.BaseModel;

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

model GfolConverter "Grid Following Converter: assembling a VCS converter model with grid following and DC side control"

/*
  Equivalent circuit and conventions:
                       __________
IdcSourcePu     IdcPu |          |iConvPu                           iPccPu
-------->-------->----|          |-->-----(Rfilter,Lfilter)---------->--(Rtransformer,Ltransformer)---(terminal)
              |       |          |                                |
      UdcPu (Cdc)     |  DC/AC   |  uConvPu         uFilterPu (Cfilter)                      uPccPu
              |       |          |                                |
              |       |          |                                |
----------------------|__________|---------------------------------------------------------------------

*/

  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit PMaxPu "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit QMaxPu "Maximal converter reactive power in p.u (base SNom)";
  parameter Types.PerUnit IMaxPu "Maximal converter valve current in p.u (base UNom, SNom)";
  parameter Types.PerUnit ConvFixLossPu "Converter fix losses in p.u (base SNom), such that PlossPu=ConvFixLossPu+Plvar";
  parameter Types.PerUnit ConvVarLossPu "Converter variable losses in p.u (base UNom, SNom), such that Plvar=ConvVarLossPu*Idc";
  parameter Types.PerUnit Rtransformer "Transformer resistance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ltransformer "Transformer inductance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Rfilter "Converter filter resistance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cdc "DC bus capacitance in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit Kpc "Proportional gain of the current loop" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit Kic "Integral gain of the current loop" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit DroopUQ "Proportional gain of the reactive power loop (AC voltage regulation), such that Qsp=Qref+DroopUQ*(UacRef-Uac)" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit DroopFP "Proportional gain of the active power loop (frequency regulation), such that Psp=Pref-DroopFP*(fnom-f)" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.Time tauIdRef "Approximation of the response time of the active power loop is seconds" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.Time tauIqRef "Approximation of the response time of the reactive power loop is seconds" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.PerUnit RPmaxPu "Maximal primary reserve in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Control"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at the PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at the PCC in p.u (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UdConv0Pu "Start value of the d-axis converter modulated voltage in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UqConv0Pu "Start value of the q-axis converter modulated voltage in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdPcc0Pu "Start value of the d-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqPcc0Pu "Start value of the q-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit PRef0Pu "Start value of the active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QRef0Pu "Start value of the reactive power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit Udc0Pu "Start value of the DC bus voltage in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdcSource0Pu "Start value of the DC source current in p.u (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdcSourceRef0Pu "Start value of the reference DC source current in p.u (base UNom, SNom)"annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit PstepHPu "Height of the active power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit QstepHPu "Height of the reactive power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit UstepHPu "Height of the AC voltage step in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Pstep "Time of the active power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Qstep "Time of the reactive power step in p.u (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Ustep "Time of the AC voltage step in p.u (base UNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));

  Dynawo.Electrical.Sources.VSCIdcSource vSCIdcSource(Cdc = Cdc,Cfilter = Cfilter, ConvFixLossPu = ConvFixLossPu, ConvVarLossPu = ConvVarLossPu, IdConv0Pu = IdConv0Pu, IdPcc0Pu = IdPcc0Pu, IdcSource0Pu = IdcSource0Pu, IqConv0Pu = IqConv0Pu, IqPcc0Pu = IqPcc0Pu, Lfilter = Lfilter, Ltransformer = Ltransformer, P0Pu = P0Pu, Q0Pu = Q0Pu, Rfilter = Rfilter, Rtransformer = Rtransformer, SNom = SNom, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, Udc0Pu = Udc0Pu, UqConv0Pu = UqConv0Pu, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-38, -1.77636e-15}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.GridFollowingControl gridFollowingControl(DroopFP = DroopFP,DroopUQ = DroopUQ, IMaxPu = IMaxPu,IdConv0Pu = IdConv0Pu, IdcSource0Pu = IdcSource0Pu, IdcSourceRef0Pu = IdcSourceRef0Pu, IqConv0Pu = IqConv0Pu, KiPll = KiPll, Kic = Kic, KpPll = KpPll, Kpc = Kpc, Kpdc = Kpdc, Lfilter = Lfilter, PMaxPu = PMaxPu, PRef0Pu = PRef0Pu, QMaxPu = QMaxPu, QRef0Pu = QRef0Pu, RPmaxPu = RPmaxPu, Rfilter = Rfilter, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, Udc0Pu = Udc0Pu, UqConv0Pu = UqConv0Pu, tauIdRef = tauIdRef, tauIqRef = tauIqRef)  annotation(
    Placement(visible = true, transformation(origin = {28, 3.9968e-15}, extent = {{25, -25}, {-25, 25}}, rotation = 0)));

  Modelica.Blocks.Sources.Step PrefPu(height = PstepHPu, offset = PRef0Pu, startTime = t_Pstep)  annotation(
    Placement(visible = true, transformation(origin = {89, 89}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = QstepHPu, offset = QRef0Pu, startTime = t_Qstep)  annotation(
    Placement(visible = true, transformation(origin = {89, 55}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRefPu(height = UstepHPu, offset = UdFilter0Pu, startTime = t_Ustep)  annotation(
    Placement(visible = true, transformation(origin = {89, 17}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRefPu(height = 0, offset = IdcSource0Pu, startTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {89, -55}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcRefPu(height = 0, offset = Udc0Pu, startTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {89, -90}, extent = {{10, -10}, {-10, 10}}, rotation= 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {89, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(visible = true, transformation(origin = {-86.5, -0.5}, extent = {{-12.5, -12.5}, {12.5, 12.5}}, rotation = 0), iconTransformation(origin = {-110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  vSCIdcSource.switchOffSignal1.value = false;
  vSCIdcSource.switchOffSignal2.value = false;
  vSCIdcSource.switchOffSignal3.value = false;
  connect(PrefPu.y, gridFollowingControl.PRefPu) annotation(
    Line(points = {{78, 89}, {55, 89}, {55, 22}, {54, 22}}, color = {0, 0, 127}));
  connect(vSCIdcSource.terminal, aCPower) annotation(
    Line(points = {{-65.5, 0}, {-86, 0}}, color = {0, 0, 255}));
  connect(gridFollowingControl.theta, vSCIdcSource.theta) annotation(
    Line(points = {{2, 20}, {-11, 20}}, color = {0, 0, 127}));
  connect(gridFollowingControl.udConvPu, vSCIdcSource.udConvPu) annotation(
    Line(points = {{2, 0}, {-11, 0}}, color = {0, 0, 127}));
  connect(gridFollowingControl.IdcSourcePu, vSCIdcSource.IdcSourcePu) annotation(
    Line(points = {{2, -20}, {-11, -20}}, color = {0, 0, 127}));
  connect(vSCIdcSource.iqConvPu, gridFollowingControl.iqConvPu) annotation(
    Line(points = {{-16, -27}, {-16, -31}, {8, -31}, {8, -27}}, color = {0, 0, 127}));
  connect(vSCIdcSource.udFilterPu, gridFollowingControl.udFilterPu) annotation(
    Line(points = {{-32, -27}, {-32, -44}, {38, -44}, {38, -27}}, color = {0, 0, 127}));
  connect(vSCIdcSource.UdcPu, gridFollowingControl.UdcPu) annotation(
    Line(points = {{-38, -27}, {-38, -50}, {48, -50}, {48, -27}}, color = {0, 0, 127}));
  connect(vSCIdcSource.idConvPu, gridFollowingControl.idConvPu) annotation(
    Line(points = {{-21, -27}, {-21, -36}, {18, -36}, {18, -26}}, color = {0, 0, 127}));
  connect(vSCIdcSource.uqFilterPu, gridFollowingControl.uqFilterPu) annotation(
    Line(points = {{-27, -27}, {-27, -40}, {28, -40}, {28, -26}}, color = {0, 0, 127}));
  connect(QRefPu.y, gridFollowingControl.QRefPu) annotation(
    Line(points = {{78, 56}, {60, 56}, {60, 14}, {54, 14}, {54, 14}}, color = {0, 0, 127}));
  connect(UFilterRefPu.y, gridFollowingControl.UFilterRefPu) annotation(
    Line(points = {{78, 18}, {64, 18}, {64, 6}, {54, 6}, {54, 6}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, gridFollowingControl.omegaRefPu) annotation(
    Line(points = {{78, -20}, {64, -20}, {64, -4}, {54, -4}, {54, -4}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu.y, gridFollowingControl.IdcSourceRefPu) annotation(
    Line(points = {{78, -54}, {60, -54}, {60, -12}, {54, -12}, {54, -12}}, color = {0, 0, 127}));
  connect(UdcRefPu.y, gridFollowingControl.UdcRefPu) annotation(
    Line(points = {{78, -90}, {56, -90}, {56, -22}, {54, -22}}, color = {0, 0, 127}));
  connect(gridFollowingControl.omegaPu, vSCIdcSource.omegaPu) annotation(
    Line(points = {{2, 10}, {-11, 10}}, color = {0, 0, 127}));
  connect(gridFollowingControl.uqConvPu, vSCIdcSource.uqConvPu) annotation(
    Line(points = {{2, -10}, {-11, -10}}, color = {0, 0, 127}));

  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 0.000001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls="kinsol",  s = "ida", nlsLS = "klu",  maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
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
  Icon(coordinateSystem(initialScale = 0.1, grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4.5, 43}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "VSC"), Text(origin = {2.5, -34}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "Gfol")}));

end GfolConverter;
