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

model GridFormingControlDroopControl "Grid Forming Control with Droop Control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  Connectors.ImPin udConvRefPuPin(value(start = UdConv0Pu));
  Connectors.ImPin uqConvRefPuPin(value(start = UqConv0Pu));
  Connectors.ImPin omegaPuPin(value(start = SystemBase.omegaRef0Pu));
  Connectors.ImPin thetaPin(value(start = Theta0));
  Connectors.ImPin IdcSourcePuPin(value(start = IdcSource0Pu));

  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Mp "Active power droop control coefficient";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Rfilter "Filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Kpv "Proportional gain of the voltage loop";
  parameter Types.PerUnit Kiv "Integral gain of the voltage loop";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.PerUnit Kpdc "Proportional gain of the dc voltage control";

  Modelica.Blocks.Interfaces.RealInput idPccPu (start = IdPcc0Pu) "d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-53, -35}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-66, -19}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu (start = IqPcc0Pu) "q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-53, -40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-62, 15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start = SystemBase.omegaRef0Pu) "grid frequency in p.u" annotation(
    Placement(visible = true, transformation(origin = {-53, -45}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-62, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu (start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, -55}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-16, -36}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu (start = 0) "q-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, -50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {25, -15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvPu (start = IdConv0Pu) "d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-53, -25}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-83, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu (start = IqConv0Pu) "q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-53, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-84, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu (start = PRef0Pu) "active power reference at the converter's capacitor in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, 29}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu (start = QRef0Pu) "reactive power reference at the converter's capacitor in p.u (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, 11}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-61, 5}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu (start = UdFilter0Pu) "reference voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, 16}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-89, 1}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IdcSourceRefPu (start = IdcSourceRef0Pu) "reference DC Current generated by the DC current source in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, -62}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-68, -64}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourceRefPu (start = UdcSource0Pu) "reference DC voltage on the DC side in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, -70}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {21, -72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourcePu (start = UdcSource0Pu) "DC voltage on the DC side in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-53, -78}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {1, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput theta (start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame" annotation(
    Placement(visible = true, transformation(origin = {72, 24}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu (start = UdConv0Pu) "reference d-axis modulated voltage created by the converter in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {72, 29}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu (start = UqConv0Pu) "reference q-axis modulated voltage created by the converter in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {72, 11}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IdcSourcePu (start = IdcSource0Pu) "DC Current generated by the DC current source in p.u (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {72, -70}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu (start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {72, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {71, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentLoop(Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, Rfilter = Rfilter, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, UdFilter0Pu = UdFilter0Pu, IdConv0Pu=IdConv0Pu, IqConv0Pu=IqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VoltageLoop voltageLoop(Cfilter = Cfilter, Kiv = Kiv, Kpv = Kpv, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, UdFilter0Pu = UdFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.VirtualImpedance virtualImpedance(KpVI = KpVI, XRratio = XRratio, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DroopControl droopControl(Kff = Kff, Mp = Mp, Mq = Mq, PRef0Pu = PRef0Pu, QRef0Pu = QRef0Pu, Wf = Wf, Wff = Wff, Theta0 = Theta0, IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu, UdFilter0Pu = UdFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.DCVoltageControl dCVoltageControl(Kpdc = Kpdc, IdcSource0Pu = IdcSource0Pu, IdcSourceRef0Pu = IdcSourceRef0Pu, UdcSource0Pu = UdcSource0Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.PerUnit IdPcc0Pu;
  parameter Types.PerUnit IqPcc0Pu;
  parameter Types.PerUnit UdFilter0Pu;
  parameter Types.PerUnit IdConv0Pu;
  parameter Types.PerUnit IqConv0Pu;
  parameter Types.PerUnit UdConv0Pu;
  parameter Types.PerUnit UqConv0Pu;
  parameter Types.Angle Theta0;
  parameter Types.PerUnit PRef0Pu;
  parameter Types.PerUnit QRef0Pu;
  parameter Types.PerUnit IdcSourceRef0Pu;
  parameter Types.PerUnit IdcSource0Pu;
  parameter Types.PerUnit UdcSource0Pu;

equation

  connect(udConvRefPuPin.value, udConvRefPu);
  connect(uqConvRefPuPin.value, uqConvRefPu);
  connect(IdcSourcePuPin.value, IdcSourcePu);
  connect(omegaPuPin.value, omegaPu);
  connect(thetaPin.value, theta);
  connect(voltageLoop.idConvRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{31, 29}, {38, 29}, {38, 29}, {39, 29}}, color = {0, 0, 127}));
  connect(voltageLoop.iqConvRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{31, 11}, {39, 11}, {39, 11}, {39, 11}}, color = {0, 0, 127}));
  connect(droopControl.uqFilterRefPu, voltageLoop.uqFilterRefPu) annotation(
    Line(points = {{1, 11}, {9, 11}, {9, 11}, {9, 11}}, color = {0, 0, 127}));
  connect(droopControl.udFilterRefPu, voltageLoop.udFilterRefPu) annotation(
    Line(points = {{1, 29}, {9, 29}, {9, 29}, {9, 29}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, voltageLoop.omegaPu) annotation(
    Line(points = {{1, 20}, {8, 20}, {8, 20}, {9, 20}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{1, 20}, {39, 20}, {39, 20}, {39, 20}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVId, droopControl.DeltaVVId) annotation(
    Line(points = {{-19, -1}, {-19, 9}}, color = {0, 0, 127}));
  connect(virtualImpedance.DeltaVVIq, droopControl.DeltaVVIq) annotation(
    Line(points = {{-19, -19}, {-16, -19}, {-16, 9}}, color = {0, 0, 127}));
  connect(idConvPu, virtualImpedance.idConvPu) annotation(
    Line(points = {{-53, -25}, {-45, -25}, {-45, -1}, {-41, -1}, {-41, -1}}, color = {0, 0, 127}));
  connect(iqConvPu, virtualImpedance.iqConvPu) annotation(
    Line(points = {{-53, -30}, {-44, -30}, {-44, -19}, {-41, -19}, {-41, -19}}, color = {0, 0, 127}));
  connect(idPccPu, droopControl.idPccPu) annotation(
    Line(points = {{-53, -35}, {-13, -35}, {-13, 9}, {-13, 9}}, color = {0, 0, 127}));
  connect(iqPccPu, droopControl.iqPccPu) annotation(
    Line(points = {{-53, -40}, {-10, -40}, {-10, 9}, {-10, 9}}, color = {0, 0, 127}));
  connect(omegaRefPu, droopControl.omegaRefPu) annotation(
    Line(points = {{-53, -45}, {-7, -45}, {-7, 9}, {-7, 9}}, color = {0, 0, 127}));
  connect(uqFilterPu, droopControl.uqFilterPu) annotation(
    Line(points = {{-53, -50}, {-4, -50}, {-4, 9}, {-4, 9}}, color = {0, 0, 127}));
  connect(udFilterPu, droopControl.udFilterPu) annotation(
    Line(points = {{-53, -55}, {-1, -55}, {-1, 9}, {-1, 9}}, color = {0, 0, 127}));
  connect(udFilterPu, voltageLoop.udFilterPu) annotation(
    Line(points = {{-53, -55}, {12, -55}, {12, 9}, {12, 9}}, color = {0, 0, 127}));
  connect(uqFilterPu, voltageLoop.uqFilterPu) annotation(
    Line(points = {{-53, -50}, {16, -50}, {16, 9}, {16, 9}}, color = {0, 0, 127}));
  connect(idPccPu, voltageLoop.idPccPu) annotation(
    Line(points = {{-53, -35}, {24, -35}, {24, 9}, {24, 9}}, color = {0, 0, 127}));
  connect(iqPccPu, voltageLoop.iqPccPu) annotation(
    Line(points = {{-53, -40}, {28, -40}, {28, 9}, {28, 9}}, color = {0, 0, 127}));
  connect(udFilterPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-53, -55}, {42, -55}, {42, 9}, {42, 9}}, color = {0, 0, 127}));
  connect(uqFilterPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{-53, -50}, {46, -50}, {46, 9}, {46, 9}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{-53, -25}, {54, -25}, {54, 9}, {54, 9}}, color = {0, 0, 127}));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{-53, -30}, {58, -30}, {58, 9}, {58, 9}}, color = {0, 0, 127}));
  connect(QRefPu, droopControl.QRefPu) annotation(
    Line(points = {{-53, 11}, {-22, 11}, {-22, 11}, {-21, 11}}, color = {0, 0, 127}));
  connect(UFilterRefPu, droopControl.UFilterRefPu) annotation(
    Line(points = {{-53, 16}, {-22, 16}, {-22, 16}, {-21, 16}}, color = {0, 0, 127}));
  connect(PRefPu, droopControl.PRefPu) annotation(
    Line(points = {{-53, 29}, {-22, 29}, {-22, 29}, {-21, 29}}, color = {0, 0, 127}));
  connect(UdcSourceRefPu, dCVoltageControl.UdcSourceRefPu) annotation(
    Line(points = {{-53, -70}, {39, -70}}, color = {0, 0, 127}));
  connect(IdcSourceRefPu, dCVoltageControl.IdcSourceRefPu) annotation(
    Line(points = {{-53, -62}, {39, -62}}, color = {0, 0, 127}));
  connect(UdcSourcePu, dCVoltageControl.UdcSourcePu) annotation(
    Line(points = {{-53, -78}, {39, -78}}, color = {0, 0, 127}));
  connect(droopControl.theta, theta) annotation(
    Line(points = {{1, 24}, {72, 24}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{61, 29}, {69, 29}, {69, 29}, {72, 29}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{61, 11}, {70, 11}, {70, 11}, {72, 11}}, color = {0, 0, 127}));
  connect(dCVoltageControl.IdcSourcePu, IdcSourcePu) annotation(
    Line(points = {{61, -70}, {70, -70}, {70, -70}, {72, -70}}, color = {0, 0, 127}));
  connect(droopControl.omegaPu, omegaPu) annotation(
    Line(points = {{1, 20}, {70, 20}, {70, 20}, {72, 20}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));

end GridFormingControlDroopControl;
