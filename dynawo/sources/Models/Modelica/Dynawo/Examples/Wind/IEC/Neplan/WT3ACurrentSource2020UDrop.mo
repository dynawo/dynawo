within Dynawo.Examples.Wind.IEC.Neplan;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT3ACurrentSource2020UDrop "Wind Turbine Type 3A model from IEC 61400-27-1 standard with infinite bus - voltage drop test"
  extends Icons.Example;
  extends WT3ACurrentSource2020(PRefPu.startTime=1e9, infiniteBusWithVariations.tUEvtStart=1, infiniteBusWithVariations.tUEvtEnd=1.1);
  
  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-05, Interval = 0.001),
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", nls = "kinsol", s = "ida", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10", emit_protected = "()"),
    Diagram(coordinateSystem(extent = {{-140, -70}, {140, 70}})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
  Documentation(info = "<html><head></head>
  <body><!--StartFragment-->
    <div style=\"background-color: rgb(255, 255, 255); font-family: Consolas, 'Courier New', monospace; font-size: 14px; line-height: 19px; white-space: pre;\"><div>This test case implements the IEC 61400-27-1 
<b>Type 3 A</b> wind turbine model
(explicit inner current loop, 
no crowbar implemented)
in a single machine infinite bus system.
As an event, a voltage drop to 0.2 pu with 100ms duration is used. 

The following image shows the drop 
and the model's P and Q responses. 

<b>Active power response:</b></div><div> <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/IEC/Resources/Images/type3aUDropP.png\"><br>
<b>Rective power response:</b></div><div> <img width=\"450\" src=\"modelica://Dynawo/Examples/Wind/IEC/Resources/Images/type3aUDropQ.png\"><figure>    </figure>

</div><!--EndFragment--></div></body></html>"));
end WT3ACurrentSource2020UDrop;
