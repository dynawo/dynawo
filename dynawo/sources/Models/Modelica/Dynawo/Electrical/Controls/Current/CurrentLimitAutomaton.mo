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

model CurrentLimitAutomaton "Current Limit Automaton (CLA) monitoring one component"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Constraint;
  import Dynawo.NonElectrical.Logs.ConstraintKeys;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.CurrentModule IMax "Maximum current on the monitored component (unit depending on IMonitored unit)";
  parameter Integer OrderToEmit "Order to emit by the CLA (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";
  parameter Boolean Running "True if the CLA is activated";
  parameter Types.Time tLagBeforeActing "Time lag before taking action in s";

  //Inputs
  Dynawo.Connectors.BPin AutomatonExists(value = true) "Pin to indicate to deactivate internal automaton natively present in C++ object";
  Dynawo.Connectors.ImPin IMonitored "Monitored current (unit depending on IMax unit)";

  //Output
  Dynawo.Connectors.IntPin order "Order emitted by the CLA (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

protected
  discrete Types.Time tThresholdReached(start = Constants.inf) "Time when IMonitored > IMax was first reached in s";
  discrete Types.Time tOrder(start = Constants.inf) "Last time the automaton emitted an order in s";

equation
  when IMonitored.value > IMax and Running and pre(order.value) <> OrderToEmit then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax, IMonitored.value, String(tLagBeforeActing));
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonArming);
  elsewhen IMonitored.value < IMax and pre(tThresholdReached) <> Constants.inf and pre(order.value) <> OrderToEmit then
    Constraint.logConstraintEndData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax, IMonitored.value, String(tLagBeforeActing));
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonDisarming);
  end when;

  when time - tThresholdReached >= tLagBeforeActing then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadOpenCLA, "OverloadOpen", IMax, IMonitored.value, String(tLagBeforeActing));
    order.value = OrderToEmit;
    tOrder = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonActing);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will open one or several components when the current stays higher than a predefined threshold during a certain amount of time on a monitored component (line, transformer, etc.).</body></html>"));
end CurrentLimitAutomaton;
