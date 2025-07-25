model RTS

  // Enumerations
  type RtsState = enumeration(Disable, Enable);
  type RtsModeState = enumeration(EquipmentRecloser, BusRecloser); 
  type SwitchState = enumeration(Open, Closed); //TODO modify it

  // Inputs
  input RtsState rtsState "Current RTS enable/disable state";
  input RtsModeState rtsModeInput "Current RMU EquipmentRecloser/BusRecloser state";
  input Real voltageBus "Voltage at the bus side";
  input Real voltageEquipment "Voltage at the equipment side";
  input SwitchState switchInput "Current switch input state";

  // Parameters
  parameter Real recloseRtsDelay = 2.0 "Recloser delay time in seconds";
  parameter Real equipmentVoltageMin = 0.8 "Minimum  equipment voltage";
  parameter Real busVoltageMin = 0.8 "Minimum bus voltage";
  parameter Real equipmentVoltageTrip = 0.2 "Eq voltage threshold to trigger";
  parameter Real busVoltageTrip = 0.2 "Bus voltage threshold to trigger bus trip";


  // Output
  output SwitchState switchOutput(start=SwitchState.Open);
  
protected 
  Boolean eqRecCond "Equipment reclose condition";
  Boolean busRecCond "Bus reclose condition";
  Boolean initializedRts "Initialized condition";
  Boolean initialized "Initialized flag";
  Boolean recloseCond "Combined reclose condition";
  discrete Real recloserTriggeredTime(start=Modelica.Constants.inf);
  
equation
  initializedRts = (rtsState == RtsState.Enable and
                    switchInput == SwitchState.Open and
                    voltageEquipment > equipmentVoltageMin and
                    voltageBus > busVoltageMin);

  eqRecCond = (rtsModeInput == RtsModeState.EquipmentRecloser and
               initialized and
               voltageEquipment < equipmentVoltageTrip and
               voltageBus > busVoltageMin);

  busRecCond = (rtsModeInput == RtsModeState.BusRecloser and
                initialized and
                voltageEquipment > equipmentVoltageMin and
                voltageBus < busVoltageTrip);

  recloseCond = eqRecCond or busRecCond;
  
  when initializedRts then 
    initialized = true;
  elsewhen pre(switchOutput) == SwitchState.Closed then
    initialized = false;
  end when;
  
  // Start timer at the moment the condition is met
  when recloseCond then
    recloserTriggeredTime = time;
  elsewhen not recloseCond then
    recloserTriggeredTime = Modelica.Constants.inf;   
  end when;

  // Close switch after delay (using pre to ensure time reference is stable)
  when recloseCond and (time - recloserTriggeredTime >= recloseRtsDelay) then
    switchOutput = SwitchState.Closed;
  end when;

end RTS;
