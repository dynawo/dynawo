within Dynawo.Electrical.Controls.Basics;

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

package SwitchOff

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

partial model SwitchOffLogic "Manage switch-off logic"
  /* Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true */
  
  public
    Connectors.BPin switchOffSignal1 (value (start = false)) "Switch-off signal 1";
    Connectors.BPin switchOffSignal2 (value (start = false)) if NbSwitchOffSignals >= 2 "Switch-off signal 2";
    Connectors.BPin switchOffSignal3 (value (start = false)) if NbSwitchOffSignals >= 3 "Switch-off signal 3";
    
    Connectors.BPin running (value (start=true)) "Indicates if the component is running or not";
    
    parameter Integer NbSwitchOffSignals (min = 1, max = 3) "Number of switch-off signals to take into account in inputs";
  
  equation
    
    if (NbSwitchOffSignals >= 3) then
      when switchOffSignal1.value or switchOffSignal2.value or switchOffSignal3.value and pre(running.value) then
        running.value = false;
      end when;
    elseif (NbSwitchOffSignals >= 2) then
      when switchOffSignal1.value or switchOffSignal2.value and pre(running.value) then
        running.value = false;
      end when;
    else 
      when switchOffSignal1.value and pre(running.value) then
        running.value = false;
      end when;
    end if;

end SwitchOffLogic;

partial model SwitchOffGenerator "Switch-off model for a generator"
  /* The three possible/expected switch-off signals for a generator are:
     - a switch-off signal coming from the node in case of a node disconnection 
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton in the generator (under-voltage protection for example)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 3);  
  
  public 
    Constants.state state (start = State0) "Generator connection state";
    
  protected 
    parameter Constants.state State0 = Constants.state.CLOSED " Start value of connection state"; 
  
  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.GeneratorDisconnected);
      state = Constants.state.OPEN;
    end when;
    
end SwitchOffGenerator;

partial model SwitchOffLoad "Switch-off model for a load"
  /* The two possible/expected switch-off signals for a load are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);  
  
  public 
    Constants.state state (start = State0) "Load connection state";
    
  protected 
    parameter Constants.state State0 = Constants.state.CLOSED " Start value of connection state"; 
  
  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.LoadDisconnected);
      state = Constants.state.OPEN;
    end when;
  
end SwitchOffLoad;

partial model SwitchOffTapChanger "Switch-off model for a tap-changer" 
  /* The only possible/expected switch-off signal for a tap-changer is:
     - a switch-off signal coming from the node in case of a node disconnection
  */
  extends SwitchOffLogic(NbSwitchOffSignals = 1);
  
  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.TapChangerSwitchOff);
    end when;

end SwitchOffTapChanger;

partial model SwitchOffPhaseShifter "Switch-off model for a phase-shifter"
  /* The only possible/expected switch-off signal for a phase-shifter is:
     - a switch-off signal coming from the node in case of a node disconnection
  */
  
  extends SwitchOffLogic(NbSwitchOffSignals = 1);
  
  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.PhaseShifterSwitchOff);
    end when;

end SwitchOffPhaseShifter;

partial model SwitchOffTransformer "Switch-off signal for a transformer"
  /* The only possible/expected switch-off signal for a transformer is:
     - a switch-off signal coming from the node in case of a node disconnection
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 1);
  
  public 
    Constants.state state (start = State0) "Load connection state";
    
  protected 
    parameter Constants.state State0 = Constants.state.CLOSED " Start value of connection state"; 
  
  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.TransformerSwitchOff);
      state = Constants.state.OPEN;
    end when;
    
end SwitchOffTransformer;

end SwitchOff;
