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

model GridFollowingControl "Grid following control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit PMaxPu "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit QMaxPu "Maximal converter reactive power in p.u (base SNom)";
  parameter Types.PerUnit IMaxPu "Maximal converter valve current in p.u (base UNom, SNom)";
  parameter Types.PerUnit Rfilter "Converter filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Lfilter "Converter filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit KpPll "Proportional gain of the phase-locked loop (PLL)";
  parameter Types.PerUnit KiPll "Integral gain of the phase-locked loop (PLL)";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit KpDc "Proportional gain of the dc voltage control";
  parameter Types.PerUnit DroopUQ "Proportional gain of the reactive power loop (AC voltage regulation), such that Qsp=Qref+DroopUQ*(UacRef-Uac)";
  parameter Types.PerUnit DroopFP "Proportional gain of the active power loop (frequency regulation), such that Psp=Pref-DroopFP*(fnom-f)";
  parameter Types.Time tauIdRef "Approximation of the response time of the active power loop is seconds";
  parameter Types.Time tauIqRef "Approximation of the response time of the reactive power loop is seconds";
  parameter Types.PerUnit RPmaxPu "Maximal primary reserve in p.u (base SNom)";
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit UdConv0Pu "Start value of the d-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of the q-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit PRef0Pu "Start value of the active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit QRef0Pu "Start value of the reactive power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit Udc0Pu "Start value of the DC bus voltage in p.u (base UNom)";
  parameter Types.PerUnit IdcSource0Pu "Start value of the DC source current in p.u (base UNom, SNom)";
  parameter Types.PerUnit IdcSourceRef0Pu "Start value of the DC source current reference in p.u (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-105, -14}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-105, 70}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Rective power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-105, 45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -85}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -85}, extent = {{5, 5}, {-5, -5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -85}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -85}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSourceRef0Pu) "DC source reference current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-25, -90}, extent = {{-9, -9}, {9, 9}}, rotation = 90), iconTransformation(origin = {-105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "DC bus reference voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {0, -90}, extent = {{-9, -9}, {9, 9}}, rotation = 90), iconTransformation(origin = {-105, -70}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC bus voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {25, -90}, extent = {{-9, -9}, {9, 9}}, rotation = 90), iconTransformation(origin = {-80, -85}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {110, 75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, 65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in p.u (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, 34}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvPu(start = UdConv0Pu) "d-axis converter modulated voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvPu(start = UqConv0Pu) "q-axis converter modulated voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, -35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC source injected current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -65}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {105, -65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.PLL pll(KiPll = KiPll, KpPll = KpPll, Theta0 = Theta0)  annotation(
    Placement(visible = true, transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.Modulation modulation(UdConv0Pu = UdConv0Pu, Udc0Pu = Udc0Pu, UqConv0Pu = UqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {69, -1}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentControl(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, Rfilter = Rfilter, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {23, -1}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DCVoltageControl dCCurrentControl(IdcSource0Pu = IdcSource0Pu, KpDc = KpDc, Udc0Pu = Udc0Pu, IdcSourceRef0Pu = IdcSourceRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {65, -65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.PControl pControl(DroopFP = DroopFP,IdConv0Pu = IdConv0Pu, PMaxPu = PMaxPu, PRef0Pu = PRef0Pu, RPmaxPu = RPmaxPu, UdFilter0Pu = UdFilter0Pu, tauIdRef = tauIdRef) annotation(
    Placement(visible = true, transformation(origin = {-60, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLimitation currentLimitation(IMaxPu = IMaxPu,IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, PMaxPu = PMaxPu, UdFilter0Pu = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-22, -1}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.QControl qControl(DroopUQ = DroopUQ, IqConv0Pu = IqConv0Pu, QMaxPu = QMaxPu, QRef0Pu = QRef0Pu, UdFilter0Pu = UdFilter0Pu, tauIqRef = tauIqRef) annotation(
    Placement(visible = true, transformation(origin = {-60, -13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-105, 20}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation

  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-110, 75}, {-71, 75}}, color = {0, 0, 127}));
  connect(UdcPu, dCCurrentControl.UdcPu) annotation(
    Line(points = {{25, -90}, {25, -77}, {48.5, -77}}, color = {0, 0, 127}));
  connect(UdcRefPu, dCCurrentControl.UdcRefPu) annotation(
    Line(points = {{0, -90}, {0, -65}, {48.5, -65}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu, dCCurrentControl.IdcSourceRefPu) annotation(
    Line(points = {{-25, -90}, {-25, -53}, {48.5, -53}}, color = {0, 0, 127}));
  connect(dCCurrentControl.IdcSourcePu, IdcSourcePu) annotation(
    Line(points = {{82, -65}, {110, -65}}, color = {0, 0, 127}));
  connect(uqFilterPu, pll.uqFilterPu) annotation(
    Line(points = {{-110, 55}, {-88, 55}, {-88, 64}, {-71, 64}}, color = {0, 0, 127}));
  connect(pll.omegaPu, currentControl.omegaPu) annotation(
    Line(points = {{-49, 65}, {-3, 65}, {-3, 9}, {6, 9}}, color = {0, 0, 127}));
  connect(udFilterPu, currentControl.udFilterPu) annotation(
    Line(points = {{-110, 35}, {12, 35}, {12, 16}}, color = {0, 0, 127}));
  connect(uqFilterPu, currentControl.uqFilterPu) annotation(
    Line(points = {{-110, 55}, {19, 55}, {19, 16}}, color = {0, 0, 127}));
  connect(pll.omegaPu, omegaPu) annotation(
    Line(points = {{-49, 65}, {67, 65}, {67, 45}, {110, 45}}, color = {0, 0, 127}));
  connect(pll.theta, theta) annotation(
    Line(points = {{-49, 75}, {110, 75}}, color = {0, 0, 127}));
  connect(omegaRefPu, pControl.omegaRefPu) annotation(
    Line(points = {{-110, 75}, {-83, 75}, {-83, 16}, {-71, 16}}, color = {0, 0, 127}));
  connect(udFilterPu, pControl.udFilterPu) annotation(
    Line(points = {{-110, 35}, {-79, 35}, {-79, 10}, {-71, 10}}, color = {0, 0, 127}));
  connect(udFilterPu, qControl.udFilterPu) annotation(
    Line(points = {{-110, 35}, {-94, 35}, {-94, -5}, {-71, -5}}, color = {0, 0, 127}));
  connect(UFilterRefPu, qControl.UFilterRefPu) annotation(
    Line(points = {{-110, -35}, {-90, -35}, {-90, -21}, {-71, -21}}, color = {0, 0, 127}));
  connect(iqConvPu, currentControl.iqConvPu) annotation(
    Line(points = {{-110, -75}, {-36, -75}, {-36, -26}, {19, -26}, {19, -18}}, color = {0, 0, 127}));
  connect(UdcPu, modulation.UdcPu) annotation(
    Line(points = {{25, -90}, {25, -35}, {51, -35}, {51, -12}}, color = {0, 0, 127}));
  connect(modulation.udConvPu, udConvPu) annotation(
    Line(points = {{87, 7}, {90, 7}, {90, 15}, {110, 15}}, color = {0, 0, 127}));
  connect(modulation.uqConvPu, uqConvPu) annotation(
    Line(points = {{87, -9}, {90, -9}, {90, -15}, {110, -15}}, color = {0, 0, 127}));
  connect(pControl.idConvRefNLPu, currentLimitation.idConvRefNLPu) annotation(
    Line(points = {{-49, 18}, {-40, 18}, {-40, 9}}, color = {0, 0, 127}));
  connect(qControl.iqConvRefNLPu, currentLimitation.iqConvRefNLPu) annotation(
    Line(points = {{-49, -13}, {-44.5, -13}, {-44.5, -11}, {-40, -11}}, color = {0, 0, 127}));
  connect(pControl.idMaxPu, currentLimitation.idMaxPu) annotation(
    Line(points = {{-49, 9}, {-44, 9}, {-44, -1}, {-40, -1}}, color = {0, 0, 127}));
  connect(currentControl.uqConvRefPu, modulation.uqConvRefPu) annotation(
    Line(points = {{40, -6}, {44, -6}, {44, 4}, {51, 4}, {51, 4}}, color = {0, 0, 127}));
  connect(currentControl.udConvRefPu, modulation.udConvRefPu) annotation(
    Line(points = {{40, 4}, {41, 4}, {41, 10}, {51, 10}, {51, 10}}, color = {0, 0, 127}));
  connect(UdcRefPu, modulation.UdcRefPu) annotation(
    Line(points = {{0, -90}, {0, -90}, {0, -30}, {47, -30}, {47, -6}, {51, -6}, {51, -6}}, color = {0, 0, 127}));
  connect(currentLimitation.idConvRefPu, currentControl.idConvRefPu) annotation(
    Line(points = {{-4, 5}, {0, 5}, {0, -1}, {6, -1}, {6, -1}}, color = {0, 0, 127}));
  connect(currentLimitation.iqConvRefPu, currentControl.iqConvRefPu) annotation(
    Line(points = {{-4, -8}, {0, -8}, {0, -10}, {6, -10}, {6, -10}}, color = {0, 0, 127}));
  connect(PRefPu, pControl.PRefPu) annotation(
    Line(points = {{-110, 15}, {-85, 15}, {-85, 5}, {-71, 5}}, color = {0, 0, 127}));
  connect(uqFilterPu, qControl.uqFilterPu) annotation(
    Line(points = {{-110, 55}, {-88, 55}, {-88, -10}, {-71, -10}}, color = {0, 0, 127}));
  connect(idConvPu, currentControl.idConvPu) annotation(
    Line(points = {{-110, -55}, {-43, -55}, {-43, -21}, {12, -21}, {12, -18}}, color = {0, 0, 127}));
  connect(pll.omegaPu, pControl.omegaPu) annotation(
    Line(points = {{-49, 65}, {-44, 65}, {-44, 30}, {-74, 30}, {-74, 21}, {-71, 21}, {-71, 21}}, color = {0, 0, 127}));
  connect(QRefPu, qControl.QRefPu) annotation(
    Line(points = {{-110, -15}, {-71, -15}, {-71, -16}, {-71, -16}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-100, -80}, {100, 80}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, extent = {{-100, -80}, {100, 80}}, initialScale = 0.1), graphics = {Rectangle(origin = {1, 0.5}, extent = {{-101, 79.5}, {99, -80.5}}), Text(origin = {6.5, -2}, extent = {{-63.5, 47}, {63.5, -47}}, textString = "Gfol")}));

end GridFollowingControl;
