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

model DispatchableVirtualOscillatorControl "Dispatchable Virtual Oscillator Control"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Eta "Parameter Eta in the dVOC control in p.u (base UNom, SNom)";
  parameter Types.PerUnit Alpha "Parameter Alpha in the dVOC control in p.u (base UNom, SNom)";
  parameter Types.PerUnit KDvoc "Parameter KDvoc in the dVOC control in rad";

  Types.VoltageModulePu vConvrefRawmodule (start = VFilterd0);
  Types.PerUnit vConvrefRawd (start = VFilterd0);
  Types.PerUnit vConvrefRawq (start = VFilterq0);
  Modelica.Blocks.Interfaces.RealInput vFilterd(start = VFilterd0) "d-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput vFilterq (start = VFilterq0) "q-axis voltage at the converter's capacitor in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iPCCd(start = IPCCd0) "d-axis current in the grid" annotation(
    Placement(visible = true, transformation(origin = {-80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iPCCq (start = IPCCq0) "q-axis current in the grid" annotation(
    Placement(visible = true, transformation(origin = {-40, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
    Placement(visible = true, transformation(origin = {33, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wref(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Veffref(start = VFilterd0) annotation(
    Placement(visible = true, transformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVId(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput vFilterdref(start = VFilterd0) annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput DeltaVVIq(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-120, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput vFilterqref(start = VFilterq0) annotation(
    Placement(visible = true, transformation(origin = {110, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {81, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {49, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pref(start=Pref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qref (start=Qref0) annotation(
    Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.PerUnit Pref0 "Start value of the active power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit Qref0 "Start value of the reactive power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit IPCCd0;
  parameter Types.PerUnit IPCCq0;
  parameter Types.PerUnit VFilterd0;
  parameter Types.PerUnit VFilterq0;
  parameter Types.Angle Theta0;

equation

  connect(omegaPu, feedback2.u1) annotation(
    Line(points = {{33, 60}, {41, 60}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-120, 90}, {49, 90}, {49, 68}}, color = {0, 0, 127}));
  connect(feedback2.y, integrator.u) annotation(
    Line(points = {{58, 60}, {69, 60}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{92, 60}, {110, 60}}, color = {0, 0, 127}));

  vConvrefRawd * tan(theta) = vConvrefRawq;
  vConvrefRawmodule = sqrt(vConvrefRawd ^ 2 + vConvrefRawq ^ 2);
  der(vConvrefRawmodule) = Eta * vConvrefRawmodule * cos(KDvoc) * ((pref / (Veffref ^ 2)) - ((vFilterd * iPCCd + vFilterq * iPCCq) / (vConvrefRawmodule ^ 2))) - Eta * vConvrefRawmodule * sin(KDvoc) * (- (qref / (Veffref ^ 2)) + ((vFilterq * iPCCd - vFilterd * iPCCq) / (vConvrefRawmodule ^ 2))) + Eta * Alpha * (1 - (vConvrefRawmodule/Veffref) ^ 2) * vConvrefRawmodule;
  omegaPu * SystemBase.omegaNom = Eta * cos(KDvoc) * (-(qref / (Veffref ^ 2)) + ((vFilterq * iPCCd - vFilterd * iPCCq) / (vConvrefRawmodule ^ 2))) + Eta * sin(KDvoc) * ((pref / (Veffref ^ 2)) - ((vFilterd * iPCCd + vFilterq * iPCCq) / (vConvrefRawmodule ^ 2))) + wref * SystemBase.omegaNom;
  vFilterqref = vConvrefRawq - DeltaVVIq;
  vFilterdref = vConvrefRawd - DeltaVVId;

  annotation(
   Diagram(coordinateSystem(grid = {1, 1})),
   preferredView = "diagram",
   Icon(coordinateSystem(grid = {1, 1})));

end DispatchableVirtualOscillatorControl;