within Dynawo.Electrical.Controls.Topology;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model LackOfVoltageRelay
  import Modelica.Blocks.Interfaces;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Constants;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  import Dynawo.Types;

  type OpeningEnabledState = enumeration(Disable, Enable);
  type ReclosingEnabledState = enumeration(Disable, Enable);
  type SleepModeState = enumeration(Disable, Enable);
  type RecloserModeState = enumeration(EquipmentRecloser, BusRecloser, Recoupler);

  parameter Types.VoltageModulePu UMonitoredEquipmentTripPu = 0.2 "Eq voltage threshold to trigger";
  parameter Types.VoltageModulePu UMonitoredBusTripPu = 0.2 "Bus voltage threshold to trigger bus trip";
  parameter Types.VoltageModulePu UMonitoredEquipmentMinPu = 0.8 "Minimum  equipment voltage";
  parameter Types.VoltageModulePu UMonitoredBusMinPu = 0.8 "Minimum bus voltage";
  parameter Types.VoltageModulePu UMonitoredDeltaMaxPu = 0.01 "Maximum allowed voltage difference between bus and equipment";
  parameter Types.Angle UPhaseMonitoredDeltaMax = 30 "Maximum allowed phase angle difference";
  parameter Types.Time TripDelay = 2 "Trip delay time in seconds";
  parameter Types.Time RecloserDelay = 3 "Recloser delay time in seconds";
  parameter Types.Time SleepDuration = 10 "Sleep mode duration in seconds (stand by)";
  parameter RecloserModeState RecloserModeInput = RecloserModeState.EquipmentRecloser "Recloser operation mode input";
  parameter OpeningEnabledState OpeningEnabled = OpeningEnabledState.Enable "Current opening enable/disable state";
  parameter ReclosingEnabledState ReclosingEnabled = ReclosingEnabledState.Enable "Current reclosing enable/disable state";

  Interfaces.RealInput UMonitoredBusPu "Monitored bus voltage in pu (base UNom)";
  Interfaces.RealInput UPhaseMonitoredBus "Phase angle of the monitored bus";
  Interfaces.RealInput UMonitoredEquipmentPu "Monitored equipment voltage in pu (base UNom)";
  Interfaces.RealInput UPhaseMonitoredEquipment "Phase angle of the monitored equipment";

  Interfaces.IntegerOutput switchControlSignal(start = SwitchControlSignal0) "Signal that controls the switches state (open = 1, closed = 2)";

protected
  parameter SleepModeState SleepMode0 = SleepModeState.Disable "Initial setting of sleep mode";
  parameter Integer SwitchControlSignal0 = 2 "Initial setting of switch control signal (also sets state of controlled switch)";

  Boolean tripCond "Trip condition";
  Boolean tripTrigger "Trip trigger";
  Boolean eqRecCond "Equipment reclose condition";
  Boolean busRecCond "Bus reclose condition";
  Boolean recouplerCond "Recoupler reclose condition";
  Boolean recloseCond "Combined reclose condition";
  Boolean recloseTrigger "Reclose trigger";
  Boolean reclosePossible "Flag if reclose is possible due to sleep mode";
  discrete Types.Time tTripTriggered(start = Modelica.Constants.inf) "Time when the trip condition became True";
  discrete Types.Time tRecloserTriggered(start = Modelica.Constants.inf) "Time when recloser condition became True";
  discrete Types.Time tSleepStart(start = Modelica.Constants.inf) "Timer tracking sleep mode duration";
  discrete SleepModeState sleepMode(start = SleepMode0) "Current sleep mode state";

