model AMU

  // Enumerations
  type AmuState = enumeration(Disable, Enable);
  type SwitchState = enumeration(Open, Closed); //TODO modfiy it
  type RmuModeState = enumeration(Disable, Enable);
  type SleepModeState = enumeration(Disable, Enable);
  type RecloserModeState = enumeration(EquipmentRecloser, BusRecloser, Recoupler);

  // Inputs
  input Real voltageBus "Voltage at the bus side";
  input Real voltageEquipment "Voltage at the equipment side";
  input Real phaseAngle "Phase angle in degrees (used for recoupler condition)"; 
  input SwitchState switchInput "Current switch input state";
  input RecloserModeState recloserModeInput "Recloser operation mode input";
  input AmuState amuState "Current AMU enable/disable state";
  input RmuModeState rmuMode "Current RMU state EquipmentRecloser, BusRecloser, Recoupler";
  
  // Parameters
  parameter Real equipmentVoltageTrip = 0.2 "Eq voltage threshold to trigger";
  parameter Real busVoltageTrip = 0.2 "Bus voltage threshold to trigger bus trip";
  parameter Real equipmentVoltageMin = 0.8 "Minimum  equipment voltage";
  parameter Real busVoltageMin = 0.8 "Minimum bus voltage";
  parameter Real voltageDiffMax = 0.01 "Maximum allowed voltage difference between bus and equipment";
  parameter Real angleDiffMax = 30 "Maximum allowed phase angle difference";
  parameter Real tripDelay = 2 "Trip delay time in seconds";
  parameter Real recloserDelay = 3 "Recloser delay time in seconds";
  parameter Real sleepDuration = 10 "Sleep mode duration in seconds (stand by)";

  // Output
  output SwitchState switchOutput(start=SwitchState.Closed) "Output switch state";

protected 
  Boolean tripCond "Trip condition";
  Boolean eqRecCond "Equipment reclose condition";
  Boolean busRecCond "Bus reclose condition";
  Boolean recouplerCond "Recoupler reclose condition";
  Boolean recloseCond "Combined reclose condition";
  Boolean recloseBlocked "Flag if reclose is blocked due to sleep";
  discrete Real tripTriggeredTime(start=Modelica.Constants.inf) "Time when the trip condition became True";
  discrete Real recloserTriggeredTime(start=Modelica.Constants.inf) "Time when recloser condition became True";
  discrete Real sleepStartTime(start=Modelica.Constants.inf) "Timeer tracking sleep mode duration";
  discrete SleepModeState sleepMode(start=SleepModeState.Disable) "Current sleep mode state";
  
equation
  // Define trip condition: AMU enabled, switch closed, voltages below trip thresholds
  tripCond = (amuState == AmuState.Enable) and
             (switchInput == SwitchState.Closed) and
             (voltageEquipment < equipmentVoltageTrip) and
             (voltageBus < busVoltageTrip);

  // Define sub-conditions for different recloser modes
  eqRecCond = (recloserModeInput == RecloserModeState.EquipmentRecloser) and
              (voltageEquipment < equipmentVoltageTrip) and
              (voltageBus > busVoltageMin);

  busRecCond = (recloserModeInput == RecloserModeState.BusRecloser) and
               (voltageEquipment > equipmentVoltageMin) and
               (voltageBus < busVoltageTrip);

  recouplerCond = (recloserModeInput == RecloserModeState.Recoupler) and
                  (voltageEquipment > equipmentVoltageMin) and
                  (voltageBus > busVoltageMin) and
                  (abs(voltageBus - voltageEquipment) < voltageDiffMax) and
                  (phaseAngle < angleDiffMax);

  // Combined reclose condition
  recloseCond = (amuState == AmuState.Enable) and
                (switchInput == SwitchState.Open) and
                (rmuMode == RmuModeState.Enable) and
                (pre(sleepMode) == SleepModeState.Enable) and
                (eqRecCond or busRecCond or recouplerCond);

  //  Check if reclose is blocked because sleep mode timer has expired
  recloseBlocked = (pre(sleepMode) == SleepModeState.Enable) and // use pre to break discrete loop
                   ((time - pre(sleepStartTime)) >= sleepDuration);

   // Time of trip trigger
  when tripCond then   // Here, we only store the first trigger time to measure delay.
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
  
  when sleepMode == SleepModeState.Enable then
    sleepStartTime = time;
  elsewhen sleepMode == SleepModeState.Disable then
    sleepStartTime = Modelica.Constants.inf;
  end when;

  //  Event: If trip condition persists longer than tripDelay, open switch and enable sleep mode
  when tripCond and (time - tripTriggeredTime >= tripDelay) then
    switchOutput = SwitchState.Open;
    sleepMode = SleepModeState.Enable;
    // TODO add msg
 // Event: If reclose delay passed and reclose is not blocked, close switch and disable sleep mode
  elsewhen (time - recloserTriggeredTime >= recloserDelay) and not recloseBlocked then
    switchOutput = SwitchState.Closed;
    sleepMode = SleepModeState.Disable;
  end when;

end AMU;
