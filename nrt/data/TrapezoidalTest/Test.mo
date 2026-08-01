// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0

// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.

model Test
  Real u(start = 2);
  Real v(start = 1);
  Real x;
  Real y;
  parameter Real a = 1;
  parameter Real b = 1;
equation
  a * der(u) = -b*u + v;
  der(v) = v - u;
  y = u*v;
  x = u + v - y;
end Test;
