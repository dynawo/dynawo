within Dynawo.Electrical.Controls.Generic.Functions;

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

package Automaton "Function to call external automaton"

function functionAutomaton
  import Dynawo.Electrical.Controls.Generic.GenericAutomatonConstants;
  
  input String command "Command to be called";
  input SIunits.Time timeActivation "Automaton activation time";
  input Real inputs[GenericAutomatonConstants.inputsMaxSize] "Inputs data for the automaton";
  input String inputsName[GenericAutomatonConstants.inputsMaxSize] "Inputs data name for the automaton";
  input Integer nbInputs "Number of inputs to provide to the automaton";
  input String outputsName[GenericAutomatonConstants.outputsMaxSize] "Outputs data name for the automaton";
  input Integer nbOutputs "Number of outputs to provide to the automaton";
  output Real outputs[GenericAutomatonConstants.outputsMaxSize] "Outputs data provided by the automaton";
  
  external "C" callExternalAutomaton(command, timeActivation, inputs, inputsName, nbInputs, outputs, outputsName, nbOutputs);

end functionAutomaton;

end Automaton;
