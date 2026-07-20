within Dynawo.Electrical.Controls.Utilities;

model ChangeofBaseSNom "Change of base from SnRef to SNom"
  /*
    * Copyright (c) 2026, RTE (http://www.rte-france.com)
    * See AUTHORS.txt
    * All rights reserved.
    * This Source Code Form is subject to the terms of the Mozilla Public
    * License, v. 2.0. If a copy of the MPL was not distributed with this
    * file, you can obtain one at http://mozilla.org/MPL/2.0/.
    * SPDX-License-Identifier: MPL-2.0
    *
    * This file is part of Dynawo, an hybrid C++/Modelica open source suite
    * of simulation tools for power systems.
    */
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";
  Connectors.ACPower terminalSNref(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(transformation(origin = {98, 4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}})));
  Connectors.ACPower terminalSNom annotation(
    Placement(transformation(origin = {-102, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-104, 2}, extent = {{-10, -10}, {10, 10}})));
  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  // Final parameters
  final parameter Types.ComplexPerUnit UPcc0Pu = u0Pu "Start value of the complex voltage at the PCC in pu (base UNom)";
  final parameter Types.ComplexPerUnit IPcc0Pu = i0Pu*SystemBase.SnRef/SNom "Start value of the complex current at terminal in pu (base UNom, SNom) (receptor convention)";
equation
  terminalSNom.V = terminalSNref.V;
  terminalSNom.i = terminalSNref.i*SystemBase.SnRef/SNom;

  annotation(
    preferredView = "diagram");
end ChangeofBaseSNom;
