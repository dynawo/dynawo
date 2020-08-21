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

model ShuntBNonLinear "Shunt element with voltage dependent reactive power and a variable susceptance given by a table and a section"

  import Dynawo.Connectors;
  import Dynawo.Types;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Modelica;

  extends SwitchOff.SwitchOffLoad;

public
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the shunt to the grid";

  parameter Real section0 "Initial section of the shunt";
  parameter String tableBPuName "Name of the table to calculate BPu from the section of the shunt";
  parameter String tableBPuFile "File containing the table to calculate BPu from the section of the shunt";
  Modelica.Blocks.Tables.CombiTable1D tableBPu(tableOnFile = true, tableName = tableBPuName, fileName = tableBPuFile) "Table to get BPu from section";

  Types.VoltageModulePu UPu(start = ComplexMath.'abs'(u0Pu)) "Voltage amplitude at shunt terminal in p.u (base UNom)";
  Types.ActivePowerPu PPu(start = 0) "Active power at shunt terminal in p.u (base SnRef, receptor convention)";
  Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at shunt terminal in p.u (base SnRef, receptor convention)";
  Types.ComplexApparentPowerPu SPu(re (start = 0), im (start = s0Pu.im)) "Apparent power at shunt terminal in p.u (base SnRef, receptor convention)";
  Connectors.ZPin section(value (start = section0)) "section position of the shunt";
  Types.PerUnit BPu(start = - s0Pu.im / ComplexMath.'abs'(u0Pu)^2) "Variable susceptance of the shunt in p.u (base SnRef, UNom)";

protected
  parameter Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at shunt terminal in p.u (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu  "Start value of apparent power at shunt terminal in p.u (base SnRef, receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu  "Start value of complex current at shunt terminal in p.u (base UNom, SnRef, receptor convention)";

equation

  section.value = tableBPu.u[1];
  BPu = tableBPu.y[1];

  if (running.value) then
    SPu = Complex(PPu, QPu);
    SPu = terminal.V * ComplexMath.conj(terminal.i);
    UPu = ComplexMath.'abs'(terminal.V);
    QPu = - BPu * UPu ^ 2;
    PPu = 0;
  else
    terminal.i.re = 0;
    terminal.i.im = 0;
    terminal.V.re = 0;
    terminal.V.im = 0;
    UPu = 0;
    QPu = 0;
    PPu = 0;
  end if;

annotation(preferredView = "text");

end ShuntBNonLinear;
