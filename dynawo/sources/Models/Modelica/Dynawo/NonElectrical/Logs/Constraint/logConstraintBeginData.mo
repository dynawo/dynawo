within Dynawo.NonElectrical.Logs.Constraint;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

function logConstraintBeginData "Create a begin constraint with data"
  extends Icons.Function;

  input Integer key;

  input String kind;
  input Real limit;
  input Real value;
  input String param;

  external "C" addLogConstraintBeginData(key, kind, limit, value, param) annotation(Include = "#include \"logConstraint.h\"");

  annotation(preferredView = "text");
end logConstraintBeginData;
