// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0

// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.

model Test "Discrete Integer counter compared with an Integer parameter"
  // The generated code stores discrete Integers as doubles. A bare Integer
  // variable is cast back to modelica_integer, but pre(beats) + 1 stays a
  // modelica_real, so each comparison below calls Less, Greater, LessEq or
  // GreaterEq with a modelica_real and a modelica_integer, in the order written
  // (issue #4342). Within the when, pre(beats) + 1 is the new value of beats.
  parameter Integer N = 3 "Threshold the counter is compared with";
  discrete Integer beats(start = 0, fixed = true) "Counter incremented every second";
  discrete Real less(start = 0, fixed = true) "1 if beats < N";
  discrete Real lessSwapped(start = 0, fixed = true) "1 if N < beats";
  discrete Real greater(start = 0, fixed = true) "1 if beats > N";
  discrete Real greaterSwapped(start = 0, fixed = true) "1 if N > beats";
  discrete Real lessEq(start = 0, fixed = true) "1 if beats <= N";
  discrete Real lessEqSwapped(start = 0, fixed = true) "1 if N <= beats";
  discrete Real greaterEq(start = 0, fixed = true) "1 if beats >= N";
  discrete Real greaterEqSwapped(start = 0, fixed = true) "1 if N >= beats";
equation
  when time >= pre(beats) + 1 then
    beats = pre(beats) + 1;
    less = if pre(beats) + 1 < N then 1 else 0;
    lessSwapped = if N < pre(beats) + 1 then 1 else 0;
    greater = if pre(beats) + 1 > N then 1 else 0;
    greaterSwapped = if N > pre(beats) + 1 then 1 else 0;
    lessEq = if pre(beats) + 1 <= N then 1 else 0;
    lessEqSwapped = if N <= pre(beats) + 1 then 1 else 0;
    greaterEq = if pre(beats) + 1 >= N then 1 else 0;
    greaterEqSwapped = if N >= pre(beats) + 1 then 1 else 0;
  end when;
end Test;
