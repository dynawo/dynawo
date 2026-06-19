within Dynawo.NonElectrical.Logs.Constraint;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

function logConstraint "Create a constraint"
  extends Icons.Function;

  input Integer key;
  input Boolean begin;

  external "C" logConstraintFromModelica(key, begin);

  annotation(preferredView = "text");
end logConstraint;
