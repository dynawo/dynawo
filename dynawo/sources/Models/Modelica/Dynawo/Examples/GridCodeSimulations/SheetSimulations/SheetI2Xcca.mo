within Dynawo.Examples.GridCodeSimulations.SheetSimulations;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SheetI2Xcca
  extends Icons.Example;
  extends Dynawo.Examples.GridCodeSimulations.BaseSheetSimulations.BaseSheetI2(XccPu = XccPu_To_Be_Defined);
  extends Dynawo.Examples.GridCodeSimulations.BaseUnitModel(URefPu(height = 0.02), XccPu = XccPu_To_Be_Defined);

  parameter Types.PerUnit XccPu_To_Be_Defined = XaPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

equation
  connect(Xcc_a.terminal2, Unit.terminal) annotation(
    Line(points = {{-20, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I2 Xcc = a")}),
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body>The event simulated is a 2% step order at t=2s on the plant voltage droop regulation required from PEIRs connected to the grid. Here, the short circuit impedance is small, emulating a strong grid situation. The test is described thoroughly in fiche I2 from the french grid code.</body></html>"));
end SheetI2Xcca;
