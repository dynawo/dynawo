within Dynawo.Electrical.Controls.Converters.BaseControls;

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

model DispatchableVirtualOscillatorControl "Dispatchable virtual oscillator control for grid forming converters"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Eta "Parameter Eta in the dVOC control in pu (base UNom, SNom)";
  parameter Types.PerUnit Alpha "Parameter Alpha in the dVOC control in pu (base UNom, SNom)";
  parameter Types.PerUnit KDvoc "Parameter KDvoc in the dVOC control in rad";

  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-25, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {25, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = UFilterRef0Pu) "Voltage module reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = DeltaVVId0) "d-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) "q-axis virtual impedance output in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-50, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QRef0Pu) "Reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {33, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterRefPu(start = UdFilter0Pu) "d-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterRefPu(start = UqFilter0Pu) "q-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {81, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {49, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  parameter Types.ActivePowerPu PRef0Pu "Start value of the active power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  parameter Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";
  parameter Types.VoltageModulePu UFilterRef0Pu "Start value of voltage module reference at the converter's capacitor in pu (base UNom)";

  Types.VoltageModulePu UFilterRefRawPu(start = UFilterRef0Pu);
  Types.PerUnit udFilterRefRawPu(start = UdFilter0Pu);
  Types.PerUnit uqFilterRefRawPu(start = UqFilter0Pu);

equation
  udFilterRefRawPu * tan(theta) = uqFilterRefRawPu;
  UFilterRefRawPu = sqrt(udFilterRefRawPu ^ 2 + uqFilterRefRawPu ^ 2);
  der(UFilterRefRawPu) = Eta * UFilterRefRawPu * cos(KDvoc) * ((PRefPu / (UFilterRefPu ^ 2)) - ((udFilterPu * idPccPu + uqFilterPu * iqPccPu) / (UFilterRefRawPu ^ 2))) - Eta * UFilterRefRawPu * sin(KDvoc) * (- (QRefPu / (UFilterRefPu ^ 2)) + ((uqFilterPu * idPccPu - udFilterPu * iqPccPu) / (UFilterRefRawPu ^ 2))) + Eta * Alpha * (1 - (UFilterRefRawPu/UFilterRefPu) ^ 2) * UFilterRefRawPu;
  omegaPu * SystemBase.omegaNom = Eta * cos(KDvoc) * (-(QRefPu / (UFilterRefPu ^ 2)) + ((uqFilterPu * idPccPu - udFilterPu * iqPccPu) / (UFilterRefRawPu ^ 2))) + Eta * sin(KDvoc) * ((PRefPu / (UFilterRefPu ^ 2)) - ((udFilterPu * idPccPu + uqFilterPu * iqPccPu) / (UFilterRefRawPu ^ 2))) + SystemBase.omegaRef0Pu * SystemBase.omegaNom;
  uqFilterRefPu = uqFilterRefRawPu - DeltaVVIq;
  udFilterRefPu = udFilterRefRawPu - DeltaVVId;
  connect(omegaPu, feedback2.u1) annotation(
    Line(points = {{33, 60}, {41, 60}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-120, 90}, {49, 90}, {49, 68}}, color = {0, 0, 127}));
  connect(feedback2.y, integrator.u) annotation(
    Line(points = {{58, 60}, {69, 60}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{92, 60}, {110, 60}}, color = {0, 0, 127}));

  annotation(
   Diagram(coordinateSystem(grid = {1, 1})),
   preferredView = "diagram",
   Icon(coordinateSystem(grid = {1, 1})));
end DispatchableVirtualOscillatorControl;