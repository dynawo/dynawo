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

model GfolConverterdVOC "Grid Following Converter: assembling a VCS converter model with grid following and DC side control"

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
  import Modelica;

  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit PMaxPu "Maximal converter active power in pu (base SNom)";
  parameter Types.PerUnit QMaxPu "Maximal converter reactive power in pu (base SNom)";
  parameter Types.PerUnit IMaxPu "Maximal converter valve current in pu (base UNom, SNom)";
  parameter Types.PerUnit ConvFixLossPu "Converter fix losses in pu (base SNom), such that PlossPu=ConvFixLossPu+Plvar";
  parameter Types.PerUnit ConvVarLossPu "Converter variable losses in pu (base UNom, SNom), such that Plvar=ConvVarLossPu*Idc";
  parameter Types.PerUnit Rtransformer "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ltransformer "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Rfilter "Converter filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cdc "DC bus capacitance in pu (base UNom, SNom)" annotation(
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
  parameter Types.PerUnit RPmaxPu "Maximal primary reserve in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Control"));

  //Droop Control parameters

  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.PerUnit Eta "Parameter Eta in the dVOC control in pu (base UNom, SNom)";
  parameter Types.PerUnit Alpha "Parameter Alpha in the dVOC control in pu (base UNom, SNom)";
  parameter Types.PerUnit KDvoc "Parameter KDvoc in the dVOC control in rad";

