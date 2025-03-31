within Dynawo.Electrical.Controls.PEIR.Converters.Average;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DynVcGridFormingControlVSM

  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain";
  parameter Types.Time H "Inertia constant in s";

  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient";
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)";
  parameter Types.PerUnit Kff "Gain of the active damping";

  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 72}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -73}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 46}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -93}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -34}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-85, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-65, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -64}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {67, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, -52}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {87, -109}, extent = {{-9, -9}, {9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = PFilter0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 84}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 77}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 96}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 33}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage module reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 24}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 3}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-108, 8}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, -19}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaSetPu annotation(
    Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-109, 55}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 31}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {106, 84}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = Omega0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {106, 72}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));


  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.VoltageControls.VoltageReferenceControl voltageReferenceControl(DeltaVVId0 = VI.DeltaVVId0, DeltaVVIq0 = VI.DeltaVVIq0,IdPcc0Pu = IdPcc0Pu, IqPcc0Pu = IqPcc0Pu,Kff = Kff, Mq = Mq, QFilter0Pu = QFilter0Pu, URef0Pu = URef0Pu, UdRef0Pu = UdConv0Pu, UqRef0Pu = UqConv0Pu, Wf = Wf, Wff = Wff)  annotation(
    Placement(visible = true, transformation(origin = {-38, 24}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls.VSM VSM(H = H, PFilter0Pu = PFilter0Pu, kVSM = kVSM, Omega0Pu = Omega0Pu, Theta0 = Theta0)  annotation(
    Placement(visible = true, transformation(origin = {-46, 78}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.PEIR.BaseControls.VirtualImpedance2 VI(IMaxVI = IMaxVI, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, KpVI = KpVI, XRratio = XRratio)  annotation(
    Placement(visible = true, transformation(origin = {-75, -25}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage reference in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of q-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of converter's frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";

  final parameter Types.VoltageModulePu URef0Pu = sqrt(UdConv0Pu*UdConv0Pu + UqConv0Pu*UqConv0Pu) "Start value of voltage module reference in pu (base UNom)";

equation
  connect(VSM.omegaPu, omegaPu) annotation(
    Line(points = {{-28, 72}, {106, 72}}, color = {0, 0, 127}));
  connect(VSM.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{-64, 91}, {-72, 91}, {-72, 96}, {-108, 96}}, color = {0, 0, 127}, thickness = 0.5));
  connect(PFilterRefPu, VSM.PFilterRefPu) annotation(
    Line(points = {{-108, 84}, {-64, 84}}, color = {85, 170, 0}, thickness = 0.5));
  connect(PFilterPu, VSM.PFilterPu) annotation(
    Line(points = {{-108, 72}, {-64, 72}}, color = {85, 170, 0}));
  connect(VI.DeltaVVId, voltageReferenceControl.DeltaVVId) annotation(
    Line(points = {{-56.3, -16.5}, {-54, -16.5}, {-54, 6}}, color = {0, 0, 127}));
  connect(VI.DeltaVVIq, voltageReferenceControl.DeltaVVIq) annotation(
    Line(points = {{-56.3, -33.5}, {-46, -33.5}, {-46, 6}}, color = {0, 0, 127}));
  connect(iqConvPu, VI.iqConvPu) annotation(
    Line(points = {{-108, -34}, {-94, -34}}, color = {0, 0, 127}));
  connect(voltageReferenceControl.idPccPu, idPccPu) annotation(
    Line(points = {{-38, 6}, {-38, -52}, {-108, -52}}, color = {85, 170, 255}));
  connect(iqPccPu, voltageReferenceControl.iqPccPu) annotation(
    Line(points = {{-108, -64}, {-30, -64}, {-30, 6}}, color = {85, 170, 255}));
  connect(omegaSetPu, VSM.omegaSetPu) annotation(
    Line(points = {{-108, 60}, {-72, 60}, {-72, 66}, {-64, 66}}, color = {0, 0, 127}));
  connect(idConvPu, VI.idConvPu) annotation(
    Line(points = {{-108, -16}, {-94, -16}}, color = {245, 121, 0}));
  connect(VSM.theta, theta) annotation(
    Line(points = {{-28, 84}, {106, 84}}, color = {0, 0, 127}));
  connect(udConvRefPu, voltageReferenceControl.udRefPu) annotation(
    Line(points = {{107, 31}, {-20, 31}, {-20, 30}}, color = {245, 121, 0}, thickness = 0.5));
  connect(uqConvRefPu, voltageReferenceControl.uqRefPu) annotation(
    Line(points = {{107, 17}, {44, 17.5}, {44, 17.5}, {-20, 18}}, color = {245, 121, 0}, thickness = 0.5));
  connect(QFilterPu, voltageReferenceControl.QPu) annotation(
    Line(points = {{-108, 46}, {-46, 46}, {-46, 42}}, color = {85, 170, 0}));
  connect(URefPu, voltageReferenceControl.URefPu) annotation(
    Line(points = {{-108, 24}, {-56, 24}}, color = {245, 121, 0}, thickness = 0.5));
  connect(QFilterRefPu, voltageReferenceControl.QFilterRefPu) annotation(
    Line(points = {{-108, 8}, {-56, 8}}, color = {85, 170, 0}, thickness = 0.5));
  annotation(preferredView = "diagram",
    Diagram);
end DynVcGridFormingControlVSM;
