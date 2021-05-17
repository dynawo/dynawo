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
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit PmaxPu            "Maximal converter active power in p.u (base SNom)";
  parameter Types.PerUnit QmaxPu            "Maximal converter reactive power in p.u (base SNom)";
  parameter Types.PerUnit ImaxPu            "Maximal converter valve current in p.u (base UNom, SNom)";

  parameter Types.PerUnit Rfilter           "Converter filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Lfilter           "Converter filter inductance in p.u (base UNom, SNom)";

  parameter Types.PerUnit KpPll             "Proportional gain of the phase-locked loop (PLL)";
  parameter Types.PerUnit KiPll             "Integral gain of the phase-locked loop (PLL)";
  parameter Types.PerUnit Kpc               "Proportional gain of the current loop";
  parameter Types.PerUnit Kic               "Integral gain of the current loop";
  parameter Types.PerUnit Kpdc              "Proportional gain of the dc voltage control";
  parameter Types.PerUnit DroopUQ           "Proportional gain of the reactive power loop (AC voltage regulation), such that Qsp=Qref+DroopUQ*(UacRef-Uac)";
  parameter Types.PerUnit DroopFP           "Proportional gain of the active power loop (frequency regulation), such that Psp=Pref-DroopFP*(fnom-f)";
  parameter Types.Time tauIdRef             "Approximation of the response time of the active power loop is seconds";
  parameter Types.Time tauIqRef             "Approximation of the response time of the reactive power loop is seconds";
  parameter Types.PerUnit RPmaxPu           "Maximal primary reserve in p.u (base SNom)";

  parameter Types.Angle Theta0              "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";
  parameter Types.PerUnit UdFilter0Pu       "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit UdConv0Pu         "Start value of the d-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit UqConv0Pu         "Start value of the q-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu         "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu         "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";

  parameter Types.PerUnit PRef0Pu           "Start value of the active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit QRef0Pu           "Start value of the reactive power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit Udc0Pu      "Start value of the DC bus voltage in p.u (base UNom)";
  parameter Types.PerUnit IdcSource0Pu      "Start value of the DC source current in p.u (base UNom, SNom)";
  parameter Types.PerUnit IdcSourceRef0Pu  "Start value of the DC source current reference in p.u (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-57, 54}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -14}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 1}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 85}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Rective power reference at the converter terminal (filter) in p.u (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, -16}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 57}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UdFilter0Pu) "AC voltage reference at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -21}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 14}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -4}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {17, -105}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {38, -105}, extent = {{5, 5}, {-5, -5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 29}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {61, -105}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-58, 19}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {86, -105}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu(start = IdcSource0Pu) "DC source reference current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -54}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -57}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "DC bus reference voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -38}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -84}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC bus voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -46}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-8, -105}, extent = {{5, -5}, {-5, 5}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {67, 54}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 83}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = 0) "Converter angular frequency in p.u (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 48}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 42}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvPu(start = UdConv0Pu) "d-axis converter modulated voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 39}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 3}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvPu(start = UqConv0Pu) "q-axis converter modulated voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 31}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -36}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu(start = IdcSource0Pu) "DC source injected current in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {68, -46}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -76}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.PLL pll(KiPll = KiPll, KpPll = KpPll, Theta0 = Theta0)  annotation(
    Placement(visible = true, transformation(origin = {-20, 51}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.Modulation modulation(UdConv0Pu = UdConv0Pu, Udc0Pu = Udc0Pu, UqConv0Pu = UqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {49, 35}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentControl(IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, Rfilter = Rfilter, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {20, 35}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DCVoltageControl dCCurrentControl(IdcSource0Pu = IdcSource0Pu, Kpdc = Kpdc, Udc0Pu = Udc0Pu, IdcSourceRef0Pu = IdcSourceRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {46, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.PControl pControl(DroopFP = DroopFP,IdConv0Pu = IdConv0Pu, PRef0Pu = PRef0Pu, PmaxPu = PmaxPu, RPmaxPu = RPmaxPu, UdFilter0Pu = UdFilter0Pu, tauIdRef = tauIdRef) annotation(
    Placement(visible = true, transformation(origin = {-37.5, 2.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLimitation currentLimitation(IdConv0Pu = IdConv0Pu, ImaxPu = ImaxPu, IqConv0Pu = IqConv0Pu, PmaxPu = PmaxPu, UdFilter0Pu = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-13.5, -6.5}, extent = {{-6.5, -6.5}, {6.5, 6.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.QControl qControl(DroopUQ = DroopUQ, IqConv0Pu = IqConv0Pu, QRef0Pu = QRef0Pu, QmaxPu = QmaxPu, UdFilter0Pu = UdFilter0Pu, tauIqRef = tauIqRef) annotation(
    Placement(visible = true, transformation(origin = {-37.5, -14.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));

  Modelica.Blocks.Sources.Step IdConvRefPu(height = 0.1, offset = IdConv0Pu, startTime = 0.4) annotation(
    Placement(visible = true, transformation(origin = {-18, 25}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Step IqConvRefPu(height = 0, offset = IqConv0Pu, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-18, 12}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

equation
  connect(pll.theta, theta) annotation(
    Line(points = {{-13, 54}, {67, 54}}, color = {0, 0, 127}));
  connect(pll.omegaPu, omegaPu) annotation(
    Line(points = {{-13, 48}, {67, 48}}, color = {0, 0, 127}));
  connect(modulation.udConvPu, udConvPu) annotation(
    Line(points = {{58, 39}, {67, 39}}, color = {0, 0, 127}));
  connect(modulation.uqConvPu, uqConvPu) annotation(
    Line(points = {{58, 31}, {67, 31}}, color = {0, 0, 127}));
  connect(UdcRefPu, modulation.UdcRefPu) annotation(
    Line(points = {{-58, -38}, {30, -38}, {30, 33}, {40, 33}}, color = {0, 0, 127}));
  connect(currentControl.omegaPu, pll.omegaPu) annotation(
    Line(points = {{11, 42}, {-5, 42}, {-5, 48}, {-13, 48}}, color = {0, 0, 127}));
  connect(uqFilterPu, currentControl.uqFilterPu) annotation(
    Line(points = {{-58, 40}, {11, 40}}, color = {0, 0, 127}));
  connect(currentControl.udConvRefPu, modulation.udConvRefPu) annotation(
    Line(points = {{29, 41}, {40, 41}}, color = {0, 0, 127}));
  connect(currentControl.uqConvRefPu, modulation.uqConvRefPu) annotation(
    Line(points = {{29, 37}, {40, 37}}, color = {0, 0, 127}));
  connect(idConvPu, currentControl.idConvPu) annotation(
    Line(points = {{-58, 29}, {-32, 29}, {-32, 35}, {11, 35}}, color = {0, 0, 127}));
  connect(iqConvPu, currentControl.iqConvPu) annotation(
    Line(points = {{-58, 19}, {-26, 19}, {-26, 32}, {11, 32}, {11, 33}}, color = {0, 0, 127}));
  connect(udFilterPu, currentControl.udFilterPu) annotation(
    Line(points = {{-58, -4}, {-68, -4}, {-68, 38}, {11, 38}}, color = {0, 0, 127}));
  connect(dCCurrentControl.IdcSourcePu, IdcSourcePu) annotation(
    Line(points = {{57, -46}, {68, -46}}, color = {0, 0, 127}));
  connect(UdcRefPu, dCCurrentControl.UdcRefPu) annotation(
    Line(points = {{-58, -38}, {35, -38}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu, dCCurrentControl.IdcSourceRefPu) annotation(
    Line(points = {{-58, -54}, {35, -54}}, color = {0, 0, 127}));
  connect(UdcPu, modulation.UdcPu) annotation(
    Line(points = {{-58, -46}, {32, -46}, {32, 29}, {40, 29}}, color = {0, 0, 127}));
  connect(UdcPu, dCCurrentControl.UdcPu) annotation(
    Line(points = {{-58, -46}, {35, -46}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-57, 54}, {-27, 54}, {-27, 54}, {-27, 54}}, color = {0, 0, 127}));
  connect(uqFilterPu, pll.uqFilterPu) annotation(
    Line(points = {{-58, 40}, {-37, 40}, {-37, 47}, {-27, 47}}, color = {0, 0, 127}));
  connect(pControl.idConvRefNLPu, currentLimitation.idConvRefNLPu) annotation(
    Line(points = {{-30, 6}, {-24, 6}, {-24, -2}, {-20, -2}}, color = {0, 0, 127}));
  connect(pControl.idMaxPu, currentLimitation.idMaxPu) annotation(
    Line(points = {{-30, 0}, {-27, 0}, {-27, -6}, {-20, -6}}, color = {0, 0, 127}));
  connect(qControl.iqConvRefNLPu, currentLimitation.iqConvRefNLPu) annotation(
    Line(points = {{-30, -15}, {-24, -15}, {-24, -11}, {-20, -11}}, color = {0, 0, 127}));
  connect(qControl.udFilterPu, udFilterPu) annotation(
    Line(points = {{-45, -7}, {-64, -7}, {-64, -4}, {-58, -4}}, color = {0, 0, 127}));
  connect(UFilterRefPu, qControl.UFilterRefPu) annotation(
    Line(points = {{-58, -21}, {-45, -21}}, color = {0, 0, 127}));
  connect(QRefPu, qControl.QRefPu) annotation(
    Line(points = {{-58, -16}, {-45, -16}}, color = {0, 0, 127}));
  connect(uqFilterPu, qControl.uqFilterPu) annotation(
    Line(points = {{-58, 40}, {-71, 40}, {-71, -12}, {-45, -12}}, color = {0, 0, 127}));
  connect(udFilterPu, pControl.udFilterPu) annotation(
    Line(points = {{-58, -4}, {-45, -4}, {-45, -4}, {-45, -4}}, color = {0, 0, 127}));
  connect(PRefPu, pControl.PRefPu) annotation(
    Line(points = {{-58, 1}, {-45, 1}}, color = {0, 0, 127}));
  connect(pll.omegaPu, pControl.omegaPu) annotation(
    Line(points = {{-13, 48}, {77, 48}, {77, 63}, {-78, 63}, {-78, 4}, {-45, 4}, {-45, 5}}, color = {0, 0, 127}));
  connect(omegaRefPu, pControl.omegaRefPu) annotation(
    Line(points = {{-57, 54}, {-75, 54}, {-75, 8}, {-46, 8}, {-46, 9}, {-45, 9}}, color = {0, 0, 127}));
  connect(currentLimitation.idConvRefPu, currentControl.idConvRefPu) annotation(
    Line(points = {{-7, -4}, {-2, -4}, {-2, 30}, {11, 30}, {11, 30}}, color = {0, 0, 127}));
  connect(currentLimitation.iqConvRefPu, currentControl.iqConvRefPu) annotation(
    Line(points = {{-7, -9}, {3, -9}, {3, 27}, {11, 27}, {11, 28}, {11, 28}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 0.5}, extent = {{-100, 99.5}, {100, -100.5}}), Text(origin = {6.5, -2}, extent = {{-63.5, 47}, {63.5, -47}}, textString = "Gfol")}));

end GridFollowingControl;
