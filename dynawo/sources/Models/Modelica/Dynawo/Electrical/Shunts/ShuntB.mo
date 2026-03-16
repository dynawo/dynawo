within Dynawo.Electrical.Shunts;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model ShuntB "Shunt element with constant susceptance, reactive power depends on voltage"
  extends AdditionalIcons.Shunt;
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffShunt;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the shunt to the grid" annotation(
  Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.VoltageModulePu UPu(start = ComplexMath.'abs'(u0Pu)) "Voltage amplitude at shunt terminal in pu (base UNom)";
  Types.ActivePowerPu PPu(start = s0Pu.re) "Active power at shunt terminal in pu (base SnRef, receptor convention)";
  Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at shunt terminal in pu (base SnRef, receptor convention)";
  Types.ComplexApparentPowerPu SPu(re(start = s0Pu.re), im(start = s0Pu.im)) "Apparent power at shunt terminal in pu (base SnRef, receptor convention)";

  parameter Types.PerUnit BPu "Susceptance in pu (base SnRef), negative values for capacitive consumption (over-excited), positive values for inductive consumption (under-excited)";

  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at shunt terminal in pu (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at shunt terminal in pu (base SnRef, receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at shunt terminal in pu (base UNom, SnRef, receptor convention)";

equation
  SPu = Complex(PPu, QPu);
  SPu = terminal.V * ComplexMath.conj(terminal.i);
  UPu = ComplexMath.'abs'(terminal.V);

  if (running.value) then
    QPu = BPu * UPu^2;
    PPu = 0;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end ShuntB;
