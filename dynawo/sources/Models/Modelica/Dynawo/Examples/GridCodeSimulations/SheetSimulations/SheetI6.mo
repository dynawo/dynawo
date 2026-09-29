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

model SheetI6
  extends Icons.Example;
  extends Examples.GridCodeSimulations.BaseSheetSimulations.BaseSheetI6(XccPu = 0);
  extends Examples.GridCodeSimulations.BaseUnitModel(XccPu = 0);

equation
  connect(infiniteBusFromTable.terminal, Unit.terminal) annotation(
    Line(points = {{-100, 0}, {0, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, Unit.omegaRefPu) annotation(
    Line(points = {{80, -40}, {60, -40}, {60, -12}, {42, -12}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Text(origin = {0, 120}, extent = {{-100, 20}, {100, -20}}, textString = "I6")}),
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "ida", variableFilter = ".*"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 12px;\">The event simulated is a voltage dip imposed with an infinite bus at the production unit's connection point. The production unit should not disconnect and should inject reactive current during the dip and recover its active power rapidly if it follows the grid code's requirements. The test is described thoroughly in fiche I6 from the french grid code.</span></body></html>"));
end SheetI6;
