within Dynawo.Electrical.Controls.Converters.BasicBlocks;

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

model DispatchableVirtualOscillatorControl "Dispatchable Virtual Oscillator Control"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  
  parameter Types.PerUnit Eta "Parameter Eta in the dVOC control in p.u (base UNom, SNom)";
  parameter Types.PerUnit Alpha "Parameter Alpha in the dVOC control in p.u (base UNom, SNom)";
  parameter Types.PerUnit Theta "Parameter Theta in the dVOC control in rad";  
  parameter Types.PerUnit Veffref0 "Start value of the voltage reference at the converter's capacitor in p.u (base UNom)";
  parameter Types.PerUnit Pref0 "Start value of the active power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit Qref0 "Start value of the reactive power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit iod0;
  parameter Types.PerUnit ioq0;
  parameter Types.PerUnit vod0;
  parameter Types.PerUnit voq0;
  parameter Types.PerUnit omega0Pu;
  parameter Types.PerUnit omegaRef0Pu;
  parameter Types.PerUnit wref0;
  parameter Types.PerUnit voqref0;
  parameter Types.PerUnit vodref0;
  parameter Types.PerUnit DeltaVVIq0;
  parameter Types.PerUnit DeltaVVId0;
  parameter Types.Angle deph0;
  parameter Types.PerUnit vorefRawmodule0;
  
  Types.VoltageModulePu vorefRawmodule (start = vorefRawmodule0);
  Types.PerUnit vorefRawd (start = vodref0);
  Types.PerUnit vorefRawq (start = voqref0);
  Modelica.Blocks.Interfaces.RealInput vod(start = vod0) "d-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90))); 
  Modelica.Blocks.Interfaces.RealInput voq (start = voq0) "q-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));   
  Modelica.Blocks.Interfaces.RealInput iod(start = iod0) "d-axis current in the grid" annotation(
    Placement(visible = true, transformation(origin = {-80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90))); 
  Modelica.Blocks.Interfaces.RealInput ioq (start = ioq0) "q-axis current in the grid" annotation(
    Placement(visible = true, transformation(origin = {-40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = omega0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {33, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wref(start = wref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput deph(start = deph0) annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Veffref(start = Veffref0) annotation(
    Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = DeltaVVId0) annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput vodref(start = vodref0) annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = DeltaVVIq0) annotation(
    Placement(visible = true, transformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput voqref(start = voqref0) annotation(
    Placement(visible = true, transformation(origin = {110, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {81, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {49, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pref(start=Pref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qref (start=Qref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
equation

  connect(omegaPu, feedback2.u1) annotation(
    Line(points = {{33, 60}, {41, 60}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-120, 90}, {49, 90}, {49, 68}}, color = {0, 0, 127}));
  connect(feedback2.y, integrator.u) annotation(
    Line(points = {{58, 60}, {69, 60}}, color = {0, 0, 127}));
  connect(integrator.y, deph) annotation(
    Line(points = {{92, 60}, {110, 60}}, color = {0, 0, 127}));
  
  vorefRawd * tan(deph) = vorefRawq; 
  vorefRawmodule = sqrt(vorefRawd ^ 2 + vorefRawq ^ 2);
  der(vorefRawmodule) = Eta * vorefRawmodule * cos(Theta) * ((pref / (Veffref ^ 2)) - ((vod * iod + voq * ioq) / (vorefRawmodule ^ 2))) - Eta * vorefRawmodule * sin(Theta) * (- (qref / (Veffref ^ 2)) + ((voq * iod - vod * ioq) / (vorefRawmodule ^ 2))) + Eta * Alpha * (1 - (vorefRawmodule/Veffref) ^ 2) * vorefRawmodule;
  omegaPu * SystemBase.omegaNom = Eta * cos(Theta) * (-(qref / (Veffref ^ 2)) + ((voq * iod - vod * ioq) / (vorefRawmodule ^ 2))) + Eta * sin(Theta) * ((pref / (Veffref ^ 2)) - ((vod * iod + voq * ioq) / (vorefRawmodule ^ 2))) + wref * SystemBase.omegaNom;
  voqref = vorefRawq - DeltaVVIq;
  vodref = vorefRawd - DeltaVVId;
  
  annotation(
    Diagram(coordinateSystem(grid = {1, 1})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));
    
end DispatchableVirtualOscillatorControl;