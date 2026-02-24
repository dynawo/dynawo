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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model CurrentLimitAutomatonTwoLevels "Current Limit Automaton (CLA) monitoring two components"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Constraint;
  import Dynawo.NonElectrical.Logs.ConstraintKeys;
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

protected
  //CLA 1 internals and output
  discrete Types.Time tThresholdReached1(start = Constants.inf) "Time when IMonitored1 > IMax1 was first reached in s";
  discrete Types.Time tOrder1(start = Constants.inf) "Last time the CLA1 emitted an order in s";
  discrete Integer Order1 "Output that would actually be emitted by CLA1";

  //CLA 2 internals and output
  discrete Types.Time tThresholdReached2(start = Constants.inf) "Time when IMonitored2 > IMax2 was first reached in s";
  discrete Types.Time tOrder2(start = Constants.inf) "Last time the CLA2 emitted an order in s";
  discrete Integer Order2 "Output that would actually be emitted by CLA2";

equation
  //CLA blocks substituted here to work around an annoying OMC bug

  //Block 1
  when IMonitored1.value > IMax1 and Running1 and pre(Order1) <> OrderToEmit1 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax1, IMonitored1.value, String(tLagBeforeActing1, significantDigits = 2));
    tThresholdReached1 = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonArming);
  elsewhen IMonitored1.value < IMax1 and pre(tThresholdReached1) <> Constants.inf and pre(Order1) <> OrderToEmit1 then
    Constraint.logConstraintEndData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax1, IMonitored1.value, String(tLagBeforeActing1, significantDigits = 2));
    tThresholdReached1 = Constants.inf;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonDisarming);
  end when;

  when tThresholdReached1 <> Constants.inf and tOrder1 == Constants.inf and der(IMonitored1.value) < 0 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax1, pre(IMonitored1.value), String(tLagBeforeActing1, significantDigits = 2));
  end when;

  when time - tThresholdReached1 >= tLagBeforeActing1 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadOpenCLA, "OverloadOpen", IMax1, IMonitored1.value, String(tLagBeforeActing1, significantDigits = 2));
    Order1 = OrderToEmit1;
    tOrder1 = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonActing);
  end when;

  //Block 2
  when IMonitored2.value > IMax2 and Running2 and pre(Order2) <> OrderToEmit2 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax2, IMonitored2.value, String(tLagBeforeActing2, significantDigits = 2));
    tThresholdReached2 = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonArming);
  elsewhen IMonitored2.value < IMax2 and pre(tThresholdReached2) <> Constants.inf and pre(Order2) <> OrderToEmit2 then
    Constraint.logConstraintEndData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax2, IMonitored2.value, String(tLagBeforeActing2, significantDigits = 2));
    tThresholdReached2 = Constants.inf;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonDisarming);
  end when;

  when tThresholdReached2 <> Constants.inf and tOrder2 == Constants.inf and der(IMonitored2.value) < 0 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadUpCLA, "OverloadUp", IMax2, pre(IMonitored2.value), String(tLagBeforeActing2, significantDigits = 2));
  end when;

  when time - tThresholdReached2 >= tLagBeforeActing2 then
    Constraint.logConstraintBeginData(ConstraintKeys.OverloadOpenCLA, "OverloadOpen", IMax2, IMonitored2.value, String(tLagBeforeActing2, significantDigits = 2));
    Order2 = OrderToEmit2;
    tOrder2 = time;
    Timeline.logEvent1(TimelineKeys.CurrentLimitAutomatonActing);
  end when;

  //Top-level orders merge
  when Order1 == 1 or Order2 == 1 or (Order1 == 3 and Order2 == 4) or (Order1 == 4 and Order2 == 3) then
    order.value = 1;
  elsewhen Order1 == 2 and Order2 == 2 then
    order.value = 2;
  elsewhen ((Order1 == 2 or Order1 == 0) and Order2 == 3) or (Order1 == 3 and (Order2 == 2 or Order2 == 0)) or (Order1 == 3 and Order2 == 3) then
    order.value = 3;
  elsewhen ((Order1 == 2 or Order1 == 0) and Order2 == 4) or (Order1 == 4 and (Order2 == 2 or Order2 == 0)) or (Order1 == 4 and Order2 == 4) then
    order.value = 4;
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The automaton will open one component when the current stays higher than a predefined threshold during a certain amount of time on two monitored components (line, transformer, etc.) (one threshold and one time constant per element).</body></html>"));
end CurrentLimitAutomatonTwoLevels;