//Operational values
  parameter Types.ActivePowerPu P0Pu "Start value of active power at the PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at the PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UdConv0Pu "Start value of the d-axis converter modulated voltage in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UqConv0Pu "Start value of the q-axis converter modulated voltage in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis valve current (before filter) in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis valve current (before filter) in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdPcc0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqPcc0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit PRef0Pu "Start value of the active power reference at the converter terminal (filter) in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit QRef0Pu "Start value of the reactive power reference at the converter terminal (filter) in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit Udc0Pu "Start value of the DC bus voltage in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdcSource0Pu "Start value of the DC source current in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IdcSourceRef0Pu "Start value of the reference DC source current in pu (base UNom, SNom)"annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit PstepHPu "Height of the active power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit QstepHPu "Height of the reactive power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.PerUnit UstepHPu "Height of the AC voltage step in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Pstep "Time of the active power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Qstep "Time of the reactive power step in pu (base SNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));
  parameter Types.Time t_Ustep "Time of the AC voltage step in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Reference steps"));

  Dynawo.Electrical.Sources.VSCIdcSource vSCIdcSource(Cdc = Cdc,Cfilter = Cfilter, ConvFixLossPu = ConvFixLossPu, ConvVarLossPu = ConvVarLossPu, IdConv0Pu = IdConv0Pu, IdPcc0Pu = IdPcc0Pu, IdcSource0Pu = IdcSource0Pu, IqConv0Pu = IqConv0Pu, IqPcc0Pu = IqPcc0Pu, Lfilter = Lfilter, Ltransformer = Ltransformer, P0Pu = P0Pu, Q0Pu = Q0Pu, Rfilter = Rfilter, Rtransformer = Rtransformer, SNom = SNom, Theta0 = Theta0, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, Udc0Pu = Udc0Pu, UqConv0Pu = UqConv0Pu, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-36, -1.77636e-15}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.GridFormingControlDispatchableVirtualOscillatorControl dVOC(Alpha = Alpha, Cfilter = Cfilter, Eta = Eta, KDvoc = KDvoc, Kic = Kic, Kiv = Kiv, KpVI = KpVI, Kpc = Kpc, Kpdc = Kpdc, Kpv = Kpv, Lfilter = Lfilter, Rfilter = Rfilter, XRratio = XRratio) "dVOC controlled grid-forming converter" annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{24, 24}, {-24, -24}}, rotation = 0)));

  Modelica.Blocks.Sources.Step PrefPu(height = PstepHPu, offset = PRef0Pu, startTime = t_Pstep)  annotation(
    Placement(visible = true, transformation(origin = {89, -89}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = QstepHPu, offset = QRef0Pu, startTime = t_Qstep)  annotation(
    Placement(visible = true, transformation(origin = {89, -57}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UFilterRefPu(height = UstepHPu, offset = UdFilter0Pu, startTime = t_Ustep)  annotation(
    Placement(visible = true, transformation(origin = {89, -21}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IdcSourceRefPu(height = 0, offset = IdcSource0Pu, startTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {89, 21}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcRefPu(height = 0, offset = Udc0Pu, startTime = 0)  annotation(
    Placement(visible = true, transformation(origin = {89, 58}, extent = {{10, -10}, {-10, 10}}, rotation= 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {89, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Dynawo.Connectors.ACPower aCPower annotation(
    Placement(visible = true, transformation(origin = {-88.5, -0.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  vSCIdcSource.switchOffSignal1.value = false;
  vSCIdcSource.switchOffSignal2.value = false;
  vSCIdcSource.switchOffSignal3.value = false;
 connect(vSCIdcSource.terminal, aCPower) annotation(
    Line(points = {{-63.5, 0}, {-88.5, 0}}, color = {0, 0, 255}));
 connect(dVOC.omegaPu, vSCIdcSource.omegaPu) annotation(
    Line);
 connect(dVOC.theta, vSCIdcSource.theta) annotation(
    Line);
 connect(dVOC.UdcRefOutPu, vSCIdcSource.udConvPu) annotation(
    Line);
 connect(dVOC.uqConvRefPu, vSCIdcSource.uqConvPu) annotation(
    Line);
 connect(dVOC.IdcSourcePu, vSCIdcSource.IdcSourcePu) annotation(
    Line);
 connect(omegaRefPu.y, dVOC.omegaRefPu) annotation(
    Line(points = {{78, 90}, {8, 90}, {8, 25}}, color = {0, 0, 127}));
 connect(IdcSourceRefPu.y, dVOC.IdcSourceRefPu) annotation(
    Line(points = {{78, 22}, {74, 22}, {74, 14}, {55, 14}}, color = {0, 0, 127}));
 connect(UFilterRefPu.y, dVOC.UFilterRefPu) annotation(
    Line(points = {{78, -20}, {74, -20}, {74, 0}, {55, 0}}, color = {0, 0, 127}));
 connect(QRefPu.y, dVOC.QRefPu) annotation(
    Line(points = {{78, -56}, {68, -56}, {68, -14}, {55, -14}}, color = {0, 0, 127}));
 connect(PrefPu.y, dVOC.PRefPu) annotation(
    Line(points = {{78, -88}, {60, -88}, {60, -24}, {55, -24}}, color = {0, 0, 127}));
 connect(vSCIdcSource.idPccPu, dVOC.idPccPu) annotation(
    Line(points = {{-63, -20}, {-63, -80}, {16, -80}, {16, -25}}, color = {0, 0, 127}));
 connect(vSCIdcSource.iqPccPu, dVOC.iqPccPu) annotation(
    Line(points = {{-63, -13}, {-72, -13}, {-72, -90}, {44, -90}, {44, -25}}, color = {0, 0, 127}));
 connect(vSCIdcSource.iqConvPu, dVOC.iqConvPu) annotation(
    Line(points = {{-14, -27}, {-14, -34}, {36, -34}, {36, -25}}, color = {0, 0, 127}));
 connect(vSCIdcSource.idConvPu, dVOC.idConvPu) annotation(
    Line(points = {{-19, -27}, {-19, -40}, {22, -40}, {22, -25}}, color = {0, 0, 127}));
 connect(vSCIdcSource.udFilterPu, dVOC.udFilterPu) annotation(
    Line(points = {{-30, -27}, {-30, -60}, {9, -60}, {9, -25}}, color = {0, 0, 127}));
 connect(vSCIdcSource.UdcPu, dVOC.UdcPu) annotation(
    Line(points = {{-36, -27}, {-36, -70}, {30, -70}, {30, -25}}, color = {0, 0, 127}));
 connect(vSCIdcSource.uqFilterPu, dVOC.uqFilterPu) annotation(
    Line(points = {{-25, -27}, {-25, -50}, {52, -50}, {52, -25}}, color = {0, 0, 127}));
 connect(UdcRefPu.y, dVOC.UdcRefPu) annotation(
    Line(points = {{78, 58}, {60, 58}, {60, 24}, {55, 24}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(initialScale = 0.1, grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}));
end GfolConverterdVOC;
