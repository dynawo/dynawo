within Dynawo.Electrical.Events.Event;

model ContinuousEventEquations
  /*
    * Copyright (c) 2023, RTE (http://www.rte-france.com)
    * See AUTHORS.txt
    * All rights reserved.
    * This Source Code Form is subject to the terms of the Mozilla Public
    * License, v. 2.0. If a copy of the MPL was not distributed with this
    * file, you can obtain one at http://mozilla.org/MPL/2.0/.
    * SPDX-License-Identifier: MPL-2.0
    *
    * This file is part of Dynawo, an hybrid C++/Modelica open source suite
    * of simulation tools for power systems.
    */
  parameter typeParameter stateEvent1 "Post event state";
  parameter typeParameter stateEvent2 if (nbEventVariables >= 2);
  parameter typeParameter stateEvent3 if (nbEventVariables >= 3);
  parameter typeParameter stateEvent4 if (nbEventVariables >= 4);
  parameter typeParameter stateEvent5 if (nbEventVariables >= 5);
  typeParameter state1 "Current state";
  typeParameter state2 if (nbEventVariables >= 2);
  typeParameter state3 if (nbEventVariables >= 3);
  typeParameter state4 if (nbEventVariables >= 4);
  typeParameter state5 if (nbEventVariables >= 5);
  parameter Types.Time tEvent "Event time";
  parameter Integer nbEventVariables(min = 1, max = 5) "Number of variables to update during the event";
protected
  // Replaceable items in order to allow using this model for various types (integer, boolean, real...)
  replaceable type typeParameter = Real;
equation
  when (time >= tEvent) then
    reinit(state1, stateEvent1);
  end when;

  if (nbEventVariables >= 2) then
    when (time >= tEvent) then
      reinit(state2, stateEvent2);
    end when;
  end if;

  if (nbEventVariables >= 3) then
    when (time >= tEvent) then
      reinit(state3, stateEvent3);
    end when;
  end if;

  if (nbEventVariables >= 4) then
    when (time >= tEvent) then
      reinit(state4, stateEvent4);
    end when;
  end if;

  if (nbEventVariables >= 5) then
    when (time >= tEvent) then
      reinit(state5, stateEvent5);
    end when;
  end if;
  annotation(
    preferredView = "text");
end ContinuousEventEquations;
