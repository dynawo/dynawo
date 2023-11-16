within Dynawo.Electrical.Controls.Current;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentLimitAutomatonTwoLevels "Current Limit Automaton (CLA) monitoring two components"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  //Monitored component 1 parameters
  parameter Types.CurrentModule IMax1 "Maximum current on monitored component 1 (unit depending on IMonitored1 unit)";
  parameter Boolean Running1 "True if CLA 1 is activated";
  parameter Types.Time tLagBeforeActing1 "Time lag before taking action for monitored component 1 in s";
  parameter Integer OrderToEmit1 "Order to emit by CLA 1 (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

  //Monitored component 2 parameters
  parameter Types.CurrentModule IMax2 "Maximum current on monitored component 2 (unit depending on IMonitored2 unit)";
  parameter Boolean Running2 "True if CLA 2 is activated";
  parameter Types.Time tLagBeforeActing2 "Time lag before taking action for monitored component 2 in s";
  parameter Integer OrderToEmit2 "Order to emit by CLA 2 (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

  //Inputs
  Dynawo.Connectors.BPin AutomatonExists(value = true) "Pin to indicate to deactivate internal automaton natively present in C++ object";
  Dynawo.Connectors.ImPin IMonitored1 "Monitored current on element 1 (unit depending on IMax1 unit)";
  Dynawo.Connectors.ImPin IMonitored2 "Monitored current on element 2 (unit depending on IMax2 unit)";

  //Outputs
  Dynawo.Connectors.IntPin order "Order emitted by the CLA (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

  //Blocks
  CurrentLimitAutomaton currentLimitAutomaton1(IMax = IMax1, OrderToEmit = OrderToEmit1, Running = Running1, tLagBeforeActing = tLagBeforeActing1);
  CurrentLimitAutomaton currentLimitAutomaton2(IMax = IMax2, OrderToEmit = OrderToEmit2, Running = Running2, tLagBeforeActing = tLagBeforeActing2);

equation
  when currentLimitAutomaton1.order.value == 1 or currentLimitAutomaton2.order.value == 1 or (currentLimitAutomaton1.order.value == 3 and currentLimitAutomaton2.order.value == 4) or (currentLimitAutomaton1.order.value == 4 and currentLimitAutomaton2.order.value == 3) then
    order.value = 1;
  elsewhen currentLimitAutomaton1.order.value == 2 and currentLimitAutomaton2.order.value == 2 then
    order.value = 2;
  elsewhen ((currentLimitAutomaton1.order.value == 2 or currentLimitAutomaton1.order.value == 0) and currentLimitAutomaton2.order.value == 3) or (currentLimitAutomaton1.order.value == 3 and (currentLimitAutomaton2.order.value == 2 or currentLimitAutomaton2.order.value == 0)) or (currentLimitAutomaton1.order.value == 3 and currentLimitAutomaton2.order.value == 3) then
    order.value = 3;
  elsewhen ((currentLimitAutomaton1.order.value == 2 or currentLimitAutomaton1.order.value == 0) and currentLimitAutomaton2.order.value == 4) or (currentLimitAutomaton1.order.value == 4 and (currentLimitAutomaton2.order.value == 2 or currentLimitAutomaton2.order.value == 0)) or (currentLimitAutomaton1.order.value == 4 and currentLimitAutomaton2.order.value == 4) then
    order.value = 4;
  end when;

  connect(IMonitored1, currentLimitAutomaton1.IMonitored);
  connect(IMonitored2, currentLimitAutomaton2.IMonitored);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will open one component when the current stays higher than a predefined threshold during a certain amount of time on two monitored components (line, transformer, etc.) (one threshold and one time constant per element).</body></html>"));
end CurrentLimitAutomatonTwoLevels;
