within Dynawo.Electrical.Controls.Protections;

model DynawoAMU
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

  // Import
  import Dynawo.Connectors;
  import Dynawo.Types;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  import Modelica.Blocks.Math;

  // Enumerations
  type AmuState = enumeration(Disable, Enable);
  type RmuModeState = enumeration(Disable, Enable);
  type SleepModeState = enumeration(Disable, Enable);
  type RecloserModeState = enumeration(EquipmentRecloser, BusRecloser, Recoupler);

  parameter Types.VoltageModulePu equipmentVoltageTrip = 0.2 "Eq voltage threshold to trigger";
  parameter Types.VoltageModulePu busVoltageTrip = 0.2 "Bus voltage threshold to trigger bus trip";
  parameter Types.VoltageModulePu equipmentVoltageMin = 0.8 "Minimum  equipment voltage";
  parameter Types.VoltageModulePu busVoltageMin = 0.8 "Minimum bus voltage";
  parameter Types.VoltageModulePu voltageDiffMax = 0.01 "Maximum allowed voltage difference between bus and equipment";
  parameter Types.Angle angleDiffMax = 30 "Maximum allowed phase angle difference";
  parameter Types.Time tripDelay = 2 "Trip delay time in seconds";
  parameter Types.Time recloserDelay = 3 "Recloser delay time in seconds";
  parameter Types.Time sleepDuration = 10 "Sleep mode duration in seconds (stand by)";

  parameter RecloserModeState recloserModeInput = RecloserModeState.EquipmentRecloser "Recloser operation mode input";
  parameter AmuState amuState = AmuState.Enable "Current AMU enable/disable state";
  parameter RmuModeState rmuMode = RmuModeState.Enable "Current RMU enable/disable state";

  //Dynawo.Connectors.VoltageModulePuConnector BusVoltage;
  //Real /*Types.VoltageModulePu*/ uBusMonitoredPu = BusVoltage "Monitored bus voltage in pu (base UNom)"; //TODO dynawo, should this be declared as an input or a connector,  If declared as a connector, it acts like a variable, which may lead to variable > equation imbalance.
  input Types.VoltageModulePu uBusMonitoredPu "Monitored bus voltage in pu (base UNom)"; //TODO dynawo, should this be declared as an input or a connector,  If declared as a connector, it acts like a variable, which may lead to variable > equation imbalance.
  //Dynawo.Connectors.VoltageModulePuConnector uBusMonitoredPu "Monitored bus voltage in pu (base UNom)";
  // Dynawo.Connectors.AngleConnector busPhaseAngle "Phase angle of the monitored bus";
  input Types.Angle busPhaseAngle "Phase angle of the monitored bus";

  input Types.VoltageModulePu uEquipmentMonitoredPu "Monitored equipment voltage in pu (base UNom)"; //TODO dynawo, should this be declared as an input or a connector,  If declared as a connector, it acts like a variable, which may lead to variable > equation imbalance.
  input Types.Angle equipmentPhaseAngle "Phase angle of the monitored equipment";
  // Dynawo.Connectors.VoltageModulePuConnector uEquipmentMonitoredPu "Monitored equipment voltage in pu (base UNom)";
  // Dynawo.Connectors.AngleConnector equipmentPhaseAngle "Phase angle of the monitored equipment";

  Connectors.BPin switchOffSignal(value(start = false)) "Switch off message"; //TODO How to use it

protected
  Boolean tripCond "Trip condition";
  Boolean eqRecCond "Equipment reclose condition";
  Boolean busRecCond "Bus reclose condition";
  Boolean recouplerCond "Recoupler reclose condition";
  Boolean recloseCond "Combined reclose condition";
  Boolean recloseBlocked "Flag if reclose is blocked due to sleep";
  discrete Types.Time tripTriggeredTime(start = Modelica.Constants.inf) "Time when the trip condition became True";
  discrete Types.Time recloserTriggeredTime(start = Modelica.Constants.inf) "Time when recloser condition became True";
  discrete Types.Time sleepStartTime(start = Modelica.Constants.inf) "Timer tracking sleep mode duration";
  discrete SleepModeState sleepMode(start = SleepModeState.Disable) "Current sleep mode state";

equation
//? Currently using '<' and '>' comparisons. Consider if '<=' or '>=' would be more appropriate in some cases.
// Define trip condition: AMU enabled, switch closed, voltages below trip thresholds
  tripCond = (amuState == AmuState.Enable) and not (pre(switchOffSignal.value)) and
             (uEquipmentMonitoredPu < equipmentVoltageTrip) and
             (uBusMonitoredPu < busVoltageTrip);

// Define sub-conditions for different recloser modes
  eqRecCond = (recloserModeInput == RecloserModeState.EquipmentRecloser) and
              (uEquipmentMonitoredPu < equipmentVoltageTrip) and
              (uBusMonitoredPu > busVoltageMin);

  busRecCond = (recloserModeInput == RecloserModeState.BusRecloser) and
               (uEquipmentMonitoredPu > equipmentVoltageMin) and
               (uBusMonitoredPu < busVoltageTrip);

  recouplerCond = (recloserModeInput == RecloserModeState.Recoupler) and
                  (uEquipmentMonitoredPu > equipmentVoltageMin) and
                  (uBusMonitoredPu > busVoltageMin) and
                  (abs(uBusMonitoredPu - uEquipmentMonitoredPu) < voltageDiffMax) and
                  (abs(equipmentPhaseAngle - busPhaseAngle) < angleDiffMax);

// Combined reclose condition
  recloseCond = (amuState == AmuState.Enable) and
                (pre(switchOffSignal.value)) and
                (rmuMode == RmuModeState.Enable) and
                (pre(sleepMode) == SleepModeState.Enable) and
                (eqRecCond or busRecCond or recouplerCond);

//  Check if reclose is blocked because sleep mode timer has expired
  recloseBlocked = (pre(sleepMode) == SleepModeState.Enable) and
                    ((time - pre(sleepStartTime)) >= sleepDuration);

// Time of trip trigger
  when tripCond then
    tripTriggeredTime = time;
  elsewhen not tripCond then
    tripTriggeredTime = Modelica.Constants.inf;
  end when;

// Time of reclose trigger
  when recloseCond then
    recloserTriggeredTime = time;
  elsewhen not recloseCond then
    recloserTriggeredTime = Modelica.Constants.inf;
  end when;

// Time of sleep
  when sleepMode == SleepModeState.Enable then
    sleepStartTime = time;
  elsewhen sleepMode == SleepModeState.Disable then
    sleepStartTime = Modelica.Constants.inf;
  end when;

//  Event: If trip condition persists longer than tripDelay, open switch and enable sleep mode
  when tripCond and (time - tripTriggeredTime >= tripDelay) then
    switchOffSignal.value = true;
    Timeline.logEvent1(TimelineKeys.SwitchOpened); //TODO add AMUTripped to TimelineKeys
    sleepMode = SleepModeState.Enable;

// Event: If reclose delay passed and reclose is not blocked, close switch and disable sleep mode
  elsewhen (time - recloserTriggeredTime >= recloserDelay) and not recloseBlocked then
    switchOffSignal.value = false;
    Timeline.logEvent1(TimelineKeys.SwitchClosed); //TODO add RMUClosed to TimelineKeys
    sleepMode = SleepModeState.Disable;
  end when;

end DynawoAMU;
