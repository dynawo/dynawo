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
  Modelica.Blocks.Interfaces.BooleanInput AutomatonExists = true "Pin to indicate to deactivate internal automaton natively present in C++ object";
  Modelica.Blocks.Interfaces.RealInput IMonitored "Monitored current (unit depending on IMax unit)";

  //Output
  Modelica.Blocks.Interfaces.IntegerOutput order "Order emitted by the CLA (it should be a value corresponding to a state: [1:OPEN, 2:CLOSED, 3:CLOSED_1, 4:CLOSED_2, 5:CLOSED_3, 6:UNDEFINED])";

protected
  discrete Types.Time tThresholdReached(start = Constants.inf) "Time when IMonitored > IMax was first reached in s";
  discrete Types.Time tOrder(start = Constants.inf) "Last time the automaton emitted an order in s";

equation
  when IMonitored > IMax and Running and pre(order) <> OrderToEmit then
    Constraint.logConstraintWithData(ConstraintKeys.OverloadUpCLA, true, "OverloadUp", IMax, IMonitored, String(tLagBeforeActing, significantDigits = 2));
    tThresholdReached = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonArming);
  elsewhen IMonitored < IMax and pre(tThresholdReached) <> Constants.inf and pre(order) <> OrderToEmit then
    Constraint.logConstraintWithData(ConstraintKeys.OverloadUpCLA, false, "OverloadUp", IMax, IMonitored, String(tLagBeforeActing, significantDigits = 2));
    tThresholdReached = Constants.inf;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonDisarming);
  end when;

  when time - tThresholdReached >= tLagBeforeActing then
    Constraint.logConstraintWithData(ConstraintKeys.OverloadOpenCLA, true, "OverloadOpen", IMax, IMonitored, String(tLagBeforeActing, significantDigits = 2));
    order = OrderToEmit;
    tOrder = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonActing);
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will open one or several components when the current stays higher than a predefined threshold during a certain amount of time on a monitored component (line, transformer, etc.).</body></html>"));
end CurrentLimitAutomaton;
