within Dynawo.Electrical;

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

model Shunt "Shunt element with voltage dependent reactive power, constant susceptance"

public
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the shunt to the grid" annotation(
  Placement(visible = true, transformation(origin = {-1.42109e-14, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu UPu(start = ComplexMath.'abs'(u0Pu)) "Voltage amplitude at shunt terminal in p.u (base UNom)";
  Types.ActivePowerPu PPu(start = s0Pu.re) "Active power at shunt terminal in p.u (base SnRef, receptor convention)";
  Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at shunt terminal in p.u (base SnRef, receptor convention)";
  Types.ComplexApparentPowerPu SPu(re (start = s0Pu.re), im (start = s0Pu.im)) "Apparent power at shunt terminal in p.u (base SnRef, receptor convention)";

  parameter Types.ReactivePowerPu QRefPu "Reactive power request at nominal voltage (base SnRef, receptor convention, negative values for capacitive reception, overexcited operation)";  

protected
  parameter Types.VoltageModulePu UNomPu = 1 "Nominal voltage amplitude";
  parameter Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at shunt terminal in p.u (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu  "Start value of apparent power at shunt terminal in p.u (base SnRef, receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu  "Start value of complex current at shunt terminal in p.u (base UNom, SnRef, receptor convention)";

equation
  SPu = Complex(PPu, QPu);
  SPu = terminal.V * ComplexMath.conj(terminal.i);     
  UPu = ComplexMath.'abs'(terminal.V);
  QPu = QRefPu * (UPu/UNomPu)^2;  
  PPu = 0;

annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(origin = {0, -24}, points = {{0, 16}, {0, -16}}, thickness = 1), Line(origin = {0, -40}, points = {{-20, 0}, {20, 0}}, thickness = 1), Line(origin = {0, -50}, points = {{-20, 0}, {20, 0}}, thickness = 1), Line(origin = {0, -79.9949}, points = {{-20, 0}, {20, 0}}, thickness = 1), Line(origin = {0, -65}, points = {{0, 15}, {0, -15}}, thickness = 1)}));

end Shunt;
