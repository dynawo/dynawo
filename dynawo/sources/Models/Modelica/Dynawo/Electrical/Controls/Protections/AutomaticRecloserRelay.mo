model AutomaticRecloserRelay
  import Modelica.Constants;
        
  // Type definition
  
  // Parameters
  parameter Real T = 0.3;
  parameter Real TB = 3 "Blocking time";
  parameter Real TCT = 2 "Three  phase cycle time";
  parameter Real TRTR = 5 "Fast coupling three phase time";
  parameter Real TD = 60 "De-energising time";
  parameter Real TG = 3 "Slip time";
  parameter Real TR = 60 "Recovery time";
  parameter Real UNominal = 1.0 "Nominal voltage";
  // parameter Real deltaThetaThreshold = 1.0 "Angle difference threshold";
  // parameter Real deltaUThreshold = 1.0 "Volatage difference threshold";
  // parameter Real stepSize = 1.0 "simulation step size";
  
  
  // Internal states
  Boolean RecloserOperating(start=true);
  Boolean RecloserCond;
  Boolean RecloserTimeCond;
  
  
  
  Real RecloserTimeStart(start=Constants.inf);
  discrete Real TCTTimerStart(start=Constants.inf) "Start value of TCT Timer, after ";
  Real RecoveryTimer(start=Constants.inf);
  Boolean RecoveryTimeActive(start=false);  //= false;
  Real BlockingTimerStart(start=Constants.inf);
  
  
  Boolean AR_RENV = true;
  Boolean AR_INV = true;
//  Boolean AR_TRIPH = true;
//  Boolean AR_RVL = true;
//  Boolean AR_REBL = true;
//  Boolean AR_REB = false;
  
  // Inputs
  Real UL(start=1);
  Real UB = 1;
  Boolean ProtectionFaultSignal(start=false);
  // Dynawo.Connectors.BPin ProtectionFaultSignal;
  // Dynawo.Connectors.BPin SCADARecloseSignal;
  // Dynawo.Connectors.BPin SCADAInversionSignal;
  
  // Outputs
  Boolean RelayBreakerSignal(start=false) "Open/Close signal to breaker: [0:open breaker, 1: close breaker]";//(start=false)
  
  // Functions
  function ULCond
    input Real UL;
    output Boolean ULCondition;
  algorithm
    ULCondition := if UL == 0 then true else false;//UL < 0.00001 and UL > -0.00001 then true else false;
  end ULCond;
  
  function TCTTimerCond
    input Real TimerValue;
    output Boolean TimerCond;
  algorithm
    TimerCond := if TimerValue <> Constants.inf then true else false;
  end TCTTimerCond;
  
equation
  RecloserCond = ULCond(UL) and UB >= 0.8 * UNominal;

  
    when ProtectionFaultSignal and RecloserCond and not pre(RecoveryTimeActive) and pre(RecloserOperating) then
      RecloserTimeStart = time;
    elsewhen not RecloserCond then
      RecloserTimeStart = Constants.inf;
    end when;
    // Slip timer 
    when time - RecloserTimeStart >= TG then 
      RecloserTimeCond = true;
      TCTTimerStart = time;
    elsewhen time - RecloserTimeStart < TG then
      RecloserTimeCond = false;
      TCTTimerStart = Constants.inf;
    end when;

  // TCT Timer to trigger Breaker signal
  when time - TCTTimerStart >= TCT and not ProtectionFaultSignal then
    RelayBreakerSignal = true;
    BlockingTimerStart = time;
    RecoveryTimeActive = false;
    RecoveryTimer = Constants.inf;
  elsewhen time - TCTTimerStart >= TCT and ProtectionFaultSignal then
    RelayBreakerSignal = false;
    BlockingTimerStart = Constants.inf;
    RecoveryTimeActive = true;
    RecoveryTimer = time;
  elsewhen time - TCTTimerStart < TCT then 
    RelayBreakerSignal = false;
    BlockingTimerStart = Constants.inf;
    RecoveryTimeActive = false;
    RecoveryTimer = Constants.inf;
  end when;
  
  when time - BlockingTimerStart < TB and time - BlockingTimerStart >= 0 and ProtectionFaultSignal then
    // deactivate Recloser, breaker open
    RecloserOperating = false;
  elsewhen time - BlockingTimerStart >= TB then
    // deactivate Recloser, breaker closed
    RecloserOperating = true;
  end when;
  
  // Relay Test 1: Reclosing breaker
  UL = if time < 2 then 1
       elseif time < 4 then 1
       elseif time < 6 then 0
       elseif time < 10 then 1
       elseif time < 40 then 0 
       else 1;
       
  // Relay Test 2: Reclosing breaker with recurring temporary faults
  /*UL = if time < 2 then 1
       elseif time < 4 then 1
       elseif time < 6 then 0
       elseif time < 10 then 1
       elseif time < 25 then 0 
       else 1;*/
  
  // Relay Test 3: Activating recovery TimeTest
  /*UL = if time < 2 then 1
       elseif time < 4 then 1
       elseif time < 6 then 0
       elseif time < 10 then 1
       elseif time < 25 then 0 
       else 1;*/
  
  ProtectionFaultSignal = if time < 13 then true
                          elseif time < 20 then false
                          elseif time < 23 then true
                          elseif time < 30 then false
                          elseif time < 32 then true
                          elseif time < 40 then false
                          else true;     
       
end AutomaticRecloserRelay;
