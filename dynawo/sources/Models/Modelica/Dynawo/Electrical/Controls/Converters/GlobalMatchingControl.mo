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

model GlobalMatchingControl "Global Matching Control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit K "Proportional gain of the matching control";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";

  parameter Types.PerUnit icdref0;
  parameter Types.PerUnit icqref0;
  parameter Types.PerUnit DeltaVVIq0;
  parameter Types.PerUnit DeltaVVId0;
  parameter Types.PerUnit yIntegratord_voltageLoop0;
  parameter Types.PerUnit yIntegratorq_voltageLoop0;
  parameter Types.PerUnit iod0;
  parameter Types.PerUnit ioq0;
  parameter Types.PerUnit vod0;
  parameter Types.PerUnit voq0;
  parameter Types.PerUnit icd0;
  parameter Types.PerUnit icq0;
  parameter Types.PerUnit vodref0;
  parameter Types.PerUnit voqref0;
  parameter Types.PerUnit omega0Pu;
  parameter Types.PerUnit yIntegratord_currentLoop0;
  parameter Types.PerUnit yIntegratorq_currentLoop0;
  parameter Types.PerUnit vcdref0;
  parameter Types.PerUnit vcqref0;
  parameter Types.PerUnit omegaRef0Pu;
  parameter Types.PerUnit wref0;
  parameter Types.Angle deph0;
  parameter Types.PerUnit Veffref0;
  parameter Types.PerUnit idcref0;
  parameter Types.PerUnit idc0;
  parameter Types.PerUnit vdc0;
  parameter Types.PerUnit vdcref0;

  Dynawo.Electrical.Controls.Converters.BasicBlocks.CurrentLoop currentLoop(Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, icdref0 = icdref0, icqref0 = icqref0, omega0Pu = omega0Pu, vcdref0 = vcdref0, vcqref0 = vcqref0, vod0 = vod0, voq0 = voq0, icd0=icd0, icq0=icq0, yIntegratord0 = yIntegratord_currentLoop0, yIntegratorq0 = yIntegratorq_currentLoop0)  annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BasicBlocks.VoltageLoop voltageLoop(Cfilter = Cfilter, Kiv = Kiv, Kpv = Kpv, icdref0 = icdref0, icqref0 = icqref0, iod0 = iod0, ioq0 = ioq0, omega0Pu = omega0Pu, vod0 = vod0, vodref0 = vodref0, voq0 = voq0, voqref0 = voqref0, yIntegratord0 = yIntegratord_voltageLoop0, yIntegratorq0 = yIntegratorq_voltageLoop0)  annotation(
    Placement(visible = true, transformation(origin = {20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BasicBlocks.VirtualImpedance virtualImpedance(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, KpVI = KpVI, XRratio = XRratio, icd0 = icd0, icq0 = icq0)  annotation(
    Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BasicBlocks.DCVoltageControl dCVoltageControl(Kpdc = Kpdc, idc0 = idc0, idcref0 = idcref0, vdc0 = vdc0, vdcref0 = vdcref0)  annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BasicBlocks.MatchingControl matchingControl(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, K = K, Veffref0 = Veffref0, deph0 = deph0, omega0Pu = omega0Pu, omegaRef0Pu = omegaRef0Pu, vdc0 = vdc0, vdcref0 = vdcref0, vodref0 = vodref0, voqref0 = voqref0, wref0 = wref0)  annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput iod (start = iod0) annotation(
    Placement(visible = true, transformation(origin = {-53, -35}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-66, -19}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ioq (start = ioq0) annotation(
    Placement(visible = true, transformation(origin = {-53, -40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-62, 15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start = omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-53, -45}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-62, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vod (start = vod0) annotation(
    Placement(visible = true, transformation(origin = {-53, -55}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-16, -36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput voq (start = voq0) annotation(
    Placement(visible = true, transformation(origin = {-53, -50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {25, -15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput icd (start = icd0) annotation(
    Placement(visible = true, transformation(origin = {-53, -25}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-83, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput icq (start = icq0) annotation(
    Placement(visible = true, transformation(origin = {-53, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-84, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wref (start = wref0) annotation(
    Placement(visible = true, transformation(origin = {-53, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-80, 14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Veffref (start = Veffref0) annotation(
    Placement(visible = true, transformation(origin = {-53, 14}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-89, 1}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idcref (start = idcref0) annotation(
    Placement(visible = true, transformation(origin = {-53, -62}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-68, -64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdcref (start = vdcref0) annotation(
    Placement(visible = true, transformation(origin = {-53, -70}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {21, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vdc (start = vdc0) annotation(
    Placement(visible = true, transformation(origin = {-53, -78}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {1, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput deph (start = deph0) annotation(
    Placement(visible = true, transformation(origin = {72, 24}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput vcdref (start = vcdref0) annotation(
    Placement(visible = true, transformation(origin = {72, 29}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput vcqref (start = vcqref0) annotation(
    Placement(visible = true, transformation(origin = {72, 11}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idc (start = idc0) annotation(
    Placement(visible = true, transformation(origin = {72, -70}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu (start = omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {72, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {71, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Connectors.ImPin vcdrefPin(value(start=vcdref0));
  Connectors.ImPin vcqrefPin(value(start=vcqref0));
  Connectors.ImPin omegaPuPin(value(start=omega0Pu));
  Connectors.ImPin dephPin(value(start=deph0));
  Connectors.ImPin idcPin(value(start=idc0));

equation

  connect(vcdrefPin.value, vcdref);
  connect(vcqrefPin.value, vcqref);
  connect(idcPin.value, idc);
  connect(omegaPuPin.value, omegaPu);
  connect(dephPin.value, deph);
  connect(voltageLoop.icdref, currentLoop.icdref) annotation(
    Line(points = {{31, 29}, {38, 29}, {38, 29}, {39, 29}}, color = {0, 0, 127}));
  connect(voltageLoop.icqref, currentLoop.icqref) annotation(
    Line(points = {{31, 11}, {39, 11}, {39, 11}, {39, 11}}, color = {0, 0, 127}));
  connect(icd, virtualImpedance.icd) annotation(
    Line(points = {{-53, -25}, {-45, -25}, {-45, -1}, {-41, -1}, {-41, -1}}, color = {0, 0, 127}));
  connect(icq, virtualImpedance.icq) annotation(
    Line(points = {{-53, -30}, {-44, -30}, {-44, -19}, {-41, -19}, {-41, -19}}, color = {0, 0, 127}));
  connect(vod, voltageLoop.vod) annotation(
    Line(points = {{-53, -55}, {12, -55}, {12, 9}, {12, 9}}, color = {0, 0, 127}));
  connect(voq, voltageLoop.voq) annotation(
    Line(points = {{-53, -50}, {16, -50}, {16, 9}, {16, 9}}, color = {0, 0, 127}));
  connect(iod, voltageLoop.iod) annotation(
    Line(points = {{-53, -35}, {24, -35}, {24, 9}, {24, 9}}, color = {0, 0, 127}));
  connect(ioq, voltageLoop.ioq) annotation(
    Line(points = {{-53, -40}, {28, -40}, {28, 9}, {28, 9}}, color = {0, 0, 127}));
  connect(vod, currentLoop.vod) annotation(
    Line(points = {{-53, -55}, {42, -55}, {42, 9}, {42, 9}}, color = {0, 0, 127}));
  connect(voq, currentLoop.voq) annotation(
    Line(points = {{-53, -50}, {46, -50}, {46, 9}, {46, 9}}, color = {0, 0, 127}));
  connect(icd, currentLoop.icd) annotation(
    Line(points = {{-53, -25}, {54, -25}, {54, 9}, {54, 9}}, color = {0, 0, 127}));
  connect(icq, currentLoop.icq) annotation(
    Line(points = {{-53, -30}, {58, -30}, {58, 9}, {58, 9}}, color = {0, 0, 127}));
  connect(vdcref, dCVoltageControl.vdcref) annotation(
    Line(points = {{-53, -70}, {39, -70}}, color = {0, 0, 127}));
  connect(idcref, dCVoltageControl.idcref) annotation(
    Line(points = {{-53, -62}, {39, -62}}, color = {0, 0, 127}));
  connect(vdc, dCVoltageControl.vdc) annotation(
    Line(points = {{-53, -78}, {39, -78}}, color = {0, 0, 127}));
  connect(currentLoop.vcdref, vcdref) annotation(
    Line(points = {{61, 29}, {69, 29}, {69, 29}, {72, 29}}, color = {0, 0, 127}));
  connect(currentLoop.vcqref, vcqref) annotation(
    Line(points = {{61, 11}, {70, 11}, {70, 11}, {72, 11}}, color = {0, 0, 127}));
  connect(dCVoltageControl.idc, idc) annotation(
    Line(points = {{61, -70}, {70, -70}, {70, -70}, {72, -70}}, color = {0, 0, 127}));
  connect(vdcref, matchingControl.vdcref) annotation(
    Line(points = {{-53, -70}, {-46, -70}, {-46, 26}, {-21, 26}, {-21, 26}}, color = {0, 0, 127}));
  connect(wref, matchingControl.wref) annotation(
    Line(points = {{-53, 20}, {-21, 20}}, color = {0, 0, 127}));
  connect(Veffref, matchingControl.Veffref) annotation(
    Line(points = {{-53, 14}, {-21, 14}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVId, matchingControl.DeltaVVId) annotation(
    Line(points = {{-19, -1}, {-17, -1}, {-17, 9}, {-17, 9}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVIq, matchingControl.DeltaVVIq) annotation(
    Line(points = {{-19, -19}, {-13, -19}, {-13, 9}, {-13, 9}}, color = {0, 0, 127}));
  connect(omegaRefPu, matchingControl.omegaRefPu) annotation(
    Line(points = {{-53, -45}, {-7, -45}, {-7, 9}, {-7, 9}}, color = {0, 0, 127}));
  connect(vdc, matchingControl.vdc) annotation(
    Line(points = {{-53, -78}, {-3, -78}, {-3, 9}, {-3, 9}}, color = {0, 0, 127}));
  connect(matchingControl.vodref, voltageLoop.vodref) annotation(
    Line(points = {{1, 29}, {8, 29}, {8, 29}, {9, 29}}, color = {0, 0, 127}));
  connect(matchingControl.omegaPu, voltageLoop.omegaPu) annotation(
    Line(points = {{1, 20}, {9, 20}, {9, 20}, {9, 20}}, color = {0, 0, 127}));
  connect(matchingControl.voqref, voltageLoop.voqref) annotation(
    Line(points = {{1, 11}, {8, 11}, {8, 11}, {9, 11}}, color = {0, 0, 127}));
  connect(matchingControl.deph, deph) annotation(
    Line(points = {{1, 24}, {69, 24}, {69, 24}, {72, 24}}, color = {0, 0, 127}));
  connect(matchingControl.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{1, 20}, {38, 20}, {38, 20}, {39, 20}}, color = {0, 0, 127}));
  connect(matchingControl.omegaPu, omegaPu) annotation(
    Line(points = {{1, 20}, {70, 20}, {70, 20}, {72, 20}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));

end GlobalMatchingControl;