equation
  // Define trip condition: Opening enabled, switch closed, voltages below trip thresholds
  tripCond = (OpeningEnabled == OpeningEnabledState.Enable) and not (pre(switchControlSignal) == 1) and
             (UMonitoredEquipmentPu < UMonitoredEquipmentTripPu) and
             (UMonitoredBusPu < UMonitoredBusTripPu);

  // Define sub-conditions for different recloser modes
  eqRecCond = (RecloserModeInput == RecloserModeState.EquipmentRecloser) and
              (UMonitoredEquipmentPu < UMonitoredEquipmentTripPu) and
              (UMonitoredBusPu > UMonitoredBusMinPu);

  busRecCond = (RecloserModeInput == RecloserModeState.BusRecloser) and
               (UMonitoredEquipmentPu > UMonitoredEquipmentMinPu) and
               (UMonitoredBusPu < UMonitoredBusTripPu);

  recouplerCond = (RecloserModeInput == RecloserModeState.Recoupler) and
                  (UMonitoredEquipmentPu > UMonitoredEquipmentMinPu) and
                  (UMonitoredBusPu > UMonitoredBusMinPu) and
                  (abs(UMonitoredBusPu - UMonitoredEquipmentPu) < UMonitoredDeltaMaxPu) and
                  (abs(UPhaseMonitoredEquipment - UPhaseMonitoredBus) < UPhaseMonitoredDeltaMax);

  // Combined reclose condition
  recloseCond = (pre(switchControlSignal) == 1) and
                (ReclosingEnabled == ReclosingEnabledState.Enable) and
                (pre(sleepMode) == SleepModeState.Enable) and
                (eqRecCond or busRecCond or recouplerCond);


  // Time of trip trigger
  when tripCond and not(pre(tripCond)) then
    tTripTriggered = time;
  elsewhen not tripCond then
    tTripTriggered = Modelica.Constants.inf;
  end when;

  // Time of reclose trigger
  when recloseCond and not pre(recloseCond) then
    tRecloserTriggered = time;
  elsewhen not recloseCond then
    tRecloserTriggered = Modelica.Constants.inf;
  end when;

  reclosePossible = (pre(sleepMode) == SleepModeState.Enable) and (abs(time - pre(tSleepStart)) <= SleepDuration);

  recloseTrigger = ((time - pre(tRecloserTriggered)) >= RecloserDelay) and reclosePossible;
  tripTrigger = (time - pre(tTripTriggered)) >= TripDelay;

    // Time of sleep; bound to sleepMode because it could be enabled externally
  when sleepMode == SleepModeState.Enable and pre(sleepMode) <> SleepModeState.Enable then
    tSleepStart = time;
  elsewhen sleepMode == SleepModeState.Disable then
    tSleepStart = Modelica.Constants.inf;
  end when;

  when tripTrigger then
    sleepMode = SleepModeState.Enable;
    switchControlSignal = 1;
    Timeline.logEvent1(TimelineKeys.LOVROpeningTriggered);
  elsewhen recloseTrigger then
    sleepMode = SleepModeState.Disable;
    switchControlSignal = 2;
    Timeline.logEvent1(TimelineKeys.LOVRClosingTriggered);
  elsewhen ((time - pre(tSleepStart)) >= SleepDuration) then
    sleepMode = SleepModeState.Disable;
    switchControlSignal = pre(switchControlSignal);
  end when;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>This lack of voltage relay triggers the opening or closing of its controlled switch in lack of voltage situations or restorations thereof.&nbsp;<div><br><div>When the voltages of a bus and a directly connected equipment (e.g. a line) fall under a certain threshold, the relay opens the corresponding switch.</div><div><br></div><div>The relay closes its switch depending on the chosen mode. When the RecloserModeInput is set to<br><div><div><ul><li><b>Equipment Recloser Mode</b>, the relay checks whether a sufficient voltage is present on the bus side in order to restore voltage on the equipment side.</li><li><b>Bus Recloser Mode</b>, the relay checks whether a sufficient voltage is present on the equipment side in order to restore voltage on the bus side.</li><li><b>Recoupler Mode</b>, the relay checks if voltages of both bus and equipment are sufficient and they are in reasonable synchronicity (voltage and phase are within a certain range of each other)</li></ul><div>The <b>sleep mode </b>is triggered for <b>all relays of a substation</b> when the trip condition of the relay is activated - it represents a time window in which reclose actions of any relay are allowed in order to restore voltage. If the sleep duration is expired, no more reclose can happen from a relay of this type on the substation.</div></div><div><br></div><div>A usage of this relay is demonstrated in the dynawo examples (DynaWaltz/IEEE14/IEEE14_LackOfVoltage).</div></div></div></div></body></html>"));
end LackOfVoltageRelay;
