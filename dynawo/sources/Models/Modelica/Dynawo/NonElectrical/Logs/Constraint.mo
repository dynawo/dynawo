within Dynawo.NonElectrical.Logs;

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

encapsulated package Constraint "Logging for constraitns monitoring purposes"

//
// Constraint logger function
// --------------------------
function logConstraintBegin "Create a begin constraint"
  input Integer key;
  external "C" addLogConstraintBegin(key);

annotation(preferredView = "text");
end logConstraintBegin;


function logConstraintEnd "Create an end constraint"
  input Integer key;
  external "C" addLogConstraintEnd(key);

annotation(preferredView = "text");
end logConstraintEnd;

end Constraint;
