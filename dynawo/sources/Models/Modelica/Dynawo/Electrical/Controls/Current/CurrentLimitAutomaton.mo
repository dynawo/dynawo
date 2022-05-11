within Dynawo.Electrical.Controls.Current;

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

model CurrentLimitAutomaton "Current Limit Automaton (CLA)"
  /* Open one/several lines when the current goes over a predefined threshold
     on one monitored component (line/transformer/danglingLine....) */
  import Modelica.Constants;
  import Dynawo.Connectors;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.CurrentModule IMax "Maximum current on the monitored component";
  parameter Boolean Running "Automaton activated ?";
  parameter Types.Time tLagBeforeActing "Time lag before taking action";
  parameter Integer OrderToEmit "Order to emit by automaton (it should be a value corresponding to a state: [1:OPEN, 2:CLOSE, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

  Connectors.ImPin IMonitored "Monitored current";
  Connectors.ZPin order "Order emitted by automaton";
  Connectors.BPin AutomatonExists(value = true) "Pin to indicate to deactivate internal automaton natively present in C++ object";

protected
  discrete Types.Time tThresholdReached(start = Constants.inf) "Time when I > IThreshold was first reached";
  discrete Types.Time tOrder(start = Constants.inf) "Last time the automaton emitted an order";

equation
  when IMonitored.value > IMax and Running and pre(order.value) <> OrderToEmit then
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonArming);
  elsewhen IMonitored.value < IMax and pre(tThresholdReached) <> Constants.inf and pre(order.value) <> OrderToEmit then
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonDisarming);
  end when;

  when time - tThresholdReached >= tLagBeforeActing then
    order.value = OrderToEmit;
    tOrder = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonActing);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will open one or several lines when the current stays higher than a predefined threshold during a certain amount of time on a monitored and controlled component (line, transformer, etc.)</body></html>"));
end CurrentLimitAutomaton;
