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

model ShuntBWithSections "Shunt element with voltage-dependent reactive power and a variable susceptance given by a table and a section"
  extends AdditionalIcons.Shunt;
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffShunt;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the shunt to the grid";
  Dynawo.Connectors.ZPin section(value(start = section0)) "Section position of the shunt";

  parameter Real section0 "Initial section of the shunt";
  parameter String TableBPuName "Name of the table to calculate BPu from the section of the shunt";
  parameter String TableBPuFile "File containing the table to calculate BPu from the section of the shunt";
  Modelica.Blocks.Tables.CombiTable1D tableBPu(tableOnFile = true, tableName = TableBPuName, fileName = TableBPuFile) "Table to get BPu from the section of the shunt";

  Types.VoltageModulePu UPu(start = ComplexMath.'abs'(u0Pu)) "Voltage amplitude at shunt terminal in pu (base UNom)";
  Types.ActivePowerPu PPu(start = 0) "Active power at shunt terminal in pu (base SnRef, receptor convention)";
  Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at shunt terminal in pu (base SnRef, receptor convention)";
  Types.ComplexApparentPowerPu SPu(re(start = 0), im(start = s0Pu.im)) "Apparent power at shunt terminal in pu (base SnRef, receptor convention)";
  Types.PerUnit BPu(start = - s0Pu.im / ComplexMath.'abs'(u0Pu)^2) "Variable susceptance of the shunt in pu (base SnRef, UNom)";

  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at shunt terminal in pu (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at shunt terminal in pu (base SnRef, receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at shunt terminal in pu (base UNom, SnRef, receptor convention)";

equation
  section.value = tableBPu.u[1];
  BPu = tableBPu.y[1];
  UPu = ComplexMath.'abs'(terminal.V);
  SPu = Complex(PPu, QPu);
  SPu = terminal.V * ComplexMath.conj(terminal.i);

  if (running.value) then
    QPu = - BPu * UPu ^ 2;
    PPu = 0;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end ShuntBWithSections;
