within Dynawo.Electrical.Controls.Protections.BaseClasses;

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

partial model BaseUFLS "Base model for under-frequency load shedding relays"
  import Modelica.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Integer NbSteps(min = 1, max = 10) "Number of steps in the UFLS scheme";
  parameter Types.Time tFilter = 0.01 "Time constant of the load change filter in s";
  parameter Types.Time tLagAction "Time-lag due to the actual tripping action in s";
  parameter Types.AngularVelocityPu[NbSteps] omegaThresholdPu "Frequency threshold of the UFLS scheme in pu (base omegaNom) (for each step of the UFLS scheme)";
  parameter Real[NbSteps] UFLSStep "Share of load disconnected by a step of UFLS (sum of all steps should be at most 1) (for each step of the UFLS scheme)";

  input Types.AngularVelocityPu omegaMonitoredPu "Monitored frequency in pu (base omegaNom)";

  Real deltaPQ(start = 0) "Delta to apply on PRef and QRef in % due to UFLS disconnections, to connect to the variables deltaP and deltaQ in the load model";
  Real deltaPQfiltered(start = 0) "Smoothed out version of deltaPQ for better numerical stability";

  Types.Time[NbSteps] tThresholdReached(each start = Constants.inf) "Time when reaches the ith UFLS threshold (for each step of the UFLS scheme)";
  Real[NbSteps] loadReduction(each start = 0) "Share of load disconnected by a step of UFLS (for each step of the UFLS scheme)";
  Boolean[NbSteps] stepActivated(each start = false) "true if the ith step of UFLS has been activated (for each step of the UFLS scheme)";

equation
  der(deltaPQfiltered) * tFilter = deltaPQ - deltaPQfiltered;

  for i in 1:NbSteps loop
    when omegaMonitoredPu <= omegaThresholdPu[i] and not pre(stepActivated[i]) then
      tThresholdReached[i] = time;
      if i == 1 then
        Timeline.logEvent1(TimelineKeys.UFLS1Arming);
      elseif i == 2 then
        Timeline.logEvent1(TimelineKeys.UFLS2Arming);
      elseif i == 3 then
        Timeline.logEvent1(TimelineKeys.UFLS3Arming);
      elseif i == 4 then
        Timeline.logEvent1(TimelineKeys.UFLS4Arming);
      elseif i == 5 then
        Timeline.logEvent1(TimelineKeys.UFLS5Arming);
      elseif i == 6 then
        Timeline.logEvent1(TimelineKeys.UFLS6Arming);
      elseif i == 7 then
        Timeline.logEvent1(TimelineKeys.UFLS7Arming);
      elseif i == 8 then
        Timeline.logEvent1(TimelineKeys.UFLS8Arming);
      elseif i == 9 then
        Timeline.logEvent1(TimelineKeys.UFLS9Arming);
      else
        Timeline.logEvent1(TimelineKeys.UFLS10Arming);
      end if;
    end when;
  end for;

  // Trips
  for i in 1:NbSteps loop
    when time - tThresholdReached[i] >= tLagAction then
      stepActivated[i] = true;
      loadReduction[i] = UFLSStep[i];
      if i == 1 then
        Timeline.logEvent1(TimelineKeys.UFLS1Activated);
      elseif i == 2 then
        Timeline.logEvent1(TimelineKeys.UFLS2Activated);
      elseif i == 3 then
        Timeline.logEvent1(TimelineKeys.UFLS3Activated);
      elseif i == 4 then
        Timeline.logEvent1(TimelineKeys.UFLS4Activated);
      elseif i == 5 then
        Timeline.logEvent1(TimelineKeys.UFLS5Activated);
      elseif i == 6 then
        Timeline.logEvent1(TimelineKeys.UFLS6Activated);
      elseif i == 7 then
        Timeline.logEvent1(TimelineKeys.UFLS7Activated);
      elseif i == 8 then
        Timeline.logEvent1(TimelineKeys.UFLS8Activated);
      elseif i == 9 then
        Timeline.logEvent1(TimelineKeys.UFLS9Activated);
      else
        Timeline.logEvent1(TimelineKeys.UFLS10Activated);
      end if;
    end when;
  end for;

  deltaPQ = -sum(loadReduction);  // Sum of the step sizes of the UFLS steps that are activated

  annotation(preferredView = "text");
end BaseUFLS;
