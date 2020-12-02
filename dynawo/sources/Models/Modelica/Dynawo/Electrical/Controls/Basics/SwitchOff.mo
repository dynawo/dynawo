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

  extends Icons.Package;

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

annotation(preferredView = "text");
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
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.GeneratorDisconnected);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffGenerator;

partial model SwitchOffInjector "Switch-off model for an injector"
  /* The three possible/expected switch-off signals for a generator are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
     - a switch-off signal coming from an automaton/control block
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 3);

  public
    Constants.state state (start = State0) "Injector connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.ComponentDisconnected);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffInjector;

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
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.LoadDisconnected);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffLoad;

partial model SwitchOffShunt "Switch-off model for a shunt"
  /* The two possible/expected switch-off signals for a shunt are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  public
    Constants.state state (start = State0) "Shunt connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.ShuntDisconnected);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffShunt;

partial model SwitchOffTapChangerPhaseShifter "Switch-off model for a tap-changer or a phase-shifter"
  /* The only possible/expected switch-off signal for a tap-changer is:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.Automaton;
  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  parameter Automaton Type;

  equation

    when not(running.value) then
      if (Type == Automaton.TapChanger) then
        Timeline.logEvent1 (TimelineKeys.TapChangerSwitchOff);
      elseif (Type == Automaton.PhaseShifter) then
        Timeline.logEvent1 (TimelineKeys.PhaseShifterSwitchOff);
      end if;
    end when;

annotation(preferredView = "text");
end SwitchOffTapChangerPhaseShifter;

partial model SwitchOffLine "Switch-off signal for a line"
  /* The two possible/expected switch-off signals for a line are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  public
    Constants.state state (start = State0) "Line connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.LineOpen);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffLine;

partial model SwitchOffDCLine "Switch-off signal for a DC line"
  /* The two possible/expected switch-off signals for a DC line are:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  public
    Constants.state state (start = State0) "DC Line connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.DCLineOpen);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffDCLine;


partial model SwitchOffTransformer "Switch-off signal for a transformer"
  /* The only possible/expected switch-off signal for a transformer is:
     - a switch-off signal coming from the node in case of a node disconnection
     - a switch-off signal coming from the user (event)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 2);

  public
    Constants.state state (start = State0) "Transformer connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.TransformerSwitchOff);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffTransformer;

partial model SwitchOffIdealSwitch "Switch-off signal for an ideal switch"
  /* The only possible/expected switch-off signal for an ideal switch is:
     - a switch-off signal coming from the outside (event or controller)
  */
  import Dynawo.Electrical.Constants;

  extends SwitchOffLogic(NbSwitchOffSignals = 1);

  public
    Constants.state state (start = State0) "Ideal switch connection state";

  protected
    parameter Constants.state State0 = Constants.state.Closed " Start value of connection state";

  equation
    when not(running.value) then
      Timeline.logEvent1 (TimelineKeys.IdealSwitchSwitchOff);
      state = Constants.state.Open;
    end when;

annotation(preferredView = "text");
end SwitchOffIdealSwitch;

annotation(preferredView = "text");
end SwitchOff;
